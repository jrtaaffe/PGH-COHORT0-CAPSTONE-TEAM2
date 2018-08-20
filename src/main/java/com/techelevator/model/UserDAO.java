package com.techelevator.model;

public interface UserDAO {

	public void saveUser(String userName, String password, String email, String firstName, String lastName);

	public boolean searchForUsernameAndPassword(String userName, String password);

	public void updatePassword(String userName, String password);

	public Object getUserByUserName(String userName);

}
