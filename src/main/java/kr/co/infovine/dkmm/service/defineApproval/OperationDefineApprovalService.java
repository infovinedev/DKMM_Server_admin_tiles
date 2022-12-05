package kr.co.infovine.dkmm.service.defineApproval;

import java.util.List;

import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateService.java
 * 2021-05-27 Made by Duhyun, Kim
 */
public interface OperationDefineApprovalService {
    List<TDefineWork> selectAlldefineWorkApproval(TDefineWork defineWork);
	
	TDefineWork selectdefineWorkApprovalDetail(TDefineWork defineWork); 
	
	//수정
	void upDateAllDefineWork(TDefineWork defineWork);
	//삭제
	void deleteAllDefineWork(TDefineWork defineWork);
	
	void upDateApproval(TDefineWork defineWork);
	
	void upDateUseYn(TDefineWork defineWork);
	
	TDefineWork selectNickComment(TDefineWork defineWork); 
	 /*
	 * List<TDefineWork> selectDefineWorkGetNicknm(TDefineWork defineWork);
	 * 
	 * 
	 * insertDefineWork(TDefineWork defineWork);
	 */
}
