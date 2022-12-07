package kr.co.infovine.dkmm.controller.board;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.controller.map.MapController;
import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.service.board.OperationBoardService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/board")
public class OperationboardController {
	
	@Autowired
	OperationBoardService operationboardService;
	
	@Autowired
	MapController mapController;
	
	@RequestMapping(value ="/board.do")
	public ModelAndView boardInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/operation_board");
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
	/*
	@RequestMapping(value = "/select/boardInfoDetail.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
			@ResponseBody
			public ResponseModel selectRealestateParcelInfoDetail(HttpServletRequest request, HttpServletResponse response 
					,@RequestBody TboardInfoModel boardInfo) {
				ResponseModel result = new ResponseModel();
				try {
					TboardInfoModel model = operationboardService.selectboardInfoDetail(boardInfo);
					ObjectMapper mapper = new ObjectMapper();
					String boardlInfoDetail = mapper.writeValueAsString(model);
					result.setCode("0000");
					result.setResult(boardlInfoDetail);
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
	// end region
	
	//저장 수정 삭제.
	@RequestMapping(value = "/save/boardInfo.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
			@ResponseBody
			public ResponseModel savaboardInfo(HttpServletRequest request, HttpServletResponse response 
					,@RequestBody TboardInfoModel boardInfo) {
				ResponseModel result = new ResponseModel();
				try {
					operationboardService.insertboardInfo(boardInfo);
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
	*/
}
