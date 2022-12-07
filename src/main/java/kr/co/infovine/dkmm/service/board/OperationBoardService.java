package kr.co.infovine.dkmm.service.board;

import java.util.List;

import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateService.java
 * 2021-05-27 Made by Duhyun, Kim
 */
public interface OperationBoardService {
    List<TBoard> selectboardAllList(TBoard board);
    /*
    TStoreInfoModel selectStoreInfoDetail(TStoreInfoModel storeInfo);
    void insertStoreInfo(TStoreInfoModel storeInfo);
    */
}
