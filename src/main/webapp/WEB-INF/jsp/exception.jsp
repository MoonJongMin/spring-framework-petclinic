<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<%
// 이 jsp를 ErrorPage로 설정(isErrorPage="true") 하고 exception 예약어 바로 쓰도록 변경
// Exception exception = (Exception)request.getAttribute("exception");
if(exception != null) {
	StringWriter sw = new StringWriter();
	exception.printStackTrace(new PrintWriter(sw));
	String errorStackTrace = sw.toString();
	request.setAttribute("errorStackTrace", errorStackTrace);
}
%>
<petclinic:layout pageName="error">

    <spring:url value="/resources/images/pets.png" var="petsImage"/>
    <img src="${petsImage}"/>

    <h2>Something happened...</h2>

    <%-- <p>${exception.message}</p> --%>
    <p>${errorStackTrace}</p>

</petclinic:layout>
