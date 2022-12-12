package kr.co.infovine.dkmm.service.admin;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import kr.co.infovine.dkmm.db.model.admin.TbAdminPermissionModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminProgramModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserLogModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserModel;
import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;

public interface TAdminService {
	public TbAdminUserModel selectByAdminUserIdAndPassword(TbAdminUserModel tbAdminUser);
	
	public TbAdminUserModel selectByAdminUserId(TbAdminUserModel tbAdminUser);
	
	public int updateByAdminUserUserId(TbAdminUserModel tbAdminUser);
	
	public int updateByAdminUserPrimaryKey(TbAdminUserModel tbAdminUser);
	
    int deleteByPrimaryKey(Integer adminUserSeq);

    int insertAdminUser(TbAdminUserModel record);
    
    int updateByAdminUserBlock(TbAdminUserModel record);
    
    TbAdminUserModel selectByAdminUserPrimaryKey(int adminUserSeq);

    List<TbAdminUserModel> selectAllAdminUser(TbAdminUserModel tbAdminUserModel);
    
    public int updateByAdminUserPassword(TbAdminUserModel tbAdminUser);
    
    public int insertPermissionOfAdminUser(TbAdminPermissionModel tbAdminPermissionModel);
    
    public int deletePermissionOfAdminUser(int adminUserSeq);
    
	public List<TbAdminPermissionModel> selectByUserLeftMenu(int adminUserSeq);
	
	public List<TbAdminProgramModel> selectAllProgramMenu(TbAdminProgramModel programMenu);
	
	TbAdminProgramModel selectNextProgramId(TbAdminProgramModel programMenu);
	 
	public int insertByProgramMenu(TbAdminProgramModel record);
	
	public int updateByProgramMenu(TbAdminProgramModel record);
	
	public int deleteByProgramMenu(int adminProgramSeq);

	public int insertAdminUserLog(TbAdminUserLogModel record);
	
	public List<TbAdminUserLogModel> selectByPrimaryKey(String startDate, String closeDate);
	
	//공통코드 조회
	List<TCommonCodeModel> selectAllTbCommonCode(TCommonCodeModel record);
	
	List<TCommonCodeModel> selectCodeGroup();
	
	//공통코드 추가
	int insertTCommonCode(TCommonCodeModel row);
	//공통코드 수정
	int updateByTbCommonCodePrimaryKey(TCommonCodeModel record);
	//공통코드 삭제
	int deleteByTCommonCodePrimaryKey(@Param("codeGroup") String codeGroup, @Param("codeValue") String codeValue);
	
}
