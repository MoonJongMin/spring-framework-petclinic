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
	SecurityManager appsm = System.getSecurityManager();
	if(appsm == null) {
		request.setAttribute("securityManager", "null");
	} else {
		request.setAttribute("securityManager", appsm);
	}
	String dnsCacheTime = java.security.Security.getProperty("networkaddress.cache.ttl");
	request.setAttribute("dnsCacheTime", dnsCacheTime);
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
    	<fmt:message key="welcome"/> (Server IP or hostname is ${requestScope["serverIp"]})<br>
    	Security Manager is ${requestScope["securityManager"]}<br>
    	networkaddress.cache.ttl (DNS Cache Time) is ${requestScope["dnsCacheTime"]} seconds.
    </div>
    <div class="row">
        <div class="col-md-12">
            <spring:url value="/resources/images/petclinic.png" htmlEscape="true" var="petsImage"/>
            <img class="img-responsive" src="${petsImage}"/>
        </div>
    </div>
</petclinic:layout>
