package kr.co.infovine.dkmm.service.system;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.define.TDefineNameStop;
import kr.co.infovine.dkmm.mapper.define.TDefineNameStopMapper;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class SystemServiceImpl implements SystemService{
	
	@Autowired
	TDefineNameStopMapper tDefineNameStopMapper;
	
	@Override
	public List<TDefineNameStop> selectAll(TDefineNameStop row) {
		return tDefineNameStopMapper.selectAll(row);
	}
}
