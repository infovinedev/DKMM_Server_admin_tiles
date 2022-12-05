package kr.co.infovine.dkmm.service.userLeave;

import java.util.List;

import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.db.model.userLeave.TUserLeave;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateService.java
 * 2021-05-27 Made by Duhyun, Kim
 */
public interface OperationUserLeaveService {
    List<TUserLeave> selectAllUserLeave(TUserLeave userLeave);
    //TUserInfo selectUserInfoDetail(TUserInfo userInfo);
}
