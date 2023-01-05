package kr.co.infovine.dkmm.batch;

import org.quartz.InterruptableJob;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.UnableToInterruptJobException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.QuartzJobBean;
import org.springframework.stereotype.Component;

import kr.co.infovine.dkmm.db.model.common.TCommonCodeModel;
import kr.co.infovine.dkmm.service.admin.TAdminService;
import kr.co.infovine.dkmm.service.store.StoreMetaBatchService;
import kr.co.infovine.dkmm.util.CommonUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * @author AB
 *
 */

@Component
@Slf4j
public class BatchPromotionChangeService extends QuartzJobBean implements InterruptableJob {

	@Override
	public void interrupt() throws UnableToInterruptJobException {
		// TODO Auto-generated method stub
	}

	@Autowired
	TAdminService commonCodeService;

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
		log.info("========= 프로모션 Batch =====");
		try {
			
			TCommonCodeModel currentDate = commonCodeService.selectByPrimaryKeyCommonCode("promotion_date", "close_date");
			TCommonCodeModel futureDate = commonCodeService.selectByPrimaryKeyCommonCode("promotion_date", "future_start_date");
	         
	        // 데이터가 없을 경우 - 종료
	        if (currentDate == null || currentDate.getCodeDescription() == null || futureDate == null || futureDate.getCodeDescription() == null) {
	        	log.info("BatchPromotionCloseService Ended - FAIL : 데이터가 없을 경우 - 종료");
	        	return;
	        }
	         
	        int today = Integer.parseInt(CommonUtil.getToday());
	        int currCloseDate = Integer.parseInt(currentDate.getCodeDescription());
	        int futureStartDate = Integer.parseInt(futureDate.getCodeDescription());
	         
	        // 현재 프로모션이 종료되지 않았거나 미래 프로모션 시작일이 아닐 경우 - 종료
	        if (today <= currCloseDate || today != futureStartDate) {
	        	log.info("BatchPromotionCloseService Ended - FAIL : 현재 프로모션이 종료되지 않았거나 미래 프로모션 시작일이 아닐 경우 - 종료");
	        	return;
	        }
	        
	        
	        commonCodeService.updatePromotionByFuture();
	        log.info("BatchPromotionCloseService Ended - SUCESS");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}