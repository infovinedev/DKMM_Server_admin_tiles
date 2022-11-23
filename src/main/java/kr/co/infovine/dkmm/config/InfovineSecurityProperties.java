package kr.co.infovine.dkmm.config;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.access.expression.WebExpressionVoter;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;


@ConfigurationProperties(prefix = "infovine.security")
public class InfovineSecurityProperties {
	private FormLoginSetting formLoginSetting;

	private LogoutSetting logoutSetting;

	private String datasourceName;

	private String usersByUsernameQuery;

	private String authoritiesByUsernameQuery;
	
	/**
	 * Ignorings
	 */
	private List<String> ignorings = new ArrayList<String>();
	
	/**
	 * InterceptUrls
	 */
	private Map<String, String> interceptUrls = new HashMap<String, String>();
	
	private List<Class<? extends WebExpressionVoter>> voters = new ArrayList<Class<? extends WebExpressionVoter>>();
	
	/**
	 * formLoginSetting 를 가져옵니다.
	 *
	 * @return formLoginSetting
	 */
	public FormLoginSetting getFormLoginSetting() {
		return formLoginSetting;
	}

	/**
	 * formLoginSetting 를 설정합니다.
	 * 
	 * @param formLoginSetting
	 *            설정 할 formLoginSetting
	 */
	public void setFormLoginSetting(FormLoginSetting formLoginSetting) {
		this.formLoginSetting = formLoginSetting;
	}

	/**
	 * logoutSetting 를 가져옵니다.
	 *
	 * @return logoutSetting
	 */
	public LogoutSetting getLogoutSetting() {
		return logoutSetting;
	}

	/**
	 * logoutSetting 를 설정합니다.
	 * 
	 * @param logoutSetting
	 *            설정 할 logoutSetting
	 */
	public void setLogoutSetting(LogoutSetting logoutSetting) {
		this.logoutSetting = logoutSetting;
	}

	/**
	 * datasourceName 를 가져옵니다.
	 *
	 * @return datasourceName
	 */
	public String getDatasourceName() {
		return datasourceName;
	}

	/**
	 * datasourceName 를 설정합니다.
	 * 
	 * @param datasourceName
	 *            설정 할 datasourceName
	 */
	public void setDatasourceName(String datasourceName) {
		this.datasourceName = datasourceName;
	}

	/**
	 * usersByUsernameQuery 를 가져옵니다.
	 *
	 * @return usersByUsernameQuery
	 */
	public String getUsersByUsernameQuery() {
		return usersByUsernameQuery;
	}

	/**
	 * usersByUsernameQuery 를 설정합니다.
	 * 
	 * @param usersByUsernameQuery
	 *            설정 할 usersByUsernameQuery
	 */
	public void setUsersByUsernameQuery(String usersByUsernameQuery) {
		this.usersByUsernameQuery = usersByUsernameQuery;
	}

	/**
	 * authoritiesByUsernameQuery 를 가져옵니다.
	 *
	 * @return authoritiesByUsernameQuery
	 */
	public String getAuthoritiesByUsernameQuery() {
		return authoritiesByUsernameQuery;
	}

	/**
	 * authoritiesByUsernameQuery 를 설정합니다.
	 * 
	 * @param authoritiesByUsernameQuery
	 *            설정 할 authoritiesByUsernameQuery
	 */
	public void setAuthoritiesByUsernameQuery(String authoritiesByUsernameQuery) {
		this.authoritiesByUsernameQuery = authoritiesByUsernameQuery;
	}
	
	/**
	 * Ignorings 을 가져옵니다.
	 *
	 * @return Ignorings
	 */
	public List<String> getIgnorings() {
		return ignorings;
	}

	/**
	 * Ignorings 을 설정합니다.
	 *
	 * @param ignorings
	 *            설정 할 Ignorings
	 */
	public void setIgnorings(List<String> ignorings) {
		this.ignorings = ignorings;
	}
	
	/**
	 * InterceptUrls 를 가져옵니다.
	 *
	 * @return InterceptUrls
	 */
	public Map<String, String> getInterceptUrls() {
		return interceptUrls;
	}

	/**
	 * InterceptUrls 를 설정합니다.
	 *
	 * @param interceptUrls
	 *            설정 할 InterceptUrls
	 */
	public void setInterceptUrls(Map<String, String> interceptUrls) {
		this.interceptUrls = interceptUrls;
	}
	
	
	public static class FormLoginSetting {

		private String loginPage;

		private String usernameParameter;

		private String passwordParameter;

		private String loginProcessingUrl;
		
		private Class<AuthenticationSuccessHandler> authenticationSuccessHandler;

		private Class<AuthenticationFailureHandler> authenticationFailureHandler;
		
		private Class<AccessDeniedHandler> accessDeniedHandler;
		
		private Class<AuthenticationEntryPoint> authenticationEntryPoint;
		

		/**
		 * loginPage 를 가져옵니다.
		 *
		 * @return loginPage
		 */
		public String getLoginPage() {
			return loginPage;
		}

		/**
		 * loginPage 를 설정합니다.
		 * 
		 * @param loginPage
		 *            설정 할 loginPage
		 */
		public void setLoginPage(String loginPage) {
			this.loginPage = loginPage;
		}

		/**
		 * usernameParameter 를 가져옵니다.
		 *
		 * @return usernameParameter
		 */
		public String getUsernameParameter() {
			return usernameParameter;
		}

		/**
		 * usernameParameter 를 설정합니다.
		 * 
		 * @param usernameParameter
		 *            설정 할 usernameParameter
		 */
		public void setUsernameParameter(String usernameParameter) {
			this.usernameParameter = usernameParameter;
		}

		/**
		 * passwordParameter 를 가져옵니다.
		 *
		 * @return passwordParameter
		 */
		public String getPasswordParameter() {
			return passwordParameter;
		}

		/**
		 * passwordParameter 를 설정합니다.
		 * 
		 * @param passwordParameter
		 *            설정 할 passwordParameter
		 */
		public void setPasswordParameter(String passwordParameter) {
			this.passwordParameter = passwordParameter;
		}

		/**
		 * loginProcessingUrl 를 가져옵니다.
		 *
		 * @return loginProcessingUrl
		 */
		public String getLoginProcessingUrl() {
			return loginProcessingUrl;
		}

		/**
		 * loginProcessingUrl 를 설정합니다.
		 * 
		 * @param loginProcessingUrl
		 *            설정 할 loginProcessingUrl
		 */
		public void setLoginProcessingUrl(String loginProcessingUrl) {
			this.loginProcessingUrl = loginProcessingUrl;
		}
		
		/**
		 * authenticationSuccessHandler 를 가져옵니다.
		 *
		 * @return authenticationSuccessHandler
		 */
		public Class<AuthenticationSuccessHandler> getAuthenticationSuccessHandler() {
			return authenticationSuccessHandler;
		}

		/**
		 * authenticationSuccessHandler 를 설정합니다.
		 * 
		 * @param authenticationSuccessHandler 설정 할 authenticationSuccessHandler
		 */
		public void setAuthenticationSuccessHandler(Class<AuthenticationSuccessHandler> authenticationSuccessHandler) {
			this.authenticationSuccessHandler = authenticationSuccessHandler;
		}

		/**
		 * authenticationFailureHandler 를 가져옵니다.
		 *
		 * @return authenticationFailureHandler
		 */
		public Class<AuthenticationFailureHandler> getAuthenticationFailureHandler() {
			return authenticationFailureHandler;
		}

		/**
		 * authenticationFailureHandler 를 설정합니다.
		 * 
		 * @param authenticationFailureHandler 설정 할 authenticationFailureHandler
		 */
		public void setAuthenticationFailureHandler(Class<AuthenticationFailureHandler> authenticationFailureHandler) {
			this.authenticationFailureHandler = authenticationFailureHandler;
		}

		@Override
		public String toString() {
			StringBuilder builder = new StringBuilder();
			builder.append("FormLoginSetting [");
			if (loginPage != null) {
				builder.append("loginPage=");
				builder.append(loginPage);
				builder.append(", ");
			}
			if (usernameParameter != null) {
				builder.append("usernameParameter=");
				builder.append(usernameParameter);
				builder.append(", ");
			}
			if (passwordParameter != null) {
				builder.append("passwordParameter=");
				builder.append(passwordParameter);
				builder.append(", ");
			}
			if (loginProcessingUrl != null) {
				builder.append("loginProcessingUrl=");
				builder.append(loginProcessingUrl);
			}
			builder.append("]");
			return builder.toString();
		}

		public Class<AccessDeniedHandler> getAccessDeniedHandler() {
			return accessDeniedHandler;
		}

		public void setAccessDeniedHandler(Class<AccessDeniedHandler> accessDeniedHandler) {
			this.accessDeniedHandler = accessDeniedHandler;
		}

		public Class<AuthenticationEntryPoint> getAuthenticationEntryPoint() {
			return authenticationEntryPoint;
		}

		public void setAuthenticationEntryPoint(Class<AuthenticationEntryPoint> authenticationEntryPoint) {
			this.authenticationEntryPoint = authenticationEntryPoint;
		}

	}

	public static class LogoutSetting {

		private String logoutUrl;

		private String logoutSuccessUrl;

		private boolean invalidateHttpSession;

		private String deleteCookies;

		/**
		 * logoutUrl 를 가져옵니다.
		 *
		 * @return logoutUrl
		 */
		public String getLogoutUrl() {
			return logoutUrl;
		}

		/**
		 * logoutUrl 를 설정합니다.
		 * 
		 * @param logoutUrl
		 *            설정 할 logoutUrl
		 */
		public void setLogoutUrl(String logoutUrl) {
			this.logoutUrl = logoutUrl;
		}

		/**
		 * logoutSuccessUrl 를 가져옵니다.
		 *
		 * @return logoutSuccessUrl
		 */
		public String getLogoutSuccessUrl() {
			return logoutSuccessUrl;
		}

		/**
		 * logoutSuccessUrl 를 설정합니다.
		 * 
		 * @param logoutSuccessUrl
		 *            설정 할 logoutSuccessUrl
		 */
		public void setLogoutSuccessUrl(String logoutSuccessUrl) {
			this.logoutSuccessUrl = logoutSuccessUrl;
		}

		/**
		 * invalidateHttpSession 를 가져옵니다.
		 *
		 * @return invalidateHttpSession
		 */
		public boolean isInvalidateHttpSession() {
			return invalidateHttpSession;
		}

		/**
		 * invalidateHttpSession 를 설정합니다.
		 * 
		 * @param invalidateHttpSession
		 *            설정 할 invalidateHttpSession
		 */
		public void setInvalidateHttpSession(boolean invalidateHttpSession) {
			this.invalidateHttpSession = invalidateHttpSession;
		}

		/**
		 * deleteCookies 를 가져옵니다.
		 *
		 * @return deleteCookies
		 */
		public String getDeleteCookies() {
			return deleteCookies;
		}

		/**
		 * deleteCookies 를 설정합니다.
		 * 
		 * @param deleteCookies
		 *            설정 할 deleteCookies
		 */
		public void setDeleteCookies(String deleteCookies) {
			this.deleteCookies = deleteCookies;
		}

		@Override
		public String toString() {
			StringBuilder builder = new StringBuilder();
			builder.append("LogoutSetting [");
			if (logoutUrl != null) {
				builder.append("logoutUrl=");
				builder.append(logoutUrl);
				builder.append(", ");
			}
			if (logoutSuccessUrl != null) {
				builder.append("logoutSuccessUrl=");
				builder.append(logoutSuccessUrl);
				builder.append(", ");
			}
			builder.append("invalidateHttpSession=");
			builder.append(invalidateHttpSession);
			builder.append(", ");
			if (deleteCookies != null) {
				builder.append("deleteCookies=");
				builder.append(deleteCookies);
			}
			builder.append("]");
			return builder.toString();
		}
	}

	public List<Class<? extends WebExpressionVoter>> getVoters() {
		return voters;
	}

	public void setVoters(List<Class<? extends WebExpressionVoter>> voters) {
		this.voters = voters;
	}
}
