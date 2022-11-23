package kr.co.infovine.dkmm.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.view.BeanNameViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import kr.co.infovine.dkmm.util.ExcelView;
import lombok.extern.slf4j.Slf4j;

@Configuration
@Slf4j
//@PropertySource("classpath:/props-${server.mode}/config.properties")
public class InternalResourceViewResolverConfiguration {

	@Bean(name = "excelView")
	public ExcelView excelView() {
		return new ExcelView();
	}
	
	@Bean(name = "beanNameViewResolver")
	public BeanNameViewResolver beanNameResolver () {
		BeanNameViewResolver beanNameViewResolver = new BeanNameViewResolver();
		beanNameViewResolver.setOrder(1);
		log.debug("beanNameViewResolver : ", beanNameViewResolver.getOrder());
		return beanNameViewResolver;
	}
	
//	@Bean(name = "jsonView")
//	public MappingJackson2JsonView mappingJackson2JsonView() {
//		MappingJackson2JsonView jackson2JsonView = new MappingJackson2JsonView();
//		return jackson2JsonView;
//	}
//	
//	@Bean(name = "jacksonMessageConverter")
//	public MappingJackson2HttpMessageConverter mappingJacksonHttpMessageConverter() {
//		MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
//		return converter;
//	}
//	
//	@Bean(name = "stringHttpMessageConverter")
//	public StringHttpMessageConverter stringHttpMessageConverter() {
//		StringHttpMessageConverter converter = new StringHttpMessageConverter();
//		return converter;
//	}
	
	@Bean(name = "internalResourceViewResolver")
	public InternalResourceViewResolver internalResourceViewResolver () {
		InternalResourceViewResolver internalResourceViewResolver = new InternalResourceViewResolver();
		internalResourceViewResolver.setOrder(3);
		internalResourceViewResolver.setViewClass(JstlView.class);
		internalResourceViewResolver.setPrefix("/WEB-INF/views/");
		internalResourceViewResolver.setSuffix(".jsp");
		return internalResourceViewResolver;
	}
	
}
