package kr.co.infovine.dkmm.controller.nicknm;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.api.model.base.SessionModel;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.faq.TFaq;
import kr.co.infovine.dkmm.db.model.nicknm.TDefineNicknm;
import kr.co.infovine.dkmm.service.nicknm.OperationNicknmService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/nicknm")
public class OperationNicknmController {
	
	@Value("${url.mainUrl}")
    private String MAIN_URL;
	
	@Autowired
	OperationNicknmService nicknmService;
	
	@RequestMapping(value ="/nicknm.do")
	public ModelAndView defineNicknmInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/nicknm");
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
			
			defineNicknm.setMainUrl(MAIN_URL);
			List<TDefineNicknm> model = nicknmService.selectAlldefineNicknm(defineNicknm);
			ObjectMapper mapper = new ObjectMapper();
			String nickNmWorkList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(nickNmWorkList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/defineNicknmDetail.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
			@ResponseBody
			public ResponseModel selectDefineWorkInfoDetail(HttpServletRequest request, HttpServletResponse response 
					,@RequestBody TDefineNicknm defineNicknm) {
				ResponseModel result = new ResponseModel();
				try {
					
					defineNicknm.setMainUrl(MAIN_URL);
					TDefineNicknm model = nicknmService.selectNicknmDetail(defineNicknm);
					ObjectMapper mapper = new ObjectMapper();
					String nickNmDetailListInfo = mapper.writeValueAsString(model);
					result.setCode("0000");
					result.setResult(nickNmDetailListInfo);
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
	
	//저장 수정 삭제.
	@RequestMapping(value = "/save/nickNmSave.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel insertSavafaq(HttpServletRequest request, HttpServletResponse response 
			,HttpSession session,@RequestBody TDefineNicknm defineNicknm) {
	ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			
			if ( defineNicknm.getType() == null ) {
				int nickSeq = defineNicknm.getNickSeq();
				nicknmService.delete(nickSeq);
			}
			else {
				if(defineNicknm.getType().equals("I")) {
					defineNicknm.setInsSeq(sessionModel.getAdminUserSeq());
					nicknmService.insert(defineNicknm);
					
				}
				else if(defineNicknm.getType().equals("U")) {
					defineNicknm.setUptSeq(sessionModel.getAdminUserSeq());
					nicknmService.update(defineNicknm);
				}
				else if(defineNicknm.getType().equals("D")) {
					int nickSeq = defineNicknm.getNickSeq();
					nicknmService.delete(nickSeq);
				}
			}
			result.setErrorMessage("success"); 
		} catch (Exception e) {
			result.setErrorMessage("error"); 
			e.printStackTrace(); 
		} 
		return result;
	}
}
