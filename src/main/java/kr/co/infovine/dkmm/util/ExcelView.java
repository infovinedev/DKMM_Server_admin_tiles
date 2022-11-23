package kr.co.infovine.dkmm.util;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;



//@Component
public class ExcelView extends AbstractExcelPOIView{
	@SuppressWarnings("unchecked")
    @Override
    protected void buildExcelDocument(Map<String, Object> model, XSSFWorkbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
 
//        String target = model.get("target").toString();
		String serviceName = model.get("serviceName").toString();
        //target에 따라서 엑셀 문서 작성을 분기한다.
        if(serviceName.equals("freefortune_promotion")){
            //Object로 넘어온 값을 각 Model에 맞게 형변환 해준다.
            //List<PromotionModel> listPromotions = (List<PromotionModel>) model.get("excelList");
 
            //Sheet 생성
            Sheet sheet = workbook.createSheet("sheet1");
            
            Row row = null;
            int rowCount = 0;
            int cellCount = 0;
 
            // 제목 Cell 생성
            row = sheet.createRow(rowCount++);
 
            row.createCell(cellCount++).setCellValue("tel");
//            row.createCell(cellCount++).setCellValue("name");
//            row.createCell(cellCount++).setCellValue("writer");
 
            // 데이터 Cell 생성
//            for (PromotionModel promotion : listPromotions) {
//                row = sheet.createRow(rowCount++);
//                cellCount = 0;
//                row.createCell(cellCount++).setCellValue(promotion.getTel()); //데이터를 가져와 입력
//            }
        }
        else if(serviceName.equals("realestate_promotion")){
        	//Object로 넘어온 값을 각 Model에 맞게 형변환 해준다.
//            List<PromotionWinnerModel> listPromotions = (List<PromotionWinnerModel>) model.get("excelList");
 
            //Sheet 생성
            Sheet sheet = workbook.createSheet("sheet1");
            
            Row row = null;
            int rowCount = 0;
            int cellCount = 0;
 
            // 제목 Cell 생성
            row = sheet.createRow(rowCount++);
 
            row.createCell(cellCount++).setCellValue("tel");
//            row.createCell(cellCount++).setCellValue("name");
//            row.createCell(cellCount++).setCellValue("writer");
 
            // 데이터 Cell 생성
//            for (PromotionWinnerModel promotion : listPromotions) {
//                row = sheet.createRow(rowCount++);
//                cellCount = 0;
//                row.createCell(cellCount++).setCellValue(promotion.getMdn()); //데이터를 가져와 입력
//            }
        }
        else {
        	
        }
    }
	
	@Override
	public String getContentType() {
		return "application/vnd.ms-excel";
	}
 
    @Override
//    protected Workbook createWorkbook() {
    protected XSSFWorkbook createWorkbook() {
        //return new XSSFWorkbook();
    	return new XSSFWorkbook();
    	
    }
}
