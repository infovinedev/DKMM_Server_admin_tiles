package kr.co.infovine.dkmm.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.Locale;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.util.ContentCachingRequestWrapper;

import kr.co.infovine.dkmm.api.model.base.SessionModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserLogModel;
import kr.co.infovine.dkmm.service.admin.EncryptService;
import kr.co.infovine.dkmm.service.admin.TbAdminService;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class SimpleCORSFilter implements Filter {
	@Autowired
	TbAdminService tbAdminService;
	
	@Autowired
	EncryptService encryptService;
	
	private final String jsonContentType = "application/json";
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
		RereadableRequestWrapper rereadableRequestWrapper = new RereadableRequestWrapper(request);
		trackingAdminLog(rereadableRequestWrapper);
			
		chain.doFilter(rereadableRequestWrapper, res);

	}
	
	protected String readContentType(HttpServletRequest request) {
        String contentType = request.getHeader("Content-Type");
        //log.info("Content Type from request: {}", contentType);

        if (contentType != null && contentType.contains(";")) {
            contentType = contentType.substring(0, contentType.indexOf(";")).trim();
        }
        return contentType;
    }
	
	private boolean trackingAdminLog(HttpServletRequest request) {
		try {
			HttpSession session = request.getSession();
			Object obj = session.getAttribute("userInfo");
			int adminUserSeq = -1;
			String cryptKey = "";
			if(obj != null) {
				SessionModel tempSessionModel = (SessionModel) obj;
				adminUserSeq = tempSessionModel.getAdminUserSeq();
				cryptKey = tempSessionModel.getCryptoAes();
			}
			
			String requestURI = request.getRequestURI();
			int assetsUrl = requestURI.indexOf("assets");
			if(assetsUrl == -1) {
				switch(requestURI) {
					case "/admin/left/menu.do":
					case "/favicon.ico":
					case "/admin/login.do":
					case "/session.do":
						return false;
					default:
						ContentCachingRequestWrapper tempRequest = new ContentCachingRequestWrapper(request);
						String requestContentType = readContentType(tempRequest);
	
						JSONObject json = new JSONObject();
						if (jsonContentType.equalsIgnoreCase(requestContentType)) {
							BufferedReader reader = tempRequest.getReader();
				            StringBuilder jsonString = new StringBuilder();
				            String inputStr;
				            while ((inputStr = reader.readLine()) != null) {
				            	jsonString.append(inputStr);
				            }
				            	//log.info("requestURI : " + requestURI + ", JsonString : " + jsonString.toString());
				            	json = insertJson(cryptKey, jsonString.toString(), request);
			            }
	
						if(adminUserSeq!=-1) {
							JSONObject parameter = new JSONObject();
							Enumeration<String> enumer = request.getParameterNames();
							while(enumer.hasMoreElements()) {
								String key = enumer.nextElement();
								String value = request.getParameter(key);
								//parameter의 password는 따로 저장하지 않는다
								switch(key) {
									case "password":
									case "oldPassword":
									case "newPassword1":
									case "newPassword2":
										parameter.put(key, JSONObject.NULL);
									break;
									default:
										parameter.put(key, value);	
								}
							}
							
							if(parameter.length()!=0) {
								json.put("param", parameter);
							}
							TbAdminUserLogModel adminUserLog = new TbAdminUserLogModel();
							adminUserLog.setAdminUserSeq(adminUserSeq);
							adminUserLog.setRequestUrl(requestURI);
							adminUserLog.setParam(json.toString());
							SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
							Calendar currentTime = Calendar.getInstance(Locale.KOREA);
							String localDate = sdf.format(currentTime.getTime());
							adminUserLog.setRegDate(localDate);
							//tbAdminService.insertAdminUserLog(adminUserLog);
							log.info("requestURI : " + requestURI + ", JsonString : " + json.toString());
						}
				}
			
	//				Enumeration<String> enumeration = request.getAttributeNames();
	//				while(enumeration.hasMoreElements()){
	//			            String attrName = enumeration.nextElement();
	//			            Object attrValue = request.getAttribute(attrName);
	//			            log.info("pool getAttributeNames() : " + attrName + " : " + attrValue);
	//			      }
	//				
	//				Set<String> keySet = request.getParameterMap().keySet();
	//				for(String key: keySet) {
	//					log.info("pool getParameterMap().keySet() : " + key + ": " + request.getParameter(key));
	//				}
	//				
	//				Enumeration<String> names = request.getParameterNames();
	//				while(names.hasMoreElements()) {
	//					String key = (String) names.nextElement();
	//					log.info("pool getParameterNames() : " + key + ": " + request.getParameter(key));
	//				}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return true; 
	}
	
	private JSONObject insertJson(String cryptKey, String jsonString, HttpServletRequest request) {
		JSONObject resultObject = new JSONObject();
		try {
			
    		boolean checkCrypt = false;
			if(jsonString.startsWith("[")) {
    			JSONArray jsonArray = new JSONArray(jsonString);
    			JSONArray insertJsonArray = new JSONArray();
	    		for(int i=0; i<jsonArray.length(); i++) {
	    			JSONObject jsonObject = jsonArray.getJSONObject(i);
	    			
//	    			byte[] iv = null;
	            	if(!jsonObject.isNull("iv")) {
	            		checkCrypt = true;
	            		break;
	            		//iv = getIv(jsonObject.getJSONArray("iv"));
	            	}
//	    			if(!jsonObject.isNull("tel")) {
//	            		String tel = "";
//	            		tel = jsonObject.getString("tel");
//	            		jsonObject.put("tel", encryptService.getAesDecode(tel, cryptKey, iv) );
//	            	}
//	            	if(!jsonObject.isNull("mdn")) {
//	            		String mdn = "";
//	            		mdn = jsonObject.getString("mdn");
//	            		jsonObject.put("mdn", encryptService.getAesDecode(mdn, cryptKey, iv) );
//	            	}
	    			
//	    			insertJsonArray.put(jsonObject);
	    		}
	    		resultObject.put("jsonArray", jsonArray);
	    		if(checkCrypt) {
	    			resultObject.put("cryptKey", cryptKey);
	    		}
	    	}
	    	else {
	        	JSONObject jsonObject = new JSONObject(jsonString);
//	        	byte[] iv = null;
            	if(!jsonObject.isNull("iv")) {
//            		iv = getIv(jsonObject.getJSONArray("iv"));
            		checkCrypt = true;
            	}
            	if(!jsonObject.isNull("promotionWinner")) {
            		checkCrypt = true;
            	}
//	        	if(!jsonObject.isNull("tel")) {
//            		String tel = "";
//            		tel = jsonObject.getString("tel");
//            		jsonObject.put("tel", encryptService.getAesDecode(tel, cryptKey, iv) );
//            	}
//            	if(!jsonObject.isNull("mdn")) {
//            		String mdn = "";
//            		mdn = jsonObject.getString("mdn");
//            		jsonObject.put("mdn", mdn);
//            		jsonObject.put("mdn", encryptService.getAesDecode(mdn, cryptKey, iv) );
//            	}
            	if(!jsonObject.isNull("password")) {
            		jsonObject.put("password", JSONObject.NULL);
            	}
            	if(!jsonObject.isNull("newPassword1")) {
            		jsonObject.put("newPassword1", JSONObject.NULL);
            	}
            	if(!jsonObject.isNull("oldPassword")) {
            		jsonObject.put("newPassword1", JSONObject.NULL);
            	}
            	if(!jsonObject.isNull("newPassword2")) {
            		jsonObject.put("newPassword2", JSONObject.NULL);
            	}
	        	
	        	resultObject.put("jsonObject", jsonObject);
	        	if(checkCrypt) {
	        		resultObject.put("cryptKey", cryptKey);
	        	}
	    	}
	    	
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return resultObject;
	}
	
//	private String decrypt(String mdn) {
//		
//	}
	
	public void init(FilterConfig filterConfig) {
	}

	public void destroy() {
	}

}
