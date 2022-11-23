package kr.co.infovine.dkmm.api.model.base;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(value = Include.NON_NULL)
public class ResultModel<T extends ResultModelData> {
	
	@JsonProperty
	private String code;
	
	private String errorMessage;
	
	private T data;
	
	public ResultModel() {
		super();
	}
	
	public ResultModel(String code, T data) {
		super();
		this.code = code;
		this.data = data;
	}
	
	public ResultModel(String code, String errorMessage) {
		super();
		this.code = code;
		this.errorMessage = errorMessage;
	}
	
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public T getData() {
		return data;
	}

	public void setData(T data) {
		this.data = data;
	}
	
	
	
}
