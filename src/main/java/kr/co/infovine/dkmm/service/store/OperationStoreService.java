package kr.co.infovine.dkmm.service.store;

import java.util.List;

import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateService.java
 * 2021-05-27 Made by Duhyun, Kim
 */
public interface OperationStoreService {
    List<TStoreInfoModel> selectStoreInfo(TStoreInfoModel storeInfo);
    TStoreInfoModel selectStoreInfoDetail(TStoreInfoModel storeInfo);
    void insertStoreInfo(TStoreInfoModel storeInfo);
}
