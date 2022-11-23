package kr.co.infovine.dkmm.controller.store;

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
import kr.co.infovine.dkmm.db.model.store.TStoreInfo;
import kr.co.infovine.dkmm.service.store.OperationStoreService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping(value = "/store")
public class OperationStoreController {
	
	@Autowired
	OperationStoreService operationStoreService;
	
	@Autowired
	MapController mapController;
	
	@RequestMapping(value ="/store.do")
	public ModelAndView realestateParcelInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/operation_store");
		model.addObject("leftPageUrl", "store/store");
		return model;
	}

	@RequestMapping(value = "/select/storeInfo.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfo(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TStoreInfo storeInfo) {
		ResponseModel result = new ResponseModel();
		try {
			List<TStoreInfo> model = operationStoreService.selectStoreInfo(storeInfo);
			ObjectMapper mapper = new ObjectMapper();
			String strParcelInfo = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(strParcelInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/storeInfoDetail.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
			@ResponseBody
			public ResponseModel selectRealestateParcelInfoDetail(HttpServletRequest request, HttpServletResponse response 
					,@RequestBody TStoreInfo storeInfo) {
				ResponseModel result = new ResponseModel();
				try {
					TStoreInfo model = operationStoreService.selectStoreInfoDetail(storeInfo);
					ObjectMapper mapper = new ObjectMapper();
					String strParcelInfo = mapper.writeValueAsString(model);
					result.setCode("0000");
					result.setResult(strParcelInfo);
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
	// end region
	
	//저장 수정 삭제.
	@RequestMapping(value = "/save/storeInfo.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
			@ResponseBody
			public ResponseModel savaStoreInfo(HttpServletRequest request, HttpServletResponse response 
					,@RequestBody TStoreInfo storeInfo) {
				ResponseModel result = new ResponseModel();
				try {
					operationStoreService.insertStoreInfo(storeInfo);
				} catch (Exception e) {
					e.printStackTrace();
				}
				return result;
			}
	
	
	
	@PostMapping(value = { "/map/placeApi" })
	@ResponseBody 
	public String main_map(
							  HttpServletRequest request
						    , HttpServletResponse response
						    , @RequestBody Map<String, Object> param
						  ) {
		String addr = (String) param.get("addr");
		String result = mapController.getMapXY(addr);
		return result;
	}
	
}
