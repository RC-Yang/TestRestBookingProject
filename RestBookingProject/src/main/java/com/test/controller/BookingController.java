package com.test.controller;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.persistence.Tuple;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.test.bean.BookingRecord;
import com.test.bean.BookingRecordDTO;
import com.test.bean.Restaurant;
import com.test.dao.BookingRepository;
import com.test.dao.RestRepositoryByJPA;
import com.test.util.ControllerUtil;

@Controller
@RequestMapping("/booking")
public class BookingController {
	
	@Autowired
	private BookingRepository bookingRepository;
	@Autowired
	private RestRepositoryByJPA restRepository;

	@RequestMapping("/goToBooking")
	public String goToBookingPage(@RequestParam("restName") String restName,
			@RequestParam("restOT") String restOT,
			@RequestParam("restCT") String restCT,
			@RequestParam("restId") String restId,
			@RequestParam("curDate") String curDate,Model model) {
		model.addAttribute("restName", restName);
		model.addAttribute("restOT", restOT);
		model.addAttribute("restCT", restCT);
		model.addAttribute("restId", restId);
		model.addAttribute("curDate", curDate);
		model.addAttribute("restId", restId);
		
		return "bookingRest";
	}
	
	@RequestMapping("/queryBooking")
	public String queryBookingRecord(Model model,HttpServletRequest req) {
		javax.servlet.http.HttpSession session = req.getSession();
		String account = req.getParameter("account")==null?(String)session.getAttribute("account"):req.getParameter("account");
		List<BookingRecord> bookingRecord = bookingRepository.findBookingRecordsByGuestId(Integer.parseInt(account));

		//20240623新增		
        StringBuilder sb = new StringBuilder();
        int i =0;
        sb.append("[");
        for (BookingRecord record : bookingRecord) {
            sb.append("{");
            sb.append("\"rest\": \"").append(record.getBookingRest().getName()).append("\", ");
            sb.append("\"date\": \"").append(record.getBookingDate()).append("\", ");
            sb.append("\"time\": \"").append(record.getBookingTime()).append("\", ");
            sb.append("\"number\": ").append(record.getGuestNum());
            sb.append("}");

            i++;
            if (i < bookingRecord.size()) {
            	sb.append(", ");
            }
        }
        sb.append("]");

		model.addAttribute("bookingRecord", sb.toString());
		return "bookingRecord";
	}
	
	@GetMapping("/goToUpdateBookingRecord")
	public String goToUpdateBookingRecord(Model model,HttpServletRequest req) {
		javax.servlet.http.HttpSession session = req.getSession();
		String account = req.getParameter("account")==null?(String)session.getAttribute("account"):req.getParameter("account");
		List<BookingRecord> bookingRecord = bookingRepository.findBookingRecordsByGuestId(Integer.parseInt(account));

		model.addAttribute("bookingRecord", bookingRecord);
		return "bookingRecord2";
	}
	
	@PostMapping("/makeReservation")
	@ResponseBody
	public String makeReservation(@RequestParam("name")String name,
			@RequestParam("phone")String phone,
			@RequestParam("date")String date,
			@RequestParam("time")String time,
			@RequestParam("guests")String guests,
			@RequestParam("restId")String restId,
			@RequestParam("restName")String restName,HttpServletRequest req) {//html type="date"、"time"的值，在後端會直接對應到Java的字串型別
	    // 檢查日期和時間是否在營業時間內
	    if (!isWithinBusinessHours(date, time,Integer.parseInt(restId))) {
	        return "訂位失敗：不在營業時間內";
	    }
	    // 檢查是否還有足夠的位子
	    if (!isSeatsAvailable(Integer.parseInt(restId),java.sql.Date.valueOf(date),
	    		Time.valueOf(LocalTime.parse(time)),Integer.parseInt(guests))) {
	        return "訂位失敗：座位不足";
	    }
	
	    // 执行訂位的其他相關操作，例如更新座位狀態等
	    restRepository.addBookingData(Integer.parseInt(restId),java.sql.Date.valueOf(date), 
	    		Time.valueOf(LocalTime.parse(time)),Integer.valueOf(guests),
	    		Integer.parseInt(req.getSession().getAttribute("account").toString()));

	    return "於"+restName+"的"+date+"，"+time+"的"+guests+"位客人，訂位成功！";
	}

    private boolean isWithinBusinessHours(String date, String time,Integer restId) {
    	Restaurant result = (Restaurant)restRepository.queryRestActiveTime(restId);
    	if(result.getOpeningTime().compareTo(time)<0&&
    			result.getClosingTime().compareTo(time)>0) {
    		return true;
    	}
        return false;
    }

    private boolean isSeatsAvailable(int restId,Date bookingDate,Time bookingTime,int numberOfSeats) {
//    	Integer avalibleSeat = (Integer)restRepository.queryRestAvalibleSeat(restId,bookingDate,bookingTime);
    	Object[] allSeatAndNonavalibleSeat = (Object[])restRepository.queryRestAvalibleSeat(restId,bookingDate,bookingTime);
    	
    	BigDecimal nonavalibleSeat = (BigDecimal)allSeatAndNonavalibleSeat[0];
    	Integer allSeat = (Integer)allSeatAndNonavalibleSeat[1];
    	Integer avalibleSeat = allSeat-nonavalibleSeat.intValue();
    	if(numberOfSeats<=avalibleSeat) {
    		return true;
    	}
        return false;
    }
}
