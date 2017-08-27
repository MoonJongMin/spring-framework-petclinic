<%@ page session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>
<% 
	String serverIp = java.net.Inet4Address.getLocalHost().getHostAddress();
	request.setAttribute("serverIp", serverIp);
%>
<petclinic:layout pageName="home">
    <!--h2><fmt:message key="welcome"/> (Server IP is ${pageContext.request.localAddr})</h2-->
    <h2><fmt:message key="welcome"/> (Server IP is ${requestScope["serverIp"]})</h2>
    <div class="row">
        <div class="col-md-12">
            <spring:url value="/resources/images/petclinic.png" htmlEscape="true" var="petsImage"/>
            <img class="img-responsive" src="${petsImage}"/>
        </div>
    </div>
</petclinic:layout>
