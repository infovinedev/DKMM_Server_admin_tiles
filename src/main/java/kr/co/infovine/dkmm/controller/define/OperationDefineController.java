package kr.co.infovine.dkmm.controller.define;

import java.util.ArrayList;
import java.util.HashMap;
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
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.service.define.OperationDefineService;
import kr.co.infovine.dkmm.service.user.OperationUserService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/define")
public class OperationDefineController {
	@Autowired
	OperationDefineService operationDefineService;
	
	@RequestMapping(value ="/define.do")
	public ModelAndView defineWorkInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/define");
		model.addObject("leftPageUrl", "define/define");
		return model;
	}
	
	@RequestMapping(value = "/select/defineWorkList.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectDefineWorkInfo(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel();
		try {
			List<TDefineWork> model = operationDefineService.selectAlldefineWork(defineWork);
			ObjectMapper mapper = new ObjectMapper();
			String defineWorkList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(defineWorkList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	@RequestMapping(value = "/select/defineWorkDetail.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectDefineWorkInfoDetail(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel();
		try {
			TDefineWork model = operationDefineService.selectdefineWorkDetail(defineWork);
			ObjectMapper mapper = new ObjectMapper();
			String defineDetailListInfo = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(defineDetailListInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/defineWorkGetNicknm.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
			@ResponseBody
			public ResponseModel selectDefineWorkGetNicknm(HttpServletRequest request, HttpServletResponse response 
					,@RequestBody TDefineWork defineWork) {
				ResponseModel result = new ResponseModel();
				try {
					List<TDefineWork> model = operationDefineService.selectDefineWorkGetNicknm(defineWork);
					ObjectMapper mapper = new ObjectMapper();
					String defineWorkList = mapper.writeValueAsString(model);
					result.setCode("0000");
					result.setResult(defineWorkList);
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
	
	@RequestMapping(value = "/save/defineWorkUpdate.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel savaDefineWorkUseYn(HttpServletRequest request, HttpServletResponse response 
			,HttpSession session,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			defineWork.setUptSeq(sessionModel.getAdminUserSeq());
			operationDefineService.upDateDefineWork(defineWork);
			result.setErrorMessage("success");
		} catch (Exception e) {
			result.setErrorMessage("error");
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/save/defineWorkinsert.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel savaDefineInsert(HttpServletRequest request, HttpServletResponse response 
			,HttpSession session,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel();
		try {
			SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
			defineWork.setInsSeq(sessionModel.getAdminUserSeq());
			operationDefineService.insertDefineWork(defineWork);
			result.setErrorMessage("success");
		} catch (Exception e) {
			result.setErrorMessage("error");
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/selectDefineWorkStatExcel.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectDefineWorkStat(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel();
		try {
			List<HashMap<String, Object>> model = operationDefineService.selectDefineWorkStat(defineWork);
			ObjectMapper mapper = new ObjectMapper();
			String defineWorkStatExcel = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(defineWorkStatExcel);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	@RequestMapping(value = "/select/selectDefineWorkPromoStatExcel.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectDefineWorkPromoStatExcel(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TDefineWork defineWork) {
		ResponseModel result = new ResponseModel();
		try {
			List<HashMap<String, Object>> rtnList = new ArrayList<HashMap<String,Object>>();
			List<HashMap<String, Object>> model = operationDefineService.selectDefineWorkStat(defineWork);
			
			int totalCnt = 0;
			
			for( HashMap<String, Object> hm : model  ) {
				
				String completeCntStr = (String) hm.get("달성횟수");
				int completeCnt = Integer.parseInt(completeCntStr);
				int numCnt = 0;
				for (int i=0; i<completeCnt; i++) {
					
					totalCnt++;
					numCnt++;
					
					HashMap<String, Object> newHm = new HashMap<String, Object>();
					
					newHm.put("번호", totalCnt);
					newHm.put("사용자업적완료순서", numCnt);
					newHm.put("사용자Seq", hm.get("사용자Seq"));
					newHm.put("닉네임", hm.get("닉네임"));
					newHm.put("휴대폰", hm.get("휴대폰"));
					newHm.put("접속기기타입", hm.get("접속기기타입"));
					newHm.put("달성횟수", hm.get("달성횟수"));
					newHm.put("달성여부", hm.get("달성여부"));
					newHm.put("업적달성일자", hm.get("업적달성일자"));
					newHm.put("첫업적등록일자", hm.get("첫업적등록일자"));
					newHm.put("마지막업적등록일자", hm.get("마지막업적등록일자"));
					
					
					log.info(newHm.toString());
					
					rtnList.add(newHm);
				}
			}
			
			log.info(rtnList.toString());
			
			ObjectMapper mapper = new ObjectMapper();
			String defineWorkStatPromoExcel = mapper.writeValueAsString(rtnList);
			
			log.info(defineWorkStatPromoExcel.toString());
			
			result.setCode("0000");
			result.setResult(defineWorkStatPromoExcel);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
