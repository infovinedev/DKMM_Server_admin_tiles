package kr.co.infovine.dkmm.util;

import java.io.OutputStream;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.poifs.crypt.EncryptionInfo;
import org.apache.poi.poifs.crypt.EncryptionMode;
import org.apache.poi.poifs.crypt.Encryptor;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.servlet.view.AbstractView;

public abstract class AbstractExcelPOIView extends AbstractView{
    private static final String CONTENT_TYPE_XLSX = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
 
    /**
     * Default Constructor. Sets the content type of the view for excel files.
     */
    public AbstractExcelPOIView() {
    }
 
    @Override
    protected boolean generatesDownloadContent() {
        return true;
    }
 
    /**
     * Renders the Excel view, given the specified model.
     */
    @Override
    protected final void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String serviceName = (String) model.get("serviceName");
    	
    	logger.info(serviceName);
    	String password = "";
    	int random = (int ) (Math.random() * 1000);
    	if(serviceName!=null) {
    		switch(serviceName) {
    	
        //Workbook workbook = createWorkbook();
    		case "freefortune_promotion":
    	 		password = "infovine1000!)";
    	 		break;
    		case "realestate_promotion":
    	 		password = "infovine2000!)";
    	 		break;	
	 		default:
	 			password = "Duhyun,Kimby!@%" + random + "#*!@$)(!@#";
    		}
    		
    	}
    	else {
    		password = "Duhyun,Kimby!@%" + random + "#*!@$)(!@#";
    	}
    	XSSFWorkbook workbook = createWorkbook();
        setContentType(CONTENT_TYPE_XLSX);
        
        
        
        buildExcelDocument(model, workbook, request, response);
 
        // Set the content type.
        response.setContentType(getContentType());
 
        // Flush byte array to servlet output stream.
        //Biff8EncryptionKey.setCurrentUserPassword("info1000!)");
//        out.flush();
//        workbook.write(out);
//        out.close();
        
        ServletOutputStream out = response.getOutputStream();
        OutputStream encryptedOs = null;
        OPCPackage opcpackage = workbook.getPackage();
        try {
        
        	POIFSFileSystem fileSystem = new POIFSFileSystem();
        	EncryptionInfo encryptionInfo = new EncryptionInfo(EncryptionMode.agile);
	        Encryptor encryptor = encryptionInfo.getEncryptor();
	        encryptor.confirmPassword(password);
	        
	        encryptedOs = encryptor.getDataStream(fileSystem);
	        workbook.write(encryptedOs);
	        workbook.close();
	        //opcpackage.save(encryptedOs);
	        encryptedOs.close();
	        
	        fileSystem.writeFilesystem(out);
	        fileSystem.close();
	        
        } catch(Exception e) {
        	e.printStackTrace();
        } finally {
        	if(encryptedOs != null) {
        		encryptedOs.close();
        	}
        	
        	if(workbook != null) {
        		workbook.close();
        	}
        	if(opcpackage != null) {
        		opcpackage.close();
        	}
        	if(out != null) {
        		out.close();
        	}
        }
        
        if (workbook instanceof XSSFWorkbook) {
            ((XSSFWorkbook) workbook).close();
        }
    }
 
    /**
     * Subclasses must implement this method to create an Excel Workbook.
     * HSSFWorkbook, XSSFWorkbook and SXSSFWorkbook are all possible formats.
     */
    protected abstract XSSFWorkbook createWorkbook();
 
    /**
     * Subclasses must implement this method to create an Excel HSSFWorkbook
     * document, given the model.
     * 
     * @param model
     *            the model Map
     * @param workbook
     *            the Excel workbook to complete
     * @param request
     *            in case we need locale etc. Shouldn't look at attributes.
     * @param response
     *            in case we need to set cookies. Shouldn't write to it.
     */
    protected abstract void buildExcelDocument(Map<String, Object> model, XSSFWorkbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception;
}
