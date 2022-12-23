package kr.co.infovine.dkmm.mapper.store;

import java.util.List;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoOrgExcel;

public interface TStoreInfoOrgExcelMapper {

    int insert(TStoreInfoOrgExcel row);

    List<TStoreInfoOrgExcel> selectAll();
    
    /* STORE_ORG 신규 작업 Data 카운트 : process_yn = 'N'  */
    int selectProcCount();
    
    /* STORE_ORG 영업중 상점 process_yn update  */
	int updateStoreOrgStatus01();
	
	/* STORE_ORG 폐업 상점 process_yn update  */
	int updateStoreOrgStatus02();
	
	/* STORE_ORG 엑셀 상점 update  */
	int bulkInsert(List<TStoreInfoOrgExcel> row);
	
	int truncateStoreOrgExcel();
}