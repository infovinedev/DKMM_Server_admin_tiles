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
import kr.co.infovine.dkmm.util.CommonUtil;
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
		model.setViewName("operation/userLeave");
		model.addObject("leftPageUrl", "userLeave/userLeave");
		model.addObject("auth", CommonUtil.getUpAuth());
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
			result.setCode("0001");
			result.setErrorMessage(e.getMessage());
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
			result.setCode("0001");
			result.setErrorMessage(e.getMessage());
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/save/leaveRollBack.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel leaveRollBack(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TUserLeave userLeave) {
		
		ResponseModel result = new ResponseModel();
		
		if ( !"ROLE_ADMIN".equals(CommonUtil.getUpAuth()) ) {
			result.setCode("9999");
			result.setErrorMessage("해당 기능을 사용할 권한이 없습니다.");
			return result;
		}
		
		try {
			int rtnCnt = operationUserLeaveService.updateRollbackLeave(userLeave);
			
			if ( rtnCnt == 9999) {
				result.setCode("0001");
				result.setErrorMessage("탈퇴한 사용자의 휴대폰 번호로 재가입된 고객이 있습니다. 탈퇴 철회를 할 수 없습니다.");
			}
			else {
				result.setCode("0000");
			}
			
		} catch (Exception e) {
//			e.printStackTrace();
			result.setCode("0001");
			result.setErrorMessage(e.getMessage());
		}
		return result;
	}
}
