package kr.co.infovine.dkmm.controller.board;

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
import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.faq.TFaq;
import kr.co.infovine.dkmm.service.board.OperationBoardService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/board")
public class OperationBoardController {
	
	@Value("${url.mainUrl}")
    private String MAIN_URL;
	
	@Autowired
	OperationBoardService operationboardService;
	
	@Autowired
	MapController mapController;
	
	@RequestMapping(value ="/board.do")
	public ModelAndView boardInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/board");
		model.addObject("leftPageUrl", "board/board");
		return model;
	}

	@RequestMapping(value = "/select/boardAllList.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfo(HttpServletRequest request, HttpServletResponse response 
	,@RequestBody TBoard board) {
		ResponseModel result = new ResponseModel();
		try {
			board.setMainUrl(MAIN_URL);
			List<TBoard> model = operationboardService.selectboardAllList(board);
			ObjectMapper mapper = new ObjectMapper();
			String boardAllList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(boardAllList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/boardListDetail.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfoDetail(HttpServletRequest request, HttpServletResponse response 
	,@RequestBody TBoard board) {
	ResponseModel result = new ResponseModel();
		try {
			board.setMainUrl(MAIN_URL);
			TBoard model = operationboardService.selectboardListDetail(board);
			ObjectMapper mapper = new ObjectMapper();
			String boardlInfoDetail = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(boardlInfoDetail);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	//저장 수정 삭제.
	@RequestMapping(value = "/save/boardSave.do", method = RequestMethod.POST 
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody 
	public ResponseModel insertSavaBoard(HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestBody TBoard board) {
		ResponseModel result = new ResponseModel();
		SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
		board.setInsSeq(sessionModel.getAdminUserSeq());
		board.setUptSeq(sessionModel.getAdminUserSeq());
		try {
			if(board.getType().equals("I")) {
				operationboardService.insertBoard(board);
			}else if(board.getType().equals("U")) {
				operationboardService.updateBoard(board);
			}else {
				int boardSeq = board.getBoardSeq();
				operationboardService.deleteBoard(boardSeq);
			}
			result.setCode("0000");
			result.setErrorMessage("success"); 
		} catch (Exception e) {
			result.setErrorMessage("error"); 
			result.setCode("0001");
			e.printStackTrace(); 
		} 
		return result;
	}
	
	//저장 수정 삭제.
		@RequestMapping(value = "/save/boardDeleteFile.do", method = RequestMethod.POST 
		, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
		@ResponseBody 
		public ResponseModel boardDeleteFile(HttpServletRequest request, HttpServletResponse response ,HttpSession session, @RequestBody TBoard board) {
			ResponseModel result = new ResponseModel();
			
			try {
				SessionModel sessionModel = (SessionModel) session.getAttribute("userInfo");
				board.setUptSeq(sessionModel.getAdminUserSeq());
				operationboardService.deleteBoardFileData(board);
				
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
