package com.test.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.util.Base64;
import java.util.HexFormat;
import java.util.Optional;

import org.springframework.security.crypto.keygen.KeyGenerators;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.test.bean.RegisterDTO;
import com.test.bean.User;
import com.test.bean.VerificationToken;
import com.test.dao.UserDao;
import com.test.dao.VerificationRepository;

@Service
public class UserService {
	
	UserDao userDao;
	PasswordEncoder encoder;
	VerificationRepository verificationRepository;

	public UserService(UserDao userDao, PasswordEncoder encoder, VerificationRepository verificationRepository) {
		super();
		this.userDao = userDao;
		this.encoder = encoder;
		this.verificationRepository = verificationRepository;
	}

	@Transactional("jpaTxManager")
	  public String register(RegisterDTO reg) {
	    String email = reg.getEmail().trim().toLowerCase();
//	    if (users.existsByEmail(email)) {
//	      throw new IllegalStateException("無法完成註冊"); // 訊息請對外模糊化
//	    }
	    User u = new User();
	    u.setAccount(reg.getAccount());
	    u.setEmail(email);
	    u.setPassword(encoder.encode(reg.getPassword()));
	    u.setUserRole(reg.getUserRole());
	    u.setEnabled(false);
	    int result = userDao.addUser(u);
	    
	    if(result!=0) {
	    	byte[] key = KeyGenerators.secureRandom(32).generateKey();
	    	String tokenForEmail = Base64.getUrlEncoder().withoutPadding().encodeToString(key);
	    	MessageDigest md=null;
			try {
				md = MessageDigest.getInstance("SHA-256");
			} catch (NoSuchAlgorithmException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	String tokenHash = java.util.HexFormat.of().formatHex(md.digest(tokenForEmail.getBytes(StandardCharsets.UTF_8)));
	    	//這樣產生的token會是唯一
	    	
	    	VerificationToken vt = new VerificationToken();
	    	vt.setToken(tokenHash);
	    	vt.setUser(u);
	    	vt.setCreatedAt(Instant.now());
	    	
	    	verificationRepository.save(vt);
	    	
	    	return tokenForEmail;
	    }
	    return null;
	}
	
	@Transactional("jpaTxManager")
	public int verify(String rawToken) {
		MessageDigest md=null;
		try {
			md = MessageDigest.getInstance("SHA-256");
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        byte[] digest = md.digest(rawToken.getBytes(StandardCharsets.UTF_8));
        String token = HexFormat.of().formatHex(digest);
        
        Optional<VerificationToken> result = verificationRepository.fetchByToken(token);
        
        if(result.isPresent()) {
        	VerificationToken vt = result.get();
        	vt.setUsed(true);
        	verificationRepository.save(vt);//會根據主鍵是否存在，判斷要做insert還是update

        	User user = result.get().getUser();
        	//user.setEnabled(true);
        	
        	return userDao.updateUser(user);
        }else {
        	return 0;
        }
	}
		
}
