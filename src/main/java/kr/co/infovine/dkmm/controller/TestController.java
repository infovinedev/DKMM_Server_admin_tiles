package kr.co.infovine.dkmm.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.stereotype.Controller;
import org.springframework.util.StopWatch;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.infovine.dkmm.api.model.base.ResponseModel;
import kr.co.infovine.dkmm.db.model.admin.TbAdminPermissionModel;
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
			user.setAdminUserSeq(2);
			user.setUserId("abcd");
			
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
			user2.setAdminUserSeq(3);
			user2.setUserId("abcd");
			
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
	
	
	
	// region 설명: 로그인 프로세스
	/**
	 * 2021-05-10 Made by Duhyun, Kim
	 * @param args
	 * return : ResponseModel
	 */
	@RequestMapping(value="/menu.do", method = RequestMethod.POST
			, consumes = "application/json; charset=utf8", produces = "application/json; charset=utf8" )
	@ResponseBody
	public ResponseModel selectLeftMenu(HttpServletRequest request, HttpServletResponse response, HttpSession session
			, @RequestBody TbAdminUserModel user
		) {
		ResponseModel result = new ResponseModel();
		try {
			ObjectMapper requestMapper = new ObjectMapper();
			//TbAdminUser user = requestMapper.readValue(requestBody, TbAdminUser.class);
					
			int adminUserSeq = 0;
			if(user != null) {
				adminUserSeq = user.getAdminUserSeq();
			}
			if(adminUserSeq != 0){
				List<TbAdminPermissionModel> resultSet = tbAdminPermissionMapper.selectByUserLeftMenu(adminUserSeq);
				
				if(resultSet.size() > 0) {
					//로그인 성공시
					try {
						
						ObjectMapper mapper = new ObjectMapper();
						String strLeftMenu = mapper.writeValueAsString(resultSet);
						result.setResult(strLeftMenu);
						if(adminUserSeq == 1) {
							Thread.sleep(2000);
						}
						else if(adminUserSeq == 2) {
							Thread.sleep(5000);
						}
						else if(adminUserSeq == 3) {
							Thread.sleep(8000);
						}
					} catch (Exception e) {
						log.error(e.getMessage());
					}
				}
				else {
					if(adminUserSeq == 3) {
						Thread.sleep(8000);
					}
					result.setCode("0001");
				}
			}
			else {
				result.setCode("0001");
			}
		}catch (Exception e) {
		}
		return result;
	}
	// end region
}
