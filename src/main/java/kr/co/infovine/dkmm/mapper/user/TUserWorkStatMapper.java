package kr.co.infovine.dkmm.mapper.user;

import java.util.List;
import org.apache.ibatis.annotations.Param;

import kr.co.infovine.dkmm.db.model.user.TUserWorkStat;

public interface TUserWorkStatMapper {
    
    List<TUserWorkStat> selectAll(TUserWorkStat row);
    
}