package kr.co.infovine.dkmm.service.marketing;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.marketing.TMarketingAnalysis;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;
import kr.co.infovine.dkmm.db.model.user.TUserInfo;
import kr.co.infovine.dkmm.mapper.common.TCommonCodeMapper;
import kr.co.infovine.dkmm.mapper.define.TDefineWorkMapper;
import kr.co.infovine.dkmm.mapper.marketing.TMarketingAnalysisMapper;
import kr.co.infovine.dkmm.mapper.user.TUserInfoMapper;
import lombok.extern.slf4j.Slf4j;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateServiceImpl.java
 * 2021-05-27 Made by Duhyun, Kim
 */
@Service
@Slf4j
public class MarketingServiceImpl implements MarketingService{
	
	@Autowired
	TMarketingAnalysisMapper marketingAnalysisMapper;	
	@Override
	public List<TMarketingAnalysis> marketingMonthly(TMarketingAnalysis maketingAnalysis) {
		return marketingAnalysisMapper.marketingMonthly(maketingAnalysis);
	}
	
	@Override
	public List<TMarketingAnalysis> marketingWeekly(TMarketingAnalysis maketingAnalysis) {
		return marketingAnalysisMapper.marketingWeekly(maketingAnalysis);
	}
}
