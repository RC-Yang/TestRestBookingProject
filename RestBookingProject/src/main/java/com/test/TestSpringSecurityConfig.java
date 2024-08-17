//package com.test;
//
//import org.springframework.context.annotation.Configuration;
//import org.springframework.security.config.annotation.web.builders.HttpSecurity;
//import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
//import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;
//import javax.sql.DataSource;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
//import org.springframework.context.annotation.Bean;
//import org.springframework.security.authentication.AuthenticationManager;
//
//
//@Configuration
////@Configuration表示這是個配置類，可以放置配置方法與其他方法，故還需要有@Bean表示配置方法
////@Configuration這個註釋在這邊的意義，是協助@EnableWebSecurity來註冊Spring Security必需的bean
////@EnableWebSecurity本身沒有註冊Spring Security必需bean的功能
////所以不可省略掉@Configuration，只剩下@EnableWebSecurity
////這樣這個TestSpringSecurityConfig類，即同時是Spring Bean註冊類、Spring Security啟動類
//@EnableWebSecurity
//public class TestSpringSecurityConfig  extends WebSecurityConfigurerAdapter{
//	//DataSource Bean不須顯式的註冊；因為Spring Boot提供了對數據源的自動配置支持，故DataSource會自動配置
//	@Autowired
//	private DataSource dataSource;
//
//	@Override
//	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
//	    auth.jdbcAuthentication()
//	        .dataSource(dataSource)
//	        .usersByUsernameQuery("SELECT account, password, true as enabled FROM web.user WHERE account = ?")
//	        //20240810新增
//	        .authoritiesByUsernameQuery("SELECT account, authority FROM web.authorities WHERE account = ?")
//	        .passwordEncoder(new PlainTextPasswordEncoder()); // 使用明文密码编码器
//	}
//	
//	protected void configure(HttpSecurity http) throws Exception { 
//        http
//            .authorizeRequests(authorizeRequests -> 
//                authorizeRequests
//                    .antMatchers("/image/**","/js/**","/entry/goToLogIn","/entry/goToReg","/entry/checkLogin"
//                    		,"/form/queryDistrictForRest").permitAll() //設置某些資源所有用戶均可存取
//                    .anyRequest().authenticated() //設置其餘資源，用戶存取前必須先通過帳密驗證
//            )
//            .formLogin//用戶帳密認證
//            (formLogin -> 
//                formLogin
//                    .loginPage("/index.jsp")//一定要設定起始頁面，否則Spring Security將以自己的頁面做為預設頁面
//                    .permitAll()
//            )
//            .csrf(csrf -> 
//		                csrf
//		                .ignoringAntMatchers("/entry/goToReg", "/entry/reg","/entry/checkLogin","/entry/goToLogIn") // 註冊和登入頁面忽略 CSRF
//		                .csrfTokenRepository(new HttpSessionCsrfTokenRepository())
//            );
//    }
//	//雖然@EnableWebSecurity會自動配置一些安全性相關的Bean，但AuthenticationManager並不會自動暴露為Bean
//	//因為Spring Boot不能直接根據比方說application.properties的設定，自動生成AuthenticationManager物件
//	//故需要註冊該類，就像在bean註冊檔那樣；具體註冊方式就是宣告註冊(配置)方法：
//	@Bean
//    @Override
//    public AuthenticationManager authenticationManagerBean() throws Exception {
//		//當Spring boot掃描到這個@Bean註釋時，會將這個工廠方法返回的類註冊下來
//		//這個被註冊的bean，也會有id(在這裡是authenticationManagerBean)。就像在bean註冊檔註冊bean時，會宣告他的id一樣
//        return super.authenticationManagerBean();
//    }
//}
