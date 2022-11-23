package kr.co.infovine.dkmm.service.store;

public interface StoreMetaBatchService {
	
	void batchStoreInfo();
	
	int mergeStoreInfo();			
	int updateStoreOrgStatus01();	
	int updateCloseStoreInfo();		
	int updateStoreOrgStatus02();	
}
