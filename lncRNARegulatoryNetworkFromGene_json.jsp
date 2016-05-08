<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="model.*" %>
<%@ page import="service.*" %>
<%
String subset1 = request.getParameter("subset1"),
			subset2 = request.getParameter("subset2"),
			top = request.getParameter("top"),
			gene = request.getParameter("gene"),
			lncRNA = request.getParameter("lncRNA"),
			isNegative = request.getParameter("isNegative");

SubsetExpService subsetExpService = new SubsetExpService();
out.println(subsetExpService.getlncRNARegulatoryNetworkFromGene(subset1, subset2, top, gene, lncRNA, isNegative));
subsetExpService.close();
%>