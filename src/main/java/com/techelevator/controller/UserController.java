package com.techelevator.controller;

import java.sql.Date;
import java.util.List;
import java.util.Map;

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
			@RequestParam(required=false) String invited_players) {
		int gameId = gameDAO.createNewGame(game_title, start_date, end_date, admin);
		gameDAO.addPlayers(gameId, admin);
		
		String [] invitees = invited_players.split(",");
		
		for(int i = 0; i < invitees.length; i++) {
			gameDAO.addInvitedPlayers(gameId, invitees[i]);
		}
		
		Email email = new Email(invitees);
		email.send();
		
		return "redirect:home";
	}
	
	@RequestMapping(path="/account/game", method=RequestMethod.GET)
	public String gamePage(HttpSession session, HttpServletRequest request) {
		String gameId = request.getParameter("gameId");
		User user = (User) session.getAttribute("currentUser");
		String email = user.getEmail();
		int portfolioId = gameDAO.getPortfolioId(email, Integer.parseInt(gameId));
		Map<Stock, Integer> transactions = gameDAO.getTransactionsByUserGame(portfolioId);
		request.setAttribute("transactions", transactions);
		return "account/userGame";
	}
	
	

}
