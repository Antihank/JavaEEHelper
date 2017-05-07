package com.antihank;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import tk.mybatis.spring.mapper.MapperScannerConfigurer;

import java.util.Properties;

/**
 * Created by Antihank on 2017/5/6.
 */
@Configuration
public class JavaConfig {

    @Bean(name = "scannerConfigurer")
    public MapperScannerConfigurer scannerConfigurer() {
        MapperScannerConfigurer m = new MapperScannerConfigurer();
        m.setBasePackage("com.antihank");
        Properties p = new Properties();
        p.setProperty("mappers", "tk.mybatis.mapper.common.Mapper");
        m.setProperties(p);
        return m;
    }

}
