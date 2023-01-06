package kr.co.infovine.dkmm.service.store;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.mapper.store.TStoreInfoMapper;
import lombok.extern.slf4j.Slf4j;


@Service
@Slf4j
public class OperationStoreServiceImpl implements OperationStoreService{
	
	@Autowired
	TStoreInfoMapper storeInfoMapper;
	
	@Override
	public List<TStoreInfoModel> selectStoreInfo(TStoreInfoModel storeInfo) {
		return storeInfoMapper.selectStoreInfo(storeInfo);
	}
	
	@Override
	public TStoreInfoModel selectStoreInfoDetail(TStoreInfoModel storeInfo) {
		return storeInfoMapper.selectDetail(storeInfo);
	}

	@Override
	public void insertStoreInfo(TStoreInfoModel storeInfo) {
		storeInfoMapper.insertStoreInfo(storeInfo);
	}
	
	@Override
	public List<TStoreInfoModel> selectStoreExcel(TStoreInfoModel storeInfo) {
		return storeInfoMapper.selectStoreExcel(storeInfo);
	}
	 
	@Override
	public int selectStoreCount(TStoreInfoModel storeInfo) {
		return storeInfoMapper.selectStoreCount(storeInfo);
	}

	@Override
	public List<TStoreInfoModel> selectUserStoreWaitExcel(TStoreInfoModel storeInfo) {
		return storeInfoMapper.selectUserStoreWaitExcel(storeInfo);
	}

	@Override
	public List<TStoreInfoModel> selectUserStoreLikeExcel(TStoreInfoModel storeInfo) {
		return storeInfoMapper.selectUserStoreLikeExcel(storeInfo);
	}
	
	@Override
	public List<TStoreInfoModel> selectStoreCatgryList() {
		return storeInfoMapper.selectStoreCatgryList();
	}
}
