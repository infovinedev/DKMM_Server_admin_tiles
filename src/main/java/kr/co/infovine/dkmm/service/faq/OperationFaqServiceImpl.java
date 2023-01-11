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
	
	@Override
	public TFaq selectFaqListDetail(TFaq faq) {
		return faqMapper.selectFaqDetail(faq);
	}
	
	
	@Override 
	public int insertFaq(TFaq faq) {
		return faqMapper.insert(faq); 
	}
	
	@Override 
	public int updateFaq(TFaq faq) {
		return faqMapper.updateByPrimaryKey(faq); 
	}
	
	@Override 
	public int deleteFaq(Integer faqSeq) {
		return faqMapper.deleteByPrimaryKey(faqSeq); 
	}
	
	@Override 
	public int deleteFaqFileData(TFaq faq) {
		return faqMapper.deleteFaqFileData(faq); 
	}
	
}
