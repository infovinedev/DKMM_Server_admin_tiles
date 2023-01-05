package kr.co.infovine.dkmm.controller.board;

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
import kr.co.infovine.dkmm.controller.map.MapController;
import kr.co.infovine.dkmm.db.model.board.TNotice;
import kr.co.infovine.dkmm.service.board.OperationNoticeService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/notice")
public class OperationNoticeController {
	
	@Autowired
	OperationNoticeService operationNoticeService;
	
	@Autowired
	MapController mapController;
	
	@RequestMapping(value ="/notice.do")
	public ModelAndView boardInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/operation_notice");
		model.addObject("leftPageUrl", "notice/notice");
		return model;
	}

	@RequestMapping(value = "/select/noticeAllList.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfo(HttpServletRequest request, HttpServletResponse response 
	,@RequestBody TNotice row) {
		ResponseModel result = new ResponseModel();
		try {
			List<TNotice> model = operationNoticeService.selecTNoticeAllList(row);
			ObjectMapper mapper = new ObjectMapper();
			String boardAllList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(boardAllList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/noticeListDetail.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfoDetail(HttpServletRequest request, HttpServletResponse response 
	,@RequestBody TNotice row) {
	ResponseModel result = new ResponseModel();
		try {
			TNotice model = operationNoticeService.selecTNoticeDetail(row);
			ObjectMapper mapper = new ObjectMapper();
			String noticeDetail = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(noticeDetail);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	//저장 수정 삭제.
	@RequestMapping(value = "/save/noticeSave.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel insertSavaBoard(HttpServletRequest request, HttpServletResponse response, HttpSession session ,@RequestBody TNotice row) {
		ResponseModel result = new ResponseModel();
		
		SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
		row.setInsSeq(sessionModel.getAdminUserSeq());
		row.setUptSeq(sessionModel.getAdminUserSeq());
		
		try {
			if(row.getType().equals("I")) {
				operationNoticeService.insertNotice(row);
			}else if(row.getType().equals("U")) {
				operationNoticeService.updateNotice(row);
			}else {
				int noticeSeq = row.getNoticeSeq();
				operationNoticeService.deleteNotice(noticeSeq);
			}
			result.setErrorMessage("success"); 
		} catch (Exception e) {
			result.setErrorMessage("error"); 
			e.printStackTrace(); 
		} 
		return result;
	}
}
