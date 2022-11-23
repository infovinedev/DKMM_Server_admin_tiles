package kr.co.infovine.dkmm.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.view.ContentNegotiatingViewResolver;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
public class ContentNegotiatingViewResolverConfiguration {
	@Bean(name = "contentNegotiatingViewResolver")
	public ContentNegotiatingViewResolver contentNegotiatingViewResolver() {
		ContentNegotiatingViewResolver contentNegotiatingViewResolver = new ContentNegotiatingViewResolver();
		contentNegotiatingViewResolver.setOrder(4);
		log.debug("contentNegotiatingViewResolver : ", contentNegotiatingViewResolver.getOrder());
		return contentNegotiatingViewResolver;
	}
	
}
