package kr.co.infovine.dkmm.controller.marketing;

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
import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.marketing.TMarketingAnalysis;
import kr.co.infovine.dkmm.service.common.CommonCodeService;
import kr.co.infovine.dkmm.service.marketing.MarketingService;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(value = "/marketing")
public class MarketingController {
	@Autowired
	MarketingService marketingService;
	
	@RequestMapping(value ="/InflowStatistics.do")
	public ModelAndView InflowStatistics(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("marketing/InflowStatistics");
		model.addObject("leftPageUrl", "marketing/InflowStatistics");
		return model;
	}
	
	@RequestMapping(value ="/promotion.do")
	public ModelAndView promotion(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("marketing/promotion");
		model.addObject("leftPageUrl", "marketing/promotion");
		return model;
	}
	
	
	@RequestMapping(value="/select/marketingMonthly.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectMarketingChart1(HttpServletRequest request, HttpServletResponse response, HttpSession session
			,@RequestBody TMarketingAnalysis maketingAnalysis) {
		ResponseModel result = new ResponseModel();
		
		List<TMarketingAnalysis> resultSet = marketingService.marketingMonthly(maketingAnalysis);
		
		try {
			ObjectMapper mapper = new ObjectMapper();
			String marketingMonth = mapper.writeValueAsString(resultSet);
			result.setResult(marketingMonth);
			result.setCode("0000");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	@RequestMapping(value="/select/marketingweekly.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectMarketingChart2(HttpServletRequest request, HttpServletResponse response, HttpSession session
			,@RequestBody TMarketingAnalysis maketingAnalysis) {
		ResponseModel result = new ResponseModel();
		
		List<TMarketingAnalysis> resultSet = marketingService.marketingWeekly(maketingAnalysis);
		
		try {
			ObjectMapper mapper = new ObjectMapper();
			String marketingWeek = mapper.writeValueAsString(resultSet);
			result.setResult(marketingWeek);
			result.setCode("0000");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
