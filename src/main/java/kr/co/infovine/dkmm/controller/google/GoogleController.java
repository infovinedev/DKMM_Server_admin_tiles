package kr.co.infovine.dkmm.controller.google;

import com.fasterxml.jackson.databind.ObjectMapper;
import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.db.model.store.TStoreGooglePlaceModel;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.service.common.CommonCodeService;
import kr.co.infovine.dkmm.service.store.GooglePlaceService;
import kr.co.infovine.dkmm.service.store.OperationStoreService;
import lombok.extern.slf4j.Slf4j;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@Controller
@RequestMapping(value = "/google")
@Slf4j
public class GoogleController {
    @Autowired
    OperationStoreService operationStoreService;

    @Autowired
    GooglePlaceService googlePlaceService;

    @Autowired
    CommonCodeService commonCodeService;

    @RequestMapping(value="/place.do")
    public ModelAndView mainPage(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView model = new ModelAndView();
        model.addObject("leftPageUrl", "google/place");
        TStoreInfoModel storeInfo = new TStoreInfoModel();
        model.addObject("storeCount", operationStoreService.selectStoreCount(storeInfo) );
        model.setViewName("google/place");
        return model;
    }



    // region 설명: 지도 보정
    /**
     * 2022-08-23 Made by Duhyun, Kim
     * @param request
     * return : ResponseModel
     */
    @RequestMapping(value="/search/keyword.do", method = RequestMethod.POST
            , consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
    @ResponseBody
    public ResponseModel searchKeyword(HttpServletRequest request, HttpServletResponse response
        , @RequestBody TStoreGooglePlaceModel place
    ) {
        ResponseModel result = new ResponseModel();
        try {
            TCommonCodeModel tCommonCodeModel = new TCommonCodeModel();

            List<TCommonCodeModel> tCodeArray = commonCodeService.selectByCodeGroup("google_place_api");
            int usableUsageMonth = -1;
            int usableUsageDay = -1;
            Date dateUsageMonth = null;
            Date dateUsageDay = null;
            String lastCoordinates = "";	//마지막으로 사용한 좌표(위, 경도)
            String lastLatitude = "";
            String lastLongitude = "";

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Calendar currentTime = Calendar.getInstance(Locale.KOREA);
            //currentTime.set(Calendar.DATE, 1);
            //String firstMonth = dateFormat.format(currentTime.getTime());


//			log.info("lastMonth : " + lastMonth + ", nextMonth : " + nextMonth);

            for (TCommonCodeModel code : tCodeArray) {
                String codeValue = code.getCodeValue();
                if(codeValue.equals("month")){
                    String description = code.getCodeDescription();
                    if(description!=null) {
                        usableUsageMonth = Integer.valueOf(description);
                    }
                    dateUsageMonth = code.getInsDt();
                }
                else if(codeValue.equals("day")){
                    String description = code.getCodeDescription();
                    if(description!=null) {
                        usableUsageDay = Integer.valueOf(description);
                    }
                    dateUsageDay = code.getInsDt();
                }
            }

//			TCode tCoordinates = new TCode();
//			tCoordinates.setHiCd("coordinates");
//			List<TCode> tCodeCoordinates = tCodeMapper.selectOfCode(tCoordinates);

//			for (TCode code : tCodeCoordinates) {
//				lastCoordinates = code.getCdNm();
//			}

            int currentMonth = currentTime.get(Calendar.MONTH);
            int currentDay = currentTime.get(Calendar.DATE);

            Calendar calUsageMonth = Calendar.getInstance();
            calUsageMonth.setTime(dateUsageMonth);
            int usageMonth = calUsageMonth.get(Calendar.MONTH);


            Calendar calUsageDay = Calendar.getInstance();
            calUsageDay.setTime(dateUsageDay);
            int usageDay = calUsageDay.get(Calendar.DATE);

            if(usageDay!=currentDay) {
                log.info("날짜가 오늘 돌릴 수 있는 갯수를 900개로 초기화 해야됨");
                TCommonCodeModel codeModel = new TCommonCodeModel();
                codeModel.setCodeGroup("google_place_api");
                codeModel.setCodeValue("day");
                codeModel.setCodeDescription(Integer.toString(900));
                codeModel.setInsDt(currentTime.getTime());
                int tempResultInt = commonCodeService.updateByDescriptionAndInsDt(codeModel);

                if(tempResultInt>0) {
                    usableUsageDay = 900;
                }
            }
            else {
                log.info("등록된 일과 오늘 일이 동일할 경우");
            }
            if(currentMonth!=usageMonth) {
                log.info("한달 내에 돌릴 수 있는 갯수를 9000개로 초기화 해야됨");

                TCommonCodeModel codeModel = new TCommonCodeModel();
                codeModel.setCodeGroup("google_place_api");
                codeModel.setCodeValue("month");
                codeModel.setCodeDescription(Integer.toString(9000));
                codeModel.setInsDt(currentTime.getTime());
                int tempResultInt = commonCodeService.updateByDescriptionAndInsDt(codeModel);

                if(tempResultInt>0) {
                    usableUsageMonth = 9000;
                }
            }
            else {
                log.info("등록된 월과 오늘 월이 동일할 경우");
            }

            int tempRemainMonth = usableUsageMonth;
            int tempRemainDay = usableUsageDay;
            String nextPageToken = "";


            if(usableUsageMonth>0) {
                if(usableUsageDay>0) {
                    //추후 사용 하고싶으면 service영역에서 변경
                    String searchLongitude = place.getLatitude();
                    String searchLatitude = place.getLongitude();
                    String searchText = place.getName();
                    String strResult = googlePlaceService.getGooglePlaceByKeyword(searchLatitude, searchLongitude, searchText);
                    if(strResult!=null) {
                        JSONObject jsonObject = new JSONObject(strResult);
                        String status = "";

                        if(!jsonObject.isNull("status")) {
                            status = jsonObject.getString("status");

                            if(status.equals("OK")) {
                                if(!jsonObject.isNull("next_page_token")) {
                                    nextPageToken = jsonObject.getString("next_page_token");
                                }

                                if(!jsonObject.isNull("results")) {
                                    JSONArray jsonArray = jsonObject.getJSONArray("results");

                                    for(int j=0; j<jsonArray.length(); j++) {
                                        JSONObject object = jsonArray.getJSONObject(j);
                                        TStoreGooglePlaceModel googlePlace = googlePlaceService.getJsonToJackson(object);
                                        log.info(googlePlace.getName());
                                        String placeId = googlePlace.getPlaceId();
                                        List<TStoreGooglePlaceModel> list = googlePlaceService.selectByPrimaryKey(googlePlace);
                                        if(list.isEmpty()) {
                                            String storeName = googlePlace.getName();
                                            List<TStoreGooglePlaceModel> listName = googlePlaceService.selectByLikeStoreName(googlePlace);
                                            if(listName.isEmpty()) {
                                                int a = googlePlaceService.insert(googlePlace);
                                            }
                                            else {
                                                int a = googlePlaceService.updateByPrimaryKey(googlePlace);
                                            }
                                        }
                                        else {
                                            int a = googlePlaceService.updateByPrimaryKey(googlePlace);
                                        }
                                    }
                                    SimpleDateFormat checkSdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
                                    Calendar checkTime = Calendar.getInstance(Locale.KOREA);
                                    String checkDate = checkSdf.format(checkTime.getTime());
                                    //polygonModel.setCheckDate(checkDate);
                                    //tWholePolygonMapper.updateByCheckYn(polygon);
                                }
                            }
                            else {
                            }
                        }
                        tempRemainMonth--;
                        tempRemainDay--;
                    }
                }
            }
            TCommonCodeModel codeModel = new TCommonCodeModel();
            codeModel.setCodeGroup("google_place_api");
            codeModel.setCodeValue("day");
            codeModel.setCodeDescription(Integer.toString(tempRemainDay));


            int tempResultDay = commonCodeService.updateByDescriptionAndInsDt(codeModel);

            codeModel.setCodeGroup("google_place_api");
            codeModel.setCodeValue("month");
            codeModel.setCodeDescription(Integer.toString(tempRemainMonth));

            int tempResultMonth = commonCodeService.updateByDescriptionAndInsDt(codeModel);

            //log.info(result.getCode());
            JSONObject resultJson = new JSONObject();
            resultJson.put("remainMonth", tempRemainMonth);
            resultJson.put("remainDay", tempRemainDay);
            result.setCode("0000");
            result.setResult(resultJson.toString());
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    // end region




    // region 설명: 지도 보정
    /**
     * 2022-08-23 Made by Duhyun, Kim
     * @param request
     * return : ResponseModel
     */
    @RequestMapping(value="/search/place.do", method = RequestMethod.POST
            , consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
    @ResponseBody
    public ResponseModel searchGooglePlace(HttpServletRequest request, HttpServletResponse response
            , @RequestBody TStoreGooglePlaceModel place
    ) {
        ResponseModel result = new ResponseModel();
        try {
            List<TStoreGooglePlaceModel> list = googlePlaceService.selectAllExceptForStoreSeq();
            ObjectMapper mapper = new ObjectMapper();
            String strList = mapper.writeValueAsString(list);
            result.setCode("0000");
            result.setResult(strList);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    // end region
}
