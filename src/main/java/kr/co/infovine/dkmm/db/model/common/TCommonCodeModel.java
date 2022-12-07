package kr.co.infovine.dkmm.db.model.common;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TCommonCodeModel {
    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_common_code.code_group
     *
     * @mbg.generated Tue Sep 13 15:42:13 KST 2022
     */
    private String codeGroup;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_common_code.code_value
     *
     * @mbg.generated Tue Sep 13 15:42:13 KST 2022
     */
    private String codeValue;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_common_code.code_name
     *
     * @mbg.generated Tue Sep 13 15:42:13 KST 2022
     */
    private String codeName;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_common_code.code_description
     *
     * @mbg.generated Tue Sep 13 15:42:13 KST 2022
     */
    private String codeDescription;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_common_code.disp_order
     *
     * @mbg.generated Tue Sep 13 15:42:13 KST 2022
     */
    private Short dispOrder;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_common_code.ins_seq
     *
     * @mbg.generated Tue Sep 13 15:42:13 KST 2022
     */
    private Long insSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column t_common_code.ins_dt
     *
     * @mbg.generated Tue Sep 13 15:42:13 KST 2022
     */
    private Date insDt;
    
    private String password;
    
    private int seq;
}