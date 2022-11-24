package kr.co.infovine.dkmm.service.admin;

import java.io.ByteArrayOutputStream;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.List;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.codehaus.jettison.json.JSONArray;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Service("encryptService")
@Slf4j
public class EncryptServiceImpl implements EncryptService {
	//private String aesSecretKey = "D9B986E97535792DFA3AE0585B81BB6C";

	public String getDateTime(){
		DateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
		Date now = new Date();
		return df.format(now);
	}
	
	public String getEncryptSha512(String id){
		id = "InfovineDHKim" + id + getDateTime();
		
		String password = "";
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            byte[] bytes = id.getBytes(Charset.forName("UTF-8"));
            md.update(bytes);

            byte[] mdByte = md.digest();
            for (int i = 0; i < mdByte.length; i++) {
                String s = Integer.toHexString(mdByte[i]);
                while (s.length() < 2) {
                    s = "0" + s;
                }
                s = s.substring(s.length() - 2);
                password += s;

            }
            return password;
        } catch (Exception e) {
            log.error(e.getMessage());
            return null;
        }
	}
	
	@Override
	public String getAesEncode(String str, String aesSecretKey, byte[] ivBytes) {
		String result=null;
    	try {
	    	byte[] textBytes = str.getBytes(Charset.forName("UTF-8"));
	        AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
	        SecretKeySpec newKey = new SecretKeySpec(aesSecretKey.getBytes("UTF-8"), "AES");
	        Cipher cipher = null;
	        cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
	        cipher.init(Cipher.ENCRYPT_MODE, newKey, ivSpec);
	        byte[] buffer = cipher.doFinal(textBytes);
	        result = Base64.getEncoder().encodeToString(buffer); 
    	}
        catch(Exception e) {
        	log.error(e.getMessage());
        }
        return result;
	}

	@Override
	public String getAesDecode(String str, String aesSecretKey, byte[] ivBytes) {
		String result=null;
    	try{
    		byte[] textBytes =Base64.getDecoder().decode(str.getBytes());
            AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
            SecretKeySpec newKey = new SecretKeySpec(aesSecretKey.getBytes("UTF-8"), "AES");
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, newKey, ivSpec);
            byte[] buffer = cipher.doFinal(textBytes);
            result = new String(buffer, "UTF-8");
    	}
    	catch (Exception e) {
    		log.error(e.getMessage());
		}
    	return result;
	}

	@Override
	public IvParameterSpec getMakeAesIv() {
		SecureRandom randomSecureRandom = new SecureRandom();
	    byte[] iv = new byte[16];
	    randomSecureRandom.nextBytes(iv);
	    IvParameterSpec ivParams = new IvParameterSpec(iv);

	    return ivParams;
	}
	
	@Override
	public byte[] getByteIv(JSONArray ivArray) {
		byte[] iv = new byte[16];
		try {
			ByteArrayOutputStream out = new ByteArrayOutputStream();
			for (int ivi = 0; ivi < ivArray.length(); ivi++) {
				out.write(ivArray.getInt(ivi));
			}
			iv = out.toByteArray();
			out.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return iv;
	}

	@Override
	public List<Integer> getListIv(JSONArray ivArray) {
		List<Integer> list = new ArrayList<Integer>();
		try {
			for(int i=0; i<ivArray.length(); i++) {
				list.add(ivArray.getInt(i));
			}
		}
		catch (Exception e) {
		}
		return list;
	}
	
}
