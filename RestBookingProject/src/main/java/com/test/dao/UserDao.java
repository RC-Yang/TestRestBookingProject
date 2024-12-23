package com.test.dao;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import javax.servlet.ServletContext;

import com.test.bean.Restaurant;
import com.test.bean.User;

public interface UserDao {
	public int addUser(User user);
	public int addRestUser(User user,Restaurant rest);
	public int addAUTHORITIES(User user);
	public List<User> queryAllUser();
	public Optional<User> queryUserByAccount(String account,Integer userType,String password);
	public Optional<User> queryUserByAccount(String account,String password);
	public Optional<String> queryUserImage(ServletContext context,String account,Integer userType) throws IOException;
}
