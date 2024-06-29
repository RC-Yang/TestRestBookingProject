package com.test;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;

@Configuration
@EnableWebSecurity
public class TestSecurityConfig extends WebSecurityConfigurerAdapter{
	@Autowired
    private DataSource dataSource;

	//這段是將通過驗證之用戶，添加到spring security裡
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.jdbcAuthentication()
            .dataSource(dataSource)
            .usersByUsernameQuery("SELECT account, password FROM web.user WHERE account = ?")
            //.authoritiesByUsernameQuery("SELECT account FROM web.user WHERE account = ?")
            .passwordEncoder(new BCryptPasswordEncoder());
        //enabled欄位可省略，省略的話則spring security將只根據帳密決定是否放行
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
	        .authorizeRequests()
	        .antMatchers("/index.jsp","/entry/goToLogIn").permitAll()
	        .antMatchers(HttpMethod.POST, "/entry/checkLogin").permitAll()
	        .antMatchers("/css/**", "/js/**", "/image/**").permitAll()
	        .anyRequest().authenticated()
	    .and()
	    .logout()
	        .logoutUrl("/entry/logout")
	        .permitAll()
	        //添加CSRF Token給http session，以防因無CSRF Token而無法通過spring security的csrf驗證
	        //spring security自動配置csrf token給用戶session(例如執行表單登入
	        .and().csrf().csrfTokenRepository(new HttpSessionCsrfTokenRepository())
	        ;
//    	http
//        .httpBasic().disable() // 禁用HTTP基本身份驗證
//        .csrf().disable() // 禁用CSRF保護
//        .authorizeRequests().anyRequest().permitAll(); // 允許所有請求訪問
    }
    
}
