package kr.co.infovine.dkmm.controller;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.api.model.base.SessionModel;
import kr.co.infovine.dkmm.db.model.file.TFileModel;
import kr.co.infovine.dkmm.db.model.file.TFileSubModel;
import kr.co.infovine.dkmm.service.file.FileService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

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
	public ResponseModel handleUpload(HttpServletRequest request, HttpServletResponse response, HttpSession session
                                      //, @RequestBody TFileModel tFileModel
                               ) throws Exception {
        ResponseModel result = new ResponseModel();
        Object obj = session.getAttribute("userInfo");
        int adminUserSeq = -1;
        if(obj != null) {
            SessionModel tempSessionModel = (SessionModel) obj;
            adminUserSeq = tempSessionModel.getAdminUserSeq();
            int intAdminUserSeq = Integer.valueOf(adminUserSeq);
            String pageType = request.getHeader("pageType");;
            String fileType = request.getHeader("fileType");;
            String uniqueId = request.getHeader("uniqueId");;

            String fileObjectName = request.getHeader("fileObjectName");;
            String fileObjectSize = request.getHeader("fileObjectSize");;
            String fileObjectType = request.getHeader("fileObjectType");;
            String fileExt = fileObjectName.substring(fileObjectName.lastIndexOf('.') + 1).toLowerCase();
            if(!checkFileExtension(fileObjectName, fileExt)){
                result.setCode("0003");
                result.setResult("????????? ????????? ????????? ???????????? ????????????.");
                return result;
            }

            String chunkNumber = request.getHeader("uploader-chunk-number");
            String chunkTotal = request.getHeader("uploader-chunks-total");

            int intChunkNumber = Integer.valueOf(chunkNumber);
            int intChunkTotal = Integer.valueOf(chunkTotal) - 1;
            String chunkFileId = request.getHeader("uploader-file-id");
            log.info("chunkNum : " + chunkNumber + ", chunkTotal : " + chunkTotal + ", chunkFileId : " + chunkFileId);
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
            InputStream stream = null;

            try {
                // Parse the request
                List<FileItem> items = upload.parseRequest(request);
                // Process the uploaded items
                int idx = 0;
                Iterator<FileItem> iter = items.iterator();
                while (iter.hasNext()) {
                    String fileDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
                    String fileSaveName = fileDate + "_" + uniqueId + "_" + idx + "." + fileExt;
                    // ?????? ?????? ?????????
                    String uploadFilePath = WEB_UPLOAD_PATH + "/" + pageType;
                    createFolder(uploadFilePath);
                    // ??????????????? full??????
                    //uploadFilePath = WEB_UPLOAD_PATH + "/" + pageType + "/" + fileSaveName; //  C:/upload/file/ (uploadPath) info/t1 (pageType) / abc.png

                    FileItem item = iter.next();
                    if (!item.isFormField()) {
                        log.info("!isFormField();");
                        stream = item.getInputStream();
                        FileOutputStream out = new FileOutputStream(uploadFilePath + File.separator + fileSaveName, true);
                        byte[] buf = new byte[1024 * 1024];
                        int len = 0;
                        while ((len = stream.read(buf)) > 0) {
                            out.write(buf, 0, len);
                        }
                        out.flush();
                        out.close();
                        log.info(item.getFieldName() + ", " + item.getName() + ", " + item.getSize() + ", " + item.toString());
                        if (intChunkTotal == intChunkNumber) {
                            log.info("Done.");
                            TFileModel tFileModel = new TFileModel();
                            tFileModel.setFileUuid(uniqueId);
                            tFileModel.setUserIp(getClientIp(request));
                            tFileModel.setInsSeq(intAdminUserSeq);
                            tFileModel.setPageType(pageType);
                            tFileModel.setDelYn("N");

                            TFileSubModel tFileSubModel = new TFileSubModel();
                            tFileSubModel.setFileUuidSub(uniqueId);
                            tFileSubModel.setFileNm(fileObjectName);
                            tFileSubModel.setFileSaveNm(fileSaveName);
                            tFileSubModel.setFileSize(fileObjectSize);
                            tFileSubModel.setDelYn("N");
                            tFileSubModel.setInsSeq(intAdminUserSeq);

                            int insertResult = fileService.insertUploadFile(tFileModel, tFileSubModel);
                            if(insertResult==2){
                                result.setCode("0004");
                                result.setResult("?????? ????????? ???????????????.");
                            }

                        }
                    }
                    idx++;
                }
                result.setCode("0000");
                result.setResult(intChunkNumber + ", " + intChunkTotal + " ??????");
                return result;
            }
            catch (Exception ex) {
            	ex.printStackTrace();
                log.error(ex.getMessage());
                //response.setStatus(500);
                result.setCode("0002");
                result.setResult("??????");
                return result;
            }
            finally {
                if(stream!=null){ try{ stream.close(); } catch (Exception e){}}
            }
        }
        else{
            result.setCode("0001");
            result.setResult("????????? ?????????????????????.");
            return result;
        }
    }



    // ?????? ?????????
    public static boolean createFolder(String inFolderPath) { // inFolderPath : ???????????? ????????? ??????
        boolean check = false;
        File desti = new File(inFolderPath);
        try {
            if (!desti.exists()) {
                desti.mkdirs();
                check = true;
            }
        } catch (Exception e) {
            return false;
        }
        return check;
    }

    // ?????? ????????? ??????
    public Boolean checkFileExtension(String fileName, String fileExt) {

        Boolean result = true;
        // ????????? ?????? ????????? ?????????
        String bad_ext[] = { "php3", "php4", "asp", "jsp", "php", "html", "htm", "inc", "js", "pl", "cgi", "java", "exe", "jspx", "msi" };
        if (Arrays.asList(bad_ext).contains(fileExt)) {
            return false;
        }
        // IIS ?????? ?????? ??????
        if (fileName.contains(";")) {
            return false;
        }
        // ????????? ?????? ?????? (??? test.jsp. )
        if (fileExt.length() == 0) {
            return false;
        }
        // ?????? ?????? ?????? ??????
        if (fileName.contains("..")) {
            return false;
        }
        if (fileName == null) {
            return false;
        }
        return result;
    }

    // ????????? ????????? ?????????
    public Boolean img_resize(String imgOriginalPath, String imgFormat){
        //String imgOriginalPath= "C:/test/test.jpg";           // ?????? ????????? ?????????
        //String imgTargetPath= "C:/test/test_resize.jpg";      // ??? ????????? ?????????
        //String imgFormat = "jpg";                             // ??? ????????? ??????. jpg, gif ???

        String imgTargetPath =  imgOriginalPath;
        int newWidth = 1000;                                  // ?????? ??? ??????
        int newHeight = 700;                                  // ?????? ??? ??????
        String mainPosition = "W";                            // W:????????????, H:????????????, X:????????? ?????????(????????????)

        Image image;
        int imageWidth;
        int imageHeight;
        double ratio;
        int w;
        int h;
        try{
            // ?????? ????????? ????????????
            image = ImageIO.read(new File(imgOriginalPath));

            // ?????? ????????? ????????? ????????????
            imageWidth = image.getWidth(null);
            imageHeight = image.getHeight(null);

            if(mainPosition.equals("W")){    // ????????????
                ratio = (double)newWidth/(double)imageWidth;
                w = (int)(imageWidth * ratio);
                h = (int)(imageHeight * ratio);

            }else if(mainPosition.equals("H")){ // ????????????
                ratio = (double)newHeight/(double)imageHeight;
                w = (int)(imageWidth * ratio);
                h = (int)(imageHeight * ratio);

            }else{ //????????? (????????????)
                w = newWidth;
                h = newHeight;
            }

            // ????????? ????????????
            // Image.SCALE_DEFAULT : ?????? ????????? ???????????? ???????????? ??????
            // Image.SCALE_FAST    : ????????? ?????????????????? ?????? ??????
            // Image.SCALE_REPLICATE : ReplicateScaleFilter ???????????? ????????? ??? ????????? ?????? ?????? ????????????
            // Image.SCALE_SMOOTH  : ???????????? ????????? ??????????????? ??????
            // Image.SCALE_AREA_AVERAGING  : ?????? ???????????? ??????
            Image resizeImage = image.getScaledInstance(w, h, Image.SCALE_SMOOTH);

            // ??? ?????????  ????????????
            BufferedImage newImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
            Graphics g = newImage.getGraphics();
            g.drawImage(resizeImage, 0, 0, null);
            g.dispose();
            ImageIO.write(newImage, imgFormat, new File(imgTargetPath));

            return true;
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }

    //IP ????????????
    public String getClientIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null) ip = req.getRemoteAddr();
        return ip;
    }
}
