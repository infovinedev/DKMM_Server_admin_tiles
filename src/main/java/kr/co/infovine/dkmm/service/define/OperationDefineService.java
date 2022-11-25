package kr.co.infovine.dkmm.service.define;

import java.util.List;

import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateService.java
 * 2021-05-27 Made by Duhyun, Kim
 */
public interface OperationDefineService {
    List<TDefineWork> selectAlldefineWork(TDefineWork defineWork);
    TDefineWork selectdefineWorkDetail(TDefineWork defineWork);
    
    void upDateDefineWork(TDefineWork defineWork);
    void insertDefineWork(TDefineWork defineWork);
}
