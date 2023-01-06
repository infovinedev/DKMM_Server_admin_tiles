package kr.co.infovine.dkmm.config;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import kr.co.infovine.dkmm.handler.LoginSuccessHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity.IgnoredRequestConfigurer;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.annotation.web.configurers.ExpressionUrlAuthorizationConfigurer;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.util.StringUtils;

import kr.co.infovine.dkmm.config.InfovineSecurityProperties.FormLoginSetting;
import kr.co.infovine.dkmm.config.InfovineSecurityProperties.LogoutSetting;
import kr.co.infovine.dkmm.util.Sha512ToBCryptPasswordEncoder;
import lombok.extern.slf4j.Slf4j;


@Configuration
@EnableWebSecurity
@Slf4j
public class InfovineSecurityConfigurer extends WebSecurityConfigurerAdapter {

	private InfovineSecurityProperties infovineSecurityProperties;
	
	/**
	 * AuthenticationSuccessHandler Class
	 */
	private Class<? extends AuthenticationSuccessHandler> loginSuccessHandler;
	
	/**
	 * AuthenticationFailureHandler Class
	 */
	private Class<? extends AuthenticationFailureHandler> loginFailedHandler;
	
	private Class<? extends AccessDeniedHandler> accessDeniedHandler;
	
	private Class<? extends AuthenticationEntryPoint> authenticationEntryPoint;
	
	/**
	 * Password Encoder
	 */
	@Autowired
	private Sha512ToBCryptPasswordEncoder passwordEncoder;
	
	public InfovineSecurityConfigurer(InfovineSecurityProperties infovineSecurityProperties) {
		super();
		this.infovineSecurityProperties = infovineSecurityProperties;
	}
	
	@Override
	public void configure(WebSecurity web) throws Exception {
		IgnoredRequestConfigurer ignoredRequestConfigurer = web.ignoring();
		List<String> ignoringList = infovineSecurityProperties.getIgnorings();

		for (String ignoring : ignoringList) {
			ignoredRequestConfigurer.antMatchers(ignoring);
		}
	}
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
//		http.cors();
//		http.csrf().disable().exceptionHandling().authenticationEntryPoint(new AjaxAuthenticationEntryPoint("/admin/loginView.do"));
		
		FormLoginSetting formLoginSetting = infovineSecurityProperties.getFormLoginSetting();
		
		String loginPage = formLoginSetting.getLoginPage();
		String usernameParameter = formLoginSetting.getUsernameParameter();
		String passwordParameter = formLoginSetting.getPasswordParameter();
		String loginProcessingUrl = formLoginSetting.getLoginProcessingUrl();
		
		loginSuccessHandler = formLoginSetting.getAuthenticationSuccessHandler();
		loginFailedHandler = formLoginSetting.getAuthenticationFailureHandler();
		accessDeniedHandler = formLoginSetting.getAccessDeniedHandler();
		authenticationEntryPoint = formLoginSetting.getAuthenticationEntryPoint();
		
		AuthenticationSuccessHandler successHandler = loginSuccessHandler.getDeclaredConstructor().newInstance();
		AuthenticationFailureHandler failureHandler = loginFailedHandler.getDeclaredConstructor().newInstance();
		AccessDeniedHandler deniedHandler = accessDeniedHandler.getDeclaredConstructor().newInstance();
		AuthenticationEntryPoint authEntryPoint = authenticationEntryPoint.getDeclaredConstructor().newInstance();
		
		http.formLogin().loginPage(loginPage)
		.usernameParameter(usernameParameter).passwordParameter(passwordParameter)
		.loginProcessingUrl(loginProcessingUrl)
		.successHandler(successHandler)
		.failureHandler(failureHandler)
//		.and().httpBasic().authenticationEntryPoint(authEntryPoint)
		//.and().logout().logoutSuccessUrl("/logout.do").invalidateHttpSession(true).clearAuthentication(true)
		
		
		//		.and().exceptionHandling().authenticationEntryPoint(authEntryPoint)
		//다 안되는데?
//		.and().exceptionHandling().authenticationEntryPoint(new AjaxAuthenticationEntryPoint("/admin/loginView.do"))
//		.and().exceptionHandling().accessDeniedHandler(deniedHandler)
//		.and().exceptionHandling().accessDeniedPage("/admin/loginView.do?error=session")
		.and().cors()
		.and().csrf().disable();
		
		LogoutSetting logoutSetting = infovineSecurityProperties.getLogoutSetting();
		String urlMain = LoginSuccessHandler.ApplicationContextProvider.getApplicationContext().getEnvironment().getProperty("url.main");
		String logoutUrl = logoutSetting.getLogoutUrl();
		String logoutSuccessUrl = logoutSetting.getLogoutSuccessUrl();
		logoutSuccessUrl = urlMain + logoutSuccessUrl;
		boolean invalidateHttpSession = logoutSetting.isInvalidateHttpSession();
		String deleteCookies = logoutSetting.getDeleteCookies();

		http.logout().logoutUrl(logoutUrl).logoutSuccessUrl(logoutSuccessUrl).invalidateHttpSession(invalidateHttpSession)
				.deleteCookies(deleteCookies);
		;
		
		ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry urlRegistry = http
				.authorizeRequests();

		Map<String, String> interceptUrls = infovineSecurityProperties.getInterceptUrls();
		if (!interceptUrls.isEmpty()) {
			for (Map.Entry<String, String> entry : interceptUrls.entrySet()) {
				urlRegistry.antMatchers(entry.getKey()).access(entry.getValue());
			}
		}
		
		
//		List<AccessDecisionVoter<? extends Object>> voterList = new ArrayList<AccessDecisionVoter<? extends Object>>();
//		
//		List<Class<? extends WebExpressionVoter>> voters = infovineSecurityProperties.getVoters();
//		for (Class<? extends WebExpressionVoter> voter : voters) {
//			WebExpressionVoter voterInstance = voter.getDeclaredConstructor().newInstance();
//			voterList.add(voterInstance);
//		}
//
//		AccessDecisionManager accessDecisionManager = new AffirmativeBased(voterList);
//
//		urlRegistry.accessDecisionManager(accessDecisionManager);
//		urlRegistry.filterSecurityInterceptorOncePerRequest(true);
	}
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		String datasourceName = infovineSecurityProperties.getDatasourceName();
		String usersByUsernameQuery = infovineSecurityProperties.getUsersByUsernameQuery();
		String authoritiesByUsernameQuery = infovineSecurityProperties.getAuthoritiesByUsernameQuery();
		
		if(StringUtils.isEmpty(datasourceName)) {
			throw new NullPointerException("datasourceName not found");
		}
		
		if(StringUtils.isEmpty(usersByUsernameQuery)) {
			throw new NullPointerException("usersByUsernameQuery not found");
		}
		
		if(StringUtils.isEmpty(authoritiesByUsernameQuery)) {
			throw new NullPointerException("authoritiesByUsernameQuery not found");
		}
		
		DataSource dataSource = (DataSource)getApplicationContext().getBean(datasourceName);
		log.info("SHA-512로 암호화 되어 있으므로 passwordEncorder는 제거했습니다");
		auth.jdbcAuthentication()
			.dataSource(dataSource)
			.passwordEncoder(passwordEncoder)
			.usersByUsernameQuery(usersByUsernameQuery)
			.authoritiesByUsernameQuery(authoritiesByUsernameQuery);
	}
	
//	@Bean
//	public LoginUrlAuthenticationEntryPoint loginUrlAuthenticationEntryPoint(){
//        
//        LoginUrlAuthenticationEntryPoint entry = new LoginUrlAuthenticationEntryPoint("/login"){
//            @Override
//            public void commence(final HttpServletRequest request, final HttpServletResponse response,
//                    final AuthenticationException authException) throws IOException, ServletException{
//                
//                String ajaxHeader = request.getHeader("X-Requested-With");
//                if(ajaxHeader != null && "XMLHttpRequest".equals(ajaxHeader)){
//                    //InsufficientAuthenticationException
//                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
//                }
//                else{
//                    super.commence(request, response, authException);
//                }
//            }
//        };
//        return entry;
//    }
}
