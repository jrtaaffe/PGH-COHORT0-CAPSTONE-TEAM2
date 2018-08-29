package com.techelevator.controller;

import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.techelevator.model.Email;
import com.techelevator.model.GameDAO;
import com.techelevator.model.Stock;
import com.techelevator.model.TempGame;
import com.techelevator.model.User;
import com.techelevator.model.UserDAO;
import com.techelevator.model.UserGame;

@Controller
public class UserController {

	private UserDAO userDAO;
	
	private GameDAO gameDAO;

	@Autowired
	public UserController(UserDAO userDAO, GameDAO gameDAO) {
		this.userDAO = userDAO;
		this.gameDAO = gameDAO;
	}

	@RequestMapping(path="/users/new", method=RequestMethod.GET)
	public String displayNewUserForm(ModelMap modelHolder) {

		if( ! modelHolder.containsAttribute("user")) {
			modelHolder.addAttribute("user", new User());
		}
		return "newUser";
	}
	
	@RequestMapping(path="/users", method=RequestMethod.POST)
	public String createUser(@Valid @ModelAttribute User user, BindingResult result, RedirectAttributes flash) {
		if(result.hasErrors()) {
			flash.addFlashAttribute("user", user);
			flash.addFlashAttribute(BindingResult.MODEL_KEY_PREFIX + "user", result);
			return "redirect:/users/new";
		}
		
		
		userDAO.saveUser(user.getFirstName(), user.getLastName(), user.getEmail(), user.getUserName(), user.getPassword());
		
		List<TempGame> tempGames = gameDAO.getInvitedGamesByPlayer(user.getEmail());
		if(!tempGames.isEmpty()) {
			for(TempGame game: tempGames) {
				gameDAO.addPlayers(game.getGameId(), game.getEmail());
			}
			gameDAO.deleteInvitedPlayers(user.getEmail());
		}
		return "redirect:/login";
	}
	
	@RequestMapping(path={"/account/home"}, method=RequestMethod.GET)
	public String accoutHomePage(HttpServletRequest request, HttpSession session) {
		User currentUser = (User) session.getAttribute("currentUser");
		List<UserGame> games = gameDAO.getGamesByUser(currentUser.getEmail());
		request.setAttribute("games", games);
		
		return "account/home";
	
	}
	
	@RequestMapping(path="/account/research", method=RequestMethod.GET)
	public String researchPage() {
		return "account/research";
	}
	

	@RequestMapping(path="/account/createGame", method=RequestMethod.GET)
	public String createNewGamePage() {
		return "account/createGame";
	}
	
	
	@RequestMapping(path="/account/createGame", method=RequestMethod.POST)
	public String saveNewGame(@RequestParam String game_title,
			@RequestParam Date start_date,
			@RequestParam Date end_date,
			@RequestParam String admin,
			@RequestParam(required=false) String invited_players,
			HttpSession session) {
		int gameId = gameDAO.createNewGame(game_title, start_date, end_date, admin);
		gameDAO.addPlayers(gameId, admin);
		
		User user = (User) session.getAttribute("currentUser");
		String player = user.getFirstName() + " " + user.getLastName();
		
		String [] invitees = invited_players.split(",");
		List<String> emails = userDAO.getAllEmails();
		
		for(int i = 0; i < invitees.length; i++) {
			boolean isDup = false;
			for(int j = 0; j < emails.size(); j++) {
				if(invitees[i].equals(emails.get(j))) {
					isDup = true;
				}
			}
			if(isDup == false) {
				gameDAO.addInvitedPlayers(gameId, invitees[i]);
			} else {
				gameDAO.addPlayers(gameId, invitees[i]);
			}
		}
		
		Email email = new Email(invitees, player);
		email.send();
		
		return "redirect:home";
		
	}
	
	@RequestMapping(path="/account/game", method=RequestMethod.GET)
	public String gamePage(HttpSession session, HttpServletRequest request) {
		System.out.println(request.getAttribute("gameId"));
		System.out.println(request.getParameter("gameId"));
		if(request.getParameter("gameId") != null) {
			request.setAttribute("gameId", request.getParameter("gameId"));
		}
		int gameId = Integer.parseInt((String)request.getAttribute("gameId"));
		System.out.println("game id");
		System.out.println(gameId);
		
		UserGame currGame = gameDAO.getGameById(gameId);
		request.setAttribute("currGame", currGame);
		User user = (User) session.getAttribute("currentUser");
		String email = user.getEmail();
		int portfolioId = gameDAO.getPortfolioId(email, gameId);

		System.out.println(portfolioId);
		float walletValue = gameDAO.getWalletValueByPortfolio(portfolioId);
		request.setAttribute("walletValue", walletValue);

		if (portfolioId != -1) {
			Map<String, Integer> transactions = gameDAO.getTransactionsByUserGame(portfolioId);
			request.setAttribute("transactions", transactions);
		}
		request.setAttribute("portfolioId", portfolioId);
		System.out.println("complete");
		return "account/game";
	}
	
	@RequestMapping(path="/account/game", method=RequestMethod.POST)
	public String transactionPost(HttpServletRequest request) {
		System.out.println(1);
		System.out.println(request.getParameter("portfolioId"));
		int portfolioId = Integer.parseInt(request.getParameter("portfolioId"));   
		System.out.println(2);
		String action = request.getParameter("action");		// buy or sell
		String tickerSymbol = request.getParameter("tickerSymbol");	
		int quantity = Integer.parseInt(request.getParameter("quantity"));		//quantity to buy or sell
		float valueOfStock = Float.parseFloat(request.getParameter("valueOfStock"));		//value of the stocks to buy or sell in pennies
		System.out.println(3);
		request.setAttribute("gameId", request.getParameter("gameId"));
		System.out.println(request.getParameter("gameId"));
		
		float walletValue = gameDAO.getWalletValueByPortfolio(portfolioId);		// current amount of cash
		Map<String, Integer> transactions = gameDAO.getTransactionsByUserGame(portfolioId);	// stocks and quantities currently owned
		System.out.println(4);
		
		if(action.equals("B")) {		// if they want to buy
			System.out.println(5);	
			boolean exists = false;
			int newQuantity = 0;
			if (!transactions.isEmpty() && transactions != null) {
				for(Entry<String, Integer> entry : transactions.entrySet()) {		//loop over the stocks they already own
					System.out.println(6);

					if(tickerSymbol.equals(entry.getKey())) {	//if the stock they want to buy matches a stock they own
						System.out.println(7);

						exists = true;
						newQuantity = entry.getValue() + quantity;
					}
				}
			}
			if(exists && walletValue >= valueOfStock) {		//if they already own the stock, and have enough money to buy
				System.out.println(8);

				gameDAO.buyOrSellStock(tickerSymbol, newQuantity, portfolioId);	//update the entry in the table to represent new quantity owned
				gameDAO.updateWalletValue((walletValue - valueOfStock), portfolioId);	//update wallet value
			} else if(walletValue >= valueOfStock) {			//if they don't own the stock, and have enough money to buy
				System.out.println(9);

				gameDAO.buyInitialStock(portfolioId, tickerSymbol, quantity);		//insert new entry in the table for that stock and quantity
				gameDAO.updateWalletValue((walletValue - valueOfStock), portfolioId); //update wallet value
			} else {
				System.out.println(10);

				request.setAttribute("failure", "You don't have enough money"); // transaction failed, you don't have enough money
			}
		} else if(action.equals("S")) {		//if they want to sell
			boolean exists = false;		//do you own this stock?
			int newQuantity = -1;
			for(Entry<String, Integer> entry : transactions.entrySet()) { //loop over stocks owned
				if(tickerSymbol.equals(entry.getKey())) { //if they do own the stock they want to buy
					exists = true;
					if(entry.getValue() >= quantity) {		//if they own more or equal to the amount the want to sell
						newQuantity = entry.getValue() - quantity; //quantity they will own after sale
					} 
				}
			}
			if(exists && newQuantity > 0) {	//if they own the stock and they will still own shares after the sale
				gameDAO.buyOrSellStock(tickerSymbol, newQuantity, portfolioId);
				gameDAO.updateWalletValue((walletValue + valueOfStock), portfolioId);
			} else if(exists && newQuantity == 0) {		//if they own the stock, but will have none after the sale
				gameDAO.deleteStock(tickerSymbol, portfolioId);
				gameDAO.updateWalletValue((walletValue + valueOfStock), portfolioId);
			} else if(newQuantity < 0) {		// if they do not own enough of the stock they want to sell
				request.setAttribute("failure", "You do not own enough of that Stock");
			} else {		//if they do not own the stock at all
				request.setAttribute("failure", "You do not own that Stock");
			}
		}
		
		return "redirect:game";
	}
}
