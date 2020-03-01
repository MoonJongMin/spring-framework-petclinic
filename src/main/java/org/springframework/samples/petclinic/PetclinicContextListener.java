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
		SecurityManager appsm = System.getSecurityManager();
		if(appsm == null) {
			LOG.info("SecurityManager is not set.");
		} else {
			LOG.info("SecurityManager is set.");
		}
		// get DNS lookup cache time seconds
		String dnsCacheTimeout = java.security.Security.getProperty("networkaddress.cache.ttl");
		if(dnsCacheTimeout != null) {
			LOG.info("DNS lookup cache time is {} seconds.", Integer.parseInt(dnsCacheTimeout));
		} else {
			LOG.info("DNS lookup cache time is not set.");
			java.security.Security.setProperty("networkaddress.cache.ttl" , "5");
			LOG.info("Now DNS lookup cache time is set to 5 seconds.");
		}
		LOG.debug("ContextInitialized ended.");
	}

}
