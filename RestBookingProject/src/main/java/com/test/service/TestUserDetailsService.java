package com.test.service;

import java.sql.Blob;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.test.bean.TestUserDetails;
import com.test.bean.User;
import com.test.util.DaoUtil;

@Service
public class TestUserDetailsService implements UserDetailsService{

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Override
	public UserDetails loadUserByUsername(String name) throws UsernameNotFoundException {
		String sql = "SELECT user_role, account, password FROM web.user WHERE account = ?";

		User user = (User)jdbcTemplate.queryForObject(sql, (rs,i)->{
			String account = rs.getString("account");
			String password = rs.getString("password");
			
			String userRole = rs.getString("user_role");
			
			User tempUser = new User();//不可也命名為user，因為會跟外層的user，scope彼此互相衝突
			tempUser.setAccount(account);
			tempUser.setPassword(password);
			tempUser.setUserRole(userRole);
			
			return tempUser;
		},name);
		
		return new TestUserDetails(user.getAccount(),user.getPassword(),
				user.getUserRole());
	}

}
