package com.test;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

@Component
@Aspect
public class TestAspect {

	@Before("execution(* com.test..*.*(..)) && !within(com.test.filter..*)")
    public void logBeforeMethod(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().toShortString();
        System.out.println("執行 " + methodName + " 方法前");
    }

    @After("execution(* com.test..*.*(..)) && !within(com.test.filter..*)")
    public void logAfterMethod(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().toShortString();
        System.out.println("執行 " + methodName + " 方法後");
    }
}
