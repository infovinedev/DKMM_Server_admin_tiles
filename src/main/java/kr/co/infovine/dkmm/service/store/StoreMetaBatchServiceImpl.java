package kr.co.infovine.dkmm.service.store;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.mapper.store.TStoreInfoMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoOrgMapper;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoTestMapper;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class StoreMetaBatchServiceImpl implements StoreMetaBatchService{
	
	@Autowired
	TStoreInfoMapper tStoreInfoMapper;
	
	@Autowired
	TStoreInfoTestMapper tStoreInfoTestMapper;
	
	@Autowired
	TStoreInfoOrgMapper tStoreInfoOrgMapper;
	
	
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
	
	/* STORE_INFO 정보 update  */
	@Override
	public int mergeStoreInfo() {
		return tStoreInfoTestMapper.mergeStoreInfo();
//		return tStoreInfoTestMapper.mergeStoreInfo();
	}
	
	/* STORE_ORG 영업중 상점 process_yn update  */
	@Override
	public int updateStoreOrgStatus01() {
		return tStoreInfoOrgMapper.updateStoreOrgStatus01();
	}
	
	/* STORE_INFO 폐업 상점 update  */
	@Override
	public int updateCloseStoreInfo() {
		return tStoreInfoTestMapper.updateCloseStoreInfo();
//		return tStoreInfoMapper.updateCloseStoreInfo();
	}
	
	/* STORE_ORG 폐업 상점 process_yn update  */
	@Override
	public int updateStoreOrgStatus02() {
		return tStoreInfoOrgMapper.updateStoreOrgStatus02();
	}

	

}
