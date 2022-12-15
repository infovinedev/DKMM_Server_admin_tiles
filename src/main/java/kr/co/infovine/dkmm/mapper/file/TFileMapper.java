package kr.co.infovine.dkmm.mapper.file;

import java.util.List;
import kr.co.infovine.dkmm.db.model.file.TFileModel;

public interface TFileMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_file
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    int deleteByPrimaryKey(Integer fileSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_file
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    int insert(TFileModel row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_file
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    TFileModel selectByPrimaryKey(Integer fileSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_file
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    List<TFileModel> selectAll();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_file
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    int updateByPrimaryKey(TFileModel row);
}