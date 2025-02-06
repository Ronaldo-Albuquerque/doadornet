package com.doadornet;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DoadornetApplication {
    public static void main(String[] args) throws InterruptedException {

        System.out.println("Entrando na aplicação DoadorNet backend");
        SpringApplication.run(DoadornetApplication.class, args);
    }
}
