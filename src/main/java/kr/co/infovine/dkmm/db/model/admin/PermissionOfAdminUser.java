package kr.co.infovine.dkmm.db.model.admin;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

/**
 * 
 * kr.co.infovine.dkmm.db.model.admin
 * PermissionOfAdminUser.java
 * 2021-07-05 Made by Duhyun, Kim
 */

@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class PermissionOfAdminUser {
	@JsonProperty(value="password")
	private String password;
	
	@JsonProperty(value="adminUserSeq")
	private int adminUserSeq;
	
	@JsonProperty(value="permission")
	private List<TbAdminPermissionModel> tbAdminPermission;
}
