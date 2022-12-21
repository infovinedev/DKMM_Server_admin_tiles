package kr.co.infovine.dkmm.service.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.db.model.board.TNotice;
import kr.co.infovine.dkmm.mapper.board.TBoardMapper;
import kr.co.infovine.dkmm.mapper.board.TNoticeMapper;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class OperationNoticeServiceImpl implements OperationNoticeService{
	
	@Autowired
	TNoticeMapper tNoticeMapper;
	
	@Override
	public List<TNotice> selecTNoticeAllList(TNotice row) {
		return tNoticeMapper.selecTNoticeAllList(row);
	}
	
	@Override
	public TNotice selecTNoticeDetail(TNotice row) {
		return tNoticeMapper.selecTNoticeDetail(row);
	}
	
	@Override 
	public int insertNotice(TNotice row) {
		return tNoticeMapper.insert(row); 
	}
	
	@Override 
	public int updateNotice(TNotice row) {
		
		if ( "Y".equals(row.getDispYn()) ) {
			tNoticeMapper.updateDispExclusion(row);
		}
		
		return tNoticeMapper.updateByPrimaryKey(row); 
	}
	
	@Override 
	public int deleteNotice(int noticeSeq) {
		return tNoticeMapper.deleteByPrimaryKey(noticeSeq); 
	}
}
