package kr.co.infovine.dkmm.util;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.tomcat.util.codec.binary.Base64;

public class AESCBCCipher {

	private IvParameterSpec iv;
	private SecretKeySpec keySpec;

	// setting key
	public void setAESStrKey(String strkey, String striv) throws UnsupportedEncodingException {

		this.keySpec = new SecretKeySpec(strkey.getBytes("UTF-8"), "AES");
		
		if ( striv == null ) {
			this.iv = new IvParameterSpec(new byte[16]);
		
		}
		else {
			this.iv = new IvParameterSpec(striv.getBytes("UTF-8"));
		}
	}

	public void setAESHexKey(String strkey, String striv) {

		this.keySpec = new SecretKeySpec(hexStringToByteArray(strkey), "AES");
		this.iv = new IvParameterSpec(hexStringToByteArray(striv));
	}

	private static byte[] hexStringToByteArray(String s) {
		int len = s.length();
		byte[] data = new byte[len / 2];
		for (int i = 0; i < data.length; i++) 
		{ 
			data[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2), 16); 
		}
		
		/*
		 * for (int i = 0; i < len; i += 2) { data[i / 2] = (byte)
		 * ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i + 1),
		 * 16)); }
		 */
		return data;
	}

	private static String byteArrayToHexString(byte[] bytes) {

		StringBuilder sb = new StringBuilder();

		for (byte b : bytes) {

			sb.append(String.format("%02X", b & 0xff));
		}

		return sb.toString();
	}

	//
	public String aesEncodeToBase64(String str)
			throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {

		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.ENCRYPT_MODE, keySpec, iv);
		byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
		String enStr = new String(Base64.encodeBase64(encrypted));

		return enStr;
	}

	public String aesEncodeToHex(String str)
			throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {

		String enStr = "";
		try {
			Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
			c.init(Cipher.ENCRYPT_MODE, keySpec, iv);
			byte[] encrypted = c.doFinal(str.getBytes("UTF-8"));
			enStr = byteArrayToHexString(encrypted);
		} catch (NoSuchAlgorithmException ex) {
			System.out.println(ex.getMessage());

		} catch (GeneralSecurityException ex) {
			System.out.println(ex.getMessage());

		} catch (UnsupportedEncodingException ex) {
			System.out.println(ex.getMessage());

		} catch (Exception ex) {
			System.out.println(ex.getMessage());

		}

		return enStr;
	}

	//
	public String aesDecodeFromBase64(String str)
			throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {
		Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
		c.init(Cipher.DECRYPT_MODE, keySpec, iv);
		byte[] byteStr = Base64.decodeBase64(str.getBytes());
		return new String(c.doFinal(byteStr), "UTF-8");
	}

	public String aesDecodeFromHex(String str)
			throws NoSuchAlgorithmException, GeneralSecurityException, UnsupportedEncodingException {
		
		byte[] byteStr = null;
		try {
			Cipher c = Cipher.getInstance("AES/CBC/PKCS5Padding");
			c.init(Cipher.DECRYPT_MODE, keySpec, iv);
			byteStr = hexStringToByteArray(str);
			
			return new String(c.doFinal(byteStr), "UTF-8");

		} catch (NoSuchAlgorithmException ex) {
			System.out.println(ex.getMessage());
			
			return null;

		} catch (GeneralSecurityException ex) {
			System.out.println(ex.getMessage());
			
			return null;

		} catch (UnsupportedEncodingException ex) {
			System.out.println(ex.getMessage());
			
			return null;

		} catch (Exception ex) {
			System.out.println(ex.getMessage());
			
			return null;
		}
	}

	public static void main(String arg[]) throws Exception {
		AESCBCCipher ciper = new AESCBCCipher();

		String json = "{\"cust_code\":\"C0YFUHY5QQ\"}";

		try {
			ciper.setAESStrKey("1234567891234500", "1234567891234500");
			String enc = ciper.aesEncodeToBase64(json);

			System.out.println(enc);

			enc = "oh7Md3ccHS4ZwdTOXN0rB3TxqYS3F8GM8KLdsi6TX+Y=";
			String dec = ciper.aesDecodeFromBase64(enc);
			System.out.println(dec);
		} catch (Exception ex) {
			System.out.println(ex.getMessage());

		}

		// String enc =
		// ciper.aesEncode("{\"aebill\":{\"SKT_ITM_LIST\":{\"SKT_ITM\":{\"ITM_M_3_AMT\":\"30,160\",\"ITM_M_AMT\":\"57,570\",\"ITM_M_2_AMT\":\"24,160\",\"SVC_NUM\":\"010-8637-7069\",\"ITM_NM\":\"?씠?룞?쟾?솕\",\"ITM_M_1_AMT\":\"27,920\"}},\"SKB_ITM_LIST\":{\"SKB_ITM\":{\"ITM_M_3_AMT\":\"38,500\",\"ITM_M_AMT\":\"38,500\",\"ITM_M_2_AMT\":\"38,500\",\"SVC_NUM\":\"7286267207\",\"ITM_NM\":\"?씤?꽣?꽬\",\"ITM_M_1_AMT\":\"38,500\"}},\"RESULT_CD\":\"0\",\"RESULT_VAL\":\"\"}}
		// ");

	}

}
