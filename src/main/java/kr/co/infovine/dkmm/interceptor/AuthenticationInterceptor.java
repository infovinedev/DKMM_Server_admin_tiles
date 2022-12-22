package kr.co.infovine.dkmm.interceptor;

import java.io.BufferedReader;
import java.util.Enumeration;
import java.util.Set;
import java.util.concurrent.atomic.AtomicLong;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.ContentCachingRequestWrapper;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.infovine.dkmm.api.model.base.SessionModel;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class AuthenticationInterceptor implements HandlerInterceptor{
	private final AtomicLong counter = new AtomicLong();
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		boolean flag = true;
		String hUserAgent = request.getHeader("User-Agent") == null ? "" : request.getHeader("User-Agent");
		String ipAddress = request.getHeader("X-FORWARDED-FOR");
		String requestURI = request.getRequestURI();
		
		if(ipAddress == null) ipAddress = request.getRemoteAddr();
		request.setAttribute("REQUEST_URI", requestURI);
		String sstr = "["+counter.incrementAndGet()+"]";
		sstr = sstr + "[" + ipAddress + "][" + requestURI + "][" + hUserAgent + "]";
		//logger.info("==========================================================");
		//logger.info(sstr);
		sstr = null;
		
		HttpSession session = request.getSession();
		Object obj = session.getAttribute("userInfo");
		
		if(obj != null) {
			SessionModel tempSessionModel = (SessionModel) obj;
			String userName = tempSessionModel.getUserName();
			String crypto = tempSessionModel.getCryptoAes();
			request.getSession().setAttribute("userName", userName);
			request.getSession().setAttribute("crypto", crypto);
		}
		else {
			if(requestURI!=null) {
				if(requestURI.equals("/favicon.ico") || requestURI.equals("/admin/logout.do") || requestURI.equals("/admin/loginView.do")) {
					
				}
				else {
					
					String contentsType =  request.getHeader("content-type");
					if ( contentsType != null && "application/json; charset=UTF-8".equals(contentsType)) {
						response.sendError(403);
						flag = false;
					}
					else if(contentsType != null && contentsType.indexOf("multipart/form-data")==0) {

					}
					else{
						response.sendRedirect("/admin/loginView.do?errorCode=session");
					}
				}
			}
		}
		
		return flag;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
	}
}
