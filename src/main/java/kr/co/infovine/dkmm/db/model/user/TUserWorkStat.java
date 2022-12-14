package kr.co.infovine.dkmm.db.model.user;

import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TUserWorkStat {
    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_user_work_stat.user_seq
     *
     * @mbg.generated Wed Oct 12 14:19:11 KST 2022
     */
    private int userSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_user_work_stat.work_seq
     *
     * @mbg.generated Wed Oct 12 14:19:11 KST 2022
     */
    private int workSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_user_work_stat.user_action_cnt
     *
     * @mbg.generated Wed Oct 12 14:19:11 KST 2022
     */
    private String userActionCnt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_user_work_stat.complete_yn
     *
     * @mbg.generated Wed Oct 12 14:19:11 KST 2022
     */
    private String completeYn;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_user_work_stat.ins_seq
     *
     * @mbg.generated Wed Oct 12 14:19:11 KST 2022
     */
    private int insSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_user_work_stat.ins_dt
     *
     * @mbg.generated Wed Oct 12 14:19:11 KST 2022
     */
    private Date insDt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_user_work_stat.upt_seq
     *
     * @mbg.generated Wed Oct 12 14:19:11 KST 2022
     */
    private int uptSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_user_work_stat.upt_dt
     *
     * @mbg.generated Wed Oct 12 14:19:11 KST 2022
     */
    private Date uptDt;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_user_work_stat.complete_dt
     *
     * @mbg.generated Wed Oct 12 14:19:11 KST 2022
     */
    private Date completeDt;
    
    
    private List<TUserWorkStat> listTUserWorkStat;
    
    
}