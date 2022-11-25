package kr.co.infovine.dkmm.db.model.store;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TStoreInfo {

	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.store_seq
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private Long storeSeq;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.store_mngt_no
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String storeMngtNo;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.store_nm
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String storeNm;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.ctgry_nm
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String ctgryNm;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.road_addr
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String roadAddr;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.zip
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String zip;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.latitude
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String latitude;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.longitude
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String longitude;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.company_no
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String companyNo;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.store_open_time
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String storeOpenTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.store_end_time
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String storeEndTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.store_holiday_type
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String storeHolidayType;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.max_cnt
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String maxCnt;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.file_uuid
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String fileUuid;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.use_yn
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String useYn;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.del_yn
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String delYn;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.ins_seq
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String insSeq;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.ins_dt
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String insDt;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.upt_seq
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String uptSeq;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.upt_dt
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String uptDt;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.store_tel
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String storeTel;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.area_tot
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String areaTot;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.priority
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private Integer priority;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.like_cnt
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private Long likeCnt;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.last_wait_user_seq
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private Long lastWaitUserSeq;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.last_wait_person_cnt
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private Integer lastWaitPersonCnt;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.last_wait_ins_dt
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String lastWaitInsDt;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.old_addr
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String oldAddr;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column t_store_info.old_zip
	 * @mbg.generated  Tue Nov 22 16:17:09 KST 2022
	 */
	private String oldZip;
	
	//조건
	private String searchText;
	private String searchStartDt;
	//등록,수정 Type
	private String sqlType;

}