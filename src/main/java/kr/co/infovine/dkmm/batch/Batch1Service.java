package kr.co.infovine.dkmm.batch;

import org.quartz.InterruptableJob;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.UnableToInterruptJobException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.QuartzJobBean;
import org.springframework.stereotype.Component;

import kr.co.infovine.dkmm.mapper.batch.Batch1Mapper;
import lombok.extern.slf4j.Slf4j;

/**
 * @author AB
 *
 */

@Component
@Slf4j
public class Batch1Service extends QuartzJobBean implements InterruptableJob {

	@Override
	public void interrupt() throws UnableToInterruptJobException {
		// TODO Auto-generated method stub
	}

	@Autowired
	Batch1Mapper batch1Mapper;

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
		log.info("========= 상점 대기등록 통계 =====");
		try {
			batch1Mapper.updateWaitAnalysis();
		}catch(Exception e) {

		}
	}
}