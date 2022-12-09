package kr.co.infovine.dkmm.service.faq;

import java.util.List;

import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.faq.TFaq;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

public interface OperationFaqService {
    List<TFaq> selectFaqAllList(TFaq faq);
    
    /*
    TBoard selectboardListDetail(TBoard board);
    
    //수정
    int insertBoard(TBoard board);
    //수정
    int updateBoard(TBoard board);
    //삭제
    int deleteBoard(Integer boardSeq);
*/
}
