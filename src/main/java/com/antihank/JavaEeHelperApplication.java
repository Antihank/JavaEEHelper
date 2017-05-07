package com.antihank;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@SpringBootApplication
@Controller
public class JavaEeHelperApplication {

    public static void main(String[] args) {
        SpringApplication.run(JavaEeHelperApplication.class, args);
    }

    @RequestMapping(value = {"/", "/index", "index"})
    public ModelAndView index() {
        return new ModelAndView("index");
    }
}
