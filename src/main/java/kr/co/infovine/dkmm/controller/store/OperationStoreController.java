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
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
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
	public ModelAndView storeInfo(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("operation/store");
		model.addObject("leftPageUrl", "store/store");
		TStoreInfoModel storeInfo = new TStoreInfoModel();
		model.addObject("storeCount", operationStoreService.selectStoreCount(storeInfo) );
		return model;
	}

	@RequestMapping(value = "/select/storeInfo.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectRealestateParcelInfo(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TStoreInfoModel storeInfo) {
		ResponseModel result = new ResponseModel();
		try {
			List<TStoreInfoModel> model = operationStoreService.selectStoreInfo(storeInfo);
			ObjectMapper mapper = new ObjectMapper();
			String storeInfoList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(storeInfoList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/storeInfoDetail.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
			@ResponseBody
			public ResponseModel selectRealestateParcelInfoDetail(HttpServletRequest request, HttpServletResponse response 
					,@RequestBody TStoreInfoModel storeInfo) {
				ResponseModel result = new ResponseModel();
				try {
					TStoreInfoModel model = operationStoreService.selectStoreInfoDetail(storeInfo);
					ObjectMapper mapper = new ObjectMapper();
					String storeInfoDetail = mapper.writeValueAsString(model);
					result.setCode("0000");
					result.setResult(storeInfoDetail);
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
					,@RequestBody TStoreInfoModel storeInfo) {
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
	
	
	@RequestMapping(value = "/select/selectStoreExcel.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectStoreExcel(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TStoreInfoModel storeInfo) {
		ResponseModel result = new ResponseModel();
		try {
			List<TStoreInfoModel> model = operationStoreService.selectStoreExcel(storeInfo);
			ObjectMapper mapper = new ObjectMapper();
			String storeInfoList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(storeInfoList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/select/selectStoreCatgryList.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8")
	@ResponseBody
	public ResponseModel selectStoreCatgryList(HttpServletRequest request, HttpServletResponse response 
			,@RequestBody TStoreInfoModel storeInfo) {
		ResponseModel result = new ResponseModel();
		try {
			List<TStoreInfoModel> model = operationStoreService.selectStoreCatgryList();
			ObjectMapper mapper = new ObjectMapper();
			String storeInfoList = mapper.writeValueAsString(model);
			result.setCode("0000");
			result.setResult(storeInfoList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
}
