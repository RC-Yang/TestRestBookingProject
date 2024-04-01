package com.test.bean;

import java.sql.Date;
import java.sql.Time;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name="booking")
public class BookingRecord {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "booking_id")
	private Integer bookingId;
	//使用JPA進行類之間的關聯對應，必須是以Java Bean來對應
	@ManyToOne
	@JoinColumn(name = "booking_rest_id")//booking_rest_id是BookingRecord對應表內的外鍵
	private Restaurant bookingRest;
	@Column(name = "booking_date")
	private Date bookingDate;
	@Column(name = "booking_time")
	private Time bookingTime;
	@Column(name = "guest_num")
	private Integer guestNum;
	@Column(name = "guest_id")
	private Integer guestId;
	@Column(name = "guest_name")
	private String guestName;
	@Column(name = "tel")
	private String tel;
	public Integer getBookingId() {
		return bookingId;
	}
	public void setBookingId(Integer bookingId) {
		this.bookingId = bookingId;
	}
//	public Integer getBookingRestId() {
//		return bookingRestId;
//	}
//	public void setBookingRestId(Integer bookingRestId) {
//		this.bookingRestId = bookingRestId;
//	}
	public Date getBookingDate() {
		return bookingDate;
	}
	public void setBookingDate(Date bookingDate) {
		this.bookingDate = bookingDate;
	}
	public Time getBookingTime() {
		return bookingTime;
	}
	public void setBookingTime(Time bookingTime) {
		this.bookingTime = bookingTime;
	}
	public Integer getGuestNum() {
		return guestNum;
	}
	public void setGuestNum(Integer guestNum) {
		this.guestNum = guestNum;
	}
	public Integer getGuestId() {
		return guestId;
	}
	public void setGuestId(Integer guestId) {
		this.guestId = guestId;
	}
	public String getGuestName() {
		return guestName;
	}
	public void setGuestName(String guestName) {
		this.guestName = guestName;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public Restaurant getBookingRest() {
		return bookingRest;
	}
	public void setBookingRest(Restaurant bookingRest) {
		this.bookingRest = bookingRest;
	}
}
