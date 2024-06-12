package com.test;

import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class TestSecurityConfig extends WebSecurityConfigurerAdapter{

    @Override
    protected void configure(HttpSecurity http) throws Exception {
//        http
//            .authorizeRequests()
//
//                .antMatchers("/index.jsp","/entry/goToLogIn").permitAll() // 允许访问checkLogin端点
//                .regexMatchers(HttpMethod.POST, "/entry/checkLogin").permitAll()
//                .antMatchers("/css/**", "/js/**", "/images/**").permitAll()
//                .anyRequest().authenticated() // 对所有其他请求要求进行身份验证
//                .and().csrf().disable()             
//                .logout()
//                .logoutUrl("/entry/logout") // 允许访问登出URL
//                .permitAll();
    	http
        .httpBasic().disable() // 禁用HTTP基本身份驗證
        .csrf().disable() // 禁用CSRF保護
        .authorizeRequests().anyRequest().permitAll(); // 允許所有請求訪問
    }
    
}
