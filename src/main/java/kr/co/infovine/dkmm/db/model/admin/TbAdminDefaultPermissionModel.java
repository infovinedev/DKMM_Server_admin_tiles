package kr.co.infovine.dkmm.db.model.admin;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class TbAdminDefaultPermissionModel {

	private String roleNm;
	
	private int adminProgramSeq;
	
    private Date insDt;

    private Date updDt;
   
    private TbAdminProgramModel adminProgram;
    
    @JsonProperty(value="permission")
	private List<TbAdminDefaultPermissionModel> tbAdminDefaultPermission;
    
    /**
     * 저장시 password를 체크하기 위함
     */
    private String password;
    
    //조건
  	private String searchText;
  	private String searchStartDt;
  	private String searchEndDt;
}