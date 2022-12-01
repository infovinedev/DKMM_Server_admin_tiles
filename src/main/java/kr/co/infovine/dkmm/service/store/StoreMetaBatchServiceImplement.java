package kr.co.infovine.dkmm.service.store;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Random;

import org.apache.ibatis.session.SqlSession;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModelTest;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoOrg;
import kr.co.infovine.dkmm.mapper.common.TCommonCodeMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoOrgMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoTestMapper;
import kr.co.infovine.dkmm.util.ExcelSheetHandler;
import lombok.extern.slf4j.Slf4j;
import reactor.netty.http.client.HttpClient;

@Service
@Slf4j
public class StoreMetaBatchServiceImplement implements StoreMetaBatchService{
	private final String TYPE_SUCCESS_IN_API_VWORLD = "OK";
	
	@Value("${vworld.api.domain}")
	private String domainVWorld;

	@Value("${vworld.api.key}")
	private String keyVWorld;

	@Value("${vworld.api.url}")
	private String urlVWorld;

	@Value("${vworld.api.version}")
	private String versionVWorld;

	@Value("${vworld.api.crs}")
	private String crsVWorld;
	
	@Value("${spring.datasource.hikari.driver-class-name}")
	private String driverClass;
	
	@Value("${spring.datasource.hikari.jdbc-url}")
	private String jdbcUrl;
	
	@Value("${spring.datasource.hikari.username}")
	private String username;
	
	@Value("${spring.datasource.hikari.password}")
	private String dbpass;
	
	@Value("${server.store.excel.directory}")
	private String storeExcelDir;
	
	@Value("${server.store.excel.backup.directory}")
	private String storeExcelBackDir;
	
	
	@Autowired
	HttpClient httpClient;
	
	@Autowired
	TStoreInfoMapper tStoreInfoMapper;
	
	@Autowired
	TStoreInfoTestMapper tStoreInfoTestMapper;
	
	@Autowired
	TStoreInfoOrgMapper tStoreInfoOrgMapper;
	
	@Autowired
	TCommonCodeMapper tCommonCodeMapper;
	
	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	private DataSourceTransactionManager transactionManager;
	
	@Override
	public void batchStoreInfo() {
		
		long start = System.currentTimeMillis();
		
		log.info("===================================================================================");
        log.info("================= StoreMetaBatchServiceImpl.batchStoreInfo START===================");
        log.info("START TIME : {}", start);
        log.info("===================================================================================");
        log.info("	::::::: STEP 0 - STOR_ORG PROCESS_YN : 'N' COUNT  ===============================");
        
        int procCnt = tStoreInfoOrgMapper.selectProcCount();
        
        if ( procCnt == 0 ) {
        	log.info("============================== RESULT TOTAL ======================================");
            log.info(" :::::: T_STORE_INFO_ORG - PROCESS DATA COUNT : " + procCnt );
            log.info(" :::::: BATCH PROCESS END" );
            log.info(" :::::: ALL STEP PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
            log.info("==================================================================================");
        	return;
        }
        
        log.info("===================================================================================");
        log.info("	::::::: STEP 1 - MERGE T_STORE_INFO =============================================");
        
        int mergeCount = this.mergeStoreInfo();
        
        log.info("	>>>>>> STEP 1 MERGE RESULT_COUNT : " + mergeCount);
        log.info("	>>>>>> STEP 1 PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초");
        
        log.info("==================================================================================");
        log.info("	::::::: STEP 2 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 01 ==================");
        
        int updOrgStat01 = this.updateStoreOrgStatus01();
        
        log.info("	>>>>>> STEP 2 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 01 RESULT_COUNT : " + updOrgStat01);
        log.info("	>>>>>> STEP 2 PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
        
        
        log.info("==================================================================================");
        log.info("	::::::: STEP 3 - UPDATE CLOSE T_STORE_INFO ===================================");
        
        int updCloseStore = this.updateCloseStoreInfo();
        
        log.info("	>>>>>> STEP 3 - UPDATE CLOSE RESULT_COUNT : " + updCloseStore);
        log.info("	>>>>>> STEP 3 PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
        
        log.info("==================================================================================");
        log.info("	::::::: STEP 4 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 02 ==================");
        
        int updOrgStat02 = this.updateStoreOrgStatus02();
        
        log.info("	>>>>>> STEP 4 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 02 RESULT_COUNT : " + updOrgStat02);
        log.info("	>>>>>> STEP 4 PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
        
        log.info("==================================================================================");
        log.info("============================== RESULT TOTAL ======================================");
        log.info(" :::::: T_STORE_INFO - MERGE COUNT : " + mergeCount );
        log.info(" :::::: T_STORE_INFO - CLOSE UPDATE COUNT : " + updCloseStore );
        log.info(" :::::: T_STORE_INFO - TOTAL EXECUTE COUNT : " + ( mergeCount + updCloseStore) );
        log.info("");
        log.info(" :::::: T_STORE_INFO_ORG - TOTAL EXECUTE COUNT : " + (updOrgStat01 + updOrgStat02) );
        log.info(" :::::: ALL STEP PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
        log.info("==================================================================================");
		
	}
	
	@Override
	public void batchStoreInfoTest() {
		
		long start = System.currentTimeMillis();
		
		log.info("===================================================================================");
        log.info("================= StoreMetaBatchServiceImpl.batchStoreInfo START===================");
        log.info("START TIME : {}", start);
        log.info("===================================================================================");
        log.info("	::::::: STEP 0 - STOR_ORG PROCESS_YN : 'N' COUNT  ===============================");
        
        int procCnt = tStoreInfoOrgMapper.selectProcCount();
        
        if ( procCnt == 0 ) {
        	log.info("============================== RESULT TOTAL ======================================");
            log.info(" :::::: T_STORE_INFO_ORG - PROCESS DATA COUNT : " + procCnt );
            log.info(" :::::: BATCH PROCESS END" );
            log.info(" :::::: ALL STEP PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
            log.info("==================================================================================");
        	return;
        }
        
        log.info("===================================================================================");
        log.info("	::::::: STEP 1 - MERGE T_STORE_INFO =============================================");
        
        int mergeCount = this.mergeStoreInfoTest();
        
        log.info("	>>>>>> STEP 1 MERGE RESULT_COUNT : " + mergeCount);
        log.info("	>>>>>> STEP 1 PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초");
        
        log.info("==================================================================================");
        log.info("	::::::: STEP 2 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 01 ==================");
        
        int updOrgStat01 = this.updateStoreOrgStatus01();
        
        log.info("	>>>>>> STEP 2 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 01 RESULT_COUNT : " + updOrgStat01);
        log.info("	>>>>>> STEP 2 PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
        
        
        log.info("==================================================================================");
        log.info("	::::::: STEP 3 - UPDATE CLOSE T_STORE_INFO ===================================");
        
        int updCloseStore = this.updateCloseStoreInfoTest();
        
        log.info("	>>>>>> STEP 3 - UPDATE CLOSE RESULT_COUNT : " + updCloseStore);
        log.info("	>>>>>> STEP 3 PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
        
        log.info("==================================================================================");
        log.info("	::::::: STEP 4 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 02 ==================");
        
        int updOrgStat02 = this.updateStoreOrgStatus02();
        
        log.info("	>>>>>> STEP 4 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 02 RESULT_COUNT : " + updOrgStat02);
        log.info("	>>>>>> STEP 4 PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
        
        log.info("==================================================================================");
        log.info("============================== RESULT TOTAL ======================================");
        log.info(" :::::: T_STORE_INFO - MERGE COUNT : " + mergeCount );
        log.info(" :::::: T_STORE_INFO - CLOSE UPDATE COUNT : " + updCloseStore );
        log.info(" :::::: T_STORE_INFO - TOTAL EXECUTE COUNT : " + ( mergeCount + updCloseStore) );
        log.info("");
        log.info(" :::::: T_STORE_INFO_ORG - TOTAL EXECUTE COUNT : " + (updOrgStat01 + updOrgStat02) );
        log.info(" :::::: ALL STEP PROC TIME : " + ( System.currentTimeMillis() - start)/1000  + "초" );
        log.info("==================================================================================");
		
	}
	
	/* STORE_INFO 정보 update  */
	@Override
	public int mergeStoreInfo() {
		return tStoreInfoTestMapper.mergeStoreInfo();
	}
	
	/* STORE_INFO 정보 update  */
	@Override
	public int mergeStoreInfoTest() {
		return tStoreInfoTestMapper.mergeStoreInfo();
	}
	
	/* STORE_ORG 영업중 상점 process_yn update  */
	@Override
	public int updateStoreOrgStatus01() {
		return tStoreInfoOrgMapper.updateStoreOrgStatus01();
	}
	
	/* STORE_INFO 폐업 상점 update  */
	@Override
	public int updateCloseStoreInfo() {
		return tStoreInfoMapper.updateCloseStoreInfo();
	}
	
	/* STORE_INFO 폐업 상점 update  */
	@Override
	public int updateCloseStoreInfoTest() {
		return tStoreInfoTestMapper.updateCloseStoreInfo();
	}
	
	/* STORE_ORG 폐업 상점 process_yn update  */
	@Override
	public int updateStoreOrgStatus02() {
		return tStoreInfoOrgMapper.updateStoreOrgStatus02();
	}

	// region 설명: 주소 없는 녀석들(roadaddress)
	/**
	 * 2022-10-12 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@Override
	public void getCoordinatesToStoreInfo() {
		try {
			
			List<TCommonCodeModel> tCodeArray = tCommonCodeMapper.selectByCodeGroup("vworld");
			int usableUsageDay = -1;
			Date dateUsageDay = null;
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			Calendar currentTime = Calendar.getInstance(Locale.KOREA);
			Date dtCurrentTime = currentTime.getTime();
			
			for (TCommonCodeModel code : tCodeArray) {
				String codeValue = code.getCodeValue();
				if(codeValue.equals("day")){
					String description = code.getCodeDescription();
					if(description!=null) {
						usableUsageDay = Integer.valueOf(description);
					}
					dateUsageDay = code.getInsDt();
				}
			}
			int currentDay = currentTime.get(Calendar.DATE);
			
			
			Calendar calUsageDay = Calendar.getInstance();
			calUsageDay.setTime(dateUsageDay);
			int usageDay = calUsageDay.get(Calendar.DATE);
			
			if(usageDay!=currentDay) {
				log.info("날짜가 오늘 돌릴 수 있는 갯수를 240000개로 초기화 해야됨");
				TCommonCodeModel codeModel = new TCommonCodeModel();
				codeModel.setCodeGroup("vworld");
				codeModel.setCodeValue("day");
				codeModel.setCodeDescription(Integer.toString(240000));
				codeModel.setInsDt(currentTime.getTime());
				int tempResultInt = tCommonCodeMapper.updateByDescriptionAndInsDt(codeModel);
				
				if(tempResultInt>0) {
					usableUsageDay = 240000;
				}
			}
			else {
				log.info("등록된 일과 오늘 일이 동일할 경우");
			}
			
			int tempRemainDay = usableUsageDay;
			String nextPageToken = "";
			
			if(usableUsageDay>0) {
				long procStartTime = System.currentTimeMillis();
				log.info("===================================================================================");
		        log.info("================= StoreMetaBatchServiceImpl.getCoordinatesToStoreInfoTest START===================");
		        log.info("START TIME : {}", procStartTime);
		        log.info("===================================================================================");
		        log.info("	::::::: STEP 0 - STORE NON EXIST Latitude Data Search  ==========================");
				
				List<TStoreInfoModel> notExistAddress = tStoreInfoMapper.selectNonExistLatitude();
				
				log.info("	>>>>>> STEP 0 - Data COUNT : " + notExistAddress.size());
		        log.info("	>>>>>> STEP 0 PROC TIME : " + ( System.currentTimeMillis() - procStartTime)/1000  + "초" );
		        
		        if ( notExistAddress.size() > 0 ) {
		        	log.info("===================================================================================");
			        log.info("	::::::: STEP 1 - Search Vworld  =================================================");
		        }
		        
				int i =0; 
				for(TStoreInfoModel info : notExistAddress) {
					
					try {
						// 빠른속도로 api 호출 하면 오류값을 전송함
						double start = 200; //150
						double end = 300;
						double random = new Random().nextDouble();
						MultiValueMap<String, String> builder = new LinkedMultiValueMap<>();
						builder.add("service", "address");
						builder.add("request", "getcoord");
						builder.add("version", versionVWorld);
						builder.add("crs", crsVWorld);
						String tempRoadAddr = info.getRoadAddr();
						builder.add("address", tempRoadAddr);
						builder.add("refine", "true");
						builder.add("format", "json");
						builder.add("type", "road");
						builder.add("key", keyVWorld);
						
						WebClient requestApiOfVworld = WebClient.builder()
								.clientConnector(new ReactorClientHttpConnector(httpClient))
								.defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
								.build();
						
						
						String resultApiOfVworld = requestApiOfVworld.post()
								.uri(domainVWorld + urlVWorld)
								.accept(MediaType.APPLICATION_JSON)
								.body(BodyInserters.fromFormData(builder))
								.retrieve()
								.bodyToMono(String.class).block();
						//http://api.vworld.kr/req/address?service=address&request=getcoord&version=2.0&crs=epsg:4326&address=%ED%9A%A8%EB%A0%B9%EB%A1%9C72%EA%B8%B8%2060&refine=true&simple=false&format=xml&type=road&key=[KEY]
						
						JSONObject resultVworldJson = new JSONObject(resultApiOfVworld);
						
						if(!resultVworldJson.isNull("response")) {
							JSONObject responseJson = resultVworldJson.getJSONObject("response");
							
							if(!responseJson.isNull("status")) {
								String status = responseJson.getString("status");
								if(status.equals(TYPE_SUCCESS_IN_API_VWORLD)) {
									String latitude = null;
									String longitude = null;
									String roadAddrLevel1 = null;
									String roadAddrLevel2 = null;
									String roadAddrLevel3 = null;
									String roadAddrLevel4 = null;
									String roadAddrLevel5 = null;
									String roadAddrLevel6 = null;
									
									if(!responseJson.isNull("result")) {
										JSONObject resultJson = responseJson.getJSONObject("result");
										if(!resultJson.isNull("point")) {
											JSONObject pointJson = resultJson.getJSONObject("point");
											if(!pointJson.isNull("x")) {
												longitude = pointJson.getString("x");
											}
											
											if(!pointJson.isNull("y")) {
												latitude = pointJson.getString("y");
											}
										}
										
										if(!responseJson.isNull("refined")) {
											JSONObject refinedJson = responseJson.getJSONObject("refined");
											
											if(!refinedJson.isNull("structure")) {
												JSONObject structureJson = refinedJson.getJSONObject("structure");
												
												roadAddrLevel1 = structureJson.getString("level1");
												roadAddrLevel2 = structureJson.getString("level2");
												roadAddrLevel3 = structureJson.getString("level3");
												roadAddrLevel4 = structureJson.getString("level4L");
												roadAddrLevel5 = structureJson.getString("level5");
												roadAddrLevel6 = structureJson.getString("detail");
											}
										}
									}
									info.setLatitude(latitude);
									info.setLongitude(longitude);
									info.setRoadAddrDetail1(roadAddrLevel1);
									info.setRoadAddrDetail2(roadAddrLevel2);
									info.setRoadAddrDetail3(roadAddrLevel3);
									info.setRoadAddrDetail4(roadAddrLevel4);
									info.setRoadAddrDetail5(roadAddrLevel5);
									info.setRoadAddrDetail6(roadAddrLevel6);
									// TODO : 업데이트 쿼리 작성
									int a = tStoreInfoMapper.updateRoadAddrByPrimaryKey(info);
								}
							}
							else{
								//result.setCode("0001");
							}
						}
						int sleep = (int) (start + (random * (end - start)));
						Thread.sleep(sleep);
						
						if ( i%1000 == 0 ) {
							log.info("	>>>>>> STEP 1 - PROC COUNT : " + i + "건 진행중");
							log.info("	>>>>>> STEP 1 - PROC TIME : " + ( System.currentTimeMillis() - procStartTime)/1000  + "초" );
						}
						
						i++;
						tempRemainDay--;
						log.info("tempRemainDay : " + tempRemainDay);
						
					} catch (Exception e) {
						e.printStackTrace();
						continue;
					}
					
					if(tempRemainDay==0) {
						break;
					}
				}
				log.info("	>>>>>> STEP 1 - Total PROC COUNT : " + i + "건 완료");
				log.info("	>>>>>> STEP 1 - Total PROC TIME : " + ( System.currentTimeMillis() - procStartTime)/1000  + "초" );
			}
			else {
				log.info("===================================================================================");
		        log.info("========= StoreMetaBatchServiceImpl.getCoordinatesToStoreInfoTest START Fail=======");
		        log.info("    :::::: usableUsageDay =" + usableUsageDay);
		        log.info("===================================================================================");
			}
			
			TCommonCodeModel codeModel = new TCommonCodeModel();
			codeModel.setCodeGroup("vworld");
			codeModel.setCodeValue("day");
			codeModel.setCodeDescription(Integer.toString(tempRemainDay));

			int tempResultDay = tCommonCodeMapper.updateByDescriptionAndInsDt(codeModel);
		}
		catch (Exception e) {
			//result.setCode("0001");
			log.error("");
			log.error(" =================== getCoordinatesToStoreInfo ERROR================== ");
			e.printStackTrace();
			log.error(" ===================================================================== ");
			log.error("");
			
		}
		
	}
	//end region
	
	
	
	// region 설명: 주소 없는 녀석들(roadaddress) - 테스트 테이블
	@Override
	public void getCoordinatesToStoreInfoTest() {
		
//		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
//		def.setName("Coordinates-transaction");
//		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
//		
//		TransactionStatus tranStatus = transactionManager.getTransaction(def);
		
		try {
			
			List<TCommonCodeModel> tCodeArray = tCommonCodeMapper.selectByCodeGroup("vworld");
			int usableUsageDay = -1;
			Date dateUsageDay = null;
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			Calendar currentTime = Calendar.getInstance(Locale.KOREA);
			Date dtCurrentTime = currentTime.getTime();
			
			for (TCommonCodeModel code : tCodeArray) {
				String codeValue = code.getCodeValue();
				if(codeValue.equals("day")){
					String description = code.getCodeDescription();
					if(description!=null) {
						usableUsageDay = Integer.valueOf(description);
					}
					dateUsageDay = code.getInsDt();
				}
			}
			int currentDay = currentTime.get(Calendar.DATE);
			
			
			Calendar calUsageDay = Calendar.getInstance();
			calUsageDay.setTime(dateUsageDay);
			int usageDay = calUsageDay.get(Calendar.DATE);
			
			if(usageDay!=currentDay) {
				log.info("날짜가 오늘 돌릴 수 있는 갯수를 240000개로 초기화 해야됨");
				TCommonCodeModel codeModel = new TCommonCodeModel();
				codeModel.setCodeGroup("vworld");
				codeModel.setCodeValue("day");
				codeModel.setCodeDescription(Integer.toString(240000));
				codeModel.setInsDt(currentTime.getTime());
				int tempResultInt = tCommonCodeMapper.updateByDescriptionAndInsDt(codeModel);
				
				if(tempResultInt>0) {
					usableUsageDay = 240000;
				}
			}
			else {
				log.info("등록된 일과 오늘 일이 동일할 경우");
			}
			
			int tempRemainDay = usableUsageDay;
			String nextPageToken = "";
			
			if(usableUsageDay>0) {
				
				long procStartTime = System.currentTimeMillis();
				log.info("===================================================================================");
		        log.info("================= StoreMetaBatchServiceImpl.getCoordinatesToStoreInfoTest START====");
		        log.info("START TIME : {}", procStartTime);
		        log.info("===================================================================================");
		        log.info("	::::::: STEP 0 - STORE NON EXIST Latitude Data Search  ==========================");
				
				List<TStoreInfoModelTest> notExistAddress = tStoreInfoTestMapper.selectNonExistLatitude();
				
				log.info("	>>>>>> STEP 0 - Data COUNT : " + notExistAddress.size());
		        log.info("	>>>>>> STEP 0 PROC TIME : " + ( System.currentTimeMillis() - procStartTime)/1000  + "초" );
		        
		        if ( notExistAddress.size() > 0 ) {
		        	log.info("===================================================================================");
			        log.info("	::::::: STEP 1 - Search Vworld  =================================================");
		        }
		        
				int i =0; 
				for(TStoreInfoModelTest info : notExistAddress) {
					
					try {
						
						// 빠른속도로 api 호출 하면 오류값을 전송함
						double start = 200; //150
						double end = 300;
						double random = new Random().nextDouble();
						MultiValueMap<String, String> builder = new LinkedMultiValueMap<>();
						builder.add("service", "address");
						builder.add("request", "getcoord");
						builder.add("version", versionVWorld);
						builder.add("crs", crsVWorld);
						String tempRoadAddr = info.getRoadAddr();
						builder.add("address", tempRoadAddr);
						builder.add("refine", "true");
						builder.add("format", "json");
						builder.add("type", "road");
						builder.add("key", keyVWorld);
						
						WebClient requestApiOfVworld = WebClient.builder()
								.clientConnector(new ReactorClientHttpConnector(httpClient))
								.defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
								.build();
						
						
						String resultApiOfVworld = requestApiOfVworld.post()
								.uri(domainVWorld + urlVWorld)
								.accept(MediaType.APPLICATION_JSON)
								.body(BodyInserters.fromFormData(builder))
								.retrieve()
								.bodyToMono(String.class).block();
						//http://api.vworld.kr/req/address?service=address&request=getcoord&version=2.0&crs=epsg:4326&address=%ED%9A%A8%EB%A0%B9%EB%A1%9C72%EA%B8%B8%2060&refine=true&simple=false&format=xml&type=road&key=[KEY]
						
						JSONObject resultVworldJson = new JSONObject(resultApiOfVworld);
						
						if(!resultVworldJson.isNull("response")) {
							JSONObject responseJson = resultVworldJson.getJSONObject("response");
							
							if(!responseJson.isNull("status")) {
								String status = responseJson.getString("status");
								if(status.equals(TYPE_SUCCESS_IN_API_VWORLD)) {
									String latitude = null;
									String longitude = null;
									String roadAddrLevel1 = null;
									String roadAddrLevel2 = null;
									String roadAddrLevel3 = null;
									String roadAddrLevel4 = null;
									String roadAddrLevel5 = null;
									String roadAddrLevel6 = null;
									
									if(!responseJson.isNull("result")) {
										JSONObject resultJson = responseJson.getJSONObject("result");
										if(!resultJson.isNull("point")) {
											JSONObject pointJson = resultJson.getJSONObject("point");
											if(!pointJson.isNull("x")) {
												longitude = pointJson.getString("x");
											}
											
											if(!pointJson.isNull("y")) {
												latitude = pointJson.getString("y");
											}
										}
										
										if(!responseJson.isNull("refined")) {
											JSONObject refinedJson = responseJson.getJSONObject("refined");
											
											if(!refinedJson.isNull("structure")) {
												JSONObject structureJson = refinedJson.getJSONObject("structure");
												
												roadAddrLevel1 = structureJson.getString("level1");
												roadAddrLevel2 = structureJson.getString("level2");
												roadAddrLevel3 = structureJson.getString("level3");
												roadAddrLevel4 = structureJson.getString("level4L");
												roadAddrLevel5 = structureJson.getString("level5");
												roadAddrLevel6 = structureJson.getString("detail");
											}
										}
									}
									info.setLatitude(latitude);
									info.setLongitude(longitude);
									info.setRoadAddrDetail1(roadAddrLevel1);
									info.setRoadAddrDetail2(roadAddrLevel2);
									info.setRoadAddrDetail3(roadAddrLevel3);
									info.setRoadAddrDetail4(roadAddrLevel4);
									info.setRoadAddrDetail5(roadAddrLevel5);
									info.setRoadAddrDetail6(roadAddrLevel6);
									// TODO : 업데이트 쿼리 작성
									int a = tStoreInfoTestMapper.updateRoadAddrByPrimaryKey(info);
								}
							}
							else{
								//result.setCode("0001");
							}
						}
						int sleep = (int) (start + (random * (end - start)));
						Thread.sleep(sleep);
						
						if ( i != 0 && i%100 == 0 ) {
							//천건에 한번씩 Commit 처리
//							transactionManager.commit(tranStatus);
							
							log.info("	>>>>>> STEP 1 - PROC COUNT : " + i + "건 진행중");
							log.info("	>>>>>> STEP 1 - PROC TIME : " + ( System.currentTimeMillis() - procStartTime)/1000  + "초" );
						}
						
						i++;
						tempRemainDay--;
						
					} catch (Exception e) {
						e.printStackTrace();
						continue;
					}
					
					log.info("tempRemainDay : " + tempRemainDay);
					if(tempRemainDay==0) {
						break;
					}
					
				}
				
				log.info("	>>>>>> STEP 1 - Total PROC COUNT : " + i + "건 완료");
				log.info("	>>>>>> STEP 1 - Total PROC TIME : " + ( System.currentTimeMillis() - procStartTime)/1000  + "초" );
			}
			else {
				log.info("===================================================================================");
		        log.info("========= StoreMetaBatchServiceImpl.getCoordinatesToStoreInfoTest START Fail=======");
		        log.info("    :::::: usableUsageDay =" + usableUsageDay);
		        log.info("===================================================================================");
			}
			
			TCommonCodeModel codeModel = new TCommonCodeModel();
			codeModel.setCodeGroup("vworld");
			codeModel.setCodeValue("day");
			codeModel.setCodeDescription(Integer.toString(tempRemainDay));
			
			int tempResultDay = tCommonCodeMapper.updateByDescriptionAndInsDt(codeModel);
		}
		catch (Exception e) {
			//result.setCode("0001");
			log.error("");
			log.error(" =================== getCoordinatesToStoreInfo ERROR================== ");
			e.printStackTrace();
			log.error(" ===================================================================== ");
			log.error("");
			
		}
	}
	
	
	@Override
	public void batchStoreOrgBulkInsert() {
		
		log.info( "==========  batchStoreOrgBulkInsert : STORE META DATA Bulk INSERT - MyBatis =============" );
		
//		storeExcelDir = "D:\\excel";
		
		try {
			
			log.info( "Store Meta Excel File Location  : " + storeExcelDir );
			
			File dir = new File(storeExcelDir);
		    File files[] = dir.listFiles();
			
		    log.info( " :::::::: 처리 파일 건수 : " + files.length );
			
		    if ( files.length == 0 ) return;
			
		    long start = System.currentTimeMillis();
		    
		    //Step1 - 엑셀 Data 불러오기
			// - 엑셀 파일은 여러개일수 있으며 시작시 디렉토리의 파일 명을 Array - For 문을 이용하여 Loop
		    int totalCount = 0;
		    
			for (int i=0; i<files.length; i++) {
				
				log.info(" ====== 엑셀 파일 등록 처리 시작  : " + files[i] );
				
				File file = new File( storeExcelDir + "\\" + files[i].getName());
				ExcelSheetHandler excelSheetHandler = ExcelSheetHandler.readExcel(file);
				List<List<String>> excelDatas = excelSheetHandler.getRows();
				
				int count = 0; //처리 카운트
				List<TStoreInfoOrg> list = new ArrayList<TStoreInfoOrg>();
				
				for(List<String> dataRow : excelDatas) { // row 하나를 읽어온다.
					
					boolean nullChk = true;
				    int cellCount = 0;
				    TStoreInfoOrg orgBean = new TStoreInfoOrg();
				    
				    for(String cellData : dataRow){ // cell 하나를 읽어온다.
						
						//store_seq, manage_no, status_type 등이 값이 없을 경우 해당 ROW 등록 하지않음
				    	if ( cellCount == 0 || cellCount == 4 || cellCount == 7 || cellCount == 8 ) {
				    		if ( cellData.replaceAll(" ", "") == "") {
				    			nullChk = false;
					    		break;
				    		}
				    	}
				    	
				    	if ( cellData.indexOf("47000") > -1) {
				    		log.info("count >>>" + count);
				    		log.info("cellCount >>>" + cellCount);
				    	}
				    	
						if ( cellCount == 0 ) orgBean.setSeq(cellData);
						if ( cellCount == 1 ) orgBean.setServiceNm(cellData);
						if ( cellCount == 2 ) orgBean.setServiceId(cellData);
						if ( cellCount == 3 ) orgBean.setAreaCode(cellData);
						if ( cellCount == 4 ) orgBean.setManageNo(cellData);
						if ( cellCount == 5 ) orgBean.setApprovalDt(cellData);
						if ( cellCount == 6 ) orgBean.setCancelDt(cellData);
						if ( cellCount == 7 ) orgBean.setStatusType(cellData);
						if ( cellCount == 8 ) orgBean.setStatusNm(cellData);
						if ( cellCount == 9 ) orgBean.setStatusCode(cellData);
						if ( cellCount == 10 ) orgBean.setStatusNm2(cellData);
						if ( cellCount == 11 ) orgBean.setCloseDt(cellData);
						if ( cellCount == 12 ) orgBean.setHolidayStartDt(cellData);
						if ( cellCount == 13 ) orgBean.setHolidayEndDt(cellData);
						if ( cellCount == 14 ) orgBean.setReopenDt(cellData);
						if ( cellCount == 15 ) orgBean.setTel(cellData);
						if ( cellCount == 16 ) orgBean.setAreaSize(cellData);
						if ( cellCount == 17 ) orgBean.setZip(cellData);
						if ( cellCount == 18 ) orgBean.setAddr(cellData);
						if ( cellCount == 19 ) orgBean.setRoadAddr(cellData);
						if ( cellCount == 20 ) orgBean.setRoadZip(cellData);
						if ( cellCount == 21 ) orgBean.setStoreNm(cellData);
						if ( cellCount == 22 ) orgBean.setUptDt(cellData);
						if ( cellCount == 23 ) orgBean.setSqlType(cellData);
						if ( cellCount == 24 ) orgBean.setDataUptDt(cellData);
						if ( cellCount == 25 ) orgBean.setCtgryNm(cellData);
						if ( cellCount == 26 ) orgBean.setPositionX(cellData.trim());
						if ( cellCount == 27 ) orgBean.setPositionY(cellData.trim());
						if ( cellCount == 28 ) orgBean.setCtgryNm2(cellData);
						if ( cellCount == 29 ) orgBean.setManCnt(cellData);
						if ( cellCount == 30 ) orgBean.setWomanCnt(cellData);
						if ( cellCount == 31 ) orgBean.setAreaType(cellData);
						if ( cellCount == 32 ) orgBean.setDegreeType(cellData);
						if ( cellCount == 33 ) orgBean.setWaterType(cellData);
						if ( cellCount == 34 ) orgBean.setPersonCnt1(cellData);
						if ( cellCount == 35 ) orgBean.setPersonCnt2(cellData);
						if ( cellCount == 36 ) orgBean.setPersonCnt3(cellData);
						if ( cellCount == 37 ) orgBean.setPersonCnt4(cellData);
						if ( cellCount == 38 ) orgBean.setPersonCnt5(cellData);
						if ( cellCount == 39 ) orgBean.setStoreBuyType(cellData);
						if ( cellCount == 40 ) orgBean.setStoreMoney(cellData);
						if ( cellCount == 41 ) orgBean.setStoreMonthMoney(cellData);
						if ( cellCount == 42 ) orgBean.setManyUseYn(cellData);
						if ( cellCount == 43 ) orgBean.setAreaTot(cellData);
						if ( cellCount == 44 ) orgBean.setCultureNo(cellData);
						if ( cellCount == 45 ) orgBean.setCultureMenu(cellData);
						if ( cellCount == 46 ) orgBean.setHompage(cellData);
						if ( cellCount == 47 ) orgBean.setProcessYn("Y");
				    	
						cellCount++;
				    }
				    
//				    log.info("orgBean.storeNm >>" + orgBean.getStoreNm());
//				    log.info("nullChk >>" + nullChk);
				    if ( nullChk ) {
						list.add(orgBean);
						count++;
						totalCount++;
					}
				    
//				    log.info("list >>" + list.size());
				    
				    if ( count%500 == 0) {
				    	
//				    	log.info("list.size >>>" + list.size());
				    	
				    	tStoreInfoOrgMapper.bulkInsert(list);
						list.clear();
					}
				    
				    if ( count%10000 == 0) {
						log.info(" :::::: 현재 처리 건수 : " + count );
						log.info(" :::::: 전체 처리 건수 : " + totalCount );
					}
				}
				
				if ( list.size() > 0) {
					tStoreInfoOrgMapper.bulkInsert(list);
					list.clear();
				}
				
				log.info(" :::::: 등록 상점 건수 : " + count );
				log.info(" ====== 파일 처리 완료  : " + files[i] );
			}
		    
//			if ( list.size() > 0) {
//				tStoreInfoOrgMapper.bulkInsert(list);
//				list.clear();
//			}
			
			log.info(" :::::: 처리 파일 갯수 : " + files.length );
			log.info(" :::::: 전체 등록 상점 건수 : " + totalCount );
			log.info(" :::::: ALL STEP PROC TIME(초): " + ( System.currentTimeMillis() - start)/1000  + "초" );
			log.info(" :::::: ALL STEP PROC TIME(분) : " + ( System.currentTimeMillis() - start)/1000/60  + "분" );
			
			//Step2 기존 백업 디렉토리의 모든 파일을 삭제하고 작업이 끝난 파일들을 백업 디렉토리로 이동
			log.info(" :::::: File Backup Thread START " );
			FileBackupThread thread = new FileBackupThread(storeExcelDir, storeExcelBackDir);
			thread.start();
			
		}catch (Exception e) {
			log.error("");
			log.error(" =================== batchStoreOrgBulkInsert ERROR================== ");
			e.printStackTrace();
			log.error(" ===================================================================== ");
			log.error("");
			
		}
		
	}
	
	@Override
	public void batchStoreOrgPstmtInsert() throws SQLException{
		
		
//		storeExcelDir = "D:\\excel";
		
		Connection con = null;
        PreparedStatement pstmt = null ;
        
        StringBuffer insertStoreOrgQuery = new StringBuffer();
        
        insertStoreOrgQuery.append("	insert into t_store_info_org_excel												\n");
        insertStoreOrgQuery.append("	(                                                                               \n");
        insertStoreOrgQuery.append("		 seq				,service_nm			,service_id		,area_code          \n");
        insertStoreOrgQuery.append("		,manage_no			,approval_dt		,cancel_dt		,status_type        \n");
        insertStoreOrgQuery.append("		,status_nm			,status_code		,status_nm2		,close_dt           \n");
        insertStoreOrgQuery.append("		,holiday_start_dt	,holiday_end_dt		,reopen_dt		,tel                \n");
        insertStoreOrgQuery.append("		,area_size			,zip				,addr			,road_addr          \n");
        insertStoreOrgQuery.append("		,road_zip			,store_nm			,upt_dt			,sql_type           \n");
        insertStoreOrgQuery.append("		,data_upt_dt		,ctgry_nm			,position_x		,position_y         \n");
        insertStoreOrgQuery.append("		,ctgry_nm2			,man_cnt			,woman_cnt		,area_type          \n");
        insertStoreOrgQuery.append("		,degree_type		,water_type			,person_cnt1	,person_cnt2        \n");
        insertStoreOrgQuery.append("		,person_cnt3		,person_cnt4		,person_cnt5	,store_buy_type		\n");
        insertStoreOrgQuery.append("		,store_money		,store_month_money	,many_use_yn	,area_tot           \n");
        insertStoreOrgQuery.append("		,culture_no			,culture_menu		,hompage		,process_yn         \n");
        insertStoreOrgQuery.append("	) values (                                                                      \n");
        insertStoreOrgQuery.append("		?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,?                  \n");
        insertStoreOrgQuery.append("		,?					,?					,?				,'Y'                \n");
        insertStoreOrgQuery.append("	)                                                                               \n");
        insertStoreOrgQuery.append("	ON CONFLICT (manage_no) DO UPDATE                                               \n");
        insertStoreOrgQuery.append("	SET                                                                             \n");
        insertStoreOrgQuery.append("		service_nm          = excluded.service_nm                                    \n");
        insertStoreOrgQuery.append("		,service_id         = excluded.service_id                                   \n");
        insertStoreOrgQuery.append("		,area_code          = excluded.area_code                                    \n");
        insertStoreOrgQuery.append("		,approval_dt        = excluded.approval_dt                                  \n");
        insertStoreOrgQuery.append("		,cancel_dt          = excluded.cancel_dt                                    \n");
        insertStoreOrgQuery.append("		,status_type        = excluded.status_type                                  \n");
        insertStoreOrgQuery.append("		,status_nm          = excluded.status_nm                                    \n");
        insertStoreOrgQuery.append("		,status_code        = excluded.status_code                                  \n");
        insertStoreOrgQuery.append("		,status_nm2         = excluded.status_nm2                                   \n");
        insertStoreOrgQuery.append("		,close_dt           = excluded.close_dt                                     \n");
        insertStoreOrgQuery.append("		,holiday_start_dt   = excluded.holiday_start_dt                             \n");
        insertStoreOrgQuery.append("		,holiday_end_dt     = excluded.holiday_end_dt                               \n");
        insertStoreOrgQuery.append("		,reopen_dt          = excluded.reopen_dt                                    \n");
        insertStoreOrgQuery.append("		,tel                = excluded.tel                                          \n");
        insertStoreOrgQuery.append("		,area_size          = excluded.area_size                                    \n");
        insertStoreOrgQuery.append("		,zip                = excluded.zip                                          \n");
        insertStoreOrgQuery.append("		,addr               = excluded.addr                                         \n");
        insertStoreOrgQuery.append("		,road_addr          = excluded.road_addr                                    \n");
        insertStoreOrgQuery.append("		,road_zip           = excluded.road_zip                                     \n");
        insertStoreOrgQuery.append("		,store_nm           = excluded.store_nm                                     \n");
        insertStoreOrgQuery.append("		,upt_dt             = excluded.upt_dt                                       \n");
        insertStoreOrgQuery.append("		,sql_type           = excluded.sql_type                                     \n");
        insertStoreOrgQuery.append("		,data_upt_dt        = excluded.data_upt_dt                                  \n");
        insertStoreOrgQuery.append("		,ctgry_nm           = excluded.ctgry_nm                                     \n");
        insertStoreOrgQuery.append("		,position_x         = excluded.position_x                                   \n");
        insertStoreOrgQuery.append("		,position_y         = excluded.position_y                                   \n");
        insertStoreOrgQuery.append("		,ctgry_nm2          = excluded.ctgry_nm2                                    \n");
        insertStoreOrgQuery.append("		,man_cnt            = excluded.man_cnt                                      \n");
        insertStoreOrgQuery.append("		,woman_cnt          = excluded.woman_cnt                                    \n");
        insertStoreOrgQuery.append("		,area_type          = excluded.area_type                                    \n");
        insertStoreOrgQuery.append("		,degree_type        = excluded.degree_type                                  \n");
        insertStoreOrgQuery.append("		,water_type         = excluded.water_type                                   \n");
        insertStoreOrgQuery.append("		,person_cnt1        = excluded.person_cnt1                                  \n");
        insertStoreOrgQuery.append("		,person_cnt2        = excluded.person_cnt2                                  \n");
        insertStoreOrgQuery.append("		,person_cnt3        = excluded.person_cnt3                                  \n");
        insertStoreOrgQuery.append("		,person_cnt4        = excluded.person_cnt4                                  \n");
        insertStoreOrgQuery.append("		,person_cnt5        = excluded.person_cnt5                                  \n");
        insertStoreOrgQuery.append("		,store_buy_type     = excluded.store_buy_type                               \n");
        insertStoreOrgQuery.append("		,store_money        = excluded.store_money                                  \n");
        insertStoreOrgQuery.append("		,store_month_money  = excluded.store_month_money                            \n");
        insertStoreOrgQuery.append("		,many_use_yn        = excluded.many_use_yn                                  \n");
        insertStoreOrgQuery.append("		,area_tot           = excluded.area_tot                                     \n");
        insertStoreOrgQuery.append("		,culture_no         = excluded.culture_no                                   \n");
        insertStoreOrgQuery.append("		,culture_menu       = excluded.culture_menu                                 \n");
        insertStoreOrgQuery.append("		,hompage            = excluded.hompage                                      \n");
        insertStoreOrgQuery.append("		,process_yn         = 'Y'                                                   \n");
        
        
		log.info( "===============  STORE META DATA Merge ==========================" );
		
		try {
			
			Class.forName(driverClass);
            con = DriverManager.getConnection(jdbcUrl, username, dbpass);
            
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(insertStoreOrgQuery.toString());
            
			log.info( "Store Meta File Location  : " + storeExcelDir );
			
			//선행 조건 
			//작업 디렉토리에 파일이 존재할 경우
			File dir = new File(storeExcelDir);
		    File files[] = dir.listFiles();
			
		    log.info( " :::::::: 처리 파일 건수 : " + files.length );
		    
		    if ( files.length == 0 ) return;
			
		    long start = System.currentTimeMillis();
		    
		    int totalCount = 0;
		    
			//Step1 - 엑셀 Data 불러오기
			// - 엑셀 파일은 여러개일수 있으며 시작시 디렉토리의 파일 명을 Array - For 문을 이용하여 Loop
			for (int i=0; i<files.length; i++) {
				
				log.info(" ====== 엑셀 파일 등록 처리 시작  : " + files[i] );
				
				File file = new File( storeExcelDir + "\\" + files[i].getName());
				ExcelSheetHandler excelSheetHandler = ExcelSheetHandler.readExcel(file);
				List<List<String>> excelDatas = excelSheetHandler.getRows();
				
				int count = 0;
				
				for(List<String> dataRow : excelDatas) { // row 하나를 읽어온다.
					
					boolean nullChk = true;
				    int cellCount = 0;
				    
					for(String cellData : dataRow){ // cell 하나를 읽어온다.
						
						//store_seq, manage_no, status_type 등이 값이 없을 경우 해당 ROW 등록 하지않음
				    	if ( cellCount == 0 || cellCount == 4 || cellCount == 7 || cellCount == 8 ) {
				    		if ( cellData.replaceAll(" ", "") == "") {
				    			nullChk = false;
					    		break;
				    		}
				    	}
						
						if ( cellCount == 0 ) 	pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 1 )   pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 2 )   pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 3 )   pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 4 )   pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 5 )   pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 6 )   pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 7 )   pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 8 )   pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 9 )   pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 10 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 11 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 12 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 13 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 14 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 15 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 16 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 17 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 18 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 19 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 20 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 21 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 22 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 23 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 24 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 25 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 26 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 27 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 28 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 29 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 30 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 31 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 32 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 33 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 34 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 35 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 36 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 37 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 38 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 39 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 40 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 41 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 42 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 43 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 44 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 45 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 46 )  pstmt.setString((cellCount+1), cellData);
						if ( cellCount == 47 )  pstmt.setString((cellCount+1), cellData);
				    	
						cellCount++;
				        	
				    }

					if ( nullChk ) {
						pstmt.addBatch();
				        pstmt.clearParameters();
						count++;
						totalCount++;
					}
					
					if ( count%1000 == 0) {
						pstmt.executeBatch();
			            pstmt.clearBatch();
			            con.commit();
					}
					
					if ( count%10000 == 0) {
						log.info(" :::::: 현재 파일 처리 건수 : " + count );
						log.info(" :::::: 전체 처리 건수 : " + totalCount );
					}
				
				}
				
				pstmt.executeBatch();
	            pstmt.clearBatch();
	            con.commit();
	            
				log.info(" :::::: 등록 상점 건수 : " + totalCount );
				log.info(" ====== 파일 처리 완료  : " + files[i] );
				 
			}
			
			pstmt.executeBatch();
            con.commit();
            
			log.info(" :::::: 처리 파일 갯수 : " + files.length );
			log.info(" :::::: ALL STEP PROC TIME(초): " + ( System.currentTimeMillis() - start)/1000  + "초" );
			log.info(" :::::: ALL STEP PROC TIME(분) : " + ( System.currentTimeMillis() - start)/1000/60  + "분" );
	
			//Step2 기존 백업 디렉토리의 모든 파일을 삭제하고 작업이 끝난 파일들을 백업 디렉토리로 이동
			FileBackupThread thread = new FileBackupThread(storeExcelDir, storeExcelBackDir);
			thread.start();
			
		}catch(Exception e) {
			con.rollback();
			e.printStackTrace();
		}finally{
		    if(pstmt != null) pstmt.close();
		    if(con != null) con.close();
		}
	}
		
}
