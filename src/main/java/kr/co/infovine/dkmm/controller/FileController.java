package kr.co.infovine.dkmm.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.infovine.dkmm.service.file.FileService;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping(value = "/file")
@Slf4j
public class FileController {
	@Value("${file.upload}") 
	private String WEB_UPLOAD_PATH;
	
	@Autowired
	private FileService fileService;
	
	@RequestMapping(value="/upload.do", method = RequestMethod.POST
			, produces = "application/json; charset=utf8")
	@ResponseBody
	public String handleUpload(HttpServletRequest request, HttpSession session) throws Exception {
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        log.info("System.getProperty java.io.tmpdir : " + System.getProperty("java.io.tmpdir"));
        log.info("isMultipart : " + String.valueOf(isMultipart));
        // Create a factory for disk-based file items
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
        factory.setSizeThreshold(DiskFileItemFactory.DEFAULT_SIZE_THRESHOLD);
        factory.setFileCleaningTracker(null);
        // Configure a repository (to ensure a secure temp location is used)
        ServletFileUpload upload = new ServletFileUpload(factory);
        try {
            // Parse the request with Streaming API
            upload = new ServletFileUpload();
            FileItemIterator iterStream = upload.getItemIterator(request);
            while (iterStream.hasNext()) {
                FileItemStream item = iterStream.next();
                String name = item.getFieldName();
                InputStream stream = item.openStream();
                if (!item.isFormField()) {
                	log.info("File field " + name + " with file name "+ item.getName() + " detected.");
                    //Process the InputStream
                	FileOutputStream out = new FileOutputStream("D:\\as\\isFormField.mp4", true);
                	//IOUtils.copy(stream, out);
                	byte[] buf = new byte[1024*1024];
    				int len = 0;
    				while ((len = stream.read(buf)) > 0){
    					out.write(buf, 0, len);
    			    }
                	out.flush();
                	out.close();
                } 
                stream.close();
            }
            return "{}";
        } 
//        catch (IOException | FileUploadException ex) {
        catch (Exception ex) {
        	log.error(ex.getMessage());
            return "{\"error\": \"" + ex.getMessage() + "\"}";
        }
	}
}
