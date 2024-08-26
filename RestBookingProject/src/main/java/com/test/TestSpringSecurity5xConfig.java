package com.test;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.JdbcUserDetailsManager;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;

@Configuration
@EnableWebSecurity
public class TestSpringSecurity5xConfig {
	@Autowired
	private DataSource dataSource;

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		return http//HttpSecurity物件的功能，就類似於一個清單，用於手動添加安全規定				
				.authorizeRequests(
						authorizeRequests -> authorizeRequests
								.antMatchers("/image/**", "/js/**", "/entry/goToLogIn", "/entry/goToReg",
										"/entry/checkLogin", "/form/queryDistrictForRest")
								.permitAll().anyRequest().authenticated())
				//用於確認任何請求路徑是否通過「是否為用戶」的檢查，若通過就放行請求路徑，若不通過則重導回去
				.formLogin(formLogin -> formLogin.loginPage("/index.jsp").permitAll())
				//確認使用者為用戶後，讓其以表單方式登入；.formLogin() 本身並不直接執行驗證
				.csrf(csrf -> csrf
						.ignoringAntMatchers("/entry/goToReg", "/entry/reg", "/entry/checkLogin", "/entry/goToLogIn")
						.csrfTokenRepository(new HttpSessionCsrfTokenRepository()))
				//假設網站首頁為index.jsp，則當使用者進入index.jsp時，以上該段即會自動執行，給這位使用者csrf token，因此即使該使用者尚未登入，也會持有該csrf token
				.build();//這是Spring Security拿HttpSecurity物件(這只是個清單)，再另外打包成的具有完整資安功能的物件
	}

	@Bean//這個bean用於根據用戶清單，檢查嘗試登入者是否為用戶
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(new PlainTextPasswordEncoder());
        return authProvider;
    }

    @Bean//這個bean用於設置用戶清單
    public UserDetailsService userDetailsService() {
        JdbcUserDetailsManager jdbcUserDetailsManager = new JdbcUserDetailsManager();
        jdbcUserDetailsManager.setDataSource(dataSource);
        // 设置用户查询
        jdbcUserDetailsManager.setUsersByUsernameQuery("SELECT account, password, true as enabled FROM web.user WHERE account = ?");
        
        // 设置权限查询
        jdbcUserDetailsManager.setAuthoritiesByUsernameQuery("SELECT account, authority FROM web.authorities WHERE account = ?");

        return jdbcUserDetailsManager;
    }
}
