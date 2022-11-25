package kr.co.infovine.dkmm.service.store;

import java.text.SimpleDateFormat;
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
import kr.co.infovine.dkmm.mapper.common.TCommonCodeMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoOrgMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoTestMapper;
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
}
