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
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.test.bean.Restaurant;
import com.test.bean.User;
import com.test.util.DaoUtil;

@Repository
public class UserDaoImpl implements UserDao{
	
	private JdbcTemplate jdbcTemplate;	

	public UserDaoImpl(JdbcTemplate jdbcTemplate) {
		super();
		this.jdbcTemplate = jdbcTemplate;
	}


	public int addUser(User user) {
		String sql1 = "insert into user(email,password,account,user_role,picture,enabled)"
				+ "values(?,?,?,?,?,?)";
		
		int result = 0;
		result = jdbcTemplate.update(conn->{
			PreparedStatement pstmt = conn.prepareStatement(sql1);
			
			pstmt.setString(1,user.getEmail());
			pstmt.setString(2,user.getPassword());
			pstmt.setString(3,user.getAccount());
			pstmt.setString(4,user.getUserRole());
			
			if(user.getPicture()==null) {
				pstmt.setNull(5, java.sql.Types.BLOB);
			}else {
				pstmt.setBlob(5, DaoUtil.multipartFileToBlob(user.getPicture()));
			}	
			
			pstmt.setBoolean(6,user.isEnabled());
			
			return pstmt;
		});
	 
		return result;		
	}
	
	public int updateUser(User user) {
		String sql = "update user set enabled=? where account=?";
		
		return jdbcTemplate.update(sql,true,user.getAccount());
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
				String userRole = rs.getString("user_role");

				byte[] byteArray = null;				
				byteArray = DaoUtil.blobToByteArr(blob);

				//取出該筆餐廳資料後，將資料加入VO
				User user = new User();
				user.setAccount(account);
				user.setUserRole(userRole);
				
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
			User user = jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(User.class),
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
	
	public Optional<byte[]> queryUserImage(String account) throws IOException {
		String sql = "SELECT picture FROM web.User where account=? ";
		byte[] picture = null;
		
		RowMapper<byte[]> mapper = new RowMapper<>() {

			@Override
			public byte[] mapRow(ResultSet rs, int rowNum) throws SQLException {
				//取出user資料
				Blob blob = rs.getBlob("picture");
				if(blob==null) {
					return null;
				}
				//將資料轉型為byte array
				byte[] byteArray = null;				
				byteArray = DaoUtil.blobToByteArr(blob);
				return byteArray;
			}
		};

		try {
			picture = jdbcTemplate.queryForObject(sql, mapper, 
					account);
			
			return Optional.ofNullable(picture);
		} catch (EmptyResultDataAccessException e) {
			return Optional.ofNullable(picture);
		}
	}
}
