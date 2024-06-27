package com.test.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Optional;

import javax.servlet.http.*;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.test.bean.Restaurant;
import com.test.bean.User;
import com.test.dao.RestDao;
import com.test.dao.UserDao;
import com.test.util.ControllerUtil;
import com.test.util.EmailService;

@Controller
@RequestMapping("/entry")
public class EntryController {
	
	@Autowired
	RestDao restDao;
	@Autowired
	UserDao userDao;
	@Autowired
	EmailService emailService;
	
	@RequestMapping(value="/checkLogin")
	@ResponseBody
	public String checkLogin(HttpServletRequest req,HttpServletResponse resq) {
		String userType = req.getParameter("userType");
		String account = req.getParameter("account");
		String password = req.getParameter("password");
		
		Optional<User> userOptional = userDao.queryUserByAccount(account, Integer.parseInt(userType),password);
		
		if(userOptional.isPresent()) {
			HttpSession session = req.getSession();
			User user = userOptional.get();
			session.setAttribute("login", true);
			session.setAttribute("account", user.getAccount());
			session.setAttribute("password", user.getPassword());
			session.setAttribute("userType", user.getUserType());
			return "登入成功";
		}
		
		return "登入失敗";		
	}
	
	@RequestMapping(value="/login")
	public String login(HttpServletRequest req,HttpServletResponse resq,Model model) throws IOException {
		HttpSession session = req.getSession();
		String userType = req.getParameter("userType")==null?session.getAttribute("userType").toString():req.getParameter("userType");
		String account = req.getParameter("account")==null?(String)session.getAttribute("account"):req.getParameter("account");
		String password = req.getParameter("password")==null?(String)session.getAttribute("password"):req.getParameter("password");
		
		Optional<User> userOptional = userDao.queryUserByAccount(account, Integer.parseInt(userType),password);
		
		if(userOptional.isPresent()) {
			Optional<String> image = userDao.queryUserImage(req.getServletContext(),account, Integer.parseInt(userType));
			session.setAttribute("userImage", image.get());
			if(userType.equals("1")){
				return "loginSuccessForUser";
			}else if(userType.equals("2")){
				return "loginSuccessForRest";
			}		
		}
		
		//在使用 Spring 的 redirect 方法時，路徑是相對於應用的根目錄的
		//根目錄是webapp這個資料夾
		return "redirect:/index.jsp";
	}
	@GetMapping(value="/goToReg")
	public String goToRegister(@RequestParam(name="action") Integer action,Model model
			) {
		model.addAttribute("action", action);
		model.addAttribute("user", new User());//讓user物件綁定到前端表單step1

		return "reqAndLogin5";
	}
	@GetMapping(value="/goToLogIn")
	public String goToLogIn(@RequestParam(name="action") Integer action,Model model
			) {
		model.addAttribute("action", action);
		model.addAttribute("user", new User());

		return "reqAndLogin5";
	}
	
//	@PostMapping(value="/reg1")
//	public String registerToDB(@ModelAttribute("user") User user) {
//		//讓user物件綁定到前端表單step3
//		int result = userDao.addUser(user);
//		System.out.println("result = "+result);
//		return "loginSuccess";
//	}
	
	@PostMapping(value="/reg")
	@ResponseBody//Spring MVC的表單雙向綁定，是將表單跟VO綁定；若前端表單值的型別，不能直接對應到VO的屬性型別的話，就不能直接雙向綁定
	//例如img元素，對應的後端型別是MultipartFile，但VO通常會將相關屬性型別設為Byte array
	public String registerToDB(@RequestParam(name="picture")MultipartFile picture, 
			@RequestParam(name="account")String account,@RequestParam(name="email")String email,
			@RequestParam(name="password")String password,
			@RequestParam(name="userType")int userType,
			@RequestParam(name="restName")String restName,
			@RequestParam(name="restAddr")String restAddr,
			@RequestParam(name="restTel")String restTel,
			@RequestParam(name="restTelExt")String restTelExt,
			@RequestParam(name="openingTime")String openingTime,
			@RequestParam(name="closingTime")String closingTime,
			HttpSession session,HttpServletRequest req) throws IOException {

		User user = new User();
		user.setAccount(account);
		user.setEmail(email);
		user.setPassword(password);
		user.setPicture(picture);
		user.setUserType(userType);
		int result = 0;
		
		if(userType==1) {
			result = userDao.addUser(user);
		}
		else if(userType==2) {
			Restaurant rest = new Restaurant();
			rest.setAddress(restAddr);
			rest.setName(restName);
			rest.setPhoneNum(restTel);
			rest.setPhoneExt(restTelExt);
			rest.setOpeningTime(openingTime);
			rest.setClosingTime(closingTime);
			
			result = userDao.addRestUser(user, rest);
		}
		
		try {
		    // 暂停一段时间
		    Thread.sleep(1000); // 1秒钟的暂停
		} catch (InterruptedException e) {
		    e.printStackTrace();
		}
		Optional<User> userOp = userDao.queryUserByAccount(account,userType,password);
		if(userOp.isPresent()) {
			Optional<String> userImgOp = userDao.queryUserImage(req.getServletContext(),account,userType);
			if(userImgOp.isPresent()) {
				session.setAttribute("user", userOp.get());
				session.setAttribute("account", user.getAccount());
				session.setAttribute("password", user.getPassword());
				session.setAttribute("userType", user.getUserType());
				session.setAttribute("userImg", userImgOp.get());
			}
			
			return "RegisterSuccess";
		}
		return "RegisterFail";
	}
	
	@RequestMapping("/logout")
	public String logout(HttpServletRequest req) {
		HttpSession session = req.getSession();
		session.invalidate();
		
		return "redirect:/index.jsp";
	}
	@RequestMapping("/sendUpdatePasswordMail")
	public String sendUpdatePasswordMail(HttpServletRequest req,Model model) {
		String email = req.getParameter("email");
		model.addAttribute("action", 3);
		model.addAttribute("user", new User());
		//ControllerUtil.sendMail(email);
		//20240627修改
		emailService.sendMail(email);
		return "reqAndLogin5";
	}
	@RequestMapping("/goToResetPassword")
	public String goToResetPassword() {
		return "passwordReset";
	}
	@RequestMapping("/updatePassword")
	@ResponseBody
	public String updatePassword(HttpServletRequest req) {
		String newPassword = req.getParameter("password");	
		return "update password success";
	}

	@GetMapping(value="/goTologinSuccessForUser")
	public String goTologinSuccessForUser() {
		return "loginSuccessForUser";
	}
	
	@GetMapping(value="/goTologinSuccessForUser2")
	public String goTologinSuccessForUser2() {
		return "loginSuccessForUser2";
	}
	@RequestMapping("/goToReqAndLogin")
	public String goToReqAndLogin() {
		return "reqAndLogin5";
	}
}
