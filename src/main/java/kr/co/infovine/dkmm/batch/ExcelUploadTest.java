package kr.co.infovine.dkmm.batch;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import kr.co.infovine.dkmm.util.ExcelSheetHandler;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ExcelUploadTest {
	
	public static void main(String[] args) {
		
		log.info( "===============  STORE META DATA Merge ==========================" );
		
		String storeMetaDir = "D:\\excel";
		
		try {
			
			log.info( "storeMetaDir : " + storeMetaDir );
			
			//선행 조건 
			//작업 디렉토리에 파일이 존재할 경우
			File dir = new File(storeMetaDir);
		    File files[] = dir.listFiles();
			
		    log.info( "files.length : " + files.length );
		    
		    if ( files.length == 0 ) return;
		    
			
		    long start = System.currentTimeMillis();
		    
			//Step1 - 엑셀 Data 불러오기
			// - 엑셀 파일은 여러개일수 있으며 시작시 디렉토리의 파일 명을 Array - For 문을 이용하여 Loop
			for (int i=0; i<files.length; i++) {
				
				log.info( "files[i] : " + files[i] );
				
				File file = new File( storeMetaDir + "\\" + files[i].getName());
				
				log.info( "file : " + file );
				
				ExcelSheetHandler excelSheetHandler = ExcelSheetHandler.readExcel(file);
				
				// excelDatas >>> [[nero@nate.com, Seoul], [jijeon@gmail.com, Busan], [jy.jeon@naver.com, Jeju]]
				List<List<String>> excelDatas = excelSheetHandler.getRows();

//				log.info( "excelDatas : " + excelDatas );
				
				int count = 0;
				
//				data = new Arraylist<>(); 초기화
				for(List<String> dataRow : excelDatas) { // row 하나를 읽어온다.
					count++;
					
					
//					dataRow.clear();
					
					String rowString = dataRow.toString();
					rowString = rowString.substring(1, rowString.length()-1).replaceAll(", ", ",");
					
					//log.info( rowString );
					
//					String arrRowData = rowString.sp
					
					
//				    for(String cellData : dataRow){ // cell 하나를 읽어온다.
//				    	System.out.println(cellData);
//				        
//				        if ( firstCell == 0 && (cellData == null || "".equals(cellData) ){
//				        	
//				        }
//
//				        	
//				    }
//					
//					
//					if ( count%1000 == 0) {
//						
//					}
				
				}
				
				 
			}
			
			log.info(" :::::: 처리 파일 갯수 : " + files.length );
			log.info(" :::::: ALL STEP PROC TIME(초): " + ( System.currentTimeMillis() - start)/1000  + "초" );
			log.info(" :::::: ALL STEP PROC TIME(분) : " + ( System.currentTimeMillis() - start)/1000/60  + "분" );
			//Step2 Data Merge
			// - addBatch를 이용 하여 1000건씩 진행
			
	
			
			//Step3 기존 백업 디렉토리의 모든 파일을 삭제하고 작업이 끝난 파일들을 백업 디렉토리로 이동
			
		}catch(Exception e) {

			e.printStackTrace();
		
		}
	}
	
}
