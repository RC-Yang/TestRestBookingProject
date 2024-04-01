package com.test.bean;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
@Entity
@Table(name = "restimages")
public class Image {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "rest_image_id")
	private Integer restImageId;
//	@Column(name = "rest_id")
//	private Integer restId;
	@ManyToOne
	@JoinColumn(name="rest_id") // 外鍵欄位名稱
	private Restaurant rest;
	@Column(name = "rest_image_name")
	private String restImageName;
	//private byte[] restImage;//這樣不容易讓jsp呈顯圖片
	@Column(name = "rest_image")
	private String restImage;
	@Column(name = "rest_image_desc")
	private String restImageDesc;
	
	public Integer getRestImageId() {
		return restImageId;
	}
	public void setRestImageId(Integer restImageId) {
		this.restImageId = restImageId;
	}
//	public Integer getRestId() {
//		return restId;
//	}
//	public void setRestId(Integer restId) {
//		this.restId = restId;
//	}
	public String getRestImageName() {
		return restImageName;
	}
	public void setRestImageName(String restImageName) {
		this.restImageName = restImageName;
	}
	public String getRestImageDesc() {
		return restImageDesc;
	}
	public void setRestImageDesc(String restImageDesc) {
		this.restImageDesc = restImageDesc;
	}
	public String getRestImage() {
		return restImage;
	}
	public void setRestImage(String restImage) {
		this.restImage = restImage;
	}
	public Restaurant getRest() {
		return rest;
	}
	public void setRest(Restaurant rest) {
		this.rest = rest;
	}

}
