package kr.co.infovine.dkmm.mapper.define;

import java.util.List;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfo;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;

public interface TDefineWorkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_work
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    int deleteByPrimaryKey(Integer workSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_work
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    int insert(TDefineWork row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_work
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    TDefineWork selectByPrimaryKey(Integer workSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_work
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    List<TDefineWork> selectAll();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_work
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    int updateByPrimaryKey(TDefineWork row);
    
    //회원정보 조회
    List<TDefineWork> selectAlldefineWork(TDefineWork defineWork);
    
    TDefineWork selectdefineWorkDetail(TDefineWork defineWork);
    
    void upDateDefineWork(TDefineWork defineWork);
    void insertDefineWork(TDefineWork defineWork);
    
}