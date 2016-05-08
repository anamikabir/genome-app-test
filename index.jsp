<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%
pageContext.setAttribute("gseID", request.getParameter("gseID"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="shortcut icon" href="images/logo.ico">
<title>Cancer RNA-Seq Nexus</title>
<style type="text/css">
html, body {
	height: 100%;
	overflow: hidden;
}
</style>
</head>

<body Marginwidth="-1" Marginheight="-1" Topmargin="0" Leftmargin="0" Rightmargin="0">

<div style="width:100%;height:4em;float:left;">
	<iframe name="top" width="100%" height="100%" src="top.jsp" scrolling="no" frameborder="0"></iframe>
</div>

<div id="center" style="width:100%;height:calc(100% - 4em);height:-webkit-calc(100% - 4em);float:left;">
	<iframe name="center" width="100%" height="100%" src="ttest.jsp" frameborder="0"></iframe>
</div>

</body>

</html>