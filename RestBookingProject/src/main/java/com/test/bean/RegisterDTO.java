package com.test.bean;

import javax.validation.constraints.*;

import org.springframework.web.multipart.MultipartFile;

public class RegisterDTO {
	
	private String account;

	@NotBlank(message = "Email 不可為空")
    @Email(message = "Email 格式錯誤")
    private String email;

    @NotBlank(message = "密碼不可為空")
    @Size(min = 3, message = "密碼長度至少 3 碼")
    //@Pattern(regexp="^(?=.*[A-Z]+)(?=.*[0-9]+).*$",
    //message="密碼必須包含至少一個大寫字母與數字")
    private String password;
	
	private String userRole;
	
	private MultipartFile picture;

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUserRole() {
		return userRole;
	}

	public void setUserRole(String userRole) {
		this.userRole = userRole;
	}

	public MultipartFile getPicture() {
		return picture;
	}

	public void setPicture(MultipartFile picture) {
		this.picture = picture;
	}
}
