package com.test;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

//若是在Maven專案中，於src/main/java，添加以下
//那麼Spring Boot就會自動去掃描到這個java檔，
//並將整個Maven專案放入Spring Boot內嵌的web container
//Spring MVC建立MVC架構、Spring Boot處理專案佈署、專案雜項設定
//Spring MVC 和 Spring Boot，算是兩個並行的工具，並非是Spring Boot包含Spring MVC
@SpringBootApplication
public class TestSpringBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(TestSpringBootApplication.class, args);
	}

}
