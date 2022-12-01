package kr.co.infovine.dkmm.service.store;

import java.sql.SQLException;

public interface StoreMetaBatchService {
	
	void batchStoreInfo();
	void batchStoreInfoTest();		//테스트 테이블
	
	int mergeStoreInfo();		
	int mergeStoreInfoTest();		//테스트 테이블
	int updateStoreOrgStatus01();	
	int updateCloseStoreInfo();		
	int updateCloseStoreInfoTest();	//테스트 테이블
	int updateStoreOrgStatus02();
	
	
	void getCoordinatesToStoreInfo(); //store info
	void getCoordinatesToStoreInfoTest();//store info test
	
	void batchStoreOrgBulkInsert(); //store org 엑셀 업로드
	void batchStoreOrgPstmtInsert() throws SQLException; //store org 엑셀 업로드
}
