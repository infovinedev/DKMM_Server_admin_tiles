package kr.co.infovine.dkmm.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import kr.co.infovine.dkmm.util.Sha512ToBCryptPasswordEncoder;

@Configuration
@ComponentScan(basePackages = "infovine.security")
public class InfovineSecurityAutoConfiguration {

	/**
	 * Password Encoder
	 */
	private PasswordEncoder passwordEncorder;
	
	/**
	 * Password Encoder 를 가져옵니다.
	 *
	 * @return Password Encoder
	 */
	@SuppressWarnings("unused")
	//@ConditionalOnMissingBean
	//@Bean
	public PasswordEncoder passwordEncorder() {
		if (passwordEncorder != null) {
			return passwordEncorder;
		}

		//passwordEncorder = new BCryptPasswordEncoder();
		//passwordEncorder = new NoOpPasswordEncoder();
		passwordEncorder = new Sha512ToBCryptPasswordEncoder();
		return passwordEncorder;
	}
}
