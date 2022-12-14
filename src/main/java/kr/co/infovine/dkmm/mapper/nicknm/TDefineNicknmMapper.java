package kr.co.infovine.dkmm.mapper.nicknm;

import java.util.List;

import kr.co.infovine.dkmm.db.model.nicknm.TDefineNicknm;

public interface TDefineNicknmMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_nicknm
     *
     * @mbg.generated Fri Nov 25 11:29:08 KST 2022
     */
    int deleteByPrimaryKey(int nickSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_nicknm
     *
     * @mbg.generated Fri Nov 25 11:29:08 KST 2022
     */
    int insert(TDefineNicknm row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_nicknm
     *
     * @mbg.generated Fri Nov 25 11:29:08 KST 2022
     */
    TDefineNicknm selectByPrimaryKey(Integer nickSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_nicknm
     *
     * @mbg.generated Fri Nov 25 11:29:08 KST 2022
     */
    List<TDefineNicknm> selectAll();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_define_nicknm
     *
     * @mbg.generated Fri Nov 25 11:29:08 KST 2022
     */
    int updateByPrimaryKey(TDefineNicknm row);
    
    //칭호 조회
    List<TDefineNicknm> selectAlldefineNicknm(TDefineNicknm defineNicknm);
    
    TDefineNicknm selectNicknmDetail(TDefineNicknm defineNicknm);
}