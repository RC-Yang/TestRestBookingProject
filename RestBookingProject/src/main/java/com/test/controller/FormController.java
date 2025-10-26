package com.test.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.test.bean.Country;
import com.test.bean.District;
import com.test.bean.RestStyle;
import com.test.bean.User;
import com.test.dao.BookingRepository;
import com.test.dao.RestStyleRepository;
import com.test.dao.UserRepositoryBySpringJPA;
import com.test.service.FormService;
import com.test.util.DaoUtil;


@Controller
@RequestMapping("/form")
public class FormController {
	
	@Autowired
	private FormService formService;
	@Autowired
	private UserRepositoryBySpringJPA userRepositoryBySpringJPA;
	@Autowired
	private RestStyleRepository restStyleRepository;
	@Autowired
	private BookingRepository bookingRepository;
	
//	@RequestMapping("/queryAllCity")
//	@ResponseBody
//	public Map<String,String> queryAllCity() {
//		List<District> cityList = formService.findAllCity();
//
//		Map<String,String> cityMap = new HashMap<>();
//		for(District district:cityList) {
//			cityMap.put(district.getCountryName(),district.getCountryName());//重複的縣市名稱，就單純put不進去而已，不會跳錯
//		}
//		return cityMap;
//	}
	
	@RequestMapping("/queryAllCity")
	@ResponseBody
	public List<Country> queryAllCity() {
		List<Country> cityList = formService.findAllCity();

		return cityList;
	}

//	@RequestMapping("/queryDistrict")
//	@ResponseBody
//	public Map<String,String> queryDistrict(@RequestParam(name="country") String country) {
//		List<District> districtList = formService.findDistrictsByCountry(country);
//
//		Map<String,String> districtMap = new HashMap<>();
//		for(District district:districtList) {
//			districtMap.put(district.getDistrictId().toString(),district.getDistrictName());
//		}
//		return districtMap;
//	}
	
	@GetMapping("/queryDistrict")
	@ResponseBody
	public List<District> queryDistrict(@RequestParam(name="cityId") Integer cityId){
		return formService.findDistrictsByCity(cityId);
	}
	
//	@RequestMapping("/queryAllDistricts")
//	@ResponseBody
//	public Map<String,String> findAllDistricts() {
//		List<District> districtList = formService.findAllDistricts();
//
//		Map<String,String> districtMap = new HashMap<>();
//		for(District district:districtList) {
//			districtMap.put(district.getDistrictId().toString(),district.getCountryName()+district.getDistrictName());
//		}
//		return districtMap;
//	}
	
	@RequestMapping("/queryAllDistricts")
	@ResponseBody
	public List<District> findAllDistricts() {
		List<District> districtList = formService.findAllDistricts();

		return districtList;
	}
	
	@GetMapping("/queryDistrictForRest")
	@ResponseBody
	public List<District> queryDistrictForRest(@RequestParam(name="country") String country) {
		List<District> districtList = formService.findDistrictsByCountry(country);
		return districtList;//透過@ResponseBody註釋，將arraylist物件轉型為json格式物件
	}
	
	@RequestMapping(value="/queryRestStyle")
	public String queryRestStyle(Model model) {
		
		List<RestStyle> restStyleList = restStyleRepository.findAllRestStyle();
		model.addAttribute("restStyleList", restStyleList);
		
		return "queryRest4";
	}
	
	@RequestMapping("/goToUpdateUserInfo")
	public String goToUpdateUserInfo(HttpServletRequest req,Model model) throws IOException {
		HttpSession session = req.getSession();
		String account = session.getAttribute("account").toString();
		
		User user = userRepositoryBySpringJPA.queryRestUser(account);
		model.addAttribute("user", user);
		model.addAttribute("userCity", user.getRest().getAddress().substring(0, 3));
		model.addAttribute("userDistrict", user.getRest().getAddress().substring(3,
				user.getRest().getAddress().indexOf("區")+1));
		model.addAttribute("address", user.getRest().getAddress().substring(
				user.getRest().getAddress().indexOf("區")+1));
		
		
		if(user.getPictureForJPA()!=null) {
			String picString = DaoUtil.getImageAsBase64(user.getPictureForJPA());
			model.addAttribute("picture", picString);
		}else {
			ServletContext context = req.getServletContext();//Request是在某個servlet環境運行的，所以才可以透過Request去取得servlet環境變數
			String imagePath = context.getRealPath("/image/photoSample.jpg");
			byte[] imageData = Files.readAllBytes(Paths.get(imagePath));
			String image = null;		
			image = DaoUtil.getImageAsBase64(imageData);
			model.addAttribute("picture", image);
		}
		
		return "updateUserInfo";
	}
	
	@PostMapping("/deleteBookingRecord")
	@ResponseBody
	public String deleteBookingRecord(HttpServletRequest req) {
		String bookingRecordId = req.getParameter("bookingRecordId");
		bookingRepository.deleteById(Integer.parseInt(bookingRecordId));//這是Spring Data JPA的repository，自帶的方法
		return "刪除成功！";
	}
	
	@GetMapping("/goToUpdateBookingRecordPage")
	public String goToUpdateBookingRecordPage() {
		return "updateBookingRecord";
	}
	
	@PostMapping("/checkUserAccount")
	@ResponseBody
	public String checkUserAccount(@RequestParam String account) {
		Optional<User> user = userRepositoryBySpringJPA.queryUserAccount(account);
		if(user.isPresent()) {
			return "帳戶存在。";
		}
		return "帳戶不存在！";
	}
	@PostMapping("/checkUser")
	@ResponseBody
	public String checkUser(@RequestParam String account,@RequestParam String password) {
		Optional<User> user = userRepositoryBySpringJPA.queryUser(account,password);
		if(user.isPresent()) {
			return "帳密正確。";
		}
		return "帳密不正確！";
	}
}
