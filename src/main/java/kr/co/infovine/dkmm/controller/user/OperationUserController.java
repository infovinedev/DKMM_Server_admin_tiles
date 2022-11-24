package kr.co.infovine.dkmm.controller.user;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.service.user.OperationUserService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/user")
public class OperationUserController {
	@Autowired
	OperationUserService operationUserService;
	
	@RequestMapping(value ="/user.do")
	public ModelAndView realestateParcelInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/operation_user");
		model.addObject("leftPageUrl", "user/user");
		return model;
	}

	@RequestMapping(value = "/select/userInfo.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfo(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TUserInfo userInfo) {
		ResponseModel result = new ResponseModel();
		try {
			List<TUserInfo> model = operationUserService.selectAllUserInfo(userInfo);
			
			
			
			
			System.out.println(model);
			ObjectMapper mapper = new ObjectMapper();
			String strParcelInfo = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(strParcelInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/userInfoDetail.do", method = RequestMethod.POST
		, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
		@ResponseBody
		public ResponseModel selectRealestateParcelInfoDetail(HttpServletRequest request, HttpServletResponse response 
				,@RequestBody TUserInfo userInfo) {
			ResponseModel result = new ResponseModel();
			try {
				TUserInfo model = operationUserService.selectUserInfoDetail(userInfo);
				ObjectMapper mapper = new ObjectMapper();
				String userDetailListInfo = mapper.writeValueAsString(model);
				result.setCode("0000");
				result.setResult(userDetailListInfo);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return result;
		}
}
