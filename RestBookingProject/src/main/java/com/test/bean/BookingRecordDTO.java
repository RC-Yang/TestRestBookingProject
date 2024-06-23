package com.test.bean;

import java.sql.Date;
import java.sql.Time;


public class BookingRecordDTO {
	private String bookingRestName;
	private String bookingDate;
	private String bookingTime;
	private Integer guestNum;
	public String getBookingRestName() {
		return bookingRestName;
	}
	public void setBookingRestName(String bookingRestName) {
		this.bookingRestName = bookingRestName;
	}
	public String getBookingDate() {
		return bookingDate;
	}
	public void setBookingDate(String bookingDate) {
		this.bookingDate = bookingDate;
	}
	public String getBookingTime() {
		return bookingTime;
	}
	public void setBookingTime(String bookingTime) {
		this.bookingTime = bookingTime;
	}
	public Integer getGuestNum() {
		return guestNum;
	}
	public void setGuestNum(Integer guestNum) {
		this.guestNum = guestNum;
	}
	
}
