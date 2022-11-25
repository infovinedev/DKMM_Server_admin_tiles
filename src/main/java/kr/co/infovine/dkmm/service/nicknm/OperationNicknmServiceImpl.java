package kr.co.infovine.dkmm.service.nicknm;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.nicknm.TDefineNicknm;
import kr.co.infovine.dkmm.mapper.define.TDefineWorkMapper;
import kr.co.infovine.dkmm.mapper.nicknm.TDefineNicknmMapper;
import lombok.extern.slf4j.Slf4j;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateServiceImpl.java
 * 2021-05-27 Made by Duhyun, Kim
 */
@Service
@Slf4j
public class OperationNicknmServiceImpl implements OperationNicknmService{
	
	@Autowired
	TDefineWorkMapper defineWorkMapper;
	
	@Autowired
	TDefineNicknmMapper defineNicknmMapper;
	
	@Override
	public List<TDefineNicknm> selectAlldefineNicknm(TDefineNicknm defineNicknm) {
		return defineNicknmMapper.selectAlldefineNicknm(defineNicknm);
	}
	
	
	/*
	 * @Override public TDefineWork selectdefineWorkDetail(TDefineWork defineWork) {
	 * return defineWorkMapper.selectdefineWorkDetail(defineWork); }
	 * 
	 * @Override public void upDateDefineWork(TDefineWork defineWork) {
	 * defineWorkMapper.upDateDefineWork(defineWork); }
	 * 
	 * @Override public void insertDefineWork(TDefineWork defineWork) {
	 * defineWorkMapper.insertDefineWork(defineWork); }
	 */
	 
}
