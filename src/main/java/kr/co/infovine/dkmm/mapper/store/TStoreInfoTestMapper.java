package kr.co.infovine.dkmm.mapper.store;

import java.util.List;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModelTest;

public interface TStoreInfoTestMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_store_info_test
     *
     * @mbg.generated Tue Nov 22 16:52:13 KST 2022
     */
    int deleteByPrimaryKey(Long storeSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_store_info_test
     *
     * @mbg.generated Tue Nov 22 16:52:13 KST 2022
     */
    int insert(TStoreInfoModelTest row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_store_info_test
     *
     * @mbg.generated Tue Nov 22 16:52:13 KST 2022
     */
    TStoreInfoModelTest selectByPrimaryKey(Long storeSeq);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_store_info_test
     *
     * @mbg.generated Tue Nov 22 16:52:13 KST 2022
     */
    List<TStoreInfoModelTest> selectAll();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table t_store_info_test
     *
     * @mbg.generated Tue Nov 22 16:52:13 KST 2022
     */
    int updateByPrimaryKey(TStoreInfoModelTest row);
    
    /* STORE_INFO 정보 update  */
	int mergeStoreInfo();	
	
	/* STORE_INFO 폐업 상점 update  */
	int updateCloseStoreInfo();	
}