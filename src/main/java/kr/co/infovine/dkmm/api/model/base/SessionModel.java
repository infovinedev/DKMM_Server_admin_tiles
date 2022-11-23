package kr.co.infovine.dkmm.api.model.base;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SessionModel {
	private Integer adminUserSeq;
	
	private String userId;
	
	private String userName;
	
	private String cryptoAes;
}
