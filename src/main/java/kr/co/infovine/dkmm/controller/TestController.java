package kr.co.infovine.dkmm.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.stereotype.Controller;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.servlet.ModelAndView;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminUserModel;
import kr.co.infovine.dkmm.mapper.admin.TAdminPermissionMapper;
import kr.co.infovine.dkmm.mapper.admin.TAdminUserMapper;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.netty.http.client.HttpClient;

@Slf4j
@Controller
@RequestMapping(value = "/test")
public class TestController {
	@Autowired
	TAdminUserMapper tbAdminUserMapper;
	
	@Autowired
	TAdminPermissionMapper tbAdminPermissionMapper;
	
	@Autowired
	HttpClient httpClient;
	
	@RequestMapping(value="/webclient.do", method = RequestMethod.POST
	, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public Map<String, Object> testWebClient(HttpServletRequest request, HttpServletResponse response) {
		//WebClient client = new WebClient
		//Map<String, Object> data = null;
		Map<String, Object> data = new LinkedHashMap<>();
		Map<String, ResponseModel> third = null;
		Flux<Mono<ResponseModel>> flux = null;
		Mono<Object> amono = null;
		try {
			String url = "https://localhost:9501/test/menu.do";
//			SslContext sslContext = SslContextBuilder
//		            .forClient()
//		            .trustManager(InsecureTrustManagerFactory.INSTANCE)
//		            .build();
//			
//			HttpClient httpClient = HttpClient.create()
//					.secure(t -> t.sslContext(sslContext))
//					  .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 15000)
//					  .responseTimeout(Duration.ofMillis(15000))
//					  .doOnConnected(conn -> 
//					    conn.addHandlerLast(new ReadTimeoutHandler(15000, TimeUnit.MILLISECONDS))
//					      .addHandlerLast(new WriteTimeoutHandler(15000, TimeUnit.MILLISECONDS)));
//			
//			ClientHttpConnector connector = new ReactorClientHttpConnector(httpClient);    
			
			WebClient client = WebClient.builder()
					  .clientConnector(new ReactorClientHttpConnector(httpClient))
					  .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
					  .build();
			
			StopWatch stopWatch = new StopWatch();
			log.info("start!");
			stopWatch.start();
			String req = "{\"adminUserSeq\":1}";
			
			Mono<ResponseModel> resultMono = client.post()
				.uri(url)
				.accept(MediaType.APPLICATION_JSON)
				//.attribute("request", req)		//"uri, ModelClass 혹은 string.class"
				//.bodyValue(parts)
				.body(BodyInserters.fromValue(req))
				.retrieve()
				.bodyToMono(ResponseModel.class);
			
			resultMono.subscribe((resultSubScribe) -> {
				log.info("1111111 resultFor3Sec: {}", resultSubScribe);

				if(stopWatch.isRunning()) {
					stopWatch.stop();
				}
	
				log.info("result(3Sec): {}", stopWatch.getTotalTimeSeconds());
				stopWatch.start();
			});
			
			TbAdminUserModel user = new TbAdminUserModel();
//			user.setAdminUserSeq(2);
//			user.setUserId("abcd");
			
			Mono<ResponseModel> resultMono2 = client.post()
					.uri(url)   
					.accept(MediaType.APPLICATION_JSON)
					//.bodyValue(parts2)
					.body(BodyInserters.fromValue(user))
					//.body(BodyInserters.fromPublisher(Mono.just("data"), String.class))
					//.attribute("model", user)		//"uri, ModelClass 혹은 string.class"
					.retrieve()
					.bodyToMono(ResponseModel.class);
			
			resultMono2.subscribe((resultSubScribe2) -> {
				log.info("22222222 resultFor5Sec: {}", resultSubScribe2);
				if(stopWatch.isRunning()) {
					stopWatch.stop();
				}
	
				log.info("result(5Sec): {}", stopWatch.getTotalTimeSeconds());
				stopWatch.start();
			});
			
			TbAdminUserModel user2 = new TbAdminUserModel();
//			user2.setAdminUserSeq(3);
//			user2.setUserId("abcd");
			
			Mono<ResponseModel> resultMono3 = client.post()
					.uri(url)   
					.accept(MediaType.APPLICATION_JSON)
					//.bodyValue(parts2)
					.body(BodyInserters.fromValue(user2))
					//.body(BodyInserters.fromPublisher(Mono.just("data"), String.class))
					//.attribute("model", user)		//"uri, ModelClass 혹은 string.class"
					.retrieve()
					.bodyToMono(ResponseModel.class);
			
			resultMono3.subscribe((resultSubScribe3) -> {
				log.info("33333333 resultFor8Sec: {}", resultSubScribe3);
				if(stopWatch.isRunning()) {
					stopWatch.stop();
				}
	
				log.info("33333333 result(8Sec): {}", stopWatch.getTotalTimeSeconds());
				stopWatch.start();
			});
			
			
//			List<Mono<ResponseModel>> list = new ArrayList<>();
//			
//			list.add(resultMono);
//			list.add(resultMono2);
//			list.add(resultMono3);
//			
//				
//				Map<String, Object> map = new LinkedHashMap<>();
//		          map.put("person", result);
//		          map.put("hobbies", result2);
//		        return map;
//	        );
//				Map<String, Object> map = new LinkedHashMap<>();
//				
//		          map.put("person", abcd);
//		          map.put("hobbies", result2);
//		          
//		        return map;
//			});
			
			data = Mono.zip( resultMono, resultMono2, (result, result2) -> {
				Map<String, Object> map = new LinkedHashMap<>();
		          map.put("1", result);
		          map.put("2", result2);
		          //map.put("3", resultMono3.block());
		        return map;
			}).block();
			
//			data.put("cccc", resultMono3.block());
//			data.put("aaaa", resultMono.block());
//			data.put("bbbb", resultMono2.block());
//			
			
			
//			data = Mono.zip( resultMono, resultMono2, (result, result2) -> {
//				Map<String, Object> map = new LinkedHashMap<>();
//		          map.put("person", result);
//		          map.put("hobbies", result2);
//		        return map;
//			}).block();
			
//			third = Mono.zip(resultMono, resultMono2, resultMono3).flatMap(resultFlat-> {
//				Map<String, Object> map = new LinkedHashMap<>();
//				map.put("1", resultFlat.getT1());
//				map.put("2", resultFlat.getT2());
//				map.put("3", resultFlat.getT3());
//				return map;
//			});
			
//			third = Mono.zip(resultMono, resultMono2, resultMono3).map(ta -> {
//				Map<String, Object> map = new LinkedHashMap<>();
//				map.put("1", ta.get);
//				map.put("2", t.getT2());
//				map.put("3", t.getT3());
//				return map;
//			});
			
//			Mono<String> m1 = Mono.just("A");
//			Mono<String> m2 = Mono.just("B");
//			Mono<String> m3 = Mono.empty();
//
//			Mono<String> combined = Mono.zip(strings -> {
//			    StringBuffer sb = new StringBuffer();
//			    for (Object string : strings) {
//			        sb.append((String) string);
//			    }
//			    return sb.toString();
//			}, m1, m2, m3);
//			System.out.println("Combined " + combined.block());
			
//			data = Mono.zip( resultMono, resultMono2, (result, result2) -> {
//				Map<String, Object> map = new LinkedHashMap<>();
//		          map.put("person", result);
//		          map.put("hobbies", result2);
//		        return map;
//			}).block();
			
//			third = Mono.zip(resultMono, resultMono2, (r1, r2) -> {
//				Map<String, Object> map = new LinkedHashMap<>();
//				map.put("1", r1);
//				map.put("2", r2);
//				return map;
//			}).block();
			
//			Mono.zip(resultMono, resultMono2, resultMono3).flatMap(dataa->{
//				Map<String, ResponseModel> tempMapa = new LinkedHashMap<>();
//				tempMapa.put("data1", dataa.getT1());
//				tempMapa.put("data2", dataa.getT2());
//				tempMapa.put("data3", dataa.getT3());
//				
//				return Mono.just(tempMapa);
//			}).block();
			
//			Mono.zip(resultMono, resultMono2, resultMono3).flatMap(dataa->{
//				Map<String, ResponseModel> tempMapa = new LinkedHashMap<>();
//				tempMapa.put("data1", dataa.getT1());
//				tempMapa.put("data2", dataa.getT2());
//				tempMapa.put("data3", dataa.getT3());
//				
//				return Mono.just(tempMapa);
//			}).block();
			
			
//			Mono.zip(resultMono, resultMono2, resultMono3).flatMap(dataa->{
//				Map<String, ResponseModel> tempMapa = new LinkedHashMap<>();
//				tempMapa.put("data1", dataa.getT1());
//				tempMapa.put("data2", dataa.getT2());
//				tempMapa.put("data3", dataa.getT3());
//				return Mono.just(tempMapa);
//			}).block();
//			flux = Flux.just(resultMono);
//			flux.concatWith(Flux.just(resultMono2));
//			flux.concatWith(Flux.just(resultMono3));
			
			//client.get
	//		WebClient client = WebClient.builder()
	//				.baseUrl(url)
	//				.defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
	//				.defaultUriVariables()
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		return data;
	}
	
	@RequestMapping(value="/testPage.do")
	public ModelAndView error(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView();
		model.setViewName("test/testPage");
		return model;
	}
	
	@RequestMapping(value="/upload.do", method = RequestMethod.POST
			, produces = "application/json; charset=utf8")
	@ResponseBody
	public String handleUpload(HttpServletRequest request) throws Exception {
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
//        	String fileName = request.getHeader("fileName");
//        	String contentRange = request.getHeader("Content-Range");
//        	contentRange = contentRange.replace("bytes ", "");
//        	String [] range = contentRange.split("/");
//        	int startBytes = Integer.valueOf(range[0]);
//        	int chunkBytes = Integer.valueOf(range[1]);
//        	int totalBytes = Integer.valueOf(range[2]);
//        	
//        	if(startBytes == 0) {
//        		File file = new File("D:\\as\\isFormField.mp4");
//        		if(file.exists()) {
//        			file.delete();
//        		}
//        	}
//        	InputStream stream = request.getInputStream();
//        	FileOutputStream out = new FileOutputStream("D:\\as\\isFormField.mp4", true);
//        	byte[] buf = new byte[1024*1024];
//			int len = 0;
//			while ((len = stream.read(buf)) > 0){
//				out.write(buf, 0, len);
//		    }
//		    
//        	out.flush();
//        	out.close();
        	
            // Parse the request
//            List<FileItem> items = upload.parseRequest(request);
//            // Process the uploaded items
//            Iterator<FileItem> iter = items.iterator();
//            while (iter.hasNext()) {
//                FileItem item = iter.next();
//
//                InputStream stream = item.getInputStream();
//                if (!item.isFormField()) {
//                	FileOutputStream out = new FileOutputStream("D:\\as\\isFormField.mp4", true);
//                	byte[] buf = new byte[1024*1024];
//    				int len = 0;
//    				while ((len = stream.read(buf)) > 0){
//    					out.write(buf, 0, len);
//    			    }
//    			    
//                	out.flush();
//                	out.close();
//                }
//            }
        	
            // Parse the request with Streaming API
            upload = new ServletFileUpload();
            FileItemIterator iterStream = upload.getItemIterator(request);
            while (iterStream.hasNext()) {
                FileItemStream item = iterStream.next();
                String name = item.getFieldName();
                InputStream stream = item.openStream();
                if (!item.isFormField()) {
                	log.info("File field " + name + " with file name "+ item.getName() + " detected.");
//                	Blob blob = stream.;
//                	InputStream is = blob.getBinaryStream();
                	
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
                	
                	
//                    try (InputStream uploadedStream = item.getInputStream();
//                    	OutputStream out = new FileOutputStream("file.mov");) {
//                    	IOUtils.copy(uploadedStream, out);
//			            out.close();
//                    }
                } 
                else {
                    //process form fields
                    log.info("Form field " + name + " with value " + Streams.asString(stream).length() + " detected.");//Streams.asString(stream)
                    
//                	OutputStream out = new FileOutputStream("D:\\as\\file.mp4", true);
//                	//IOUtils.copy(stream, out);
//                	byte[] buf = new byte[1024*1024];
//    				int len = 0;
//    				while ((len = stream.read(buf)) > 0){
//    					out.write(buf, 0, len);
//    			    }
//    			    
//                	out.flush();
//                	out.close();
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
