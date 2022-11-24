package kr.co.infovine.dkmm.service.admin;

import java.util.List;

import javax.crypto.spec.IvParameterSpec;

import org.codehaus.jettison.json.JSONArray;

public interface EncryptService {
	public String getAesEncode(String str, String aesSecretKey, byte[] ivBytes);
	
	public String getAesDecode(String str, String aesSecretKey, byte[] ivBytes);
	
	public String getEncryptSha512(String id);
	
	IvParameterSpec getMakeAesIv();
	
	public byte[] getByteIv(JSONArray ivArray);
	
	public List<Integer> getListIv(JSONArray ivArray);
}
