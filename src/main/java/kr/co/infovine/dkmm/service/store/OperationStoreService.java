package kr.co.infovine.dkmm.service.store;

import java.util.List;

import kr.co.infovine.dkmm.db.model.store.TStoreInfo;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateService.java
 * 2021-05-27 Made by Duhyun, Kim
 */
public interface OperationStoreService {
    List<TStoreInfo> selectStoreInfo(TStoreInfo storeInfo);
    TStoreInfo selectStoreInfoDetail(TStoreInfo storeInfo);
    void insertStoreInfo(TStoreInfo storeInfo);
}
