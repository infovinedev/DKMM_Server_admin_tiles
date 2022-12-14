package kr.co.infovine.dkmm.controller.faq;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.api.model.base.SessionModel;
import kr.co.infovine.dkmm.controller.map.MapController;
import kr.co.infovine.dkmm.db.model.faq.TFaq;
import kr.co.infovine.dkmm.service.faq.OperationFaqService;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/faq")
public class OperationFaqController {
	
	@Value("${url.mainUrl}")
    private String MAIN_URL;
	
	@Autowired
	OperationFaqService operationfaqService;
	
	@Autowired
	MapController mapController;
	
	@RequestMapping(value ="/faq.do")
	public ModelAndView faqInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/faq");
		model.addObject("leftPageUrl", "faq/faq");
		return model;
	}

	@RequestMapping(value = "/select/faqAllList.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfo(HttpServletRequest request, HttpServletResponse response 
	,@RequestBody TFaq faq) {
		ResponseModel result = new ResponseModel();
		try {
			faq.setMainUrl(MAIN_URL);
			List<TFaq> model = operationfaqService.selectFaqAllList(faq);
			ObjectMapper mapper = new ObjectMapper();
			String faqAllList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(faqAllList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/select/faqListDetail.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfoDetail(HttpServletRequest request, HttpServletResponse response 
	,@RequestBody TFaq faq) {
	ResponseModel result = new ResponseModel();
		try {
			faq.setMainUrl(MAIN_URL);
			TFaq model = operationfaqService.selectFaqListDetail(faq);
			ObjectMapper mapper = new ObjectMapper();
			String faqlInfoDetail = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(faqlInfoDetail);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	//?????? ?????? ??????.
	@RequestMapping(value = "/save/faqSave.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel insertSavafaq(HttpServletRequest request, HttpServletResponse response ,HttpSession session, @RequestBody TFaq faq) {
		ResponseModel result = new ResponseModel();
		
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			faq.setInsSeq(sessionModel.getAdminUserSeq());
			faq.setUptSeq(sessionModel.getAdminUserSeq());
			
			if(faq.getType().equals("I")) {
				operationfaqService.insertFaq(faq);
			}else if(faq.getType().equals("U")) {
				operationfaqService.updateFaq(faq);
			}else {
				int faqSeq = faq.getFaqSeq();
				operationfaqService.deleteFaq(faqSeq);
			}
			result.setCode("0000");
			result.setErrorMessage("success"); 
		} catch (Exception e) {
			result.setCode("0001");
			result.setErrorMessage("error"); 
			e.printStackTrace(); 
		} 
		return result;
	}
	
	//?????? ?????? ??????.
	@RequestMapping(value = "/save/faqDeleteFile.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel faqDeleteFile(HttpServletRequest request, HttpServletResponse response ,HttpSession session, @RequestBody TFaq faq) {
		ResponseModel result = new ResponseModel();
		
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			faq.setUptSeq(sessionModel.getAdminUserSeq());
			operationfaqService.deleteFaqFileData(faq);
			
			result.setCode("0000");
			result.setErrorMessage("success"); 
		} catch (Exception e) {
			result.setCode("0001");
			result.setErrorMessage("error"); 
			e.printStackTrace(); 
		} 
		return result;
	}

}
