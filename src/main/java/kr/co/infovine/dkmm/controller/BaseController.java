package kr.co.infovine.dkmm.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.servlet.ModelAndView;

import org.codehaus.jettison.json.JSONObject;
import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.service.store.StoreMetaBatchService;
import lombok.extern.slf4j.Slf4j;
import reactor.netty.http.client.HttpClient;

@Slf4j
@Controller
public class BaseController {
	
	@Autowired
	StoreMetaBatchService storeMetaBatchService;
	
	@Autowired
	HttpClient httpClient;
	
	@Value("${url.server.api}")
	String urlServerApi;
	
	
	@RequestMapping(value="/error.do")
	public ModelAndView error(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("error");
		return model;
	}
	
	@RequestMapping(value="/main/page.do")
	public ModelAndView mainPage(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("main/page");
		return model;
	}
	
	@RequestMapping(value = "/favicon.ico", method = RequestMethod.GET)
	public void favicon( HttpServletRequest request, HttpServletResponse reponse ) {
		try {
			reponse.sendRedirect("/assets/images/favicon.ico");
		} catch (IOException e) {
		}
	}
	
	
	@RequestMapping(value="/baseInfo.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel baseInfo(HttpServletRequest request, HttpServletResponse response
			, @RequestBody String admin) {
		ResponseModel result = new ResponseModel();
		try {
			JSONObject requestJson = new JSONObject();
			requestJson.put("admin", "kdh");
	
			WebClient requestApi = WebClient.builder()
			      .clientConnector(new ReactorClientHttpConnector(httpClient))
			      .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
			      .build();
	
	
			String resultLoadBalancer = requestApi.post()
			      .uri(urlServerApi + "/baseinfo.do")
			      .accept(MediaType.APPLICATION_JSON)
			      .body(BodyInserters.fromValue(requestJson.toString()))
			      .retrieve()
			      .bodyToMono(String.class).block();
		
			result.setCode("0000");
			result.setResult(resultLoadBalancer);
		}
		catch (Exception e) {
			log.error(e.getMessage());
		}
		return result;
	}
	
	
	@RequestMapping(value="/session.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel checkSession(HttpServletRequest request, HttpServletResponse response) {
		ResponseModel result = new ResponseModel();
		try {
			HttpSession session = request.getSession();
			Object obj = session.getAttribute("userInfo");
			if(obj != null) {
//				Calendar calendar = Calendar.getInstance(Locale.KOREA);
//				calendar.setTimeInMillis(session.getCreationTime());
//				int min = calendar.get(Calendar.MINUTE);
//				int sec = calendar.get(Calendar.SECOND);
//				log.info("min : " + min + ", sec : " + sec);
//				JSONObject json = new JSONObject();
//				json.put("min", min);
//				json.put("sec", sec);
				
				result.setCode("0000");
//				result.setResult(json.toString());
			}
			else {
				result.setCode("0001");
			}
		}
		catch (Exception e) {
		}
		return result;
	}
	
	@RequestMapping(value="/batchStoreOrg.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel batchStoreOrg(HttpServletRequest request, HttpServletResponse response
			, @RequestBody String admin
		) {
		
		ResponseModel result = new ResponseModel();
		try {
			JSONObject json = new JSONObject(admin);
			String str = json.getString("admin");
			if(str.equals("kdh")) {
//				storeMetaBatchService.batchStoreInfoTest();
				storeMetaBatchService.batchStoreInfo("WEB");
				result.setCode("0000");
			}
		}
		catch (Exception e) {
			result.setCode("0001");
		}
		return result;
	}
	
	@RequestMapping(value="/batchStoreCoordinates.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel batchStoreCoordinates(HttpServletRequest request, HttpServletResponse response
			, @RequestBody String admin
		) {
		
		ResponseModel result = new ResponseModel();
		try {
			JSONObject json = new JSONObject(admin);
			String str = json.getString("admin");
			if(str.equals("kdh")) {
//				storeMetaBatchService.getCoordinatesToStoreInfoTest();
				storeMetaBatchService.getCoordinatesToStoreInfo("WEB");
				result.setCode("0000");
			}
		}
		catch (Exception e) {
			result.setCode("0001");
		}
		return result;
	}
	
	@RequestMapping(value="/batchStoreOrgBulkInsert.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel batchStoreOrgBulkInsert(HttpServletRequest request, HttpServletResponse response
			, @RequestBody String admin
		) {
		
		ResponseModel result = new ResponseModel();
		try {
			JSONObject json = new JSONObject(admin);
			String str = json.getString("admin");
			if(str.equals("kdh")) {
//				storeMetaBatchService.batchStoreOrgPstmtInsert();
//				storeMetaBatchService.batchStoreOrgBulkInsert();
				storeMetaBatchService.batchStoreOrgBulkInsertToExcelStreaming("WEB");
				result.setCode("0000");
			}
		}
		catch (Exception e) {
			result.setCode("0001");
		}
		return result;
	}
	
	@RequestMapping("/filedownloadWebLink.do")
	public void fileDownloadOnWebBroweser(HttpServletRequest req, HttpServletResponse res) throws Exception  {
		
		String fName = req.getParameter("fName");
		
		File f = new File(req.getServletContext().getRealPath( File.separator + "upload" + File.separator + "doc") + File.separator + fName);

		String downloadName = null;
		String browser = req.getHeader("User-Agent");
		//파일 인코딩
		if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")){
		  //브라우저 확인 파일명 encode  		             
		  downloadName = URLEncoder.encode(f.getName(), "UTF-8").replaceAll("\\+", "%20");		             
		}else{		             
		  downloadName = new String(f.getName().getBytes("UTF-8"), "ISO-8859-1");
		}        
		res.setHeader("Content-Disposition", "attachment;filename=\"" + downloadName +"\"");             
		res.setContentType("application/octer-stream");
		res.setHeader("Content-Transfer-Encoding", "binary;");

		try {
			FileInputStream fis = new FileInputStream(f);
			ServletOutputStream sos = res.getOutputStream();	
	
			byte[] b = new byte[1024];
			int data = 0;

			while((data=(fis.read(b, 0, b.length))) != -1){		             
				sos.write(b, 0, data);		             
			}

			sos.flush();
		} catch(Exception e) {
			throw e;
		}
	}

	// region 설명: 로드벨런싱 체크
	/**
	 * 2022-12-26 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/checkHealth.do", method = RequestMethod.GET
			, produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel checkHealth(HttpServletRequest request, HttpServletResponse response) {
		ResponseModel result = new ResponseModel();
		try {
			result.setCode("0000");
		}
		catch (Exception e) {
			result.setCode("0001");
		}
		return result;
	}
	// end region
}
