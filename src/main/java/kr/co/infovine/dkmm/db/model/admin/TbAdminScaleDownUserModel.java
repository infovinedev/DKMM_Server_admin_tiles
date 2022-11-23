package kr.co.infovine.dkmm.db.model.admin;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class TbAdminScaleDownUserModel {
	@JsonIgnore
	private Integer adminUserSeq;

    @JsonIgnore
    private String userId;

    private String userName;
    
    private String userTypeCode;
    
    @JsonIgnore
    private String regDate;

    @JsonIgnore
    private String lastloginDate;
 
    @JsonIgnore
    private String blockYn;
}