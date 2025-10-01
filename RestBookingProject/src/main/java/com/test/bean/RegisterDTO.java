package com.test.bean;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.validation.constraints.*;

public class RegisterDTO {

	@Id
	private Integer id;
	
	@Column
	private String account;
	
	@Column
	@NotBlank(message = "Email 不可為空")
    @Email(message = "Email 格式錯誤")
    private String email;

	@Column
    @NotBlank(message = "密碼不可為空")
    @Size(min = 6, message = "密碼長度至少 6 碼")
    @Pattern(regexp="^(?=.*[A-Z]+)(?=.*[0-9]+).*$",
    message="密碼必須包含至少一個大寫字母與數字")
    private String password;
	
	@Column(name="user_Type")
	private Integer userType;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

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

	public Integer getUserType() {
		return userType;
	}

	public void setUserType(Integer userType) {
		this.userType = userType;
	}
}
