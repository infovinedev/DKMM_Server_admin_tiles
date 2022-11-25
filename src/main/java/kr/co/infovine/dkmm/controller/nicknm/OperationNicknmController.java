package kr.co.infovine.dkmm.controller.nicknm;

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
import kr.co.infovine.dkmm.db.model.nicknm.TDefineNicknm;
import kr.co.infovine.dkmm.service.nicknm.OperationNicknmService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/nicknm")
public class OperationNicknmController {
	@Autowired
	OperationNicknmService nicknmService;
	
	@RequestMapping(value ="/nicknm.do")
	public ModelAndView realestateParcelInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/operation_nicknm");
		model.addObject("leftPageUrl", "nicknm/nicknm");
		return model;
	}

	@RequestMapping(value = "/select/defineNicknmList.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectDefineNicknmInfo(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineNicknm defineNicknm) {
		ResponseModel result = new ResponseModel();
		try {
			List<TDefineNicknm> model = nicknmService.selectAlldefineNicknm(defineNicknm);
			ObjectMapper mapper = new ObjectMapper();
			String defineWorkList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(defineWorkList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	/*
	 * @RequestMapping(value = "/select/defineWorkDetail.do", method =
	 * RequestMethod.POST , consumes = "application/json; charset=utf8", produces =
	 * "application/json; charset=utf8")
	 * 
	 * @ResponseBody public ResponseModel
	 * selectRealestateParcelInfoDetail(HttpServletRequest request,
	 * HttpServletResponse response ,@RequestBody TDefineWork defineWork) {
	 * ResponseModel result = new ResponseModel(); try { TDefineWork model =
	 * operationDefineService.selectdefineWorkDetail(defineWork); ObjectMapper
	 * mapper = new ObjectMapper(); String defineDetailListInfo =
	 * mapper.writeValueAsString(model); result.setCode("0000");
	 * result.setResult(defineDetailListInfo); } catch (Exception e) {
	 * e.printStackTrace(); } return result; }
	 * 
	 * @RequestMapping(value = "/save/defineWorkUpdate.do", method =
	 * RequestMethod.POST , consumes = "application/json; charset=utf8", produces =
	 * "application/json; charset=utf8")
	 * 
	 * @ResponseBody public ResponseModel savaDefineWorkUseYn(HttpServletRequest
	 * request, HttpServletResponse response ,@RequestBody TDefineWork defineWork) {
	 * ResponseModel result = new ResponseModel(); try {
	 * operationDefineService.upDateDefineWork(defineWork);
	 * result.setErrorMessage("success"); } catch (Exception e) {
	 * result.setErrorMessage("error"); e.printStackTrace(); } return result; }
	 * 
	 * @RequestMapping(value = "/save/defineWorkinsert.do", method =
	 * RequestMethod.POST , consumes = "application/json; charset=utf8", produces =
	 * "application/json; charset=utf8")
	 * 
	 * @ResponseBody public ResponseModel savaDefineInsert(HttpServletRequest
	 * request, HttpServletResponse response ,@RequestBody TDefineWork defineWork) {
	 * ResponseModel result = new ResponseModel(); try {
	 * operationDefineService.insertDefineWork(defineWork);
	 * result.setErrorMessage("success"); } catch (Exception e) {
	 * result.setErrorMessage("error"); e.printStackTrace(); } return result; }
	 */
}
