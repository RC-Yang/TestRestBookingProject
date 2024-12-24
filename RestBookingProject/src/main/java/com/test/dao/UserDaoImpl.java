package com.test.dao;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Blob;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Optional;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.test.bean.Restaurant;
import com.test.bean.User;
import com.test.util.DaoUtil;

@Repository
public class UserDaoImpl implements UserDao{
	
	@Autowired
	private JdbcTemplate jdbcTemplate;

	public int addUser(User user) {
		String sql1 = "insert into user(email,password,account,user_type,picture)"
				+ "values(?,?,?,?,?)";
		
		int result = 0;
		result = jdbcTemplate.update(conn->{
			PreparedStatement pstmt = conn.prepareStatement(sql1);
			
			pstmt.setString(1,user.getEmail());
			pstmt.setString(2,user.getPassword());
			pstmt.setString(3,user.getAccount());
			pstmt.setInt(4,user.getUserType());	
			pstmt.setBlob(5, DaoUtil.multipartFileToBlob(user.getPicture()));
			return pstmt;
			});
	 
		return result;		
	}

	public int addAUTHORITIES(User user) {
		
		int result = 0;

		if(user.getUserType()==1) {
			String sql1 ="INSERT INTO AUTHORITIES(account,authority) values(?,'ROLE_USER')";
			result = jdbcTemplate.update(conn->{
				PreparedStatement pstmt = conn.prepareStatement(sql1);
				pstmt.setString(1,user.getAccount());
				return pstmt;
			});
		}else if(user.getUserType()==2) {
			String sql2 ="INSERT INTO AUTHORITIES(account,authority) values(?,'ROLE_REST')";
			result = jdbcTemplate.update(conn->{
				PreparedStatement pstmt = conn.prepareStatement(sql2);
				pstmt.setString(1,user.getAccount());
				return pstmt;
			});
		}
		return result;		
	}
	@Override
	public int addRestUser(User user,Restaurant rest) {
		int result = 0;

		String restSql = "insert into rest(rest_name,address,phone_num,phone_ext,opening_time,closing_time)"
				+ "values(?,?,?,?,?,?)";
		
		jdbcTemplate.update(conn->{
			PreparedStatement pstmt = conn.prepareStatement(restSql);
			
			pstmt.setString(1,rest.getName());
			pstmt.setString(2,rest.getAddress());
			pstmt.setString(3,rest.getPhoneNum());
			pstmt.setString(4,rest.getPhoneExt());	
			pstmt.setString(5,rest.getOpeningTime());
			pstmt.setString(6,rest.getClosingTime());
			return pstmt;
			});

		return result;
	}

	@Override
	public List<User> queryAllUser() {
		String sql = "SELECT account,picture,user_type FROM web.User";
		
		RowMapper<User> mapper = new RowMapper<>() {

			@Override
			public User mapRow(ResultSet rs, int rowNum) throws SQLException {
				//取出user資料
				Blob blob = rs.getBlob("picture");
				String account = rs.getString("account");
				int user_type = rs.getInt("user_type");

				byte[] byteArray = null;				
				byteArray = DaoUtil.blobToByteArr(blob);

				//取出該筆餐廳資料後，將資料加入VO
				User user = new User();
				user.setAccount(account);
				user.setUserType(user_type);
				
				user.setImage(DaoUtil.getImageAsBase64(byteArray));
				return user;
			}
		};

		List<User> user = jdbcTemplate.query(sql, mapper);
		return user;
	}
	//20231226新增
	public Optional<User> queryUserByAccount(String account,Integer userType,String password) {
		String sql = "SELECT account,user_type,password FROM web.User where account=? and user_type=? and password=?";
		
		try {
			User user = jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(User.class),//BeanPropertyRowMapper是Spring提供的一个实用类，用于将查询结果的行映射到Java对象的属性 
					account,userType,password);
			return Optional.ofNullable(user);
		} catch (EmptyResultDataAccessException e) {
			return Optional.empty();
		} 
	}
	//20240101新增
	public Optional<User> queryUserByAccount(String account,String password) {
		String sql = "SELECT account,password FROM web.User where account=? and password=?";
		
		try {
			User user = jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(User.class), 
					account,password);
			return Optional.ofNullable(user);
		} catch (EmptyResultDataAccessException e) {
			return Optional.empty();
		} 
	}
	
	public Optional<String> queryUserImage(ServletContext context,String account,Integer userType) throws IOException {
		String sql = "SELECT picture FROM web.User where account=? and user_type=?";
		
		RowMapper<String> mapper = new RowMapper<>() {

			@Override
			public String mapRow(ResultSet rs, int rowNum) throws SQLException {
				//取出user資料
				Blob blob = rs.getBlob("picture");
				if(blob==null) {
					return null;
				}
				//將資料轉型為byte array
				byte[] byteArray = null;				
				byteArray = DaoUtil.blobToByteArr(blob);

				//將資料轉型為base64字串
				String image = null;		
				image = DaoUtil.getImageAsBase64(byteArray);
				return image;
			}
		};

		try {
			String picture = jdbcTemplate.queryForObject(sql, mapper, 
					account,userType);
			if(picture==null) {
				//找不到使用者圖片，就以預設圖片為使用者圖片
				String imagePath = context.getRealPath("/image/photoSample.jpg");
				byte[] imageData = Files.readAllBytes(Paths.get(imagePath));
				String image = null;		
				image = DaoUtil.getImageAsBase64(imageData);
				return Optional.ofNullable(image);
			}
			
			return Optional.ofNullable(picture);
		} catch (EmptyResultDataAccessException e) {
			return Optional.empty();
		} 
	}
}
