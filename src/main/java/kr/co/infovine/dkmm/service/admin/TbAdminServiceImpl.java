package kr.co.infovine.dkmm.service.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.admin.TbAdminPermissionModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminProgramModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserLogModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserModel;
import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.mapper.admin.TAdminPermissionMapper;
import kr.co.infovine.dkmm.mapper.admin.TAdminProgramMapper;
import kr.co.infovine.dkmm.mapper.admin.TAdminUserLogMapper;
import kr.co.infovine.dkmm.mapper.admin.TAdminUserMapper;
import kr.co.infovine.dkmm.mapper.common.TCommonCodeMapper;

@Service("tbAdminService")
public class TbAdminServiceImpl implements TbAdminService {
	@Autowired
	TAdminUserMapper tbAdminUserMapper;
	
	@Autowired
	TAdminProgramMapper tbAdminProgramMapper;  
	
	@Autowired
	TAdminPermissionMapper tbAdminPermissionMapper;
	
	@Autowired
	TAdminUserLogMapper tbAdminUserLogMapper;
	
	@Autowired
	TCommonCodeMapper tcommonCodeMapper;
	
	@Override
	public TbAdminUserModel selectByAdminUserIdAndPassword(TbAdminUserModel tbAdminUser) {
		return tbAdminUserMapper.selectByUserIdAndPassword(tbAdminUser);
	}

	@Override
	public TbAdminUserModel selectByAdminUserId(TbAdminUserModel tbAdminUser) {
		return tbAdminUserMapper.selectByUserId(tbAdminUser);
	}
	
	@Override
	public int updateByAdminUserUserId(TbAdminUserModel tbAdminUser) {
		return tbAdminUserMapper.updateByUserId(tbAdminUser);
	}
	
	
	@Override
	public int updateByAdminUserPrimaryKey(TbAdminUserModel tbAdminUser) {
		return tbAdminUserMapper.updateByPrimaryKey(tbAdminUser);
	}
	
	@Override
	public int updateByAdminUserBlock(TbAdminUserModel record) {
		return tbAdminUserMapper.updateByBlock(record);
	}

	@Override
	public List<TbAdminPermissionModel> selectByUserLeftMenu(int adminUserSeq) {
		return tbAdminPermissionMapper.selectByUserLeftMenu(adminUserSeq);
	}

	@Override
	public List<TbAdminProgramModel> selectAllProgramMenu(TbAdminProgramModel programMenu) {
		return tbAdminProgramMapper.selectAll(programMenu);
	}

	@Override
	public int insertByProgramMenu(TbAdminProgramModel record) {
		return tbAdminProgramMapper.insert(record);
	}

	@Override
	public int updateByProgramMenu(TbAdminProgramModel record) {
		return tbAdminProgramMapper.updateByPrimaryKey(record);
	}

	@Override
	public int deleteByProgramMenu(int adminProgramSeq) {
		return tbAdminProgramMapper.deleteByPrimaryKey(adminProgramSeq);
	}

	@Override
	public int deleteByPrimaryKey(Integer adminUserSeq) {
		return tbAdminUserMapper.deleteByPrimaryKey(adminUserSeq);
	}

	@Override
	public int insertAdminUser(TbAdminUserModel record) {
		return tbAdminUserMapper.insert(record);
	}

	@Override
	public TbAdminUserModel selectByAdminUserPrimaryKey(Integer adminUserSeq) {
		return tbAdminUserMapper.selectByPrimaryKey(adminUserSeq);
	}

	@Override
	public List<TbAdminUserModel> selectAllAdminUser() {
		return tbAdminUserMapper.selectAll();
	}

	@Override
	public int updateByAdminUserPassword(TbAdminUserModel tbAdminUser) {
		return tbAdminUserMapper.updateByPassword(tbAdminUser);
	}

	@Override
	public int insertPermissionOfAdminUser(TbAdminPermissionModel tbAdminPermissionModel) {
		return tbAdminPermissionMapper.insert(tbAdminPermissionModel);
	}

	@Override
	public int deletePermissionOfAdminUser(int adminUserSeq) {
		return tbAdminPermissionMapper.deleteByAdminUserSeq(adminUserSeq);
	}

	@Override
	public int insertAdminUserLog(TbAdminUserLogModel record) {
		return tbAdminUserLogMapper.insert(record);
	}

	@Override
	public List<TbAdminUserLogModel> selectByPrimaryKey(String startDate, String closeDate) {
		return tbAdminUserLogMapper.selectByPrimaryKey(startDate, closeDate);
	}
	
	
	@Override
	public int insertTCommonCode(TCommonCodeModel row) {
		return tcommonCodeMapper.insert(row);
	}
	
	@Override
	public int updateByTbCommonCodePrimaryKey(TCommonCodeModel record) {
		return tcommonCodeMapper.updateByPrimaryKey(record);
	}
	
	@Override
	public int deleteByTCommonCodePrimaryKey(String codeGroup, String codeValue) {
		return tcommonCodeMapper.deleteByPrimaryKey(codeGroup, codeValue);
	}

}
