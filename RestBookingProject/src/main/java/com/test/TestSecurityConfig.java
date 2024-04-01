package com.test;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class TestSecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()

                .antMatchers("/index.jsp","/entry/goToLogIn").permitAll() // 允许访问checkLogin端点
                .anyRequest().authenticated() // 对所有其他请求要求进行身份验证
                .and()             
                .logout()
                .logoutUrl("/entry/logout") // 允许访问登出URL
                .permitAll();
    }


}
