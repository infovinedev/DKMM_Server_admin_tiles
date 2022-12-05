package kr.co.infovine.dkmm.mapper.define;

import java.util.List;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
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
    
    //업적정보 조회
    List<TDefineWork> selectAlldefineWork(TDefineWork defineWork);
    //업적 상세정보 조회
    TDefineWork selectdefineWorkDetail(TDefineWork defineWork);
    //업적 칭호 매칭 조회
    List<TDefineWork> selectDefineWorkGetNicknm(TDefineWork defineWork);
    void upDateDefineWork(TDefineWork defineWork);
    void insertDefineWork(TDefineWork defineWork);
    
    
    /****************************************************************여기서 부터 업적승인 등록*****************************************************************/
    List<TDefineWork> selectAlldefineWorkApproval(TDefineWork defineWork);
    
    TDefineWork selectdefineWorkApprovalDetail(TDefineWork defineWork);
    
    void upDateAllDefineWork(TDefineWork defineWork);
    
    void deleteAllDefineWork(TDefineWork defineWork);
    
    void upDateApproval(TDefineWork defineWork);
    
    void upDateUseYn(TDefineWork defineWork);
    
    TDefineWork selectNickComment(TDefineWork defineWork);
    
}