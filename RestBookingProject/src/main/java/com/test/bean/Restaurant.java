package com.test.bean;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotEmpty;

import com.google.gson.annotations.Expose;

@Entity
@Table(name = "rest")
public class Restaurant {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "rest_id")
	private Integer id;
	@NotEmpty(message="餐廳名稱不可為空白")
	@Column(name = "rest_name")
	private String name;
	@NotEmpty(message="餐廳地址不可為空白")
	@Column(name = "address")
	private String address;
	@NotEmpty(message="餐廳聯絡方式不可為空白")
	@Column(name = "phone_num")
	private String phoneNum;
	@Column(name = "phone_ext")
	private String phoneExt;
	@Column(name = "opening_time")
	private String openingTime;
	@Column(name = "closing_time")
	private String closingTime;

	@OneToMany(mappedBy = "bookingRest")
	//這裡的bookingRest，是該類的對應類
	//20240127新增
	//餐廳類別原本並無餐廳訂位List這個屬性，
	//但是因為餐廳在資料庫是一對多關聯到餐廳訂位訊息，
	//而在ORM工具中，希望透過「餐廳在資料庫是一對多關聯到餐廳訂位訊息」這個訊息，
	//去定義類之間的關聯；透過將類與類之間(餐廳類、餐廳訂位類)定義為一對多關係
	//就可改使用物件存取資料庫，取代直接使用原生SQL操作資料庫
	//1
	//故於類內部(餐廳類內部)，新增關聯類(餐廳訂位類)之屬性；又因為一餐廳對多筆餐廳訂位
	//故新增的屬性為餐廳訂位List
	//一餐廳對多筆餐廳訂位，表示需要添加@OneToMany註釋
	//2
	//接著在另一關聯類(餐廳訂位類)，由於一餐廳訂位類對應一餐廳類，故於餐廳訂位類新增一餐廳類餐廳屬性
	//3
	//一餐廳訂位類對應一餐廳類，若以資料庫角度來看，是餐廳類有主鍵、餐廳訂位類有外鍵
	//4
	//這時餐廳類的餐廳屬性，會被JPA預設為是餐廳類主鍵名稱(具體的主鍵名稱：屬性名+_id)、餐廳訂位類的外鍵
	//5
	//這樣的話，透過這個餐廳類的餐廳屬性，即可連結餐廳類與餐廳訂位類
	//6
	//故餐廳類內的餐廳訂位屬性，就是被「餐廳類的餐廳屬性」拿去跟餐廳類連結
	//7
	//所以前面的@OneToMany註釋，需要添加mappedBy參數，參數值就是「餐廳類的餐廳屬性」
	//8
	//若需要修改JPA預設的主鍵名稱，需要使用@JoinColumn註釋，直接在「JPA預設的主鍵名稱」正上方使用
	//9
	//而若要做到兩個關聯類之間的雙向關聯，就要在餐廳訂位類的餐廳屬性，添加@ManyToOne註釋
	private List<BookingRecord> bookingRecordList;
	
	@OneToMany(mappedBy="rest")//rest是Image類用來跟Rest類關聯的屬性，
	//而rest存在於Image類內
	private List<Image> imageList;
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPhoneNum() {
		return phoneNum;
	}
	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}
	public String getPhoneExt() {
		return phoneExt;
	}
	public void setPhoneExt(String phoneExt) {
		this.phoneExt = phoneExt;
	}
	public List<Image> getImageList() {
		return imageList;
	}
	public void setImageList(List<Image> imageList) {
		this.imageList = imageList;
	}
	public String getOpeningTime() {
		return openingTime;
	}
	public void setOpeningTime(String openingTime) {
		this.openingTime = openingTime;
	}
	public String getClosingTime() {
		return closingTime;
	}
	public void setClosingTime(String closingTime) {
		this.closingTime = closingTime;
	}
	public List<BookingRecord> getBookingRecordList() {
		return bookingRecordList;
	}
	public void setBookingRecordList(List<BookingRecord> bookingRecordList) {
		this.bookingRecordList = bookingRecordList;
	}
}
