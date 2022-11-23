package kr.co.infovine.dkmm.controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.api.model.base.SessionModel;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BaseController {
	@RequestMapping(value="/error.do")
	public ModelAndView error(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("error");
		return model;
	}
	
	@RequestMapping(value="/main/page.do")
	public ModelAndView mainPage(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("main/page");
		return model;
	}
	
	@RequestMapping(value = "/favicon.ico", method = RequestMethod.GET)
	public void favicon( HttpServletRequest request, HttpServletResponse reponse ) {
		try {
			reponse.sendRedirect("/assets/favicon.ico");
		} catch (IOException e) {
		}
	}
	
	@RequestMapping(value="/session.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel checkSession(HttpServletRequest request, HttpServletResponse response) {
		ResponseModel result = new ResponseModel();
		try {
			HttpSession session = request.getSession();
			Object obj = session.getAttribute("userInfo");
			if(obj != null) {
//				Calendar calendar = Calendar.getInstance(Locale.KOREA);
//				calendar.setTimeInMillis(session.getCreationTime());
//				int min = calendar.get(Calendar.MINUTE);
//				int sec = calendar.get(Calendar.SECOND);
//				log.info("min : " + min + ", sec : " + sec);
//				JSONObject json = new JSONObject();
//				json.put("min", min);
//				json.put("sec", sec);
				
				result.setCode("0000");
//				result.setResult(json.toString());
			}
			else {
				result.setCode("0001");
			}
		}
		catch (Exception e) {
		}
		return result;
	}
}
