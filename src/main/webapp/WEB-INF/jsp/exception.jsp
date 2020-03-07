<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page session="false" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="petclinic" tagdir="/WEB-INF/tags" %>

<%
StringWriter sw = new StringWriter();
exception.printStackTrace(new PrintWriter(sw));
String errorStackTrace = sw.toString();
request.setAttribute("errorStackTrace", errorStackTrace);
%>
<petclinic:layout pageName="error">

    <spring:url value="/resources/images/pets.png" var="petsImage"/>
    <img src="${petsImage}"/>

    <h2>Something happened...</h2>

    <%-- <p>${exception.message}</p> --%>
    <p>${requestScope["errorStackTrace"]</p>

</petclinic:layout>
