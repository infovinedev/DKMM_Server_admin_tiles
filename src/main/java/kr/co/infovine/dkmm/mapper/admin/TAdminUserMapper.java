package kr.co.infovine.dkmm.mapper.admin;

import java.util.List;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserModel;

public interface TAdminUserMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TB_Admin_User
     *
     * @mbg.generated Mon May 10 14:15:56 KST 2021
     */
    int deleteByPrimaryKey(Integer adminUserSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TB_Admin_User
     *
     * @mbg.generated Mon May 10 14:15:56 KST 2021
     */
    int insert(TbAdminUserModel record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TB_Admin_User
     *
     * @mbg.generated Mon May 10 14:15:56 KST 2021
     */
    TbAdminUserModel selectByPrimaryKey(Integer adminUserSeq);
    
    /**
     * create By Duhyun, Kim
     * 2021-08-13
     */
    TbAdminUserModel selectByScaleDownPrimaryKey(Integer adminUserSeq);
    

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TB_Admin_User
     *
     * @mbg.generated Mon May 10 14:15:56 KST 2021
     */
    TbAdminUserModel selectByUserIdAndPassword(TbAdminUserModel record);
    
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TB_Admin_User
     *
     * @mbg.generated Mon May 10 14:15:56 KST 2021
     */
    TbAdminUserModel selectByUserId(TbAdminUserModel record);
    
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TB_Admin_User
     *
     * @mbg.generated Mon May 10 14:15:56 KST 2021
     */
    List<TbAdminUserModel> selectAll();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table TB_Admin_User
     *
     * @mbg.generated Mon May 10 14:15:56 KST 2021
     */
    int updateByPrimaryKey(TbAdminUserModel record);
    
    int updateByUserId(TbAdminUserModel record);
    
    int updateByPassword(TbAdminUserModel record);
    
    int updateByBlock(TbAdminUserModel record);
    
}