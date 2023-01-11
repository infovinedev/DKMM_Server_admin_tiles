package kr.co.infovine.dkmm.service.store;

import kr.co.infovine.dkmm.db.model.store.TStoreGooglePlaceModel;
import org.codehaus.jettison.json.JSONObject;

import java.util.List;

public interface GooglePlaceService {
	String getGooglePlace(String latitude, String longitude, String nextPageToken);
	
	String getGooglePlaceByKeyword(String latitude, String longitude, String keyword);
	
	String getGooglePlaceByKeywordNextToken(String latitude, String longitude, String keyword, String nextPageToken);
	
	TStoreGooglePlaceModel getJsonToJackson(JSONObject object);

	List<TStoreGooglePlaceModel> selectAll(TStoreGooglePlaceModel row);

	List<TStoreGooglePlaceModel> selectAllExceptForStoreSeq();

	List<TStoreGooglePlaceModel> selectByPrimaryKey(TStoreGooglePlaceModel row);

	List<TStoreGooglePlaceModel> selectByLikeStoreName(TStoreGooglePlaceModel row);

	int insert(TStoreGooglePlaceModel row);

	int updateByPrimaryKey(TStoreGooglePlaceModel row);

	
	//int calibrationKeywordMap();
	
}
