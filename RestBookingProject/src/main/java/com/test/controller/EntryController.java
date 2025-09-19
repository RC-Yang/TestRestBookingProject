package com.test.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.*;

import javax.servlet.ServletContext;
import javax.servlet.http.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.test.bean.Restaurant;
import com.test.bean.User;
import com.test.dao.RestDao;
import com.test.dao.UserDao;
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
	//20240817新增
	@Autowired
	private  AuthenticationProvider authenticationProvider;
	@Autowired
    private ServletContext servletContext;

	@RequestMapping("/login")
    public String loginForward(Authentication auth) {
        boolean isUser = auth.getAuthorities().stream()
            .anyMatch(a -> "ROLE_USER".equals(a.getAuthority()));
        return isUser ? "loginSuccessForUser" : "loginSuccessForAdmin";
    }
	
	@RequestMapping(value="/users/{id}/getUserImage")
	//@PreAuthorize("#id == principal.id")
	public ResponseEntity<byte[]> getUserImage(@PathVariable Long id) throws IOException{
		Optional<byte[]> image;

		image = userDao.queryUserImage(id.toString());
		
		if(image.isPresent()) {
			return ResponseEntity.ok()
		            .contentType(MediaType.parseMediaType("image/jpeg"))
		            .body(image.get());
		}else {
			String realPath = servletContext.getRealPath("/image/photoSample.jpg");
		    File file = new File(realPath);

		    byte[] bytes = Files.readAllBytes(file.toPath());
			
			return ResponseEntity.ok()
		            .contentType(MediaType.IMAGE_JPEG)
		            .body(bytes);
		}				
	}
	
	@RequestMapping(value="/goToReg")
	public String goToRegister(Model model) {
		model.addAttribute("action", 1);
		model.addAttribute("user", new User());//讓user物件綁定到前端表單step1

		return "reqAndLogin5";
	}
	@GetMapping(value="/goToLogIn")
	public String goToLogIn(Model model) {
		model.addAttribute("action", 2);
		model.addAttribute("user", new User());

		return "reqAndLogin5";
	}
	
	@PostMapping(value="/reg")
	@ResponseBody//Spring MVC的表單雙向綁定，是將表單跟VO綁定；若前端表單值的型別，不能直接對應到VO的屬性型別的話，就不能直接雙向綁定
	//例如img元素，對應的後端型別是MultipartFile，但VO通常會將相關屬性型別設為Byte array
	@Transactional
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
			userDao.addUser(user);
			result = userDao.addAUTHORITIES(user);
		}
		else if(userType==2) {
			Restaurant rest = new Restaurant();
			rest.setAddress(restAddr);
			rest.setName(restName);
			rest.setPhoneNum(restTel);
			rest.setPhoneExt(restTelExt);
			rest.setOpeningTime(openingTime);
			rest.setClosingTime(closingTime);
			
			userDao.addUser(user);
			userDao.addRestUser(user, rest);
			result = userDao.addAUTHORITIES(user);
		}
		
		try {
		    // 暂停一段时间
		    Thread.sleep(1000); // 1秒钟的暂停
		} catch (InterruptedException e) {
		    e.printStackTrace();
		}
		Optional<User> userOp = userDao.queryUserByAccount(account,userType,password);
		if(userOp.isPresent()) {
			Optional<byte[]> userImgOp = userDao.queryUserImage(account);
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
	@GetMapping(value="/goTologinSuccessForAdmin")
	public String goTologinSuccessForAdmin() {
		return "loginSuccessForAdmin";
	}
	
	@PostMapping(value="/checkloginForAdmin")
	public ResponseEntity<String> checkloginForAdmin(HttpServletRequest req) throws NumberFormatException, IOException {
		
		String account = req.getParameter("account");
		String password = req.getParameter("password");
		String userType = req.getParameter("userType")==null?"3":req.getParameter("userType");

        UsernamePasswordAuthenticationToken authRequest = 
                new UsernamePasswordAuthenticationToken(account, password);

        Authentication authentication = authenticationProvider.authenticate(authRequest);

        SecurityContextHolder.getContext().setAuthentication(authentication);

		if (authentication != null && authentication.isAuthenticated()
				&&authentication.getAuthorities().stream()
		        .anyMatch(authority -> authority.getAuthority().equals("ROLE_ADMIN"))) {
			HttpSession session = req.getSession();
			session.setAttribute("account", account);
			Optional<byte[]> image = userDao.queryUserImage(account);
			session.setAttribute("userImage", image.get());
			
			return ResponseEntity.ok().body("登入成功");		
		}

		return ResponseEntity.ok().body("登入失敗");
	}
}
