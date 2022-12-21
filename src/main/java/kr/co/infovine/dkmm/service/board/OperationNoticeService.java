package kr.co.infovine.dkmm.service.board;

import java.util.List;

import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.db.model.board.TNotice;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

public interface OperationNoticeService {
	
    List<TNotice> selecTNoticeAllList(TNotice row);
    
    TNotice selecTNoticeDetail(TNotice row);
    
    int insertNotice(TNotice row);

    int updateNotice(TNotice row);

    int deleteNotice(int noticeSeq);
}
