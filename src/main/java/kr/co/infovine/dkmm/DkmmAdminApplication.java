package kr.co.infovine.dkmm;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.PropertySource;

import kr.co.infovine.dkmm.config.InfovineSecurityProperties;



@SpringBootApplication
@PropertySource(value = { "classpath:/props-${server.mode}/application.properties" })
@EnableConfigurationProperties( InfovineSecurityProperties.class )
@ComponentScan(basePackages = {"kr.co.infovine.dkmm.**"})
@MapperScan(basePackages = {"kr.co.infovine.dkmm.mapper.**"})
public class DkmmAdminApplication extends SpringBootServletInitializer{
	
	public static void main(String[] args) {
		SpringApplication.run(DkmmAdminApplication.class, args);
	}
}
