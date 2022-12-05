package kr.co.infovine.dkmm.service.userLeave;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.db.model.userLeave.TUserLeave;
import kr.co.infovine.dkmm.mapper.user.TUserInfoMapper;
import kr.co.infovine.dkmm.mapper.userLeave.TUserLeaveMapper;
import lombok.extern.slf4j.Slf4j;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateServiceImpl.java
 * 2021-05-27 Made by Duhyun, Kim
 */
@Service
@Slf4j
public class OperationUserLeaveServiceImpl implements OperationUserLeaveService{
	@Autowired
	TUserLeaveMapper userLeaveMapper;
	
	@Override
	public List<TUserLeave> selectAllUserLeave(TUserLeave userLeave) {
		return userLeaveMapper.selectAllUserLeave(userLeave);
	}
/*	
	@Override
	public TUserInfo selectUserInfoDetail(TUserInfo userInfo) {
		return userInfoMapper.selectDetail(userInfo);
	}*/
}
