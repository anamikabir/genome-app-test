<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="org.apache.commons.codec.binary.Base64"%>   
<%
	String type = request.getParameter("type").toString();
	String content = request.getParameter("content").toString().replace("data:image/png;base64,", "");
	OutputStream o = response.getOutputStream();
	byte nerStr[];
	if(type.equals("png")) {
		response.setContentType("image/png");	
		nerStr = Base64.decodeBase64(content.toString());
	} else {
		response.setContentType("text/xml");
		nerStr = content.getBytes();
	}
	response.setHeader("Content-Disposition","attachment;filename=network."+type);
	o.write(nerStr);
	o.flush();
	o.close();
	o = null;
	response.flushBuffer(); 
	out.clear(); 
	out = pageContext.pushBody();
%>    