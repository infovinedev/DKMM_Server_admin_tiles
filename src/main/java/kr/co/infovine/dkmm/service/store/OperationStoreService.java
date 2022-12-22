package kr.co.infovine.dkmm.service.store;

import java.util.List;

import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

public interface OperationStoreService {
    List<TStoreInfoModel> selectStoreInfo(TStoreInfoModel storeInfo);
    TStoreInfoModel selectStoreInfoDetail(TStoreInfoModel storeInfo);
    void insertStoreInfo(TStoreInfoModel storeInfo);
    List<TStoreInfoModel> selectStoreExcel(TStoreInfoModel storeInfo);
    int selectStoreCount(TStoreInfoModel storeInfo);
}
