package kr.co.infovine.dkmm.service.define;

import java.util.HashMap;
import java.util.List;

import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

public interface OperationDefineService {
    List<TDefineWork> selectAlldefineWork(TDefineWork defineWork);
    TDefineWork selectdefineWorkDetail(TDefineWork defineWork);
    List<TDefineWork> selectDefineWorkGetNicknm(TDefineWork defineWork);
    
    void upDateDefineWork(TDefineWork defineWork);
    void insertDefineWork(TDefineWork defineWork);
    
    List<HashMap<String, Object>> selectDefineWorkStat(TDefineWork defineWork);
    List<TDefineWork> selectUserDefineWorkList(TDefineWork defineWork);
}
