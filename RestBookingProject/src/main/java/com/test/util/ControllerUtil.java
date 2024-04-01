package com.test.util;

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.web.multipart.MultipartFile;

public class ControllerUtil {
    public static byte[] multipartFileToByteArr(MultipartFile pic) {
        
        try {
            byte[] bytes = pic.getBytes();
            // 在這裡可以對 bytes 做你需要的處理，比如存儲到資料庫或進行其他操作
            return bytes;
        } catch (IOException e) {
            return null;
        }
 
    }
    public static boolean sendMail(String email)  //email 為收件者, password 為密碼
    {   
        java.util.Properties property = new java.util.Properties();
        property.put("mail.host", "smtp.gmail.com");  //設定郵件伺服器
        property.put("mail.transport.protocol", "smtp");     //設定通訊協定
        property.put("mail.smtp.starttls.enable", "true");
        property.put("mail.smtp.auth", "true");
        Session sess = Session.getInstance(property, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(email, "moso vriy bpqd bprv");
            }
        });    //取得 Session
        MimeMessage msg = new MimeMessage(sess);   //以Session 為參數 建立一封電子郵件  
        try{
            //msg.setFrom(new InternetAddress("some999816@gmail.com"));  //寄件者
            //將收件者的 InetAddress 物件新增給使用者
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(email));  
            msg.setSubject("找回密碼");  //郵件的主旨
            msg.setText("http://localhost:8080/RestBookingProject/entry/goToResetPassword");    //郵件的內容
            msg.setSentDate(new java.util.Date());   //設定寄送日期  為現在
            Transport.send(msg);   //寄送郵件
            return true;
        }catch(AddressException ae){
            System.out.println(ae);
            return false;   //記得要 return false
        }catch(MessagingException me){
            System.out.println(me);
            return false;   //記得要 return false
        }
    }
    
    public static Date stringToSqlDate(String dateStr) {
    	
    	java.sql.Date sqlDate = new java.sql.Date(0);
    	try {
            // 使用SimpleDateFormat解析字符串为Date对象
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date date = sdf.parse(dateStr);

            // 使用java.sql.Date构造函数将Date对象转换为java.sql.Date
            sqlDate = new java.sql.Date(date.getTime());

            System.out.println("Original String: " + dateStr);
            System.out.println("Converted java.sql.Date: " + sqlDate);

        } catch (ParseException e) {
            e.printStackTrace();
        }
    	return sqlDate;
    }
}
