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

@Service
@Slf4j
public class OperationUserLeaveServiceImpl implements OperationUserLeaveService{
	@Autowired
	TUserLeaveMapper userLeaveMapper;
	
	@Autowired
	TUserInfoMapper tUserInfoMapper;
	
	@Override
	public List<TUserLeave> selectAllUserLeave(TUserLeave userLeave) {
		return userLeaveMapper.selectAllUserLeave(userLeave);
	}
	
	@Override
	public TUserLeave selectUserLeaveDetail(TUserLeave userLeave) {
		return userLeaveMapper.selectUserLeaveDetail(userLeave);
	}
	
	@Override
	public int updateRollbackLeave(TUserLeave userLeave) {
		TUserInfo userInfo = new TUserInfo();
		userInfo.setUserSeq(userLeave.getUserSeq());
		
		int liveCnt = tUserInfoMapper.selectLivePhoneUserCnt(userInfo);
		
		if ( liveCnt > 0 ) {
			return 9999;
		}else {
			return userLeaveMapper.updateRollbackLeave(userLeave);
		}
	}
	
}
