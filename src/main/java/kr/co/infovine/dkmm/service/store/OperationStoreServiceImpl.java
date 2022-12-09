package kr.co.infovine.dkmm.service.store;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
