package kr.co.infovine.dkmm.service.nicknm;

import java.util.List;

import kr.co.infovine.dkmm.db.model.nicknm.TDefineNicknm;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateService.java
 * 2021-05-27 Made by Duhyun, Kim
 */
public interface OperationNicknmService {
    List<TDefineNicknm> selectAlldefineNicknm(TDefineNicknm defineNicknm);
	/*
	 * TDefineWork selectdefineWorkDetail(TDefineWork defineWork);
	 * 
	 * void upDateDefineWork(TDefineWork defineWork); void
	 * insertDefineWork(TDefineWork defineWork);
	 */
}
