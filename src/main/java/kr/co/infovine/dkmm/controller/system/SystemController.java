package kr.co.infovine.dkmm.controller.system;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.api.model.base.SessionModel;
import kr.co.infovine.dkmm.db.model.define.TDefineNameStop;
import kr.co.infovine.dkmm.service.system.SystemService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/system")
public class SystemController {
	
	@Autowired
	SystemService systemService;
	
	@RequestMapping(value ="/nameStop.do")
	public ModelAndView realestateParcelInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("system/name_stop");
		model.addObject("leftPageUrl", "system/nameStop");
		return model;
	}

	@RequestMapping(value = "/select/nameStop.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfo(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineNameStop row) {
		ResponseModel result = new ResponseModel();
		try {
			List<TDefineNameStop> model = systemService.selectAll(row);
			ObjectMapper mapper = new ObjectMapper();
			String list = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(list);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	//등록
	@RequestMapping(value = "/save/insertNameStop.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel insertNameStop(HttpServletRequest request, HttpServletResponse response 
			,HttpSession session ,@RequestBody TDefineNameStop row) {
		ResponseModel result = new ResponseModel();
		try {
			
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			log.info(" sessionModel ==> " + sessionModel);
			row.setInsSeq(sessionModel.getAdminUserSeq());
			systemService.insert(row);
			result.setCode("0000");
		} catch (Exception e) {
			result.setCode("0001");
			result.setErrorMessage(e.toString());
			e.printStackTrace();
		}
		return result;
	}

	//수정
	@RequestMapping(value = "/save/updateNameStop.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel updateNameStop(HttpServletRequest request, HttpServletResponse response 
			,HttpSession session ,@RequestBody TDefineNameStop row) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			row.setInsSeq(sessionModel.getAdminUserSeq());
			systemService.updateByPrimaryKey(row);
			result.setCode("0000");
		} catch (Exception e) {
			result.setCode("0001");
			result.setErrorMessage(e.toString());
			e.printStackTrace();
		}
		return result;
	}
	
	//삭제
	@RequestMapping(value = "/save/deleteNameStop.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel deleteNameStop(HttpServletRequest request, HttpServletResponse response 
			,HttpSession session ,@RequestBody TDefineNameStop row) {
		ResponseModel result = new ResponseModel();
		try {
			systemService.deleteByPrimaryKey(row.getStopSeq());
			result.setCode("0000");
		} catch (Exception e) {
			result.setCode("0001");
			result.setErrorMessage(e.toString());
			e.printStackTrace();
		}
		return result;
	}
}
