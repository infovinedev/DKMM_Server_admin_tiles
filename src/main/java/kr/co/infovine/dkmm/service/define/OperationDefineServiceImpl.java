package kr.co.infovine.dkmm.service.define;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfo;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.mapper.define.TDefineWorkMapper;
import kr.co.infovine.dkmm.mapper.user.TUserInfoMapper;
import lombok.extern.slf4j.Slf4j;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateServiceImpl.java
 * 2021-05-27 Made by Duhyun, Kim
 */
@Service
@Slf4j
public class OperationDefineServiceImpl implements OperationDefineService{
	
	@Autowired
	TDefineWorkMapper defineWorkMapper;
	
	@Override
	public List<TDefineWork> selectAlldefineWork(TDefineWork defineWork) {
		return defineWorkMapper.selectAlldefineWork(defineWork);
	}
	
	
	@Override
	public TDefineWork selectdefineWorkDetail(TDefineWork defineWork) { 
		return defineWorkMapper.selectdefineWorkDetail(defineWork); 
	}
	
	@Override
	public void upDateDefineWork(TDefineWork defineWork) {
		defineWorkMapper.upDateDefineWork(defineWork);
	}
	
	@Override
	public void insertDefineWork(TDefineWork defineWork) {
		defineWorkMapper.insertDefineWork(defineWork);
	}
	 
}
