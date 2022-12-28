package kr.co.infovine.dkmm.service.store;

import java.sql.SQLException;

public interface StoreMetaBatchService {
	
	void batchStoreInfo(String flag); 					//STORE_ORG_EXCEL  =>  STORE INFO Merge 배치
	
	int mergeStoreInfo();		
	int updateStoreOrgStatus01();	
	int updateCloseStoreInfo();		
	int updateStoreOrgStatus02();
	int updateCafeCtgry();
	int updateCafeName();
	int truncateStoreOrgExcel();
	
	void getCoordinatesToStoreInfo(String flag); 		//STORE INFO 좌표정보 배치
	
	@Deprecated
	void batchStoreOrgBulkInsert(); //store org 엑셀 업로드
	@Deprecated
	void batchStoreOrgPstmtInsert() throws SQLException; //store org 엑셀 업로드
	
	void batchStoreOrgBulkInsertToExcelStreaming(String flag); //STORE_ORG_EXCEL 엑셀 업로드 배치
}
