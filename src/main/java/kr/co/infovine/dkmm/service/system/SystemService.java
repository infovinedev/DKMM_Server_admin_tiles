package kr.co.infovine.dkmm.service.system;

import java.util.List;

import kr.co.infovine.dkmm.db.model.define.TDefineNameStop;

public interface SystemService {
	List<TDefineNameStop> selectAll(TDefineNameStop row);
	
	int insert(TDefineNameStop row);
	
	int updateByPrimaryKey(TDefineNameStop row);
	
	int deleteByPrimaryKey(int stopSeq);
}
