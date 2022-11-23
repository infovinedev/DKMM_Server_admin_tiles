/**
 *
 */
package kr.co.infovine.dkmm.mapper.batch;

import java.util.List;

import org.springframework.stereotype.Repository;


/**
 * @author User
 *
 */
@Repository
public interface Batch1Mapper {
  // 대기 일별 통계
  public int updateWaitAnalysis();

}
