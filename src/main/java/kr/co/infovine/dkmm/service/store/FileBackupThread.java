package kr.co.infovine.dkmm.service.store;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class FileBackupThread extends Thread{
	
	private String fileDir; 
	private String fileBackupDir;

    public FileBackupThread(String fileDir, String fileBackupDir) {
        this.fileDir = fileDir;
        this.fileBackupDir = fileBackupDir;
    }
	
	@Override
	public void run() {
		
		log.info("FileBackupThread START - CUR Directory : " + fileDir + ", BACKUP Directory : " + fileBackupDir);
		
		File currentDirectory = new File(fileDir);
		File backupDirectory = new File(fileBackupDir);
		
		try {
			//STEP 1 기존 백업 위치의 파일을 삭제 한다.
			if ( !backupDirectory.exists() ) {			//해당 디렉토리가 없을 경우 생성
				backupDirectory.mkdirs();
			}
			else{
				File[] fileBackupList = backupDirectory.listFiles();
				
				System.out.println( "fileBackupList.length >> " + fileBackupList.length);
				
				if ( fileBackupList.length > 0) {				//파일목록이 있을 경우에만 삭제
					for (int i = 0; i < fileBackupList.length; i++) {
						Thread.sleep(1000);  // 1초 대기한다.
						log.info(fileBackupList[i].getName() + " FILE DELETE!!" );
						fileBackupList[i].delete(); //파일 삭제 
					}
				}
			}
			
			//STEP 2 현재의 파일들을 백업 위치로 MOVE
			File[] fileList = currentDirectory.listFiles();
            
			for (int i = 0; i < fileList.length; i++) {
				Thread.sleep(1000);  // 1초 대기한다.
				
				String fileNm = fileList[i].getName();
				
				Path oldfile = Paths.get(fileDir + "/" + fileNm);
				Path newfile = Paths.get(backupDirectory + "/" + fileNm);
				Files.move(oldfile, newfile, StandardCopyOption.ATOMIC_MOVE);
				
				log.info(fileNm + " FILE MOVE!!" );
			}
			
			log.info("FileBackupThread SUCESS ");
			
        } catch (Exception e) {
        	log.info("FileBackupThread FAILED!!!!!!!!!!! ");
        	e.printStackTrace();
        }
		
	}
	
	
}
