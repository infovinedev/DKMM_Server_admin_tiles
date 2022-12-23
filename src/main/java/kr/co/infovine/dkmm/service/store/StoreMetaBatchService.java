package kr.co.infovine.dkmm.service.store;

import java.sql.SQLException;

public interface StoreMetaBatchService {
	
	void batchStoreInfo(); 
	
	int mergeStoreInfo();		
	int updateStoreOrgStatus01();	
	int updateCloseStoreInfo();		
	int updateStoreOrgStatus02();
	int updateCafeCtgry();
	int updateCafeName();
	int truncateStoreOrgExcel();
	
	void getCoordinatesToStoreInfo(); //store info
	
	@Deprecated
	void batchStoreOrgBulkInsert(); //store org 엑셀 업로드
	@Deprecated
	void batchStoreOrgPstmtInsert() throws SQLException; //store org 엑셀 업로드
	
	void batchStoreOrgBulkInsertToExcelStreaming(); //store org 엑셀 업로드
}
