package kr.co.infovine.dkmm.service.admin;

import java.util.List;

import kr.co.infovine.dkmm.db.model.admin.TbAdminPermissionModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminProgramModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserLogModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserModel;

public interface TbAdminService {
	public TbAdminUserModel selectByAdminUserIdAndPassword(TbAdminUserModel tbAdminUser);
	
	public TbAdminUserModel selectByAdminUserId(TbAdminUserModel tbAdminUser);
	
	public int updateByAdminUserUserId(TbAdminUserModel tbAdminUser);
	
	public int updateByAdminUserPrimaryKey(TbAdminUserModel tbAdminUser);
	
    int deleteByPrimaryKey(Integer adminUserSeq);

    int insertAdminUser(TbAdminUserModel record);
    
    int updateByAdminUserBlock(TbAdminUserModel record);
    
    TbAdminUserModel selectByAdminUserPrimaryKey(Integer adminUserSeq);

    List<TbAdminUserModel> selectAllAdminUser();
    
    public int updateByAdminUserPassword(TbAdminUserModel tbAdminUser);
    
    public int insertPermissionOfAdminUser(TbAdminPermissionModel tbAdminPermissionModel);
    
    public int deletePermissionOfAdminUser(int adminUserSeq);
    
	public List<TbAdminPermissionModel> selectByUserLeftMenu(int adminUserSeq);
	
	public List<TbAdminProgramModel> selectAllProgramMenu(TbAdminProgramModel programMenu);
	
	public int insertByProgramMenu(TbAdminProgramModel record);
	
	public int updateByProgramMenu(TbAdminProgramModel record);
	
	public int deleteByProgramMenu(int adminProgramSeq);

	public int insertAdminUserLog(TbAdminUserLogModel record);
	
	public List<TbAdminUserLogModel> selectByPrimaryKey(String startDate, String closeDate);
}
