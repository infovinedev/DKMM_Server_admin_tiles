package kr.co.infovine.dkmm.service.nicknm;

import java.util.List;

import kr.co.infovine.dkmm.db.model.nicknm.TDefineNicknm;

public interface OperationNicknmService {
    List<TDefineNicknm> selectAlldefineNicknm(TDefineNicknm defineNicknm);
	/*
	 * TDefineWork selectdefineWorkDetail(TDefineWork defineWork);
	 * 
	 * void upDateDefineWork(TDefineWork defineWork); void
	 * insertDefineWork(TDefineWork defineWork);
	 */
}
