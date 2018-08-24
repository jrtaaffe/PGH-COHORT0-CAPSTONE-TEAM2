package com.techelevator.controller;

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

import com.techelevator.model.GameDAO;
import com.techelevator.model.Stock;
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
		return "redirect:/login";
	}
	
	@RequestMapping(path={"/account/home"}, method=RequestMethod.GET)
	public String accoutHomePage(HttpServletRequest request, HttpSession session) {
		System.out.println(1);
		if(session.getAttribute("currentUser") != null) {
System.out.println(2);
			User currentUser = (User) session.getAttribute("currentUser");
			List<UserGame> games = gameDAO.getGamesByUser(currentUser.getEmail());
			request.setAttribute("games", games);
			return "account/home";
		} else {
			System.out.println(3);
			return "newUser";
		}
	}
	
	@RequestMapping(path="/account/research", method=RequestMethod.GET)
	public String researchPage() {
		
		return "account/research";
	}
	
	@RequestMapping(path="/account/game", method=RequestMethod.GET)
	public String gamePage(HttpSession session, HttpServletRequest request) {
		int portfolioId = (int) request.getAttribute("portfolioId");
		Map<Stock, Integer> transactions = gameDAO.getTransactionsByUserGame(portfolioId);
		request.setAttribute("transactions", transactions);
		return "account/userGame";
	}

}
