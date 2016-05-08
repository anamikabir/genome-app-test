<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="model.*" %>
<%@ page import="service.*" %>
<%@ page import="org.apache.commons.math3.stat.descriptive.moment.StandardDeviation" %>
<%
String subset1 = request.getParameter("subset1"),
			subset2 = request.getParameter("subset2"),
			subset1Title = request.getParameter("subset1Title"),
			subset2Title = request.getParameter("subset2Title"),
			subset1SubTitle = request.getParameter("subset1SubTitle"),
			subset2SubTitle = request.getParameter("subset2SubTitle");

String titles[] = subset1Title.split(" - ");
pageContext.setAttribute("Title", titles[0]);
pageContext.setAttribute("subset1Title", subset1Title);
pageContext.setAttribute("subset2Title", subset2Title);
pageContext.setAttribute("subset1SubTitle", subset1SubTitle);
pageContext.setAttribute("subset2SubTitle", subset2SubTitle);
%>

<h3 style="color: #1B446B; display: inline;line-height: 18px;">${Title} : ${subset1SubTitle} V.S. ${subset2SubTitle}</h3>
<%
GseInfoService gseInfoService = new GseInfoService();
GseInfo gseInfo = gseInfoService.selectFromSubset(subset1);
gseInfoService.close();

if (gseInfo != null) {
	pageContext.setAttribute("title", gseInfo.getTitle());
	pageContext.setAttribute("gseID", gseInfo.getGseID());
	pageContext.setAttribute("summary", gseInfo.getSummary());
%>

	<table width="100%" cellspacing="1px" style="margin-top:6px;">
	
		<tr>
			<th id="td_text_right" width="80px">Title : </th>
			<th id="content"><a href="http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=${gseID}" target="_blank" style="text-decoration:none;">${gseID}</a>&nbsp;${title}</th>		
		</tr>
	
		<tr>
			<th id="td_text_right" valign="top">Summary : </th>
			<td id="content">
				<div style="max-height:90px; overflow: auto; border: gray 1px solid; padding: 6px;">
					${summary}
				</div>
			</td>		
		</tr>
	
	</table>
	
	<table width="100%" cellspacing="1px">
		
		<tr>
			<td width="50px" style="color: #ffffff; background-color: #888888; border: #ffffff 1px solid; cursor: pointer;" title="${subset1Title}">1</td>
			<td id="td_text_left">&nbsp;${subset1Title}</td>
		</tr>
		
		<tr>	
			<td style="color: #ffffff; background-color: #888888; border: #ffffff 1px solid; cursor: pointer;" title="${subset2Title}">2</td>
			<td id="td_text_left">&nbsp;${subset2Title}</td>
		</tr>
		
	</table>

<%
} else {
	TCGAService tcgaService = new TCGAService();
	TCGADataset tcgaDataset = tcgaService.selectFromSubset(subset1, subset2);
	tcgaService.close();
	
	pageContext.setAttribute("summary", tcgaDataset.getSummary());
	
	StringBuffer sb = new StringBuffer();
	for (String more : tcgaDataset.getMore())
		sb.append("<div><a href=\"" + more + "\" target=\"_blank\">" + more + "</a></div>");
	pageContext.setAttribute("more", sb.toString());
%>

	<table width="100%" cellspacing="1px" style="margin-top:6px; margin-bottom: 6px;">
	
		<tr>
			<th id="td_text_right" valign="top" width="90px">Summary : </th>
			<td id="content">
				<div style="max-height: 200px; overflow: auto; border: gray 1px solid; padding: 6px;">
					${summary}
				</div>
			</td>		
		</tr>
		
		<!-- 
		<tr>
			<th id="td_text_right" valign="top">References : </th>
			<td id="content">
				<div style="max-height:90px; overflow: auto;">
					${more}
				</div>
			</td>		
		</tr>
		 -->
	
	</table>

	<!-- 
	<table width="100%" cellspacing="1px">
		
		<tr>
			<td width="50px" style="color: #ffffff; background-color: #888888; border: #ffffff 1px solid; cursor: pointer;" title="${subset1Title}">1</td>
			<td id="td_text_left">&nbsp;${subset1Title}</td>
		</tr>
		
		<tr>	
			<td style="color: #ffffff; background-color: #888888; border: #ffffff 1px solid; cursor: pointer;" title="${subset2Title}">2</td>
			<td id="td_text_left">&nbsp;${subset2Title}</td>
		</tr>
		
	</table>
	 -->
	
<%
}
%>