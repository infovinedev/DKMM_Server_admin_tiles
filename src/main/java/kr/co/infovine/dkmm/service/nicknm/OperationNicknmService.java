package kr.co.infovine.dkmm.service.nicknm;

import java.util.List;

import kr.co.infovine.dkmm.db.model.faq.TFaq;
import kr.co.infovine.dkmm.db.model.nicknm.TDefineNicknm;

public interface OperationNicknmService {
    List<TDefineNicknm> selectAlldefineNicknm(TDefineNicknm defineNicknm);
    TDefineNicknm selectNicknmDetail(TDefineNicknm defineNicknm);
    
    //수정
    int insertFaq(TDefineNicknm defineNicknm);
    //수정
    int updateFaq(TDefineNicknm defineNicknm);
    //삭제
    int deleteFaq(Integer nickSeq);
}
