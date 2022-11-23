package kr.co.infovine.dkmm.batch;

import static org.quartz.JobBuilder.newJob;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.CronScheduleBuilder;
import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;

@Controller
public class Batch1Controller {

	private final Log logger = LogFactory.getLog(getClass());


	@Autowired
    private Scheduler scheduler;
	
//	@Value("${batch.cron.patteren.storewait}")
//	private String storeWaitCron;
//	
//	@Value("${batch.cron.patteren.storeorgtoinfo}")
//	private String storeOrgToInfoCron;
	
	// -------------------- 스프링 부트 배치 (quartz) [start] -----------------------------
    @PostConstruct
    public void start() {
        try {
        	
        	Map map = new HashMap();
        	
        	//배치작업 class 지정하기
        	//01. 상점 대기등록 통계
        	JobDetail jobDetail = buildJobDetail(Batch1Service.class, "batch1", "t_batch1", map);
			scheduler.scheduleJob(jobDetail, buildJobTrigger("0 0 1 * * ?"));
//			scheduler.scheduleJob(jobDetail, buildJobTrigger(storeWaitCron));
			
			//02. 상점 정보 등록
        	JobDetail jobDetailStoreOrg = buildJobDetail(BatchStoreOrgToInfoService.class, "batchStoreOrg", "t_batchStoreOrg", map);
			scheduler.scheduleJob(jobDetailStoreOrg, buildJobTrigger("0 21 17 * * ?"));
//			scheduler.scheduleJob(jobDetailStoreOrg, buildJobTrigger(storeOrgToInfoCron));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

    //String scheduleExp ="0 40 11 * * ?"; 초 분 시 일 월 ?
    public Trigger buildJobTrigger(String scheduleExp) {
        return TriggerBuilder.newTrigger()
                .withSchedule(CronScheduleBuilder.cronSchedule(scheduleExp)).build();
    }
    
    public JobDetail buildJobDetail(Class job, String name, String group, Map params) {
        JobDataMap jobDataMap = new JobDataMap();
        jobDataMap.putAll(params);
        return newJob(job).withIdentity(name, group)
                .usingJobData(jobDataMap)
                .build();
    }
    // -------------------- 스프링 부트 배치 (quartz) [end] -----------------------------
}