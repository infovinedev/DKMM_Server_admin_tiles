package kr.co.infovine.dkmm.controller.userLeave;

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
import kr.co.infovine.dkmm.db.model.userLeave.TUserLeave;
import kr.co.infovine.dkmm.service.user.OperationUserService;
import kr.co.infovine.dkmm.service.userLeave.OperationUserLeaveService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/userLeave")
public class OperationUserLeaveController {
	@Autowired
	OperationUserLeaveService operationUserLeaveService;
	
	@RequestMapping(value ="/userLeave.do")
	public ModelAndView realestateParcelInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/operation_userLeave");
		model.addObject("leftPageUrl", "userLeave/userLeave");
		return model;
	}

	@RequestMapping(value = "/select/userLeaveList.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfo(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TUserLeave userLeave) {
		ResponseModel result = new ResponseModel();
		try {
			List<TUserLeave> model = operationUserLeaveService.selectAllUserLeave(userLeave);
			ObjectMapper mapper = new ObjectMapper();
			String userLeaveInfoList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(userLeaveInfoList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/userInfoDetail.do", method = RequestMethod.POST
		, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
		@ResponseBody
		public ResponseModel selectRealestateParcelInfoDetail(HttpServletRequest request, HttpServletResponse response 
				,@RequestBody TUserLeave userLeave) {
			ResponseModel result = new ResponseModel();
			try {
				TUserLeave model = operationUserLeaveService.selectUserLeaveDetail(userLeave);
				ObjectMapper mapper = new ObjectMapper();
				String userLeaveDetailList = mapper.writeValueAsString(model);
				result.setCode("0000");
				result.setResult(userLeaveDetailList);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return result;
		}
}
