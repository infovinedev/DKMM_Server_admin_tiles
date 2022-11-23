package kr.co.infovine.dkmm.api.model.base;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Getter;
import lombok.Setter;


/**
 * responseModel의 vo를 최소한으로 만들기 위함
 * kr.co.infovine.dkmm.api.model.base
 * ResponseModel.java
 * 2021-05-17 Made by Duhyun, Kim
 */
@Getter
@Setter
@JsonIgnoreProperties(ignoreUnknown = true)
public class ResponseModel extends ResultModel<ResultModelData> {
	private String result;
}
