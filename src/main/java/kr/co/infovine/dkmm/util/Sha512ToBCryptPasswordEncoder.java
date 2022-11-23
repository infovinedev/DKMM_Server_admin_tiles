package kr.co.infovine.dkmm.util;

import org.springframework.security.crypto.password.DelegatingPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class Sha512ToBCryptPasswordEncoder implements PasswordEncoder {
	private PasswordEncoder bcryptPasswordEncoder;
    private DelegatingPasswordEncoder sha512PasswordEncoder;
    private String salt;
	
	@Override
	public String encode(CharSequence rawPassword) {
		if (rawPassword == null) {
			throw new IllegalArgumentException("rawPassword cannot be null");
		}
		if(rawPassword.equals("userNotFoundPassword")) {
			return rawPassword.toString();
		}
		else {
			return bcryptPasswordEncoder.encode(rawPassword);
		}
	}

	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		if (encodedPassword.startsWith("$2a$10$") && encodedPassword.length() == 60) {
            return bcryptPasswordEncoder.matches(rawPassword, encodedPassword);
        }

        if (encodedPassword.length() == 128) {
            //return sha512PasswordEncoder.isPasswordValid(encodedPassword, rawPassword.toString(), salt);
        	return rawPassword.toString().equals(encodedPassword);
        }

        return false;
	}

	public void setBcryptPasswordEncoder(PasswordEncoder bcryptPasswordEncoder) {
        this.bcryptPasswordEncoder = bcryptPasswordEncoder;
    }

    public void setSha256PasswordEncoder(DelegatingPasswordEncoder sha512PasswordEncoder) {
        this.sha512PasswordEncoder = sha512PasswordEncoder;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }
}
