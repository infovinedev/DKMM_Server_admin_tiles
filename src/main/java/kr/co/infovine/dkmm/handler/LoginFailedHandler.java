package kr.co.infovine.dkmm.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

/**
 * LoginFailedHandler Class 입니다.
 *
 * @author duHyun, Kim
 */
public class LoginFailedHandler implements AuthenticationFailureHandler {

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {

		String redirectUrl = request.getContextPath();
		redirectUrl += "/admin/loginView.do";
		redirectUrl += "?errorCode=403";

		String requestRedirectUrl = request.getParameter("redirectUrl");
		if (requestRedirectUrl != null && !redirectUrl.isEmpty()) {
			redirectUrl += "&redirectUrl=" + requestRedirectUrl;
		}
		response.sendRedirect(redirectUrl);
	}

}
