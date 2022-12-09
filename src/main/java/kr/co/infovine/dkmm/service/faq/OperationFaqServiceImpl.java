package kr.co.infovine.dkmm.service.faq;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.db.model.faq.TFaq;
import kr.co.infovine.dkmm.mapper.board.TBoardMapper;
import kr.co.infovine.dkmm.mapper.faq.TFaqMapper;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class OperationFaqServiceImpl implements OperationFaqService{
	
	@Autowired
	TFaqMapper faqMapper;
	
	@Override
	public List<TFaq> selectFaqAllList(TFaq faq) {
		return faqMapper.selectFaqAllList(faq);
	}
	/*
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
	}*/
}
