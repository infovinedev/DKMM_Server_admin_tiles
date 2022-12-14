package kr.co.infovine.dkmm.db.model.admin;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class TbAdminPermissionModel {
    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column TB_Admin_Permission.admin_permission_seq
     *
     * @mbg.generated Mon May 10 14:15:37 KST 2021
     */
	//@JsonIgnore
	private int adminPermissionSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column TB_Admin_Permission.admin_user_seq
     *
     * @mbg.generated Mon May 10 14:15:37 KST 2021
     */
	//@JsonIgnore
	private int adminUserSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column TB_Admin_Permission.admin_program_seq
     *
     * @mbg.generated Mon May 10 14:15:37 KST 2021
     */
	//@JsonIgnore
	private int adminProgramSeq;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column TB_Admin_Permission.block_yn
     *
     * @mbg.generated Mon May 10 14:15:37 KST 2021
     */
    private String blockYn;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column TB_Admin_Permission.reg_date
     *
     * @mbg.generated Mon May 10 14:15:37 KST 2021
     */
    
    private String regDate;

    /**
     *
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column TB_Admin_Permission.update_date
     *
     * @mbg.generated Mon May 10 14:15:37 KST 2021
     */
    private String updateDate;
    
    private TbAdminProgramModel adminProgram;
    
    /**
     * 저장시 password를 체크하기 위함
     */
    //@JsonIgnore
    private String password;
}