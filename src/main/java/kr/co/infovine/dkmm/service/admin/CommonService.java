package kr.co.infovine.dkmm.service.admin;

import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;


@Service
public class CommonService {
	/**
	 * Login 된 User 를 설정합니다.
	 * 
	 * @param userId
	 *            Login 된 User Id
	 */
	public void setLoggedInUser(String userId) {

		RequestAttributes requestAttributes = RequestContextHolder.currentRequestAttributes();
		if (requestAttributes == null) {
			return;
		}

//		UserModel searchUser = new UserModel();
//		searchUser.setUserId(userId);
//
//		UserModel user = userService.getUser(searchUser);
//		requestAttributes.setAttribute(SESSION_KEY_LOGIN_USER, user, RequestAttributes.SCOPE_SESSION);
	}
}
