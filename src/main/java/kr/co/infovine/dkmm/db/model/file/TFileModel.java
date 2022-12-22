package kr.co.infovine.dkmm.db.model.file;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class TFileModel {
    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_file.file_seq
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    private Integer fileSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_file.file_uuid
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    private String fileUuid;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_file.page_type
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    private String pageType;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_file.user_ip
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    private String userIp;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_file.del_yn
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    private String delYn;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_file.ins_seq
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    private int insSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_file.ins_dt
     *
     * @mbg.generated Thu Dec 15 15:23:16 KST 2022
     */
    private Date insDt;
}