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
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.web.multipart.MultipartFile;

import com.test.bean.Image;
import com.test.bean.Restaurant;
import com.test.bean.User;
import com.test.util.DaoUtil;

import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

@Repository
public class RestDaoImpl implements RestDao{

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Override
	public List<Image> getAllRestImage() {
		String imageSQL = "SELECT rest_id,rest_image,rest_image_name,rest_image_desc  FROM web.RestImages";
		
		RowMapper<Image> mapper = new RowMapper<>() {

			@Override
			public Image mapRow(ResultSet rs, int rowNum) throws SQLException {
				//取出該筆餐廳資料
				Blob blob = rs.getBlob("rest_image");
				Integer id = rs.getInt("rest_id");
				String name = rs.getString("rest_image_name");
				String desc = rs.getString("rest_image_desc");
				byte[] byteArray = null;
				
				if (blob != null) {
				    // 讀取BLOB型別圖片，轉成byte array
				    byteArray = blob.getBytes(1, (int) blob.length());
				}else {
					Path defaultImg = Paths.get("C:\\Users\\cuser\\workspace20231213\\photo.png");
					try {
						
						byteArray = Files.readAllBytes(defaultImg);
					} catch (IOException e) {
					    e.printStackTrace();
					}				
				}
				//取出該筆餐廳資料後，將資料加入VO
				Image image = new Image();
				//image.setRestId(id);
				image.setRestImageName(name);
				image.setRestImageDesc(desc);
				image.setRestImage(DaoUtil.getImageAsBase64(byteArray));
				return image;
			}
		};

		List<Image> images = jdbcTemplate.query(imageSQL, mapper);
		return images;
	}
	@Override
	public List<Restaurant> getRestsByDistrictJoinImage(String country,String district){
		String sql = "SELECT r.rest_id,r.rest_name,r.address,r.phone_num"
				+ ",r.opening_time,r.closing_time,ri.rest_image " +
                "FROM web.rest r " +
                "left JOIN web.restimages ri ON r.rest_id = ri.rest_id " +
                "WHERE r.address like ? and r.opening_time is not null and r.closing_time is not null";

		 String queryCondition = "%"+country+"%" + district + "%";
		 
		 RowMapper<Restaurant> mapper = new RowMapper<>() {

			Map<Integer,Restaurant> restMap=new HashMap<>();
			@Override
			public Restaurant mapRow(ResultSet rs, int rowNum) throws SQLException {
				
				//添加每筆資料到Restaurant物件
				//以下做法確保一個Restaurant物件可包含多個image物件
				Restaurant rest = restMap.get(rs.getInt("rest_id"));

			    if (rest == null) {
			    	rest = new Restaurant();
			    	rest.setImageList(new ArrayList<Image>());
			    	rest.setId(rs.getInt("rest_id"));
			    	rest.setName(rs.getString("rest_name"));
			    	rest.setAddress(rs.getString("address"));
			    	rest.setPhoneNum(rs.getString("phone_num"));
			    	//20240122新增
			    	rest.setOpeningTime(rs.getTime("opening_time").toString());
			    	rest.setClosingTime(rs.getTime("closing_time").toString());

			    	restMap.put(rest.getId(), rest);
			    }

			    Image restImage = new Image();
			    Blob blob = rs.getBlob("rest_image");

				byte[] byteArray = null;
				
				if (blob != null) {
				    // 讀取BLOB型別圖片，轉成byte array
				    byteArray = blob.getBytes(1, (int) blob.length());
				}else {
					Path defaultImg = Paths.get("C:\\Users\\cuser\\git\\TestRestBookingProject\\RestBookingProject\\src\\main\\webapp\\image\\photo1.png");
					try {
						
						byteArray = Files.readAllBytes(defaultImg);
					} catch (IOException e) {
					    e.printStackTrace();
					}				
				}
			    restImage.setRestImage(DaoUtil.getImageAsBase64(byteArray));

			    // 将圖片添加到餐廳的圖片列表中
			    rest.getImageList().add(restImage);

			    return rest;
			}
		};
		
		List<Restaurant> rests = jdbcTemplate.query(sql, mapper,queryCondition);
		return rests;
	}
	@Override
	public List<Image> getRestImage(Integer restName, Integer restImageName) {
		// TODO Auto-generated method stub
		return null;
	}
	
	public String getDistrictNameById(String districtId) {
		String sql="select district_name from web.district where district_id=?";
		
		String queryCondition = districtId;
		
		RowMapper<String> mapper = new RowMapper<>() {
			public String mapRow(ResultSet rs, int rowNum) throws SQLException {
				return rs.getString("district_name");
			}
		};
		
		return jdbcTemplate.queryForObject(sql, mapper,queryCondition);
	}
	
	public List<Restaurant> getRestsByDistrictJoinImage(String district){
		String sql = "SELECT r.rest_id,r.rest_name,r.address,r.phone_num"
				+ ",r.opening_time,r.closing_time,ri.rest_image " +
                "FROM web.rest r " +
                "left JOIN web.restimages ri ON r.rest_id = ri.rest_id " +
                "WHERE r.address like ? and r.opening_time is not null and r.closing_time is not null";

		 String queryCondition = "%" + district + "%";
		 
		 RowMapper<Restaurant> mapper = new RowMapper<>() {

			Map<Integer,Restaurant> restMap=new HashMap<>();
			@Override
			public Restaurant mapRow(ResultSet rs, int rowNum) throws SQLException {
				
				//添加每筆資料到Restaurant物件
				//以下做法確保一個Restaurant物件可包含多個image物件
				Restaurant rest = restMap.get(rs.getInt("rest_id"));

			    if (rest == null) {
			    	rest = new Restaurant();
			    	rest.setImageList(new ArrayList<Image>());
			    	rest.setId(rs.getInt("rest_id"));
			    	rest.setName(rs.getString("rest_name"));
			    	rest.setAddress(rs.getString("address"));
			    	rest.setPhoneNum(rs.getString("phone_num"));
			    	//20240122新增
			    	rest.setOpeningTime(rs.getTime("opening_time").toString());
			    	rest.setClosingTime(rs.getTime("closing_time").toString());

			    	restMap.put(rest.getId(), rest);
			    }

			    Image restImage = new Image();
			    Blob blob = rs.getBlob("rest_image");

				byte[] byteArray = null;
				
				if (blob != null) {
				    // 讀取BLOB型別圖片，轉成byte array
				    byteArray = blob.getBytes(1, (int) blob.length());
				}else {
					Path defaultImg = Paths.get("C:\\Users\\cuser\\git\\TestRestBookingProject\\RestBookingProject\\src\\main\\webapp\\image\\photo1.png");
					try {
						
						byteArray = Files.readAllBytes(defaultImg);
					} catch (IOException e) {
					    e.printStackTrace();
					}				
				}
			    restImage.setRestImage(DaoUtil.getImageAsBase64(byteArray));

			    // 将圖片添加到餐廳的圖片列表中
			    rest.getImageList().add(restImage);

			    return rest;
			}
		};
		
		List<Restaurant> rests = jdbcTemplate.query(sql, mapper,queryCondition);
		return rests;
	}
}
