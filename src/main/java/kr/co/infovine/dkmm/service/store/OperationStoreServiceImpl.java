package kr.co.infovine.dkmm.service.store;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.store.TStoreInfo;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoMapper;
import lombok.extern.slf4j.Slf4j;


/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateServiceImpl.java
 * 2021-05-27 Made by Duhyun, Kim
 */
@Service
@Slf4j
public class OperationStoreServiceImpl implements OperationStoreService{
	
	@Autowired
	TStoreInfoMapper storeInfoMapper;
	
	@Override
	public List<TStoreInfo> selectStoreInfo(TStoreInfo storeInfo) {
		return storeInfoMapper.selectStoreInfo(storeInfo);
	}
	
	@Override
	public TStoreInfo selectStoreInfoDetail(TStoreInfo storeInfo) {
		return storeInfoMapper.selectDetail(storeInfo);
	}

	@Override
	public void insertStoreInfo(TStoreInfo storeInfo) {
		storeInfoMapper.insertStoreInfo(storeInfo);
	}
}
