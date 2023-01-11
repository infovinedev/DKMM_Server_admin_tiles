package kr.co.infovine.dkmm.service.common;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.mapper.common.TCommonCodeMapper;
import kr.co.infovine.dkmm.mapper.define.TDefineWorkMapper;
import kr.co.infovine.dkmm.mapper.user.TUserInfoMapper;
import lombok.extern.slf4j.Slf4j;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateServiceImpl.java
 * 2021-05-27 Made by Duhyun, Kim
 */
@Service
@Slf4j
public class CommonCodeServiceImpl implements CommonCodeService{
	
	@Autowired
	TCommonCodeMapper tCommonCodeMapper;
	
	@Override
	public List<TCommonCodeModel> selectCommonCode(TCommonCodeModel tCommonCodeModel) {
		return tCommonCodeMapper.selectCommonCode(tCommonCodeModel);
	}

	@Override
	public List<TCommonCodeModel> selectByCodeGroup(String codeGroup) {
		return tCommonCodeMapper.selectByCodeGroup(codeGroup);
	}

	@Override
	public int updateByDescriptionAndInsDt(TCommonCodeModel row) {
		return tCommonCodeMapper.updateByDescriptionAndInsDt(row);
	}


}
