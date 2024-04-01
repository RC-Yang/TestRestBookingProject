package com.test.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.Base64;

import javax.sql.rowset.serial.SerialBlob;

import org.springframework.web.multipart.MultipartFile;

public class DaoUtil {

	public static ByteArrayInputStream byteArrToBlob(byte[] byteArray) {

        return new ByteArrayInputStream(byteArray,1, byteArray.length);		
	}
	
	public static Blob multipartFileToBlob(MultipartFile multipartFile) {
		if(multipartFile.getSize()==0) {
			return null;
		}

		Blob blob = null;
		try {
			byte[] fileBytes = multipartFile.getBytes(); 
			
            blob = new SerialBlob(fileBytes);
        } catch (SQLException |IOException e) {
            e.printStackTrace();
        }
        
        return blob;
    }
	
	 public static Blob stringToBlob(String str) {

		 Blob blob = null;
	        try {
	            byte[] bytes = str.getBytes(); // 將字串轉換成byte陣列
	            blob = new SerialBlob(bytes); // 使用SerialBlob將byte陣列轉換成Blob物件

	            System.out.println("字串轉換成Blob成功！");
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return blob;
	    }
	 
	//將byte array型別的圖片，轉乘base64格式
	public static String getImageAsBase64(byte[] imageByteArray) {        
        String base64Image = Base64.getEncoder().encodeToString(imageByteArray);
        return base64Image;
    }
	
	// 讀取BLOB型別圖片，轉成byte array
	public static byte[] blobToByteArr(Blob blob) throws SQLException {
		byte[] byteArray = null;
		
		if (blob != null) {
		    byteArray = blob.getBytes(1, (int) blob.length());
		}else {
			Path defaultImg = Paths.get("C:\\Users\\cuser\\workspace20231213\\photo1.jpg");
			try {
				
				byteArray = Files.readAllBytes(defaultImg);
			} catch (IOException e) {
			    e.printStackTrace();
			}
		}
		return byteArray;
	}
}
