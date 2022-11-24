package kr.co.infovine.dkmm.controller.map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.extern.slf4j.Slf4j;
import reactor.netty.http.client.HttpClient;

@Component
@Slf4j
@Controller
public class MapController{
	private final String TYPE_SUCCESS_IN_API_VWORLD = "OK";

	@Autowired
	HttpClient httpClient;
	
	@Value("${vworld.api.domain}")
	private String domainVWorld;

	@Value("${vworld.api.key}")
	private String keyVWorld;

	@Value("${vworld.api.url}")
	private String urlVWorld;

	@Value("${vworld.api.version}")
	private String versionVWorld;

	@Value("${vworld.api.crs}")
	private String crsVWorld;

	// 도로명 주소로 위치 좌표 가져오기
	public String getMapXY(String roadAddr){
		JSONObject resultObj = new JSONObject();
		try {
			MultiValueMap<String, String> builder = new LinkedMultiValueMap<>();
			builder.add("service", "address");
			builder.add("request", "getcoord");
			builder.add("version", versionVWorld);
			builder.add("crs", crsVWorld);
			builder.add("address", roadAddr);
			builder.add("refine", "true");
			builder.add("format", "json");
			builder.add("type", "road");
			builder.add("key", keyVWorld);
			builder.add("simple", "false");

			WebClient requestApiOfVworld = WebClient.builder()
					.clientConnector(new ReactorClientHttpConnector(httpClient))
					  .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
					  .build();

			String resultApiOfVworld = requestApiOfVworld.post()
			.uri(domainVWorld + urlVWorld)
			.accept(MediaType.APPLICATION_JSON)
			.body(BodyInserters.fromFormData(builder))
			.retrieve()
			.bodyToMono(String.class).block();

			//http://api.vworld.kr/req/address?service=address&request=getcoord&version=2.0&crs=epsg:4326&address=%ED%9A%A8%EB%A0%B9%EB%A1%9C72%EA%B8%B8%2060&refine=true&simple=false&format=json&type=road&key=[KEY]

			JSONObject resultVworldJson = new JSONObject(resultApiOfVworld);
			if(!resultVworldJson.isNull("response")) {
				JSONObject responseJson = resultVworldJson.getJSONObject("response");
				if(!responseJson.isNull("status")) {
					String status = responseJson.getString("status");
					if(status.equals(TYPE_SUCCESS_IN_API_VWORLD)) {
						if(!responseJson.isNull("result")) {
							JSONObject resultJson = responseJson.getJSONObject("result");
							if(!resultJson.isNull("point")) {
								JSONObject pointJson = resultJson.getJSONObject("point");
								String latitude = null;
								String longitude = null;
								if(!pointJson.isNull("x")) {
									longitude = pointJson.getString("x");
								}
								if(!pointJson.isNull("y")) {
									latitude = pointJson.getString("y");
								}
								resultObj.put("latitude", latitude);					//위도 WGS84(EPGS4326)
								resultObj.put("longitude", longitude);					//경도 WGS84(EPGS4326)
							}
						}
					}
				}
			}
		}
		catch (Exception e) {
			System.out.println("=========Err==="+e);
		}
		return resultObj.toString();
	}
}
