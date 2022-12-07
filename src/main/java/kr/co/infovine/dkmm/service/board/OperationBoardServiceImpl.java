package kr.co.infovine.dkmm.service.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.mapper.board.TBoardMapper;
import lombok.extern.slf4j.Slf4j;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateServiceImpl.java
 * 2021-05-27 Made by Duhyun, Kim
 */
@Service
@Slf4j
public class OperationBoardServiceImpl implements OperationBoardService{
	
	@Autowired
	TBoardMapper boardMapper;
	
	@Override
	public List<TBoard> selectboardAllList(TBoard board) {
		return boardMapper.selectboardAllList(board);
	}
	/*
	@Override
	public TStoreInfoModel selectStoreInfoDetail(TStoreInfoModel storeInfo) {
		return storeInfoMapper.selectDetail(storeInfo);
	}

	@Override
	public void insertStoreInfo(TStoreInfoModel storeInfo) {
		storeInfoMapper.insertStoreInfo(storeInfo);
	}
	*/
}
