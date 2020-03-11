<%@ page session="false" trimDirectiveWhitespaces="true" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<% 
	String serverIp = "";
    try {
		serverIp = java.net.Inet4Address.getLocalHost().getHostAddress();
    } catch (Exception e) {
    		serverIp = getHostname();
    }
	request.setAttribute("serverIp", serverIp);
	
	// This is to check DNS cache time.
	SecurityManager securityManager = System.getSecurityManager();
	if(securityManager == null) {
		request.setAttribute("securityManager", "null");
	} else {
		request.setAttribute("securityManager", securityManager);
	}
	String networkaddressCacheTtl = java.security.Security.getProperty("networkaddress.cache.ttl");
	if(networkaddressCacheTtl == null) {
		request.setAttribute("networkaddressCacheTtl", "null");
	} else {
		request.setAttribute("networkaddressCacheTtl", networkaddressCacheTtl);
	}
	String sunNetInetaddrTtl = System.getProperty("sun.net.inetaddr.ttl");
	if(sunNetInetaddrTtl == null) {
		request.setAttribute("sunNetInetaddrTtl", "null");
	} else {
		request.setAttribute("sunNetInetaddrTtl", sunNetInetaddrTtl);
	}
	
	// DNS cache time mechanism is associated with sun.net.InetAddressCachePolicy in rt.jar.
	String dnsCacheTime = null;
	String dnsCacheSetter = null;
	if(networkaddressCacheTtl != null) {
		dnsCacheTime = networkaddressCacheTtl;
		dnsCacheSetter = "networkaddress.cache.ttl";
	} else if(sunNetInetaddrTtl != null) {
		dnsCacheTime = sunNetInetaddrTtl;
		dnsCacheSetter = "sun.net.inetaddr.ttl";
	} else if(securityManager == null) {
		dnsCacheTime = "30";
		dnsCacheSetter = "no networkaddress.cache.ttl, no sun.net.inetaddr.ttl, no Security Manager, but default value";
	} else {
		dnsCacheTime = "FOREVER";
		dnsCacheSetter = "no networkaddress.cache.ttl, no sun.net.inetaddr.ttl, but Security Manager";
	}
	
	request.setAttribute("dnsCacheTime", dnsCacheTime);
	request.setAttribute("dnsCacheSetter", dnsCacheSetter);
%>

<%!
public static class StreamGobbler extends Thread {
	private InputStream is;
	private StringBuilder sb = new StringBuilder();
	public StreamGobbler(InputStream is) {
		this.is = is;
	}

	public void run() {
		try {
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
		} catch (IOException ignore) {
		}
	}
	
	public String getResult() {
		return sb.toString();
	}
}

private String getHostname() throws Exception {
	Process process = Runtime.getRuntime().exec("hostname");
	StreamGobbler gb1 = new StreamGobbler(process.getInputStream());
	StreamGobbler gb2 = new StreamGobbler(process.getErrorStream());
	gb1.start();
	gb2.start();
	
	while(true) {
		if (!gb1.isAlive() && !gb2.isAlive()) {  //두개의 스레드가 정지하면 프로세스 종료때까지 기다린다.
			process.waitFor();
			break;
		}
	}
	return gb1.getResult();
}
%>

<petclinic:layout pageName="home">
    <%-- <h2><fmt:message key="welcome"/> (Server IP is ${pageContext.request.localAddr})</h2> This always display 127.0.0.1 --%>
    <div class="form-group">
    	<fmt:message key="welcome"/> (Server IP or hostname is ${serverIp})<br>
    	networkaddress.cache.ttl (DNS Cache Time priority #1) is ${networkaddressCacheTtl} seconds.<br>
    	sun.net.inetaddr.ttl (DNS Cache Time priority #2) is ${sunNetInetaddrTtl} seconds.<br>
    	Security Manager is ${securityManager}.<br>
    	DNS Cache time is ${dnsCacheTime} seconds. It is set by ${dnsCacheSetter}.
    </div>
    <div class="row">
        <div class="col-md-12">
            <spring:url value="/resources/images/petclinic.png" htmlEscape="true" var="petsImage"/>
            <img class="img-responsive" src="${petsImage}"/>
        </div>
    </div>
</petclinic:layout>
