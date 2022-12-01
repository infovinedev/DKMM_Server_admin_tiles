package kr.co.infovine.dkmm.service.defineApproval;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
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
public class OperationDefineApprovalServiceImpl implements OperationDefineApprovalService{
	
	@Autowired
	TDefineWorkMapper defineWorkMapper;
	
	@Override
	public List<TDefineWork> selectAlldefineWorkApproval(TDefineWork defineWork) {
		return defineWorkMapper.selectAlldefineWorkApproval(defineWork);
	}
	
	@Override 
	public TDefineWork selectdefineWorkApprovalDetail(TDefineWork defineWork) {
		return defineWorkMapper.selectdefineWorkApprovalDetail(defineWork);
	}
	
	@Override 
	public void upDateAllDefineWork(TDefineWork defineWork) {
		defineWorkMapper.upDateAllDefineWork(defineWork); 
	}
	
	@Override 
	public void upDateApproval(TDefineWork defineWork) {
		defineWorkMapper.upDateApproval(defineWork); 
	}
	
	@Override
	public void upDateUseYn(TDefineWork defineWork) {
		defineWorkMapper.upDateUseYn(defineWork);
	}
	
	@Override 
	public TDefineWork selectNickComment(TDefineWork defineWork) {
		return defineWorkMapper.selectNickComment(defineWork);
	}
	
	
	/*
	 *
	 ** @Override public List<TDefineWork> selectDefineWorkGetNicknm(TDefineWork
	 * * defineWork) { return defineWorkMapper.selectDefineWorkGetNicknm(defineWork);
	 * }
	 * 
	 * @Override public void upDateDefineWork(TDefineWork defineWork) {
	 * defineWorkMapper.upDateDefineWork(defineWork); }
	 * 
	 * @Override public void insertDefineWork(TDefineWork defineWork) {
	 * defineWorkMapper.insertDefineWork(defineWork); }
	 */
	 
}
