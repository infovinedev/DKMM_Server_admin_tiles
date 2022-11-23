package kr.co.infovine.dkmm.batch;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class StoreMetaBatchTest {
	
	public static void main(String[] args) {
		
		Connection con = null;
        PreparedStatement pstmt = null ;
        
        int mergeStoreInfoCount = 0;
        int deleteStoreInfoCount = 0;
        int updStoreOrgCount = 0;
        
        
        String driverClass = "net.sf.log4jdbc.sql.jdbcapi.DriverSpy";
        String jdbcUrl = "jdbc:log4jdbc:postgresql://pg-asukd.vpc-pub-cdb-kr.ntruss.com:5432/dkmmdb";
        String username = "postgre";
        String dbpass = "password1!";
        
        
        StringBuffer mergeStoreInfoQuery = new StringBuffer();
        
        mergeStoreInfoQuery.append("	INSERT INTO t_store_info_test						\n");
        mergeStoreInfoQuery.append("    	(                                               \n");
        mergeStoreInfoQuery.append("	    	 store_mngt_no                              \n");
        mergeStoreInfoQuery.append("			,store_nm                                   \n");
        mergeStoreInfoQuery.append("			,ctgry_nm                                   \n");
        mergeStoreInfoQuery.append("			,road_addr                                  \n");
        mergeStoreInfoQuery.append("			,zip                                        \n");
        mergeStoreInfoQuery.append("			,old_addr                                   \n");
        mergeStoreInfoQuery.append("			,old_zip                                    \n");
        mergeStoreInfoQuery.append("			,ins_seq                                    \n");
        mergeStoreInfoQuery.append("			,upt_seq                                    \n");
        mergeStoreInfoQuery.append("			,store_tel                                  \n");
        mergeStoreInfoQuery.append("			,area_tot                                   \n");
        mergeStoreInfoQuery.append("		)                                               \n");
        mergeStoreInfoQuery.append("		SELECT                                          \n");
        mergeStoreInfoQuery.append("			manage_no as store_mngt_no                  \n");
        mergeStoreInfoQuery.append("			,store_nm as store_nm                       \n");
        mergeStoreInfoQuery.append("			,ctgry_nm as ctgry_nm                       \n");
        mergeStoreInfoQuery.append("			,road_addr as road_addr                     \n");
        mergeStoreInfoQuery.append("			,road_zip as zip                            \n");
        mergeStoreInfoQuery.append("			,road_addr as old_addr                      \n");
        mergeStoreInfoQuery.append("			,road_zip as old_zip                        \n");
        mergeStoreInfoQuery.append("			,0 as ins_seq                               \n");
        mergeStoreInfoQuery.append("			,0 as upt_seq                               \n");
        mergeStoreInfoQuery.append("			,tel as store_tel                           \n");
        mergeStoreInfoQuery.append("			,area_tot                                   \n");
        mergeStoreInfoQuery.append("		FROM t_store_info_org                           \n");
        mergeStoreInfoQuery.append("		WHERE status_type = '01'                        \n");
        mergeStoreInfoQuery.append("		AND   process_yn = 'N'                        	\n");
        mergeStoreInfoQuery.append("		ON CONFLICT (store_mngt_no) DO UPDATE           \n");
        mergeStoreInfoQuery.append("	    SET                                             \n");
        mergeStoreInfoQuery.append("	    	road_addr = excluded.road_addr              \n");
        mergeStoreInfoQuery.append("	    	,zip = excluded.zip                         \n");
        mergeStoreInfoQuery.append("	    	,store_tel = excluded.store_tel             \n");
        mergeStoreInfoQuery.append("	    	,old_addr = excluded.old_addr               \n");
        mergeStoreInfoQuery.append("	    	,old_zip = excluded.old_zip                 \n");
        
        StringBuffer updStoreOrgQuery = new StringBuffer();
        updStoreOrgQuery.append("	UPDATE 	t_store_info_org							\n");
        updStoreOrgQuery.append("	SET		process_yn = 'Y'							\n");
        updStoreOrgQuery.append("	WHERE status_type = '01'                        	\n");
        updStoreOrgQuery.append("	AND   process_yn = 'N'                        		\n");
        
        StringBuffer delStoreInfoQuery = new StringBuffer();
        delStoreInfoQuery.append("	UPDATE 	t_store_info_test	A					\n");
        delStoreInfoQuery.append("	SET		use_yn = 'N'							\n");
        delStoreInfoQuery.append("			,del_yn = 'Y'							\n");
        delStoreInfoQuery.append("	FROM	t_store_info_org B						\n");
        delStoreInfoQuery.append("	WHERE A.store_mngt_no = B.manage_no             \n");
        delStoreInfoQuery.append("	AND   B.process_yn = 'N'                        \n");
        delStoreInfoQuery.append("	AND   B.status_type <> '01'                     \n");
        
        StringBuffer updStatStoreOrgQuery = new StringBuffer();
        updStatStoreOrgQuery.append("	UPDATE 	t_store_info_org							\n");
        updStatStoreOrgQuery.append("	SET		process_yn = 'Y'							\n");
        updStatStoreOrgQuery.append("	WHERE status_type <> '01'                        	\n");
        updStatStoreOrgQuery.append("	AND   process_yn = 'N'                        		\n");
        
        long start = System.currentTimeMillis();
        
        System.out.println("===================================================================================");
        System.out.println("========================= StoreMetaBatch START=====================================");
        System.out.println("START TIME : " + start);
        
        
        try{
        	
        	Class.forName(driverClass);
            con = DriverManager.getConnection(jdbcUrl, username, dbpass);
            
            con.setAutoCommit(false);
            
            System.out.println("==================================================================================");
            System.out.println("	::::::: STEP 1 - MERGE T_STORE_INFO ========================================");
            
            //step1 - 영업중인 상점 ORG 정보를 Store Info테이블에 Merge 
            pstmt = con.prepareStatement(mergeStoreInfoQuery.toString()) ;
            mergeStoreInfoCount = pstmt.executeUpdate();
            pstmt.close();
            
            System.out.println("	>>>>>> STEP 1 MERGE RESULT_COUNT : " + mergeStoreInfoCount);
            System.out.println("	>>>>>> STEP 1 PROC TIME : " + ( System.currentTimeMillis() - start)/1000 );
            
            
            System.out.println("==================================================================================");
            System.out.println("	::::::: STEP 2 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 01 ==================");
            
            //step1 - 영업중인 상점 ORG 테이블 process_yn UPDATE
            pstmt = con.prepareStatement(updStoreOrgQuery.toString()) ;
            updStoreOrgCount = pstmt.executeUpdate();
            pstmt.close();
            
            System.out.println("	>>>>>> STEP 2 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 01 RESULT_COUNT : " + updStoreOrgCount);
            System.out.println("	>>>>>> STEP 2 PROC TIME : " + ( System.currentTimeMillis() - start)/1000 );
            
            
            System.out.println("==================================================================================");
            System.out.println("	::::::: STEP 3 - UPDATE CLOSE T_STORE_INFO ===================================");
            
            //step1 - 영업중인 상점 ORG 정보를 Store Info테이블에 Merge 
            pstmt = con.prepareStatement(delStoreInfoQuery.toString()) ;
            deleteStoreInfoCount = pstmt.executeUpdate();
            pstmt.close();
            
            System.out.println("	>>>>>> STEP 3 - UPDATE CLOSE RESULT_COUNT : " + deleteStoreInfoCount);
            System.out.println("	>>>>>> STEP 3 PROC TIME : " + ( System.currentTimeMillis() - start)/1000 );
            
            System.out.println("==================================================================================");
            System.out.println("	::::::: STEP 4 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 02 ==================");
            
            //step1 - 영업중인 상점 ORG 테이블 process_yn UPDATE
            pstmt = con.prepareStatement(updStatStoreOrgQuery.toString()) ;
            updStoreOrgCount = updStoreOrgCount + pstmt.executeUpdate();
            pstmt.close();
            
            System.out.println("	>>>>>> STEP 4 - UPDATE T_STORE_INFO_ORG - STATUS_TYPE : 02 RESULT_COUNT : " + updStoreOrgCount);
            System.out.println("	>>>>>> STEP 4 PROC TIME : " + ( System.currentTimeMillis() - start)/1000 );
            
            System.out.println("==================================================================================");
            System.out.println("============================== RESULT TOTAL ======================================");
            
            System.out.println(" :::::: T_STORE_INFO - MERGE COUNT : " + mergeStoreInfoCount );
            System.out.println(" :::::: T_STORE_INFO - CLOSE UPDATE COUNT : " + deleteStoreInfoCount );
            System.out.println(" :::::: T_STORE_INFO - TOTAL EXECUTE COUNT : " + ( mergeStoreInfoCount + deleteStoreInfoCount) );
            System.out.println();
            System.out.println(" :::::: T_STORE_INFO_ORG - TOTAL EXECUTE COUNT : " + updStoreOrgCount );
            System.out.println(" :::::: ALL STEP PROC TIME : " + ( System.currentTimeMillis() - start)/1000 );
            System.out.println("============================== RESULT TOTAL ======================================");
            
            
            con.commit() ;
//            con.rollback() ;
            
        }catch(Exception e){
            e.printStackTrace();
              
            try {
                con.rollback() ;
            } catch (SQLException e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
              
        }finally{
            if (pstmt != null) try {pstmt.close();pstmt = null;} catch(SQLException ex){}
            if (con != null) try {con.close();con = null;} catch(SQLException ex){}
        }
		
	}
	
}
