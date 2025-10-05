package com.test.bean;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class TestUserDetails implements UserDetails {

	private final String account;
	private final String password;
	private final String userRole;

	public TestUserDetails(String account, String password, String userRole) {
		super();
		this.account = account;
		this.password = password;
		this.userRole = userRole;
	}

	//用於Spring Security tag，principal取出account的值
	public String getAccount() {
		return account;
	}

	public String getImageUrl() {
		return "/RestBookingProject/entry/users/" + account + "/getUserImage";
	}

	//對應DB的authority欄位名或自己組出authority值
	public Collection<? extends GrantedAuthority> getAuthorities() {
		String role = null;

		role = userRole;
		return List.of(new SimpleGrantedAuthority(role));
	}

	@Override
	//對應DB的密碼欄位名
	public String getPassword() {
		// TODO Auto-generated method stub
		return password;
	}

	@Override
	//對應DB的帳號欄位名
	public String getUsername() {
		// TODO Auto-generated method stub
		return account;
	}

	@Override
	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return true;
	}

}
