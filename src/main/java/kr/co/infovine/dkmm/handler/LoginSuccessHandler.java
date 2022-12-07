package kr.co.infovine.dkmm.handler;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.api.model.base.SessionModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserModel;
import kr.co.infovine.dkmm.service.admin.CommonService;
import kr.co.infovine.dkmm.service.admin.EncryptService;
import kr.co.infovine.dkmm.service.admin.TAdminService;

/**
 * LoginSuccessHandler Class 입니다.
 *
 * @author duHyun, Kim
 */
public class LoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
	protected final String PASSWORD_NEW = "0004";  
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws ServletException, IOException {

		ResponseModel result = new ResponseModel();
		if (authentication instanceof UsernamePasswordAuthenticationToken) {
			UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) authentication;
			String userId = token.getName();
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
			SimpleDateFormat fileDateSdf = new SimpleDateFormat("yyMMdd");
			Calendar currentTime = Calendar.getInstance(Locale.KOREA);
			String tryLoginDate = dateFormat.format(currentTime.getTime());

			CommonService commonService 
				= (CommonService)ApplicationContextProvider.getApplicationContext().getBean("commonService");
			EncryptService encryptService 
			= (EncryptService)ApplicationContextProvider.getApplicationContext().getBean("encryptService");
			TAdminService tbAdminService 
			= (TAdminService)ApplicationContextProvider.getApplicationContext().getBean("tbAdminService");
			
			commonService.setLoggedInUser(userId);
			TbAdminUserModel tbAdminUser = new TbAdminUserModel();
			tbAdminUser.setUserId(userId);
			TbAdminUserModel resultSet = tbAdminService.selectByAdminUserId(tbAdminUser);
			if(resultSet!=null) {
				//로그인 성공시
				result.setCode("0000");
				Integer passwordErrorCount = resultSet.getPasswordErrorCount();
				String passwordErrorDate = resultSet.getPasswordErrorDate();
				String passwordLostCheck = resultSet.getPasswordLostCheck();
				String passwordLostDate = resultSet.getPasswordLostDate();
				int adminUserSeq = resultSet.getAdminUserSeq();
				String userName = resultSet.getUserName();
				
				String block = resultSet.getBlockYn();
				
				if(passwordLostCheck != null) {
					if(passwordLostCheck.equals("Y")) {
						System.out.println("현재날짜 : " + sdf.format(currentTime.getTime()));
						String localDate = sdf.format(currentTime.getTime());
						String startDate = "";
						String endDate = "";
						String fileStartDate = "";
						String fileEndDate = "";
						currentTime.add(Calendar.DATE, -7);
						System.out.println("현재날짜-7 : " + sdf.format(currentTime.getTime()));
						currentTime.add(Calendar.DATE, 2 - currentTime.get(Calendar.DAY_OF_WEEK));
						currentTime.set(Calendar.HOUR_OF_DAY, 10);
						currentTime.set(Calendar.MINUTE, 0);
						currentTime.set(Calendar.SECOND, 0);
						currentTime.set(Calendar.MILLISECOND, 000);
						System.out.println("첫번째 요일(월요일)날짜:"+sdf.format(currentTime.getTime()));
						startDate = sdf.format(currentTime.getTime());
						fileStartDate = fileDateSdf.format(currentTime.getTime());
						
						currentTime.add(Calendar.DATE, 9 - currentTime.get(Calendar.DAY_OF_WEEK));
						currentTime.set(Calendar.HOUR_OF_DAY, 9);
						currentTime.set(Calendar.MINUTE, 59);
						currentTime.set(Calendar.SECOND, 59);
						currentTime.set(Calendar.MILLISECOND, 999);
						System.out.println("마지막 요일(일요일)날짜:"+sdf.format(currentTime.getTime()));
						endDate = sdf.format(currentTime.getTime());
						fileEndDate = fileDateSdf.format(currentTime.getTime());
						
						//4월 5일을 월요일로 기준점을 잡는다
						//오늘은 4월 7일이야
						//4월 12일을 기준으로 잡아야돼
//						vo.setStartDate(startDate);
//						vo.setEndDate(endDate);
						//if(passwordLostDate.equals(lastloginDate)) {
						result.setCode("0002");
						//}
					}
					else if(passwordLostCheck.equals("F")){
						result.setCode("0004");
//						String userId = tbAdminUser.getUserId();
//						SessionModel sessionModel = new SessionModel();
//						sessionModel.setUserId(userId);
//						sessionModel.setAdminUserSeq(adminUserSeq);
//						sessionModel.setUserName(userName);
//						session.setAttribute("userInfo", sessionModel);
					}
				}
				
				tbAdminUser.setPasswordErrorCount(0);
				tbAdminUser.setPasswordErrorDate("");
				if(result.getCode().equals(PASSWORD_NEW)) {
					tbAdminUser.setPasswordLostCheck(null);
				}
				else {
					tbAdminUser.setPasswordLostCheck("");
				}
				tbAdminUser.setPasswordLostDate("");
				tbAdminUser.setLastloginDate(tryLoginDate);
				
				tbAdminService.updateByAdminUserUserId(tbAdminUser);
				
				
				HttpSession session = request.getSession();
				SessionModel sessionModel = new SessionModel();
				String sha512 = encryptService.getEncryptSha512(userId);
				sha512 = sha512.substring(0, 32);			
				sessionModel.setUserId(userId);
				sessionModel.setAdminUserSeq(adminUserSeq);
				sessionModel.setUserName(userName);
				sessionModel.setCryptoAes(sha512.toUpperCase());
				session.setAttribute("userInfo", sessionModel);
				session.setMaxInactiveInterval(3600); //세션시간 1시간
			}
			
			String rememberMe = request.getParameter("rememberMe");
			if (rememberMe != null && rememberMe.equals("on")) {
				Cookie cookie = new Cookie("userId", userId);
				response.addCookie(cookie);
			}
			
			
		}
		
		if(result.getCode().equals(PASSWORD_NEW)) {
			setDefaultTargetUrl("/admin/firstPassword.do");
		}
		else {
			setDefaultTargetUrl("/main/page.do");
		}
		super.onAuthenticationSuccess(request, response, authentication);

	}

	@Component
	public static class ApplicationContextProvider implements ApplicationContextAware{
	    
	    private static ApplicationContext applicationContext;

	    @Override
	    public void setApplicationContext(ApplicationContext ctx)
	    		throws BeansException {
	    	applicationContext = ctx;
	    	
	    }
	    
	    public static ApplicationContext getApplicationContext() {
	        return applicationContext;
	    }
	 
	}
}
