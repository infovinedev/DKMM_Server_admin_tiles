package kr.co.infovine.dkmm.controller.defineApproval;

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
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.service.define.OperationDefineService;
import kr.co.infovine.dkmm.service.defineApproval.OperationDefineApprovalService;
import kr.co.infovine.dkmm.service.user.OperationUserService;
import kr.co.infovine.dkmm.util.CommonUtil;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/approval")
public class OperationDefineApprovalController {
	@Autowired
	OperationDefineApprovalService operationDefineApprovalService;
	
	@RequestMapping(value ="/defineApproval.do")
	public ModelAndView defineWorkInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/operation_defineApproval");
		model.addObject("leftPageUrl", "approval/defineApproval");
		model.addObject("auth", CommonUtil.getUpAuth());
		return model;
	}

	@RequestMapping(value = "/select/defineWorkApprovalList.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectDefineWorkInfo(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel();
		try {
			List<TDefineWork> model = operationDefineApprovalService.selectAlldefineWorkApproval(defineWork);
			ObjectMapper mapper = new ObjectMapper();
			String defineWorkList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(defineWorkList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/defineWorkApprovalDetail.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel selectDefineWorkInfoDetail(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) { 
		ResponseModel result = new ResponseModel(); 
		try { 
			TDefineWork model = operationDefineApprovalService.selectdefineWorkApprovalDetail(defineWork);
			ObjectMapper mapper = new ObjectMapper();
			String defineDetailListInfo = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(defineDetailListInfo); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result; 
	}
	
	//수정
	@RequestMapping(value = "/save/defineWorkUpdate.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel savaDefineWorkAll(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
	ResponseModel result = new ResponseModel();
		try {
			operationDefineApprovalService.upDateAllDefineWork(defineWork);
			result.setErrorMessage("success"); 
		} catch (Exception e) {
			result.setErrorMessage("error"); e.printStackTrace(); 
		} 
		return result;
	}
	
	@RequestMapping(value = "/save/defineWorkDelete.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel deleteDefineWorkAll(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
	ResponseModel result = new ResponseModel();
		try {
			operationDefineApprovalService.deleteAllDefineWork(defineWork);
			result.setErrorMessage("success"); 
		} catch (Exception e) {
			result.setErrorMessage("error"); e.printStackTrace(); 
		} 
		return result;
	}
	
	
	@RequestMapping(value = "/save/defineWorkapproval.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel savaDefineWorkApproval(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel();
		try {
			if ( "ROLE_ADMIN".equals(CommonUtil.getUpAuth()) || "ROLE_MNG".equals(CommonUtil.getUpAuth()) ){
				operationDefineApprovalService.upDateApproval(defineWork);
				result.setCode("0000"); 
				result.setErrorMessage("success"); 
			}
			else {
				result.setCode("0001"); 
				result.setErrorMessage("해당기능을 실행 할 권한이 없습니다"); 
			}
		} catch (Exception e) {
			e.printStackTrace(); 
			result.setCode("0001"); 
			result.setErrorMessage("error");
		} 
		return result;
	}
	 
	
	@RequestMapping(value = "/save/defineWorkUseYn.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel savaDefineWorkUseYn(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel();
		try {
			if ( "ROLE_ADMIN".equals(CommonUtil.getUpAuth()) || "ROLE_MNG".equals(CommonUtil.getUpAuth()) ){
				operationDefineApprovalService.upDateUseYn(defineWork);
				result.setCode("0000"); 
				result.setErrorMessage("success"); 
			}
			else {
				result.setCode("0001"); 
				result.setErrorMessage("해당기능을 실행 할 권한이 없습니다"); 
			}
		} catch (Exception e) {
			result.setErrorMessage("error");
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/selectNickComment.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel selectNickComment(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel(); 
		try { 
			TDefineWork model = operationDefineApprovalService.selectNickComment(defineWork);
			ObjectMapper mapper = new ObjectMapper();
			String defineDetailListInfo = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(defineDetailListInfo); 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result; 
	}
}
