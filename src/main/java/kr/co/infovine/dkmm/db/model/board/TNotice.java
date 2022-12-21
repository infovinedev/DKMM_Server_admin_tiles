package kr.co.infovine.dkmm.db.model.board;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;
import lombok.Setter;
@Getter
@Setter
public class TNotice {

    private int noticeSeq;

    private String noticeDesc;

    private String noticeFilePath;

    private String dispYn;

    private int boardSeq;

    private int insSeq;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date insDt;

    private int uptSeq;

    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date uptDt;

    private String delYn;
    
    //조건
    private String searchText;
    private String searchStartDt;
    private String searchEndDt;
    private String type;
    
  	private String rowNum;
}