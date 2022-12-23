package kr.co.infovine.dkmm.mapper.admin;

import java.util.List;
import kr.co.infovine.dkmm.db.model.admin.TbAdminDefaultPermissionModel;


public interface TAdminDefaultPermissionMapper {
   
    int deleteByPrimaryKey(String roleNm);

    int insert(TbAdminDefaultPermissionModel record);
    
    List<TbAdminDefaultPermissionModel> selectAll(String roleNm);


}