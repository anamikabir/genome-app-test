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
			pageWidth = request.getParameter("pageWidth");

pageContext.setAttribute("subset1title", subset1Title);
pageContext.setAttribute("subset2title", subset2Title);
pageContext.setAttribute("pageWidth", pageWidth);
%>

<h3 style="color: #1B446B; display: inline;line-height: 18px;">${subset1title} v.s. ${subset2title}</h3>
<%
GseInfoService gseInfoService = new GseInfoService();
GseInfo gseInfo = gseInfoService.selectFromSubset(subset1);
gseInfoService.close();

if (gseInfo != null) {
	pageContext.setAttribute("title", gseInfo.getTitle());
	pageContext.setAttribute("gseID", gseInfo.getGseID());
	pageContext.setAttribute("summary", gseInfo.getSummary());
%>

	<table width="${pageWidth - 104}px" cellspacing="1px" style="margin-top:6px;">
	
		<tr>
			<th id="td_text_right" width="80px">Title : </th>
			<td id="content" style="font-weight: bold;"><a href="http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=${gseID}" target="_blank" style="text-decoration:none;">${gseID}</a>&nbsp;${title}</th>		
		</tr>
	
		<tr>
			<th id="td_text_right" valign="top">Summary : </th>
			<td id="content">
				${summary}
			</td>		
		</tr>
	
	</table>
	
	<table width="100%" cellspacing="1px">
		
		<tr>
			<td width="50px" style="color: #ffffff; background-color: #888888; border: #ffffff 1px solid; cursor: pointer;" title="${subset1title}">1</td>
			<td id="td_text_left">&nbsp;${subset1title}</td>
		</tr>
		
		<tr>	
			<td style="color: #ffffff; background-color: #888888; border: #ffffff 1px solid; cursor: pointer;" title="${subset2title}">2</td>
			<td id="td_text_left">&nbsp;${subset2title}</td>
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

	<table width="100%" cellspacing="1px" style="margin-top:6px;">
	
		<tr>
			<th id="td_text_right" valign="top" width="90px">Summary : </th>
			<td id="content">
				${summary}
			</td>		
		</tr>
	
		<!-- 
		<tr>
			<th id="td_text_right" valign="top">References : </th>
			<td id="content">
				<div style="max-height:90px; overflow: auto; text-align: left;">
					${more}
				</div>
			</td>		
		</tr>
		 -->
	
	</table>

	<!-- 
	<table width="100%" cellspacing="1px">
		
		<tr>
			<td width="50px" style="border: #0000FF 1px solid; cursor: pointer;" title="${subset1title}">1</td>
			<td id="td_text_left">&nbsp;${subset1title}</td>
		</tr>
		
		<tr>	
			<td style="border: #0000FF 1px solid; cursor: pointer;" title="${subset2title}">2</td>
			<td id="td_text_left">&nbsp;${subset2title}</td>
		</tr>
		
	</table>
	 -->
	
<%
}
%>