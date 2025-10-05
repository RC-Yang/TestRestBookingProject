package com.test.bean;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.NotEmpty;

import org.springframework.web.multipart.MultipartFile;

@Entity
@Table(name="user")
public class User {

//	private Integer id;
//	@NotEmpty(message="姓名不可為空白")
//	private String name;
	@NotEmpty(message="Email不可為空白")
	private String email;
	@NotEmpty(message="密碼不可為空白")
	private String password;
	@NotEmpty(message="帳號不可為空白")
	@Id
	private String account;
	
	@Column(name="user_role")
	private String userRole;//顧客或餐廳使用者
	@Column(name="picture")
	private byte[] pictureForJPA;//使用者頭貼
	@Transient
	private MultipartFile picture;//使用者頭貼
	@Transient
	private String image;//for呈顯於jsp header
	
	@Column
	private boolean enabled;
	
	@OneToMany(mappedBy="user")
	private List<VerificationToken> verificationToken;

	//一使用者關聯到一餐廳
	@OneToOne
	//使用者透過rest_id這個外鍵來關聯到餐廳
	@JoinColumn(name = "rest_id")
	private Restaurant rest;
	//但需要設定兩個類之間，關聯的方式嗎？
	//在一對多關係中，需要用mappedBy參數來設定關聯
	//在一對一關係中，JPA會直接將外鍵關聯到餐廳主鍵，故不用特別設定關聯的方式

	public String getEmail() {
		return email;
	}
	public String getUserRole() {
		return userRole;
	}
	public void setUserRole(String userRole) {
		this.userRole = userRole;
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
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	public MultipartFile getPicture() {
		return picture;
	}

	public void setPicture(MultipartFile picture) {
		this.picture = picture;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public Restaurant getRest() {
		return rest;
	}
	public void setRest(Restaurant rest) {
		this.rest = rest;
	}
	public byte[] getPictureForJPA() {
		return pictureForJPA;
	}
	public void setPictureForJPA(byte[] pictureForJPA) {
		this.pictureForJPA = pictureForJPA;
	}
	public List<VerificationToken> getVerificationToken() {
		return verificationToken;
	}
	public void setVerificationToken(List<VerificationToken> verificationToken) {
		this.verificationToken = verificationToken;
	}
	public boolean isEnabled() {
		return enabled;
	}
	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
}
