package kr.co.infovine.dkmm.service.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.mapper.board.TBoardMapper;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class OperationBoardServiceImpl implements OperationBoardService{
	
	@Autowired
	TBoardMapper boardMapper;
	
	@Override
	public List<TBoard> selectboardAllList(TBoard board) {
		return boardMapper.selectboardAllList(board);
	}
	
	@Override
	public TBoard selectboardListDetail(TBoard board) {
		return boardMapper.selectBoardDetail(board);
	}
	
	@Override 
	public int insertBoard(TBoard board) {
		return boardMapper.insert(board); 
	}
	
	@Override 
	public int updateBoard(TBoard board) {
		return boardMapper.updateByPrimaryKey(board); 
	}
	
	@Override 
	public int deleteBoard(Integer boardSeq) {
		return boardMapper.deleteByPrimaryKey(boardSeq); 
	}
	
	@Override 
	public int deleteBoardFileData(TBoard board) {
		return boardMapper.deleteBoardFileData(board); 
	}
}
