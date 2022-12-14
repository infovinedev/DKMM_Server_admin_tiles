package kr.co.infovine.dkmm.service.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.mapper.user.TUserInfoMapper;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class OperationUserServiceImpl implements OperationUserService{
	@Autowired
	TUserInfoMapper userInfoMapper;
	
	@Override
	public List<TUserInfo> selectAllUserInfo(TUserInfo userInfo) {
		return userInfoMapper.selectUserInfo(userInfo);
	}
	
	@Override
	public TUserInfo selectUserInfoDetail(TUserInfo userInfo) {
		return userInfoMapper.selectDetail(userInfo);
	}
}
