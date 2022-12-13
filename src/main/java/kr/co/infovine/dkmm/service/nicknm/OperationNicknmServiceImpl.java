package kr.co.infovine.dkmm.service.nicknm;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.faq.TFaq;
import kr.co.infovine.dkmm.db.model.nicknm.TDefineNicknm;
import kr.co.infovine.dkmm.mapper.nicknm.TDefineNicknmMapper;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class OperationNicknmServiceImpl implements OperationNicknmService{
	
	
	@Autowired
	TDefineNicknmMapper defineNicknmMapper;
	
	@Override
	public List<TDefineNicknm> selectAlldefineNicknm(TDefineNicknm defineNicknm) {
		return defineNicknmMapper.selectAlldefineNicknm(defineNicknm);
	}
	
	@Override
	public TDefineNicknm selectNicknmDetail(TDefineNicknm defineNicknm) { 
		return defineNicknmMapper.selectNicknmDetail(defineNicknm); 
	}
	
	@Override 
	public int insertFaq(TDefineNicknm defineNicknm) {
		return defineNicknmMapper.insert(defineNicknm); 
	}
	
	@Override 
	public int updateFaq(TDefineNicknm defineNicknm) {
		return defineNicknmMapper.updateByPrimaryKey(defineNicknm); 
	}
	
	@Override 
	public int deleteFaq(Integer nickSeq) {
		return defineNicknmMapper.deleteByPrimaryKey(nickSeq); 
	}
}
