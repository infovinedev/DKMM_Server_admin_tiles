package kr.co.infovine.dkmm.controller.common;

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

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.service.common.CommonCodeService;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(value = "/common")
public class CommonController {
	@Autowired
	CommonCodeService commonCodeService;
	
	@RequestMapping(value="/select/serviceCodeList.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectTComonCode(HttpServletRequest request, HttpServletResponse response, HttpSession session
			,@RequestBody TCommonCodeModel tCommonCodeModel) {
		ResponseModel result = new ResponseModel();
		
		List<TCommonCodeModel> resultSet = commonCodeService.selectCommonCode(tCommonCodeModel);
		
		try {
			ObjectMapper mapper = new ObjectMapper();
			String commonCode = mapper.writeValueAsString(resultSet);
			result.setResult(commonCode);
			result.setCode("0000");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
}
