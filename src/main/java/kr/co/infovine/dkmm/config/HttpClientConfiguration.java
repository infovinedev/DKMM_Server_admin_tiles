package kr.co.infovine.dkmm.config;

import java.time.Duration;
import java.util.concurrent.TimeUnit;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.netty.buffer.UnpooledByteBufAllocator;
import io.netty.channel.ChannelOption;
import io.netty.handler.ssl.SslContext;
import io.netty.handler.ssl.SslContextBuilder;
import io.netty.handler.ssl.util.InsecureTrustManagerFactory;
import io.netty.handler.timeout.ReadTimeoutHandler;
import io.netty.handler.timeout.WriteTimeoutHandler;
import reactor.netty.http.client.HttpClient;

@Configuration
public class HttpClientConfiguration {
	@Bean
	HttpClient getHttpClient() {
		HttpClient httpClient = null;
		try {
			SslContext sslContext = SslContextBuilder
		            .forClient()
		            .trustManager(InsecureTrustManagerFactory.INSTANCE)
		            .build();
			//sslContext.newEngine(UnpooledByteBufAllocator.DEFAULT);
			
			httpClient = HttpClient.create()
					.secure(t -> t.sslContext(sslContext))
					.option(ChannelOption.ALLOCATOR, UnpooledByteBufAllocator.DEFAULT)
//					  .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 15000)
					  .responseTimeout(Duration.ofMillis(15000))
					  .doOnConnected(conn -> 
					    conn.addHandlerLast(new ReadTimeoutHandler(15000, TimeUnit.MILLISECONDS))
					      .addHandlerLast(new WriteTimeoutHandler(15000, TimeUnit.MILLISECONDS)));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return httpClient;
	}
}
