package kr.co.infovine.dkmm.service.faq;

import java.util.List;

import kr.co.infovine.dkmm.db.model.board.TBoard;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.faq.TFaq;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

public interface OperationFaqService {
    List<TFaq> selectFaqAllList(TFaq faq);
    
    TFaq selectFaqListDetail(TFaq faq);
    
    //수정
    int insertFaq(TFaq faq);
    //수정
    int updateFaq(TFaq faq);
    //삭제
    int deleteFaq(Integer faqSeq);
    
    int deleteFaqFileData(TFaq faq); 
}
