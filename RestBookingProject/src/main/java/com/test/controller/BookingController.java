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
		for (BookingRecord record : bookingRecord) {
			sb.append("rest: ").append(record.getBookingRest().getName()).append(", ")
		      .append("date: ").append(record.getBookingDate()).append(", ")
		      .append("time: ").append(record.getBookingTime()).append(", ")
		      .append("number: ").append(record.getGuestNum()).append("; ");
		}
		if (sb.length() > 0) {
		    sb.delete(sb.length() - 2, sb.length());
		}
		String bookingRecordStr = sb.toString();
		
		// 切割字串以分號為分隔符
        String[] bookingRecordStrArr = bookingRecordStr.split(";");

        // 使用 Gson 將每個訂位信息轉換成 JSON
        Gson gson = new Gson();
        List<BookingRecordDTO> bookingRecordDTOList = new ArrayList<>();

        for (String str : bookingRecordStrArr) {
        	BookingRecordDTO bookingRecordDTO = new BookingRecordDTO();
            
            // 解析每個訂位信息
            String[] parts = str.trim().split(", ");
            for (String part : parts) {
                String[] keyValue = part.split(": ");
                String key = keyValue[0].trim();
                String value = keyValue[1].trim();

                switch (key) {
                    case "rest":
                    	bookingRecordDTO.setBookingRestName(value);
                        break;
                    case "date":
                    	bookingRecordDTO.setBookingDate(value);
                        break;
                    case "time":
                    	bookingRecordDTO.setBookingTime(value);
                        break;
                    case "number":
                    	bookingRecordDTO.setGuestNum(Integer.parseInt(value));
                        break;
                    default:
                        // Handle unknown key
                        break;
                }
            }

            bookingRecordDTOList.add(bookingRecordDTO);
        }
		
        StringBuilder sb2 = new StringBuilder();
        sb2.append("[");
        for (int i = 0; i < bookingRecordDTOList.size(); i++) {
        	BookingRecordDTO bookingRecordDTO = bookingRecordDTOList.get(i);
            sb2.append("{");
            sb2.append("\"rest\": \"").append(bookingRecordDTO.getBookingRestName()).append("\", ");
            sb2.append("\"date\": \"").append(bookingRecordDTO.getBookingDate()).append("\", ");
            sb2.append("\"time\": \"").append(bookingRecordDTO.getBookingTime()).append("\", ");
            sb2.append("\"number\": ").append(bookingRecordDTO.getGuestNum());
            sb2.append("}");

            if (i < bookingRecordDTOList.size() - 1) {
            	sb2.append(", ");
            }
        }
        sb2.append("]");

		model.addAttribute("bookingRecord", sb2.toString());
		return "bookingRecord";
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
