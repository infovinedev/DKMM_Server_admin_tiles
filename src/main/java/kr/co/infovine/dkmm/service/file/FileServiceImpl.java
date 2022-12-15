package kr.co.infovine.dkmm.service.file;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.mapper.file.TFileMapper;
import kr.co.infovine.dkmm.mapper.file.TFileSubMapper;

@Service
public class FileServiceImpl implements FileService {
	@Autowired
	TFileMapper tFileMapper;
	
	@Autowired
	TFileSubMapper tFileSubMapper;
}
