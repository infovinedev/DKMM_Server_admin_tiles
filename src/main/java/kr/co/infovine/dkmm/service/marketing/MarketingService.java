package kr.co.infovine.dkmm.service.marketing;

import java.util.List;

import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.db.model.define.TDefineWork;
import kr.co.infovine.dkmm.db.model.marketing.TMarketingAnalysis;
import kr.co.infovine.dkmm.db.model.store.TStoreInfoModel;

/**
 * kr.co.infovine.dkmm.service.realestate
 * RealEstateService.java
 * 2021-05-27 Made by Duhyun, Kim
 */
public interface MarketingService {
    List<TMarketingAnalysis> marketingMonthly(TMarketingAnalysis maketingAnalysis);
    List<TMarketingAnalysis> marketingWeekly(TMarketingAnalysis maketingAnalysis);
}
