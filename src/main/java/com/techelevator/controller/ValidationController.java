package com.techelevator.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.techelevator.model.Email;
import com.techelevator.model.User;
import com.techelevator.model.UserDAO;
import com.techelevator.model.Username;

@RestController
public class ValidationController {
	
	private UserDAO userDao;
	
	@Autowired
	public ValidationController(UserDAO UserDAO) {
		this.userDao = UserDAO;
	}
	
	@RequestMapping(value = "/validate", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Boolean> checkForDuplicates(@RequestBody User newUser) {
		Map<String, Boolean> valid = new HashMap<String, Boolean>(); // true indicates that there are no dups
		valid.put("email", true);
		valid.put("username", true);
		List<String> usernames = userDao.getAllUsernames();
		List<String> emails = userDao.getAllEmails();
		for(String username : usernames) {
			if(newUser.getUserName() == username) {
				valid.put("username", false);
			}
		}
		for(String email : emails) {
			if(newUser.getEmail() == email) {
				valid.put("email", false);
			}
		}
		return valid;
	}
	
	@RequestMapping(value = "/validateEmail", method = RequestMethod.POST, produces = "application/json")
	public boolean checkForDuplicateEmail(@RequestBody String newEmail) { 
		boolean validEmail = true;
		List<String> emails = userDao.getAllEmails();
		for(String email : emails) {
			if(newEmail == email) {
				validEmail = false;
			}
		}
		return validEmail;
	
	}
	
	@RequestMapping(value = "/validateUsername", method = RequestMethod.POST, produces = "application/json")
	public boolean checkForDuplicateUsername(@RequestBody Username u) { 
		boolean validUsername = true;
		List<String> newUsernames = userDao.getAllUsernames();
		for(String newUsername : newUsernames) {
			if(u.getUsername().equals(newUsername)) {
				validUsername = false;
			}
		}
		return validUsername;
	}
	
	@RequestMapping(value = "/controllerTest", method = RequestMethod.GET, produces = "application/json")
	public String testThisController() {
		return "HEY! IT WORKED!";
	}
}
