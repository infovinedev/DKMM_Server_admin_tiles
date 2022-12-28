package kr.co.infovine.dkmm.mapper.user;

import java.util.List;

import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;

public interface TUserInfoMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_user_info
     *
     * @mbg.generated Tue Nov 22 17:05:02 KST 2022
     */
    int deleteByPrimaryKey(Integer userSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_user_info
     *
     * @mbg.generated Tue Nov 22 17:05:02 KST 2022
     */
    int insert(TUserInfo row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_user_info
     *
     * @mbg.generated Tue Nov 22 17:05:02 KST 2022
     */
    TUserInfo selectByPrimaryKey(Integer userSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_user_info
     *
     * @mbg.generated Tue Nov 22 17:05:02 KST 2022
     */
    List<TUserInfo> selectAll();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_user_info
     *
     * @mbg.generated Tue Nov 22 17:05:02 KST 2022
     */
    int updateByPrimaryKey(TUserInfo row);
    
    //회원정보 조회
    List<TUserInfo> selectUserInfo(TUserInfo userInfo);
    //회원정보 상세보기
    TUserInfo selectDetail(TUserInfo userInfo);
    
    int selectLivePhoneUserCnt(TUserInfo userInfo);
}