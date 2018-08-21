package com.techelevator.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.techelevator.model.User;
import com.techelevator.model.UserDAO;

@RestController
public class ValidationController {
	
	private UserDAO userDao;
	
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
	public boolean checkForDuplicateEmail(@RequestBody User newUser) { 
		boolean validEmail = true;
		
		List<String> emails = userDao.getAllEmails();
		for(String email : emails) {
			if(newUser.getEmail() == email) {
				validEmail = false;
			}
		}
		return validEmail;
	
	}
	
	@RequestMapping(value = "/validateUsername", method = RequestMethod.POST, produces = "application/json")
	public boolean checkForDuplicateUsername(@RequestBody User newUser) { 
		boolean validUsername = true;
		
		List<String> usernames = userDao.getAllUsernames();
		for(String username : usernames) {
			if(newUser.getUserName() == username) {
				validUsername = false;
			}
		}
		return validUsername;
	
	}
}
