package kr.co.infovine.dkmm.service.userLeave;

import java.util.List;

import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.db.model.userLeave.TUserLeave;

public interface OperationUserLeaveService {
    List<TUserLeave> selectAllUserLeave(TUserLeave userLeave);
    TUserLeave selectUserLeaveDetail(TUserLeave userLeave);
    int updateRollbackLeave(TUserLeave userLeave);
}
