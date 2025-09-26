package com.test.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender javaMailSender;

    public boolean sendMail(String email) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("test@rcyang.bid");
        message.setTo(email);
        message.setSubject("找回密碼");
        message.setText("https://localhost:8443/RestBookingProject/entry/goToResetPassword");

        try {
            javaMailSender.send(message);
            return true;
        } catch (Exception e) {
            System.out.println(e);
            return false;
        }
    }
}
