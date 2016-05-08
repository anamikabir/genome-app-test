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
			geneName = request.getParameter("geneName"),
			isoform = request.getParameter("isoform");

Boolean isUpRegulation;
int start, end;

if (subset1 == null || subset1.length() == 0)
	subset1 = "SRC10449";
if (subset2 == null || subset2.length() == 0)
	subset2 = "SRC10454";

DecimalFormat p2eFormat = new DecimalFormat("0.00E0");
DecimalFormat p2Format = new DecimalFormat("0.00");
SubsetExpService subsetExpService = new SubsetExpService();

List<SubsetExp> gseInfoList = subsetExpService.selectAllGeneSymbol();
Set<String> geneNames = new HashSet<String>();
Set<String> isoforms = new HashSet<String>();
for (SubsetExp subsetExp : gseInfoList) {	
	String expGeneName = subsetExp.getGeneName();
	if (expGeneName.indexOf("-") > 0)
		expGeneName = expGeneName.substring(0, expGeneName.lastIndexOf("-"));
	geneNames.add(expGeneName);
	
	isoforms.add(subsetExp.getEnstID().split("\\.")[0]);
}

SubsetExp se = subsetExpService.hasExist(subset1, subset2);
if (se != null) {
	pageContext.setAttribute("subset1", se.getSubset1().getSubsetID());
	pageContext.setAttribute("subset2", se.getSubset2().getSubsetID());
	pageContext.setAttribute("subset1title", subsetExpService.selectSubsetSubTitle(se.getSubset1().getSubsetID()));
	pageContext.setAttribute("subset2title", subsetExpService.selectSubsetSubTitle(se.getSubset2().getSubsetID()));
} else {
	pageContext.setAttribute("subset1", subset1);
	pageContext.setAttribute("subset2", subset2);
	pageContext.setAttribute("subset1title", subset1);
	pageContext.setAttribute("subset2title", subset2);
}

int pageWidth = 0;
if (geneName != null && !geneName.equals("null") && geneName.length() > 0) {
	gseInfoList = subsetExpService.selectGeneSymbol(subset1, subset2, geneName);
	SubsetExp subsetExpZero = gseInfoList.get(0);
	List<GeneExp> subset1GeneExpList = subsetExpService.selectIsoformExp(subsetExpZero.getSubset1().getSubsetID(), subsetExpZero.getEnstID());
	List<GeneExp> subset2GeneExpList = subsetExpService.selectIsoformExp(subsetExpZero.getSubset2().getSubsetID(), subsetExpZero.getEnstID());
	pageWidth = 618 + ((subset1GeneExpList.size() + subset2GeneExpList.size()) * 11);
} else if (isoform != null && !isoform.equals("null") && isoform.length() > 0) {
	gseInfoList = subsetExpService.selectIsoform(subset1, subset2, isoform);
	SubsetExp subsetExpZero = gseInfoList.get(0);
	List<GeneExp> subset1GeneExpList = subsetExpService.selectIsoformExp(subsetExpZero.getSubset1().getSubsetID(), subsetExpZero.getEnstID());
	List<GeneExp> subset2GeneExpList = subsetExpService.selectIsoformExp(subsetExpZero.getSubset2().getSubsetID(), subsetExpZero.getEnstID());
	pageWidth = 618 + ((subset1GeneExpList.size() + subset2GeneExpList.size()) * 11);
}
pageContext.setAttribute("pageWidth", pageWidth);

String geneNamesStr[] = geneNames.toArray(new String[0]);
Arrays.sort(geneNamesStr, String.CASE_INSENSITIVE_ORDER);

StringBuffer geneNameList = new StringBuffer();

for (String expGeneName : geneNamesStr)
	geneNameList.append(expGeneName + ",");
if (geneNameList.length() > 0)
	geneNameList.delete(geneNameList.length() - 1, geneNameList.length());
pageContext.setAttribute("geneNameList", geneNameList.toString());

String isoformsStr[] = isoforms.toArray(new String[0]);
Arrays.sort(isoformsStr, String.CASE_INSENSITIVE_ORDER);

StringBuffer isoformList = new StringBuffer();

for (String isoformStr : isoformsStr)
	isoformList.append(isoformStr + ",");
if (isoformList.length() > 0)
	isoformList.delete(geneNameList.length() - 1, geneNameList.length());
pageContext.setAttribute("isoformList", isoformList.toString());

subsetExpService.close();

pageContext.setAttribute("geneName", geneName);
pageContext.setAttribute("isoform", isoform);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Index</title>
<style>
@page {
	size: ${pageWidth}px 1600px;
}

a:link {
    color: #0000FF;
}

a:visited {
    color: #0000FF;
}

a:hover {
    color: #0000FF;
}

a:active {
    color: #0000FF;
}

th {
	text-align: center;
	white-space: nowrap;
}

#th_text {
	padding-left: 5px;
	padding-right: 5px;
}

td {
	text-align: center;
}

#tr1 {
	background-color: #eeeeee;
}

#tr2 {
	background-color: #f8f8f8;
}

#td_text_right {
	text-align: right;
}

#td_text_left {
	text-align: left;
}

#content {
	text-align: justify;
	text-justify:inter-ideograph;
}

#exp_demo {
	width: 15px;
	line-height: 15px;
	font-size: 30px; 
}
</style>
</head>

<body style="overflow-y: hidden;">

<jsp:include page="/context_download.jsp">
	<jsp:param value="${subset1}" name="subset1"/>
	<jsp:param value="${subset2}" name="subset2"/>
	<jsp:param value="${subset1title}" name="subset1Title"/>
	<jsp:param value="${subset2title}" name="subset2Title"/>
	<jsp:param value="${pageWidth}" name="pageWidth"/>
</jsp:include>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 10px;">

	<tr>
	
		<td id="td_text_left" style="font-weight: bold;">
			Gene Symbol:
			&nbsp;
			${geneName}
		</td>
		
		<td width="30%" id="td_text_right">
			<table cellpadding="0" cellspacing="0" border="0" height="30px"  style="display: inline;"">
				
				<tr>
					<td id="td_text_left" colspan="8" style="font-size:12px;">Low Expression</td>
					<td>&nbsp;</td>
					<td id="td_text_right" colspan="8" style="font-size:12px;">High Expression</td>
				</tr>
				
				<tr>
					<td id="exp_demo" style="background-color:#0000FF;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#3939FF;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#5959FF;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#7777FF;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#9595FF;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#B3B3FF;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#C8C8FF;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#DBDBFF;">&nbsp;</td>					
					
					<td id="exp_demo" style="background-color:#FFFFFF;">&nbsp;</td>
					
					<td id="exp_demo" style="background-color:#FFDBDB;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#FFC8C8;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#FFB3B3;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#FF9595;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#FF7777;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#FF5959;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#FF3939;">&nbsp;</td>
					<td id="exp_demo" style="background-color:#FF0000;">&nbsp;</td>
				</tr>
				
			</table>		
		</td>
		
	</tr>
	
</table>

<%
subsetExpService = new SubsetExpService();
if (geneName != null && geneName.length() > 0)
	gseInfoList = subsetExpService.selectGeneSymbol(subset1, subset2, geneName);
else
	gseInfoList = subsetExpService.selectIsoform(subset1, subset2, isoform);
if (gseInfoList.size() > 0) {
	SubsetExp subsetExpZero = gseInfoList.get(0);	
	List<GeneExp> subset1GeneExpList = subsetExpService.selectIsoformExp(subsetExpZero.getSubset1().getSubsetID(), subsetExpZero.getEnstID());
	List<GeneExp> subset2GeneExpList = subsetExpService.selectIsoformExp(subsetExpZero.getSubset2().getSubsetID(), subsetExpZero.getEnstID());
	double values[] = new double[subset1GeneExpList.size() + subset2GeneExpList.size()];
%>
<table border="0" cellspacing="0" cellpadding="0">

	<tr>
		<th id="th_text" style="background-color: #555555;color: #ffffff; letter-spacing: -1px;">Adjusted<br>P-value</th>
		<th id="th_text" style="background-color: #555555;color: #ffffff;">Subset 1<br>TPM </th>
		<th id="th_text" style="background-color: #555555;color: #ffffff;">Subset 2<br>TPM </th>
		<th id="th_text" style="background-color: #555555;color: #ffffff;">Isoform</th>
		<th id="th_text" style="background-color: #555555;color: #ffffff;">Gene Symbol</th>
		<th style="background-color: #555555;color: #ffffff;">
			Expression (TPM)
			<table cellspacing="1px" >
				
				<tr>
					<%
						pageContext.setAttribute("subset1number", subset1GeneExpList.size());
						pageContext.setAttribute("subset2number", subset2GeneExpList.size());
						for (int i=0, size=subset1GeneExpList.size() + subset2GeneExpList.size(); i<size; i++) {
					%>
					<td style="line-height: 1px; font-size:30px;">&nbsp;</td>
					<%
						}
					%>
				</tr>
				
				<tr>
					<td colspan="${subset1number}" style="border: #FFFFFF 1px solid; cursor: pointer;" align="center" title="${subset1title}">1</td>
					<td colspan="${subset2number}" style="border: #FFFFFF 1px solid; cursor: pointer;" align="center" title="${subset2title}">2</td>
				</tr>
				
			</table>
		</th>
	</tr>
	
		<%
			StandardDeviation sd = new StandardDeviation();	
			int index = 0;
			for (SubsetExp subsetExp : gseInfoList) {
				index++;
				
				List<GeneExp> subset1GeneExp = subsetExpService.selectIsoformExp(subsetExp.getSubset1().getSubsetID(), subsetExp.getEnstID());
				List<GeneExp> subset2GeneExp = subsetExpService.selectIsoformExp(subsetExp.getSubset2().getSubsetID(), subsetExp.getEnstID());
				
				double standardDeviation = 0.0;
				double avg = 0.0;
				double subset1Avg = 0.0, subset2Avg = 0.0;
				double interval[][] = null;
				boolean hasPvalue = subsetExp.getPvalue() != null? true : false;						
				if (hasPvalue) {
					int count = 0;
					for (GeneExp geneExp : subset1GeneExp) {
						double exp = geneExp.getExp();
						avg += exp;
						values[count++] = exp;
					}
					for (GeneExp geneExp : subset2GeneExp) {
						double exp = geneExp.getExp();
						avg += exp;
						values[count++] = exp;
					}
					avg /= values.length;
					standardDeviation = sd.evaluate(values);
					interval = new double[][] {
							{avg + (standardDeviation * 0.1), avg - (standardDeviation * 0.1)},
							{avg + (standardDeviation * 0.5), avg - (standardDeviation * 0.5)},
							{avg + (standardDeviation * 1), avg - (standardDeviation * 1)},
							{avg + (standardDeviation * 1.5), avg - (standardDeviation * 1.5)},
							{avg + (standardDeviation * 2), avg - (standardDeviation * 2)},
							{avg + (standardDeviation * 2.5), avg - (standardDeviation * 2.5)},
							{avg + (standardDeviation * 3), avg - (standardDeviation * 3)},
							{avg + (standardDeviation * 3.5), avg - (standardDeviation * 3.5)},
							{avg + (standardDeviation * 4), avg - (standardDeviation * 4)}
					};

					subset1Avg = subsetExp.getSubset1Avg();
					subset2Avg = subsetExp.getSubset2Avg();
				} else {
					int count = 0;
					for (GeneExp geneExp : subset1GeneExp) {
						double exp = geneExp.getExp();
						avg += exp;
						subset1Avg += exp;
						values[count++] = exp;
					}
					subset1Avg /= subset1GeneExp.size();
					for (GeneExp geneExp : subset2GeneExp) {
						double exp = geneExp.getExp();
						avg += exp;
						subset2Avg += exp;
						values[count++] = exp;
					}
					subset2Avg /= subset2GeneExp.size();
					avg /= values.length;
					standardDeviation = sd.evaluate(values);	
					interval = new double[][] {
							{avg + (standardDeviation * 0.1), avg - (standardDeviation * 0.1)},
							{avg + (standardDeviation * 0.5), avg - (standardDeviation * 0.5)},
							{avg + (standardDeviation * 1), avg - (standardDeviation * 1)},
							{avg + (standardDeviation * 1.5), avg - (standardDeviation * 1.5)},
							{avg + (standardDeviation * 2), avg - (standardDeviation * 2)},
							{avg + (standardDeviation * 2.5), avg - (standardDeviation * 2.5)},
							{avg + (standardDeviation * 3), avg - (standardDeviation * 3)},
							{avg + (standardDeviation * 3.5), avg - (standardDeviation * 3.5)},
							{avg + (standardDeviation * 4), avg - (standardDeviation * 4)}
					};
				}
				
				pageContext.setAttribute("subsetPValue", hasPvalue? p2eFormat.format(subsetExp.getPvalue()) : "-");
				pageContext.setAttribute("subset1Avg", p2Format.format(subset1Avg));
				pageContext.setAttribute("subset2Avg", p2Format.format(subset2Avg));
				pageContext.setAttribute("enstID", subsetExp.getEnstID());
				pageContext.setAttribute("enstIDUrl", subsetExp.getEnstID().substring(0, 8));			
				pageContext.setAttribute("gene", subsetExp.getGeneName());	
				pageContext.setAttribute("isTextRight", hasPvalue? "td_text_right" : "");
				pageContext.setAttribute("trid", index % 2 == 0? "tr1" : "tr2");
		%>
	<tr id="${trid}">
		<td id="${isTextRight}" style="padding-left: 5px; padding-right: 5px; white-space: nowrap;">${subsetPValue}</td>
		<td id="td_text_right" style="padding-left: 5px; padding-right: 5px; white-space: nowrap;">${subset1Avg}</td>
		<td id="td_text_right" style="padding-left: 5px; padding-right: 5px; white-space: nowrap;">${subset2Avg}</td>
		<td style="padding-left: 5px; padding-right: 5px; white-space: nowrap;"><a href="http://genome.ucsc.edu/cgi-bin/hgTracks?db=hg19&position=${enstIDUrl}" target="_blank" style="text-decoration:none;">${enstID}</a></td>
		<td id="td_text_right" style="padding-left: 5px; padding-right: 5px; white-space: nowrap;">${gene}</td>
		<td style="white-space: nowrap;">
			<table cellspacing="1px" style="background-color: #555555; cursor: pointer;">
				<tr>
				
					<%					
					for (GeneExp geneExp : subset1GeneExp) {
						double exp = geneExp.getExp();
						String color = "FFFFFF";
						// if (exp < interval[0][0] && exp > interval[0][1])
						if (exp == avg)
							color = "FFFFFF";
						else  if (exp < interval[1][0] && exp > interval[1][1])
							color = exp < avg? "DBDBFF" : "FFDBDB";
						else if (exp < interval[2][0] && exp > interval[2][1])
							color = exp < avg? "C8C8FF" : "FFC8C8";
						else if (exp < interval[3][0] && exp > interval[3][1])
							color = exp < avg? "B3B3FF" : "FFB3B3";
						else if (exp < interval[4][0] && exp > interval[4][1])
							color = exp < avg? "9595FF" : "FF9595";
						else if (exp < interval[5][0] && exp > interval[5][1])
							color = exp < avg? "7777FF" : "FF7777";
						else if (exp < interval[6][0] && exp > interval[6][1])
							color = exp < avg? "5959FF" : "FF5959";
						else if (exp < interval[7][0] && exp > interval[7][1])
							color = exp < avg? "3939FF" : "FF3939";
						else if (exp < interval[8][0] && exp > interval[8][1])
							color = exp < avg? "0000FF" : "FF0000";
						else if (exp > interval[7][0])
							color = "FF0000";
						else if (exp < interval[7][0])
							color = "0000FF";
						pageContext.setAttribute("sampleID", geneExp.getSampleID());
						pageContext.setAttribute("exp", exp);
						pageContext.setAttribute("color", color);
					%>
					<td style="font-size:30px; line-height: 0.6em; background-color: #${color};"><a title="${sampleID}: ${exp}">&nbsp;</a></td>
					<%
					}
					%>
				
					<%
					for (GeneExp geneExp : subset2GeneExp) {
						double exp = geneExp.getExp();
						String color = "FFFFFF";
						// if (exp < interval[0][0] && exp > interval[0][1])
						if (exp == avg)
							color = "FFFFFF";
						else  if (exp < interval[1][0] && exp > interval[1][1])
							color = exp < avg? "DBDBFF" : "FFDBDB";
						else if (exp < interval[2][0] && exp > interval[2][1])
							color = exp < avg? "C8C8FF" : "FFC8C8";
						else if (exp < interval[3][0] && exp > interval[3][1])
							color = exp < avg? "B3B3FF" : "FFB3B3";
						else if (exp < interval[4][0] && exp > interval[4][1])
							color = exp < avg? "9595FF" : "FF9595";
						else if (exp < interval[5][0] && exp > interval[5][1])
							color = exp < avg? "7777FF" : "FF7777";
						else if (exp < interval[6][0] && exp > interval[6][1])
							color = exp < avg? "5959FF" : "FF5959";
						else if (exp < interval[7][0] && exp > interval[7][1])
							color = exp < avg? "3939FF" : "FF3939";
						else if (exp < interval[8][0] && exp > interval[8][1])
							color = exp < avg? "0000FF" : "FF0000";
						else if (exp > interval[7][0])
							color = "FF0000";
						else if (exp < interval[7][0])
							color = "0000FF";
						pageContext.setAttribute("sampleID", geneExp.getSampleID());
						pageContext.setAttribute("exp", exp);
						pageContext.setAttribute("color", color);
					%>
					<td style="font-size:30px; line-height: 0.6em; background-color: #${color};"><a title="${sampleID}: ${exp}">&nbsp;</a></td>
					<%
					}
					%>
					
				</tr>
			</table>
		</td>
	</tr>
	<%
		for (int i=0; i < values.length; i++)
			values[i] = 0.0;
	
		subset1GeneExp.clear();
		subset2GeneExp.clear();
		
		subset1GeneExp = null;
		subset2GeneExp = null;
	}
	%>	
	
	<td colspan="6" style="text-align: left;">In the adjusted p-value column, the absent values indicate insignificance (adjusted p-value > 0.01) in differential expression analysis.</td>
	
</table>
<%
}
subsetExpService.close();
%>
</body>

</html>