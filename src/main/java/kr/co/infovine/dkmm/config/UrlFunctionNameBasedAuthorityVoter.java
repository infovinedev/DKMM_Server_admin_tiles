package kr.co.infovine.dkmm.config;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.expression.WebExpressionVoter;

/**
 * UrlFunctionNameBasedAuthorityVoter Class 입니다.
 *
 * @author duHyun, Kim
 */
public class UrlFunctionNameBasedAuthorityVoter extends WebExpressionVoter{
	private static final String URL_SEPERATOR = "/";

	private String[] readFunctionNames = { "index", "management", "view", "data", "registration", "get", "export" };

	private String[] writeFunctionNames = { "save", "edit", "update", "delete", "create", "refresh", "modify", "set",
			"import" };

	private String readSuffix = "read";

	private String writeSuffix = "write";

	public String[] getReadFunctionNames() {
		return readFunctionNames;
	}

	public void setReadFunctionNames(String[] readFunctionNames) {
		this.readFunctionNames = readFunctionNames;
	}

	public String[] getWriteFunctionNames() {
		return writeFunctionNames;
	}

	public void setWriteFunctionNames(String[] writeFunctionNames) {
		this.writeFunctionNames = writeFunctionNames;
	}

	public String getReadSuffix() {
		return readSuffix;
	}

	public void setReadSuffix(String readSuffix) {
		this.readSuffix = readSuffix;
	}

	public String getWriteSuffix() {
		return writeSuffix;
	}

	public void setWriteSuffix(String writeSuffix) {
		this.writeSuffix = writeSuffix;
	}

	/**
	 * 요청 url 에 따른 권한 처리
	 */
	@Override
	public int vote(Authentication authentication, FilterInvocation fi, Collection<ConfigAttribute> attributes) {

		int returnVal = super.vote(authentication, fi, attributes);

		if (returnVal == ACCESS_GRANTED) {
			return returnVal;
		}

		if (authentication == null) {
			return ACCESS_ABSTAIN;
		}

		String url = fi.getRequestUrl();
		int lastIndexOf = url.lastIndexOf(".");
		if (lastIndexOf >= 0) {
			@SuppressWarnings("unused")
			String extension = url.substring(lastIndexOf + 1);
			url = url.substring(0, lastIndexOf);
		}

		Set<String> authoritySet = getAuthoritySet(authentication);
		String authority = url + URL_SEPERATOR + readSuffix;
		returnVal = checkAuthority(authoritySet, authority);
		if (returnVal == ACCESS_GRANTED) {
			return returnVal;
		}

		authority = url + URL_SEPERATOR + writeSuffix;
		returnVal = checkAuthority(authoritySet, authority);
		if (returnVal == ACCESS_GRANTED) {
			return returnVal;
		}

		lastIndexOf = url.lastIndexOf("/");
		String parentPath = url.substring(0, lastIndexOf);
		String functionName = url.substring(lastIndexOf + 1);
		functionName = functionName.toLowerCase();

		returnVal = checkReadAuthority(authoritySet, parentPath, functionName);
		if (returnVal == ACCESS_GRANTED) {
			return returnVal;
		}

		returnVal = checkWriteAuthority(authoritySet, parentPath, functionName);
		if (returnVal == ACCESS_GRANTED) {
			return returnVal;
		}

		return returnVal;
	}

	private int checkReadAuthority(Set<String> authoritySet, String url, String functionName) {
		int returnVal = ACCESS_ABSTAIN;

		for (String name : readFunctionNames) {
			if (functionName.contains(name)) {
				String authority = url + URL_SEPERATOR + readSuffix;
				return checkAuthority(authoritySet, authority);
			}
		}

		return returnVal;
	}

	private int checkWriteAuthority(Set<String> authoritySet, String url, String functionName) {
		int returnVal = ACCESS_ABSTAIN;

		for (String name : writeFunctionNames) {
			if (functionName.contains(name)) {
				String authority = url + URL_SEPERATOR + writeSuffix;
				return checkAuthority(authoritySet, authority);
			}
		}

		return returnVal;
	}

	private int checkAuthority(Set<String> authoritySet, String authority) {
		if (authority == null || (authority != null && authority.isEmpty())) {
			return ACCESS_ABSTAIN;
		}

		// 검사한다.
		if (authoritySet.contains(authority)) {
			return ACCESS_GRANTED;
		}
		return ACCESS_ABSTAIN;
	}

	private Set<String> getAuthoritySet(Authentication authentication) {

		Set<String> returnVal = new HashSet<String>();
		// 검사한다.
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		// Attempt to find a matching granted authority
		for (GrantedAuthority grantedAuthority : authorities) {
			returnVal.add(grantedAuthority.getAuthority());
		}

		return returnVal;
	}
}
