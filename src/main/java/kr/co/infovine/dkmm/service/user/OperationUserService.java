package kr.co.infovine.dkmm.service.user;

import java.util.List;

import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateService.java
 * 2021-05-27 Made by Duhyun, Kim
 */
public interface OperationUserService {
    List<TUserInfo> selectAllUserInfo(TUserInfo userInfo);
    TUserInfo selectUserInfoDetail(TUserInfo userInfo);
}
