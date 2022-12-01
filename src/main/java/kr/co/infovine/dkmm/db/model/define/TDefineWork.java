package kr.co.infovine.dkmm.db.model.define;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
@Getter
@Setter
public class TDefineWork {
    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.work_seq
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private Integer workSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.work_condition
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String workCondition;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.work_nm
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String workNm;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.work_cnt
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String workCnt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.nick_seq
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private int nickSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.point
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String point;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.except_condition
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String exceptCondition;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.start_dt
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String startDt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.end_dt
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String endDt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.approval_yn
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String approvalYn;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.del_yn
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String delYn;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.ins_seq
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private Long insSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.ins_dt
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String insDt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.upt_seq
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private Long uptSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.upt_dt
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String uptDt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.work_type
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String workType;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.work_text
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String workText;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.work_condition_desc
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String workConditionDesc;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.use_yn
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String useYn;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.zombie_yn
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String zombieYn;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.limit_yn
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String limitYn;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_define_work.unit_txt
     *
     * @mbg.generated Wed Nov 23 17:41:12 KST 2022
     */
    private String unitTxt;
    
    //추가
    private String rowNum;
    private String seqString;
    private String codeValue;
    
    //조건
  	private String searchText;
  	private String searchStartDt;
  	private String searchEndDt;
  	
  	//숨김여부 , 승인 처리
  	private String upWorkSeq;
  	private String upWorkNm;
  	private String upWorkCondition;
  	private String approval;
  	
  	
    // t_define_nicknm
    private String nickNm;
    private String nickComment;

}