package kr.co.infovine.dkmm.db.model.marketing;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;
import lombok.Setter;
@Getter
@Setter
public class TMarketingAnalysis {
    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_marketing_analysis.marketing_seq
     *
     * @mbg.generated Mon Dec 12 16:19:04 KST 2022
     */
    private int marketingSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_marketing_analysis.channel
     *
     * @mbg.generated Mon Dec 12 16:19:04 KST 2022
     */
    private String channel;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_marketing_analysis.week_type
     *
     * @mbg.generated Mon Dec 12 16:19:04 KST 2022
     */
    private String weekType;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_marketing_analysis.os_type
     *
     * @mbg.generated Mon Dec 12 16:19:04 KST 2022
     */
    private String osType;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_marketing_analysis.move_store_cnt
     *
     * @mbg.generated Mon Dec 12 16:19:04 KST 2022
     */
    private int moveStoreCnt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_marketing_analysis.down_cnt
     *
     * @mbg.generated Mon Dec 12 16:19:04 KST 2022
     */
    private int downCnt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_marketing_analysis.regit_cnt
     *
     * @mbg.generated Mon Dec 12 16:19:04 KST 2022
     */
    private int regitCnt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_marketing_analysis.ins_dt
     *
     * @mbg.generated Mon Dec 12 16:19:04 KST 2022
     */
    private String insDt;
    
    // ??????
    private int clickCnt;
    private int weekCnt;
    
    private int osTypeAos;
    private int osTypeIos;
    
    private int clickCntAos;
    private int clickCntIos;
    private int moveStoreCntAos;
    private int moveStoreCntIos;
    private int downCntAos;
    private int downCntIos;
    private int regitCntAos;
    private int regitCntIos;
}