package kr.co.infovine.dkmm.mapper.common;

import java.util.List;
import kr.co.infovine.dkmm.db.model.commoncode.CommonCodeModel;
import org.apache.ibatis.annotations.Param;

public interface CommonCodeMapper {

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table COMMON_CODE
	 * @mbg.generated  Thu May 27 17:35:27 KST 2021
	 */
	int deleteByPrimaryKey(@Param("codeGroup") String codeGroup, @Param("codeValue") String codeValue);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table COMMON_CODE
	 * @mbg.generated  Thu May 27 17:35:27 KST 2021
	 */
	int insert(CommonCodeModel record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table COMMON_CODE
	 * @mbg.generated  Thu May 27 17:35:27 KST 2021
	 */
	CommonCodeModel selectByPrimaryKey(@Param("codeGroup") String codeGroup, @Param("codeValue") String codeValue);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table COMMON_CODE
	 * @mbg.generated  Thu May 27 17:35:27 KST 2021
	 */
	List<CommonCodeModel> selectAll();

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table COMMON_CODE
	 * @mbg.generated  Thu May 27 17:35:27 KST 2021
	 */
	int updateByPrimaryKey(CommonCodeModel record);
}