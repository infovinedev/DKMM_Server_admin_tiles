package kr.co.infovine.dkmm;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = DkmmAdminApplication.class
, 
properties = {"server.mode=local"})
class DkmmAdminApplicationTests {

	@Test
	void contextLoads() {
	}

}
