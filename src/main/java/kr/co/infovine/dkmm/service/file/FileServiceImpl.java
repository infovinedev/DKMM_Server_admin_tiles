package kr.co.infovine.dkmm.service.file;

import kr.co.infovine.dkmm.db.model.file.TFileModel;
import kr.co.infovine.dkmm.db.model.file.TFileSubModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.mapper.file.TFileMapper;
import kr.co.infovine.dkmm.mapper.file.TFileSubMapper;

import java.util.List;

@Service
public class FileServiceImpl implements FileService {
	@Autowired
	TFileMapper tFileMapper;
	
	@Autowired
	TFileSubMapper tFileSubMapper;

	@Override
	public int deleteFileByPrimaryKey(Integer fileSeq) {
		return tFileMapper.deleteByPrimaryKey(fileSeq);
	}
	
	@Override
	public int insertFile(TFileModel row) {
		return tFileMapper.insert(row);
	}

	@Override
	public TFileModel selectFileByPrimaryKey(Integer fileSeq) {
		return tFileMapper.selectByPrimaryKey(fileSeq);
	}

	@Override
	public List<TFileModel> selectAllFile() {
		return tFileMapper.selectAll();
	}

	@Override
	public int updateFileByPrimaryKey(TFileModel row) {
		return tFileMapper.updateByPrimaryKey(row);
	}

	@Override
	public int deleteFileSubByPrimaryKey(Integer fileSubSeq) {
		return tFileSubMapper.deleteByPrimaryKey(fileSubSeq);
	}

	@Override
	public int insertFileSub(TFileSubModel row) {
		return tFileSubMapper.insert(row);
	}

	@Override
	public TFileSubModel selectFileSubByPrimaryKey(Integer fileSubSeq) {
		return tFileSubMapper.selectByPrimaryKey(fileSubSeq);
	}

	@Override
	public List<TFileSubModel> selectAllFileSub() {
		return tFileSubMapper.selectAll();
	}

	@Override
	public int updateFileSubByPrimaryKey(TFileSubModel row) {
		return tFileSubMapper.updateByPrimaryKey(row);
	}

	@Override
	public int insertUploadFile(TFileModel row, TFileSubModel row2) {
		int cnt = tFileMapper.insert(row);
		cnt += tFileSubMapper.insert(row2);
		return cnt;
	}
}
