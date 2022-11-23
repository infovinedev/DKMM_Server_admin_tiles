package kr.co.infovine.dkmm.util;

import java.util.Calendar;

/**
 * 공통 유틸
 * 
 * kr.co.infovine.dkmm.util
 * CommonUtil.java
 * 2021-05-12 Made by Yunho, Kim
 */
public class CommonUtil {

	private CommonUtil() {}

	// region 설명: 문자 채우기
	/**
	 * 2021-05-13 Made by Yunho, Kim
	 * @param str
	 * @param length
	 * @param ch
	 * return : String
	 */
	public static String fillChar(String str, int length, char ch) {
		if (str == null) {
			return null;
		} else if (length < str.length()) {
			return str;
		}
		
		StringBuilder sb = new StringBuilder();
		
		int size = length - str.length();
		for (int i = 0; i < size; i++) {
			sb.append(ch);
		}
		
		sb.append(str);
		
		
		return sb.toString();
	}
	// end region

	// region 설명: 현재 날짜
	/**
	 * 2021-05-13 Made by Yunho, Kim
	 * return : String
	 */
	public static String getToday() {
		Calendar cal = Calendar.getInstance();
		
		StringBuilder sb = new StringBuilder();
		sb.append(cal.get(Calendar.YEAR));
		sb.append(CommonUtil.fillChar("" + (cal.get(Calendar.MONTH) + 1), 2, '0'));
		sb.append(CommonUtil.fillChar("" + cal.get(Calendar.DATE), 2, '0'));
		
		return sb.toString();
	}
	// end region

	// region 설명: 현재 날짜시간
	/**
	 * 2021-05-13 Made by Yunho, Kim
	 * @param args
	 * return : String
	 */
	public static String getNow() {
		Calendar cal = Calendar.getInstance();
		
		StringBuilder sb = new StringBuilder();
		sb.append(cal.get(Calendar.YEAR));
		sb.append(CommonUtil.fillChar("" + (cal.get(Calendar.MONTH) + 1), 2, '0'));
		sb.append(CommonUtil.fillChar("" + cal.get(Calendar.DATE), 2, '0'));
		sb.append(CommonUtil.fillChar("" + cal.get(Calendar.HOUR_OF_DAY), 2, '0'));
		sb.append(CommonUtil.fillChar("" + cal.get(Calendar.MINUTE), 2, '0'));
		sb.append(CommonUtil.fillChar("" + cal.get(Calendar.SECOND), 2, '0'));
		
		return sb.toString();
	}
	// end region

}
