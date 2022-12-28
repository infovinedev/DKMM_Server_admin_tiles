package kr.co.infovine.dkmm.batch;

import org.quartz.InterruptableJob;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.UnableToInterruptJobException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.QuartzJobBean;
import org.springframework.stereotype.Component;

import kr.co.infovine.dkmm.service.store.StoreMetaBatchService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author AB
 *
 */

@Component
@Slf4j
public class BatchStoreOrgToInfoService extends QuartzJobBean implements InterruptableJob {

	@Override
	public void interrupt() throws UnableToInterruptJobException {
		// TODO Auto-generated method stub
	}

	@Autowired
	StoreMetaBatchService storeMetaBatchService;

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
		log.info("========= 상점 정보 갱신 Batch =====");
		try {
			storeMetaBatchService.batchStoreInfo("BATCH");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}