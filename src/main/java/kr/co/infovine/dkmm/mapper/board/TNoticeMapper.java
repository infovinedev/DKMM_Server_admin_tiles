package kr.co.infovine.dkmm.mapper.board;

import java.util.List;

import kr.co.infovine.dkmm.db.model.board.TNotice;

public interface TNoticeMapper {
	
	int deleteByPrimaryKey(int noticeSeq);
    
	int insert(TNotice row);
	
	int updateByPrimaryKey(TNotice row);
	
	int updateDispExclusion(TNotice row);
	
	List<TNotice> selecTNoticeAllList(TNotice row);
	
	TNotice selecTNoticeDetail(TNotice row);
}