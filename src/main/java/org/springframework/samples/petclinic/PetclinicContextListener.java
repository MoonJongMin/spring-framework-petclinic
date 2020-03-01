package org.springframework.samples.petclinic;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebListener
public class PetclinicContextListener implements ServletContextListener {
	
	private static final Logger LOG = LoggerFactory.getLogger(PetclinicContextListener.class);
	
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		LOG.debug("ContextInitialized starting...");
		
		// check SecurityManager is null or not.
		SecurityManager securityManager = System.getSecurityManager();
		if(securityManager == null) {
			LOG.info("SecurityManager is not set.");
		} else {
			LOG.info("SecurityManager is set.");
		}
		
		// DNS cache time mechanism is associated with sun.net.InetAddressCachePolicy in rt.jar.
		// set DNS lookup Cache time with highest priority.
//		java.security.Security.setProperty("networkaddress.cache.ttl", "5");
		String dnsCacheSetter = null;
		String dnsCacheTime = null;
		String networkaddressCacheTtl = java.security.Security.getProperty("networkaddress.cache.ttl");
		String sunNetInetaddrTtl = System.getProperty("sun.net.inetaddr.ttl");
		
		if(networkaddressCacheTtl != null) {
			dnsCacheTime = networkaddressCacheTtl;
			dnsCacheSetter = "networkaddress.cache.ttl";
		} else if(sunNetInetaddrTtl != null) {
			dnsCacheTime = sunNetInetaddrTtl;
			dnsCacheSetter = "sun.net.inetaddr.ttl";
		} else if(securityManager == null) {
			dnsCacheTime = "30";
			dnsCacheSetter = "no networkaddress.cache.ttl, no sun.net.inetaddr.ttl and no Security Manager";
		} else {
			dnsCacheTime = "FOREVER";
			dnsCacheSetter = "no networkaddress.cache.ttl, no sun.net.inetaddr.ttl but Security Manager";
		}
		LOG.info("DNS lookup cache time is {} seconds. It is set by {}.", dnsCacheTime, dnsCacheSetter);
		
		LOG.debug("ContextInitialized ended.");
	}

}
