package kr.co.infovine.dkmm.service.store;

import kr.co.infovine.dkmm.db.model.store.TStoreGooglePlaceModel;
import kr.co.infovine.dkmm.mapper.common.TCommonCodeMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreGooglePlaceMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoMapper;
import lombok.extern.log4j.Log4j2;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;

import java.util.List;

@Service
@Log4j2
public class GooglePlaceServiceImpl implements GooglePlaceService {
	@Autowired
	HttpClient httpClient;
	
	@Autowired
	TStoreInfoMapper tStoreInfoMapper;
	
	@Autowired
	TStoreGooglePlaceMapper tStoreGooglePlaceMapper;
	
	@Autowired
	TCommonCodeMapper tCommonCodeMapper;
	
	@Override
	public String getGooglePlace(String latitude, String longitude, String nextPageToken) {
		String url = "https://localhost:9125/test/calibrationMapTest.do";
		log.info("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + latitude + "," + longitude + "&pagetoken=" + nextPageToken + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&radius=100&types=restaurant&language=ko");
		//String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + latitude + "," + longitude + "&pagetoken=" + nextPageToken + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&radius=100&types=restaurant&language=ko"; 
		WebClient client = WebClient.builder()
				  .clientConnector(new ReactorClientHttpConnector(httpClient))
				  .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
				  .build();
		String json = "{\"pageToken\":\"" + nextPageToken + "\"}";
		String strResult = client.post()
				.uri(url)
				.accept(MediaType.APPLICATION_JSON)
				.body(BodyInserters.fromValue(json))
				.retrieve()
				.bodyToMono(String.class).block();
		
		return strResult;
	}
	
	@Override
	public String getGooglePlaceByKeyword(String latitude, String longitude, String keyword) {
		//String url = "https://localhost:9125/test/calibrationMapTest.do";
		//log.info("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + latitude + "," + longitude + "&keyword=" + keyword + "&radius=100&types=restaurant&language=ko");
		String url = "";
		if(latitude!=null && longitude!=null) {
			//url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + latitude + "," + longitude + "&keyword=" + keyword + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&radius=100&types=restaurant&language=ko";
			url = "https://maps.googleapis.com/maps/api/place/textsearch/json?location=" + latitude + "," + longitude + "&radius=100&types=restaurant,cafe,bakery&query=" +keyword + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&language=ko";
		}
		else {
			url = "https://maps.googleapis.com/maps/api/place/textsearch/json?types=restaurant,cafe,bakery&query=" +keyword + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&language=ko";
			//url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=" + keyword + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&radius=100&types=restaurant&language=ko";
		}
		//https://maps.googleapis.com/maps/api/place/nearbysearch/json?radius=100&types=restaurant&language=ko&key={{key}}&location=37.68849836909826,127.04158567654656&keyword=완도황칠보쌈전복찜
		WebClient client = WebClient.builder()
				  .clientConnector(new ReactorClientHttpConnector(httpClient))
				  .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
				  .build();
		//String json = "{\"pageToken\":\"" + keyword + "\"}";
		String strResult = client.post()
				.uri(url)
				.accept(MediaType.APPLICATION_JSON)
				//.body(BodyInserters.fromValue(json))
				.retrieve()
				.bodyToMono(String.class).block();
		
		return strResult;
	}
	
	@Override
	public String getGooglePlaceByKeywordNextToken(String latitude, String longitude, String keyword, String nextPageToken) {
		//String url = "https://localhost:9125/test/calibrationMapTest.do";
		//log.info("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + latitude + "," + longitude + "&keyword=" + keyword + "&radius=100&types=restaurant&language=ko");
		String url = "";
		if(latitude!=null && longitude!=null) {
			//url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + latitude + "," + longitude + "&keyword=" + keyword + "&pagetoken=" + nextPageToken + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&radius=100&types=restaurant&language=ko";
			url = "https://maps.googleapis.com/maps/api/place/textsearch/json?location=" + latitude + "," + longitude + "&radius=100&types=restaurant,cafe,bakery&query=" +keyword + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&language=ko&pagetoken=" + nextPageToken;
		}
		else{
			//url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=" + keyword + "&pagetoken=" + nextPageToken + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&radius=100&types=restaurant&language=ko";
			url = "https://maps.googleapis.com/maps/api/place/textsearch/json?types=restaurant,cafe,bakery&query=" +keyword + "&key=AIzaSyBykmHtJypH0_m1cxQUknCNlttW33D6RKo&language=ko&pagetoken=" + nextPageToken;
		}

		//https://maps.googleapis.com/maps/api/place/nearbysearch/json?radius=100&types=restaurant&language=ko&key={{key}}&location=37.68849836909826,127.04158567654656&keyword=완도황칠보쌈전복찜
		WebClient client = WebClient.builder()
				  .clientConnector(new ReactorClientHttpConnector(httpClient))
				  .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
				  .build();
		//String json = "{\"pageToken\":\"" + keyword + "\"}";
		String strResult = client.post()
				.uri(url)
				.accept(MediaType.APPLICATION_JSON)
				//.body(BodyInserters.fromValue(json))
				.retrieve()
				.bodyToMono(String.class).block();
		
		return strResult;
	}

	@Override
	public TStoreGooglePlaceModel getJsonToJackson(JSONObject object) {
		TStoreGooglePlaceModel googlePlace = new TStoreGooglePlaceModel();
		try {
			String placeId = null;
			String name = null;
			String latitude = null;
			String longitude = null;
			String viewportNortheastLatitude = null;
			String viewportNortheastLongitude = null;
			String viewportSouthwestLatitude = null;
			String viewportSouthwestLongitude = null;
			String reference = null;
			String types = null;
			String rating = null;
			String priceLevel = null;
			String userRatingsTotal = null;
			String vicinity = null;
			String formattedAddress = null;
			if(!object.isNull("place_id")) {
				placeId = object.getString("place_id");
				googlePlace.setPlaceId(placeId);
			}
			
			if(!object.isNull("name")) {
				name = object.getString("name");
				googlePlace.setName(name);
			}

			if(!object.isNull("formatted_address")) {
				formattedAddress = object.getString("formatted_address");
				googlePlace.setFormattedAddress(formattedAddress);
			}
			
			if(!object.isNull("geometry")) {
				JSONObject geometry = object.getJSONObject("geometry");
				
				if(!geometry.isNull("location")) {
					JSONObject location = geometry.getJSONObject("location");
					
					if(!location.isNull("lat")) {
						latitude = location.getString("lat");
						googlePlace.setLatitude(latitude);
					}
					
					if(!location.isNull("lng")) {
						longitude = location.getString("lng");
						googlePlace.setLongitude(longitude);
					}
				}
				
				if(!geometry.isNull("viewport")) {
					JSONObject viewport = geometry.getJSONObject("viewport");
					
					if(!viewport.isNull("northeast")) {
						JSONObject northeast = viewport.getJSONObject("northeast");
						if(!northeast.isNull("lat")) {
							viewportNortheastLatitude = northeast.getString("lat");
							googlePlace.setViewportNortheastLatitude(viewportNortheastLatitude);
						}
						
						if(!northeast.isNull("lng")) {
							viewportNortheastLongitude = northeast.getString("lng");
							googlePlace.setViewportNortheastLongitude(viewportNortheastLongitude);
						}
					}
					
					if(!viewport.isNull("southwest")) {
						JSONObject southwest = viewport.getJSONObject("southwest");
						if(!southwest.isNull("lat")) {
							viewportSouthwestLatitude = southwest.getString("lat");
							googlePlace.setViewportSouthwestLatitude(viewportSouthwestLatitude);
						}
						
						if(!southwest.isNull("lng")) {
							viewportSouthwestLongitude = southwest.getString("lng");
							googlePlace.setViewportSouthwestLongitude(viewportSouthwestLongitude);
						}
					}
				}
			}
			
			if(!object.isNull("reference")) {
				reference = object.getString("reference");
				googlePlace.setReference(reference);
			}
			
			if(!object.isNull("types")) {
				types = object.getJSONArray("types").toString();
				googlePlace.setTypes(types);
			}
			
			if(!object.isNull("rating")) {
				rating = object.getString("rating");
				googlePlace.setRating(rating);
			}
			
			if(!object.isNull("price_level")) {
				priceLevel = object.getString("price_level");
				googlePlace.setPriceLevel(priceLevel);
			}
			
			if(!object.isNull("user_ratings_total")) {
				userRatingsTotal = object.getString("user_ratings_total");
				googlePlace.setUserRatingsTotal(userRatingsTotal);
			}
			
			if(!object.isNull("vicinity")) {
				vicinity = object.getString("vicinity");
				googlePlace.setVicinity(vicinity);
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return googlePlace;
	}

	@Override
	public List<TStoreGooglePlaceModel> selectAll(TStoreGooglePlaceModel row) {
		return tStoreGooglePlaceMapper.selectAll();
	}

	@Override
	public List<TStoreGooglePlaceModel> selectAllExceptForStoreSeq() {
		return tStoreGooglePlaceMapper.selectAllExceptForStoreSeq();
	}

	@Override
	public List<TStoreGooglePlaceModel> selectByPrimaryKey(TStoreGooglePlaceModel row) {
		return tStoreGooglePlaceMapper.selectByPrimaryKey(row);
	}

	@Override
	public List<TStoreGooglePlaceModel> selectByLikeStoreName(TStoreGooglePlaceModel row) {
		return tStoreGooglePlaceMapper.selectByLikeStoreName(row);
	}

	@Override
	public int insert(TStoreGooglePlaceModel row) {
		return tStoreGooglePlaceMapper.insert(row);
	}

	@Override
	public int updateByPrimaryKey(TStoreGooglePlaceModel row) {
		return tStoreGooglePlaceMapper.updateByPrimaryKey(row);
	}

//	// region 설명: 지도 보정(calibrationKeywordMap)
//	/**
//	 * 2022-10-20 Made by Duhyun, Kim
//	 * @param param
//	 */
//	@Override
//	public int calibrationKeywordMap() {
//		try {
//			TCommonCodeModel tCommonCodeModel = new TCommonCodeModel();
//
//			List<TCommonCodeModel> tCodeArray = tCommonCodeMapper.selectByCodeGroup("google_place_api");
//			int usableUsageMonth = -1;
//			int usableUsageDay = -1;
//			Date dateUsageMonth = null;
//			Date dateUsageDay = null;
//			String lastCoordinates = "";	//마지막으로 사용한 좌표(위, 경도)
//			String lastLatitude = "";
//			String lastLongitude = "";
//
//			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//			Calendar currentTime = Calendar.getInstance(Locale.KOREA);
//			Date dtCurrentTime = currentTime.getTime();
//			//currentTime.set(Calendar.DATE, 1);
//			//String firstMonth = dateFormat.format(currentTime.getTime());
//
//
//	//		log.info("lastMonth : " + lastMonth + ", nextMonth : " + nextMonth);
//
//			for (TCommonCodeModel code : tCodeArray) {
//				String codeValue = code.getCodeValue();
//				if(codeValue.equals("month")){
//					String description = code.getCodeDescription();
//					if(description!=null) {
//						usableUsageMonth = Integer.valueOf(description);
//					}
//					dateUsageMonth = code.getInsDt();
//				}
//				else if(codeValue.equals("day")){
//					String description = code.getCodeDescription();
//					if(description!=null) {
//						usableUsageDay = Integer.valueOf(description);
//					}
//					dateUsageDay = code.getInsDt();
//				}
//			}
//
//	//		TCode tCoordinates = new TCode();
//	//		tCoordinates.setHiCd("coordinates");
//	//		List<TCode> tCodeCoordinates = tCodeMapper.selectOfCode(tCoordinates);
//
//	//		for (TCode code : tCodeCoordinates) {
//	//			lastCoordinates = code.getCdNm();
//	//		}
//
//			int currentMonth = currentTime.get(Calendar.MONTH);
//			int currentDay = currentTime.get(Calendar.DATE);
//
//			Calendar calUsageMonth = Calendar.getInstance();
//			calUsageMonth.setTime(dateUsageMonth);
//			int usageMonth = calUsageMonth.get(Calendar.MONTH);
//
//
//			Calendar calUsageDay = Calendar.getInstance();
//			calUsageDay.setTime(dateUsageDay);
//			int usageDay = calUsageDay.get(Calendar.DATE);
//
//			if(usageDay!=currentDay) {
//				log.info("날짜가 오늘 돌릴 수 있는 갯수를 900개로 초기화 해야됨");
//				TCommonCodeModel codeModel = new TCommonCodeModel();
//				codeModel.setCodeGroup("google_place_api");
//				codeModel.setCodeValue("day");
//				codeModel.setCodeDescription(Integer.toString(900));
//				codeModel.setInsDt(currentTime.getTime());
//				int tempResultInt = tCommonCodeMapper.updateByDescriptionAndInsDt(codeModel);
//
//				if(tempResultInt>0) {
//					usableUsageDay = 900;
//				}
//			}
//			else {
//				log.info("등록된 일과 오늘 일이 동일할 경우");
//			}
//			if(currentMonth!=usageMonth) {
//				log.info("한달 내에 돌릴 수 있는 갯수를 9000개로 초기화 해야됨");
//
//				TCommonCodeModel codeModel = new TCommonCodeModel();
//				codeModel.setCodeGroup("google_place_api");
//				codeModel.setCodeValue("month");
//				codeModel.setCodeDescription(Integer.toString(9000));
//				codeModel.setInsDt(currentTime.getTime());
//				int tempResultInt = tCommonCodeMapper.updateByDescriptionAndInsDt(codeModel);
//
//				if(tempResultInt>0) {
//					usableUsageMonth = 9000;
//				}
//			}
//			else {
//				log.info("등록된 월과 오늘 월이 동일할 경우");
//			}
//
//			int tempRemainMonth = usableUsageMonth;
//			int tempRemainDay = usableUsageDay;
//			String nextPageToken = "";
//
//
//			if(usableUsageMonth>0) {
//				if(usableUsageDay>0) {
//
//					TStoreInfoModel parameter = new TStoreInfoModel();
//					parameter.setStartLatitude("37.53634240579513");
//					parameter.setEndLatitude("37.51472993687259");
//					parameter.setStartLongitude("126.90831184387208");
//					parameter.setEndLongitude("126.94384574890138");
//					parameter.setSeq(4); 		//여의도
//					List<TStoreInfoModel> resultStoreInfo = tStoreInfoMapper.selectByLocation(parameter);
//					int i=0;
//					for(TStoreInfoModel storeInfo : resultStoreInfo) {
//					//for (int i=0; i<usableUsageDay; i++) {
//						String searchLongitude = storeInfo.getLongitude();
//						String searchLatitude = storeInfo.getLatitude();
//						String searchKeyword = storeInfo.getStoreNm();// + "&" + storeInfo.getRoadAddrLevel4() + " " + storeInfo.getRoadAddrLevel5();
//						int storeSeq = storeInfo.getStoreSeq();
//						// 빠른속도로 api 호출 하면 오류값을 전송함
//						double start = 150;
//						double end = 300;
//						double random = new Random().nextDouble();
////						if(i==2) {
////							//테스트용도
////							break;
////						}
//						String strResult = getGooglePlaceByKeyword(searchLatitude, searchLongitude, searchKeyword);
//						if(strResult!=null) {
//							JSONObject jsonObject = new JSONObject(strResult);
//
//
//							String status = "";
//
//							if(!jsonObject.isNull("status")) {
//								status = jsonObject.getString("status");
//
//								if(status.equals("OK")) {
//									if(!jsonObject.isNull("next_page_token")) {
//										nextPageToken = jsonObject.getString("next_page_token");
//									}
//									else {
//										nextPageToken = null;
//									}
//
//									if(!jsonObject.isNull("results")) {
//										JSONArray jsonArray = jsonObject.getJSONArray("results");
//
//										if(jsonArray.length()>=2) {		//한개 이상일경우 google place table에 저장만 한다 t_store_info에는 업데이트 하지 않음
//											for(int j=0; j<jsonArray.length(); j++) {
//												JSONObject object = jsonArray.getJSONObject(j);
//												TStoreGooglePlace googlePlace = getJsonToJackson(object);
//												//log.info(googlePlace.getName());
//												googlePlace.setInsDt(dtCurrentTime);
//												googlePlace.setStoreSeq(-1);
//
//												List<TStoreGooglePlace> list = tStoreGooglePlaceMapper.selectByPrimaryKey(googlePlace);
//												if(list.isEmpty()) {
//													List<TStoreGooglePlace> listName = tStoreGooglePlaceMapper.selectByLikeStoreName(googlePlace);
//													if(listName.isEmpty()) {
//														int a = tStoreGooglePlaceMapper.insert(googlePlace);
//													}
//													else {
//														int a = tStoreGooglePlaceMapper.updateByPrimaryKey(googlePlace);
//													}
//												}
//												else {
//													int a = tStoreGooglePlaceMapper.updateByPrimaryKey(googlePlace);
//												}
//											}
//											int a = tStoreInfoMapper.updateGooglePlaceZeroByPrimaryKey(storeInfo);
//										}
//										else {
//											for(int j=0; j<jsonArray.length(); j++) {
//												JSONObject object = jsonArray.getJSONObject(j);
//												TStoreGooglePlace googlePlace = getJsonToJackson(object);
//												log.info(googlePlace.getName());
//												String placeId = googlePlace.getPlaceId();
//												String placeLatitude = googlePlace.getLatitude();
//												String placeLongitude = googlePlace.getLongitude();
//												googlePlace.setInsDt(dtCurrentTime);
//												googlePlace.setStoreSeq(storeSeq);
//
//												List<TStoreGooglePlace> list = tStoreGooglePlaceMapper.selectByPrimaryKey(googlePlace);
//												if(list.isEmpty()) {
//													List<TStoreGooglePlace> listName = tStoreGooglePlaceMapper.selectByLikeStoreName(googlePlace);
//													if(listName.isEmpty()) {
//														int a = tStoreGooglePlaceMapper.insert(googlePlace);
//													}
//													else {
//														int a = tStoreGooglePlaceMapper.updateByPrimaryKey(googlePlace);
//													}
//												}
//												else {
//													int a = tStoreGooglePlaceMapper.updateByPrimaryKey(googlePlace);
//												}
//												storeInfo.setPlaceId(placeId);
//												storeInfo.setPlaceLongitude(placeLongitude);
//												storeInfo.setPlaceLatitude(placeLatitude);
//												storeInfo.setPlaceUptDt(dtCurrentTime);
//												int a = tStoreInfoMapper.updateGooglePlaceByPrimaryKey(storeInfo);
//											}
//											int a = tStoreInfoMapper.updateGooglePlaceZeroByPrimaryKey(storeInfo);
//										}
//	//									SimpleDateFormat checkSdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
//	//									Calendar checkTime = Calendar.getInstance(Locale.KOREA);
//	//									String checkDate = checkSdf.format(checkTime.getTime());
//	//									parameter.setCheckDate(checkDate);
//										//tWholePolygonMapper.updateByCheckYn(polygon);
//									}
//
//									while(nextPageToken!=null) {
//										// nextPageToken이 존재 할 경우 실행
//										double startDo = 150;
//										double endDo = 300;
//										double randomDo = new Random().nextDouble();
//										String nextTokenResult = getGooglePlaceByKeyword(searchLatitude, searchLongitude, searchKeyword);
//										if(strResult!=null) {
//											JSONObject jsonObjectByNextToken = new JSONObject(nextTokenResult);
//
//
//											String nextTokenStatus = "";
//
//											if(!jsonObjectByNextToken.isNull("status")) {
//												nextTokenStatus = jsonObjectByNextToken.getString("status");
//
//												if(nextTokenStatus.equals("OK")) {
//													if(!jsonObjectByNextToken.isNull("next_page_token")) {
//														nextPageToken = jsonObjectByNextToken.getString("next_page_token");
//													}
//													else {
//														nextPageToken = null;
//													}
//
//													if(!jsonObject.isNull("results")) {
//														JSONArray jsonArray = jsonObject.getJSONArray("results");
//
//														if(jsonArray.length()>=2) {		//한개 이상일경우 google place table에 저장만 한다 t_store_info에는 업데이트 하지 않음
//															for(int j=0; j<jsonArray.length(); j++) {
//																JSONObject object = jsonArray.getJSONObject(j);
//																TStoreGooglePlace googlePlace = getJsonToJackson(object);
//																//log.info(googlePlace.getName());
//																googlePlace.setInsDt(dtCurrentTime);
//																googlePlace.setStoreSeq(-1);
//
//																List<TStoreGooglePlace> list = tStoreGooglePlaceMapper.selectByPrimaryKey(googlePlace);
//																if(list.isEmpty()) {
//																	List<TStoreGooglePlace> listName = tStoreGooglePlaceMapper.selectByLikeStoreName(googlePlace);
//																	if(listName.isEmpty()) {
//																		int a = tStoreGooglePlaceMapper.insert(googlePlace);
//																	}
//																	else {
//																		int a = tStoreGooglePlaceMapper.updateByPrimaryKey(googlePlace);
//																	}
//																}
//																else {
//																	int a = tStoreGooglePlaceMapper.updateByPrimaryKey(googlePlace);
//																}
//															}
//															int a = tStoreInfoMapper.updateGooglePlaceZeroByPrimaryKey(storeInfo);
//														}
//														else {
//															for(int j=0; j<jsonArray.length(); j++) {
//																JSONObject object = jsonArray.getJSONObject(j);
//																TStoreGooglePlace googlePlace = getJsonToJackson(object);
//																log.info(googlePlace.getName());
//																String placeId = googlePlace.getPlaceId();
//																String placeLatitude = googlePlace.getLatitude();
//																String placeLongitude = googlePlace.getLongitude();
//																googlePlace.setInsDt(dtCurrentTime);
//																googlePlace.setStoreSeq(storeSeq);
//
//																List<TStoreGooglePlace> list = tStoreGooglePlaceMapper.selectByPrimaryKey(googlePlace);
//																if(list.isEmpty()) {
//																	List<TStoreGooglePlace> listName = tStoreGooglePlaceMapper.selectByLikeStoreName(googlePlace);
//																	if(listName.isEmpty()) {
//																		int a = tStoreGooglePlaceMapper.insert(googlePlace);
//																	}
//																	else {
//																		int a = tStoreGooglePlaceMapper.updateByPrimaryKey(googlePlace);
//																	}
//																}
//																else {
//																	int a = tStoreGooglePlaceMapper.updateByPrimaryKey(googlePlace);
//																}
//																storeInfo.setPlaceId(placeId);
//																storeInfo.setPlaceLongitude(placeLongitude);
//																storeInfo.setPlaceLatitude(placeLatitude);
//																storeInfo.setPlaceUptDt(dtCurrentTime);
//																int a = tStoreInfoMapper.updateGooglePlaceByPrimaryKey(storeInfo);
//															}
//															int a = tStoreInfoMapper.updateGooglePlaceZeroByPrimaryKey(storeInfo);
//														}
//													}
//												}
//												else {
//													//데이터가 없어도 place 조회한 결과는 Y체크해야됨
//													int a = tStoreInfoMapper.updateGooglePlaceZeroByPrimaryKey(storeInfo);
//												}
//											}
//											int sleepDo = (int) (startDo + (randomDo * (endDo - startDo)));
//											Thread.sleep(sleepDo);
//											tempRemainMonth--;
//											tempRemainDay--;
//											i ++;
//
//											if(nextPageToken==null) {
//												break;
//											}
//											if(tempRemainDay==0) {
//												break;
//											}
//										}
//									}
//								}
//								else {
//									//데이터가 없어도 place 조회한 결과는 Y체크해야됨
//									int a = tStoreInfoMapper.updateGooglePlaceZeroByPrimaryKey(storeInfo);
//								}
//							}
//							int sleep = (int) (start + (random * (end - start)));
//							Thread.sleep(sleep);
//							tempRemainMonth--;
//							tempRemainDay--;
//							i ++;
//						}
//						else {
//							break;
//						}
//
//
//	//					tempRemainMonth--;
//	//					tempRemainDay--;
//						if(tempRemainDay==0) {
//							break;
//						}
//					}
//				}
//			}
//			TCommonCodeModel codeModel = new TCommonCodeModel();
//			codeModel.setCodeGroup("google_place_api");
//			codeModel.setCodeValue("day");
//			codeModel.setCodeDescription(Integer.toString(tempRemainDay));
//
//
//			int tempResultDay = tCommonCodeMapper.updateByDescriptionAndInsDt(codeModel);
//
//			codeModel.setCodeGroup("google_place_api");
//			codeModel.setCodeValue("month");
//			codeModel.setCodeDescription(Integer.toString(tempRemainMonth));
//
//			int tempResultMonth = tCommonCodeMapper.updateByDescriptionAndInsDt(codeModel);
//
//			//log.info(result.getCode());
//			//result.setResult(strResult);
//
//			return 0;
//		}
//		catch (Exception e) {
//			e.printStackTrace();
//			return -1;
//		}
//
//	}
	// end region
}
