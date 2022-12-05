package kr.co.infovine.dkmm.service.store;

import java.sql.SQLException;

public interface StoreMetaBatchService {
	
	void batchStoreInfo(); 
	
	int mergeStoreInfo();		
	int updateStoreOrgStatus01();	
	int updateCloseStoreInfo();		
	int updateStoreOrgStatus02();
	
	void getCoordinatesToStoreInfo(); //store info
	
	void batchStoreOrgBulkInsert(); //store org 엑셀 업로드
	void batchStoreOrgPstmtInsert() throws SQLException; //store org 엑셀 업로드
}
