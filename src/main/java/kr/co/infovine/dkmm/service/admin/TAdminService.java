package kr.co.infovine.dkmm.service.admin;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.co.infovine.dkmm.db.model.admin.TbAdminDefaultPermissionModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminPermissionModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminProgramModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserLogModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserModel;
import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;

public interface TAdminService {
	TbAdminUserModel selectByAdminUserIdAndPassword(TbAdminUserModel tbAdminUser);
	
	TbAdminUserModel selectByAdminUserId(TbAdminUserModel tbAdminUser);
	
	int updateByAdminUserUserId(TbAdminUserModel tbAdminUser);
	
	int updateByAdminUserPrimaryKey(TbAdminUserModel tbAdminUser);
	
	int updateByPassword(TbAdminUserModel record);
	
    int deleteByPrimaryKey(Integer adminUserSeq);

    int selectChkIdDup(TbAdminUserModel record);
    
    int insertAdminUser(TbAdminUserModel record);
    
    int updateByAdminUserBlock(TbAdminUserModel record);
    
    TbAdminUserModel selectByAdminUserPrimaryKey(int adminUserSeq);

    List<TbAdminUserModel> selectAllAdminUser(TbAdminUserModel tbAdminUserModel);
    
    int updateByAdminUserPassword(TbAdminUserModel tbAdminUser);
    
    int insertPermissionOfAdminUser(TbAdminPermissionModel tbAdminPermissionModel);
    
    int deletePermissionOfAdminUser(int adminUserSeq);
    
	List<TbAdminPermissionModel> selectByUserLeftMenu(int adminUserSeq);
	
	List<TbAdminProgramModel> selectAllProgramMenu(TbAdminProgramModel programMenu);
	
	TbAdminProgramModel selectNextProgramId(TbAdminProgramModel programMenu);
	 
	int insertByProgramMenu(TbAdminProgramModel record);
	
	int updateByProgramMenu(TbAdminProgramModel record);
	
	int deleteByProgramMenu(int adminProgramSeq);

	int insertAdminUserLog(TbAdminUserLogModel record);
	
	List<TbAdminUserLogModel> selectByPrimaryKey(String startDate, String closeDate);
	
	//공통코드 조회
	List<TCommonCodeModel> selectAllTbCommonCode(TCommonCodeModel record);
	
	List<TCommonCodeModel> selectCodeGroup();
	
	//공통코드 추가
	int insertTCommonCode(TCommonCodeModel row);
	//공통코드 수정
	int updateByTbCommonCodePrimaryKey(TCommonCodeModel record);
	//공통코드 삭제
	int deleteByTCommonCodePrimaryKey(@Param("codeGroup") String codeGroup, @Param("codeValue") String codeValue);
	
	int deleteDefaultPermmissionByPrimaryKey(String roleNm);
	
	int insertDefaultPermmission(TbAdminDefaultPermissionModel record);
	
	List<TbAdminDefaultPermissionModel> selectAllDefaultPermmissionByRole(String roleNm);
}
