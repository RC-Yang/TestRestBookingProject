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

import com.test.bean.Restaurant;
import com.test.bean.User;
import com.test.util.DaoUtil;

@Repository
public class UserDaoImpl implements UserDao{
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	public int addUser(User user) {
		String sql = "insert into user(email,password,account,user_type,picture)"
				+ "values(?,?,?,?,?)";
		//update方法吃的參數是Preparestatementcreator物件，
		//這個物件回傳Preparestatement物件，給update方法使用，以執行crud動作
		//而update方法預期programmer傳入的參數，就是Preparestatementcreator物件
		//且programmer已經將Preparestatementcreator物件需實作的方法給寫好
		//也就是update方法預期Preparestatementcreator物件包含了方法的內容，可以讓他直接執行crud動作；
		//既然java可以確定programmer傳入的參數為Preparestatementcreator物件
		//那programmer就不需特別去寫物件的型別；
		//而該物件要實作的方法只有一個，就是createPreparestatement這個方法
		//所以programmer一定是實作這個方法，故實作的方法名稱也不用特別去寫
		//而是可以直接撰寫實作方法的內容
		//實作方法的內容可以用Lambda表示式來表示
		//而實作方法的內容就是要return Preparestatement物件，該物件可以透過connection物件取得
		//例如以下寫法：
		//jdbcTemplate.update(//要return Preparestatement物件，該物件可以透過connection物件取得);
		//而connection物件可以透過jdbcTemplate取得，因為jdbcTemplate包含dataSource物件，dataSource物件又包含connection物件
		//所以寫成：
		//jdbcTemplate.update(conn->{return null;});
		//接著透過connection物件產生Preparestatement物件，然後還要將參數寫入該物件
		
		KeyHolder keyHolder = new GeneratedKeyHolder();
		int result = jdbcTemplate.update(conn->{
			PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			
			pstmt.setString(1,user.getEmail());
			pstmt.setString(2,user.getPassword());
			pstmt.setString(3,user.getAccount());
			pstmt.setInt(4,user.getUserType());	
			pstmt.setBlob(5, DaoUtil.multipartFileToBlob(user.getPicture()));
			return pstmt;}, keyHolder);
		
		return result;
		
	}
	@Override
	public int addRestUser(User user,Restaurant rest) {
		int addUserResult = addUser(user);
		
		String restSql = "insert into rest(rest_id,rest_name,address,phone_num,phone_ext,opening_time,closing_time)"
				+ "values(?,?,?,?,?,?,?)";
		
		int curRestId = getMaxRestId();
		int result = jdbcTemplate.update(conn->{
			PreparedStatement pstmt = conn.prepareStatement(restSql);
			
			pstmt.setInt(1,curRestId+1);
			pstmt.setString(2,rest.getName());
			pstmt.setString(3,rest.getAddress());
			pstmt.setString(4,rest.getPhoneNum());
			pstmt.setString(5,rest.getPhoneExt());	
			pstmt.setString(6,rest.getOpeningTime());
			pstmt.setString(7,rest.getClosingTime());
			return pstmt;});
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
	
	public int getMaxRestId() {
        // 执行查询语句，获取最大的 ID 值
        String sql = "SELECT MAX(rest_id) FROM rest";
        return jdbcTemplate.queryForObject(sql, int.class);
    }
}
