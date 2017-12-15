package net.ddex.ern.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
//@PropertySource("file:${app.home}")
@PropertySource("classpath:application.properties")
@ComponentScan(basePackages = "net.ddex.ern")
public class AppConfig {
}
