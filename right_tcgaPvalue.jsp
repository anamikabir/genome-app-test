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
			isUpRegulationStr = request.getParameter("isUpRegulation"),
			startStr = request.getParameter("start"),
			endStr = request.getParameter("end"),
			pValue = request.getParameter("pValue"),
			type = request.getParameter("type");

Boolean isUpRegulation;
int start, end;

if (subset1 == null || subset1.length() == 0)
	subset1 = "SRC10449";
if (subset2 == null || subset2.length() == 0)
	subset2 = "SRC10454";
if (isUpRegulationStr == null || isUpRegulationStr.length() == 0)
	isUpRegulation = true;
else if (isUpRegulationStr.equals("null"))
	isUpRegulation = null;
else
	isUpRegulation = Boolean.parseBoolean(isUpRegulationStr);
if (startStr == null || startStr.length() == 0)
	start = 1;
else
	start = Integer.parseInt(startStr);
if (endStr == null || endStr.length() == 0)
	end = 20;
else
	end = Integer.parseInt(endStr);

SubsetExpService subsetExpService = new SubsetExpService();

DecimalFormat p2eFormat = new DecimalFormat("0.00E0");
DecimalFormat p2Format = new DecimalFormat("0.00");

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

List<SubsetExp> gseInfoList = null;
if (pValue == null || pValue.length() == 0) {
	pValue = "1E-6";
	gseInfoList = subsetExpService.selectTCGA(subset1, subset2, pValue, type);
	if (gseInfoList.size() >= 20)
		pageContext.setAttribute("pValueP6Selected", "Selected");
	
	if (gseInfoList.size() < 20) {
		pValue = "1E-5";
		gseInfoList = subsetExpService.selectTCGA(subset1, subset2, pValue, type);
		if (gseInfoList.size() >= 20)
			pageContext.setAttribute("pValueP5Selected", "Selected");	
	}
	
	if (gseInfoList.size() < 20) {
		pValue = "1E-4";
		gseInfoList = subsetExpService.selectTCGA(subset1, subset2, pValue, type);
		if (gseInfoList.size() >= 20)
			pageContext.setAttribute("pValueP4Selected", "Selected");	
	}
	
	if (gseInfoList.size() < 20) {
		pValue = "1E-3";
		gseInfoList = subsetExpService.selectTCGA(subset1, subset2, pValue, type);
		if (gseInfoList.size() >= 20)
			pageContext.setAttribute("pValueP3Selected", "Selected");	
	}
	
	if (gseInfoList.size() < 20) {
		pValue = "1E-2";
		gseInfoList = subsetExpService.selectTCGA(subset1, subset2, pValue, type);
		pageContext.setAttribute("pValueP2Selected", "Selected");	
	}	
} else {
	if (pValue.equals("1E-10"))
		pageContext.setAttribute("pValueP10Selected", "Selected");
	else if (pValue.equals("1E-9"))
		pageContext.setAttribute("pValueP9Selected", "Selected");
	else if (pValue.equals("1E-8"))
		pageContext.setAttribute("pValueP8Selected", "Selected");	
	else if (pValue.equals("1E-7"))
		pageContext.setAttribute("pValueP7Selected", "Selected");
	else if (pValue.equals("1E-6"))
		pageContext.setAttribute("pValueP6Selected", "Selected");
	else if (pValue.equals("1E-5"))
		pageContext.setAttribute("pValueP5Selected", "Selected");
	else if (pValue.equals("1E-4"))
		pageContext.setAttribute("pValueP4Selected", "Selected");
	else if (pValue.equals("1E-3"))
		pageContext.setAttribute("pValueP3Selected", "Selected");
	else if (pValue.equals("1E-2"))
		pageContext.setAttribute("pValueP2Selected", "Selected");
	gseInfoList = subsetExpService.selectTCGA(subset1, subset2, pValue, type);
}

if (isUpRegulation == null)
	pageContext.setAttribute("isUpDownRegulationSelected", "selected");
else if (!isUpRegulation)
	pageContext.setAttribute("isDownRegulationSelected", "selected");

pageContext.setAttribute("isUpRegulation", isUpRegulation == null? "null" : isUpRegulation);
pageContext.setAttribute("pValue", pValue);
pageContext.setAttribute("start", start);
pageContext.setAttribute("end", end);
pageContext.setAttribute("type", type);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Index</title>

<script type="text/javascript" src="js/jquery/jquery-1.8.2.js"></script>
<script type="text/javascript" src="js/jquery/jquery-ui-1.8.12.custom.min.js"></script>
<script type="text/javascript" src="js/jquery/jquery.blockUI.js"></script>

<script type="text/javascript">
$(function(){
	$("#transcriptsPvalue", parent.document).unblock();		

	if($("#expTable tr").length == 4)
		window.location.href = "right_tcgaPvalue.jsp?subset1=${subset1}&subset2=${subset2}&isUpRegulation=${!isUpRegulation}&pValue=${pValue}&type=${type}";
});

function changePValue(target, subset1, subset2, isUpRegulation, type) {
	window.location.href = "right_tcgaPvalue.jsp?subset1=" + subset1 +"&subset2=" + subset2 + "&isUpRegulation=" + isUpRegulation + "&pValue=" + $(target).val() + "&type=" + type;
}

function changeRegulation(target, subset1, subset2, pValue, type) {
	window.location.href = "right_tcgaPvalue.jsp?subset1=" + subset1 +"&subset2=" + subset2 + "&isUpRegulation=" + $(target).val() + "&pValue=" + pValue + "&type=" + type;
}

function changePage(e, target, subset1, subset2, isUpRegulation, pValue, type) {
	var keynum;

	if(window.event)
	  keynum = e.keyCode;
	else if(e.which)
	  keynum = e.which;
	
	var re = /^[0-9]+$/;
	var v = $(target).val();
	if (keynum == 13 && re.test(v)) {
		var index = v - 1;
		var start = index * 20 + 1;
		var end = index * 20 + 20;
		window.location.href = "right_tcgaPvalue.jsp?subset1=" + subset1 +"&subset2=" + subset2 + "&isUpRegulation=" + isUpRegulation + "&pValue=" + pValue + "&start=" + start  + "&end=" + end + "&type=" + type;
	}
}

function searchGene(gene, type) {
	$("#myTabs", parent.document).tabs("select", "#searchGene");
	$("#serarchGeneAction", parent.document).attr("src", "right_searchgene.jsp?subset1=${subset1}&subset2=${subset2}&gene=" + gene + "&type=" + type);
}

function searchPvalue() {
	$("#pvalue", parent.document).block({ message: "<div>Loading...<br>Please Wait ...</div>"});	
}
</script>

<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" /> 
<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.8.23.custom.css"/>
<link rel="stylesheet" type="text/css" href="css/ttest.css" />

</head>

<body>

<%
if (se != null) {
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom: 10px;">

	<tr>
	
		<td id="td_text_left" style="font-weight: bold;">
			<select onChange="changeRegulation(this, '${subset1}', '${subset2}', '${pValue}', '${type}');">
				<option value="true">Up regulation</option>
				<option value="false" ${isDownRegulationSelected}>Down regulation</option>
				<option value="null" ${isUpDownRegulationSelected}>Up/Down regulation</option>
			</select>
			&nbsp;
			&nbsp;
			&nbsp;
			P-value &lt;
			<select onChange="changePValue(this, '${subset1}', '${subset2}', '${isUpRegulation}', '${type}');">
				<option value="1E-10" ${pValueP10Selected}>1E-10</option>
				<option value="1E-9" ${pValueP9Selected}>1E-9</option>
				<option value="1E-8" ${pValueP8Selected}>1E-8</option>
				<option value="1E-7" ${pValueP7Selected}>1E-7</option>
				<option value="1E-6" ${pValueP6Selected}>1E-6</option>
				<option value="1E-5" ${pValueP5Selected}>1E-5</option>
				<option value="1E-4" ${pValueP4Selected}>1E-4</option>
				<option value="1E-3" ${pValueP3Selected}>1E-3</option>
				<option value="1E-2" ${pValueP2Selected}>1E-2</option>
			</select>		
			&nbsp;
			&nbsp;
			&nbsp;
			<a href="right_tcgaPvalue_download.jsp?subset1=${subset1}&subset2=${subset2}&isUpRegulation=${isUpRegulation}&pValue=${pValue}&start=${start}&end=${end}&type=${type}" target="_blank" style="text-decoration:none;">
				<div style="display: inline;">
					<!-- 
					<img src="images/download.png" width="20" align="top" style="border-width: 0px;" />
					 -->
					Result Download
				</div>
			</a>
		</td>
		
		<td width="30%" id="td_text_right">
			<table cellpadding="0" cellspacing="0" border="0" style="display: inline;position: fixed; top: 0px; right: 5px;">
				
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
}
%>

<%
if (gseInfoList.size() > 0) {
	SubsetExp subsetExpZero = gseInfoList.get(0);
	List<GeneExp> subset1GeneExpList = subsetExpService.selectIsoformExp(subsetExpZero.getSubset1().getSubsetID(), subsetExpZero.getEnstID());
	List<GeneExp> subset2GeneExpList = subsetExpService.selectIsoformExp(subsetExpZero.getSubset2().getSubsetID(), subsetExpZero.getEnstID());
	double values[] = new double[subset1GeneExpList.size() + subset2GeneExpList.size()];
%>
<table id="expTable"  border="0" cellspacing="0" cellpadding="0">

	<tr>
		<th id="th_text" style="background-color: #555555;color: #ffffff;">Rank</th>
		<th id="th_text" style="background-color: #555555;color: #ffffff; letter-spacing: -1px;">Adjusted<br>P-value</th>
		<th id="th_text" style="background-color: #555555;color: #ffffff;">Subset 1<br>TPM </th>
		<th id="th_text" style="background-color: #555555;color: #ffffff;">Subset 2<br>TPM </th>
		<th id="th_text" style="background-color: #555555;color: #ffffff;">Transcript ID</th>
		<th id="th_text" style="background-color: #555555;color: #ffffff;">Name</th>
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
			if (!(isUpRegulation == null)) {
				if (isUpRegulation && subsetExp.getSubset1Avg() < subsetExp.getSubset2Avg())
					continue;
				else if (!isUpRegulation && subsetExp.getSubset1Avg() > subsetExp.getSubset2Avg())
					continue;
			}
				
			index++;

			if (index < start)
				continue;
			else if (index > end)
				break;
			
			pageContext.setAttribute("index", index);
			pageContext.setAttribute("subsetPValue", p2eFormat.format(subsetExp.getPvalue()));
			pageContext.setAttribute("subset1Avg", p2Format.format(subsetExp.getSubset1Avg()));
			pageContext.setAttribute("subset2Avg", p2Format.format(subsetExp.getSubset2Avg()));
			pageContext.setAttribute("enstID", subsetExp.getEnstID());
			pageContext.setAttribute("enstIDUrl", subsetExp.getEnstID().substring(0, 8));
			pageContext.setAttribute("gene", subsetExp.getGeneName());
			pageContext.setAttribute("trid", index % 2 == 0? "tr1" : "tr2");
		%>
	<tr id="${trid}">
		<td style="padding-left: 5px; padding-right: 5px; white-space: nowrap;">${index}</td>
		<td id="td_text_right" style="padding-left: 5px; padding-right: 5px; white-space: nowrap;">${subsetPValue}</td>
		<td id="td_text_right" style="padding-left: 5px; padding-right: 5px; white-space: nowrap;">${subset1Avg}</td>
		<td id="td_text_right" style="padding-left: 5px; padding-right: 5px; white-space: nowrap;">${subset2Avg}</td>
		<td style="padding-left: 5px; padding-right: 5px; white-space: nowrap;"><a href="http://genome.ucsc.edu/cgi-bin/hgTracks?db=hg19&position=${enstIDUrl}" target="_blank" style="text-decoration:none;">${enstID}</a></td>
		<td id="td_text_right" style="padding-left: 5px; padding-right: 5px; white-space: nowrap;">${gene}</td>
		<td style="white-space: nowrap;">
			<table cellspacing="1px" style="background-color: #555555; cursor: pointer;">
				<tr>
				
					<%
					List<GeneExp> subset1GeneExp = subsetExpService.selectIsoformExp(subsetExp.getSubset1().getSubsetID(), subsetExp.getEnstID());
					List<GeneExp> subset2GeneExp = subsetExpService.selectIsoformExp(subsetExp.getSubset2().getSubsetID(), subsetExp.getEnstID());
					int count = 0;
					double avg = 0.0;
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
					avg = avg / values.length;
					double standardDeviation = sd.evaluate(values);
					double interval[][] = {
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
	
	<tr>
		<td align="left" colspan="7">
			<div style="text-align:left;background-color: #555555;color: #ffffff;margin: 0 0 10px 0;padding: 3px 0 3px 5px;">
				Pages:
				<%
					int maxSize = 0;
					for (SubsetExp subsetExp : gseInfoList) {		
						if (!(isUpRegulation == null)) {
							if (isUpRegulation && subsetExp.getSubset1Avg() > subsetExp.getSubset2Avg())
								maxSize++;
							else if (!isUpRegulation && subsetExp.getSubset1Avg() < subsetExp.getSubset2Avg())
								maxSize++;
						} else
							maxSize++;
					}
					
					if (start > 1) {
				%>
					<a style="color: black;text-decoration: none;" href="right_tcgaPvalue.jsp?subset1=${subset1}&subset2=${subset2}&isUpRegulation=${isUpRegulation}&pValue=${pValue}&start=<%= start - 20 %>&end=<%= start - 1 %>&type=${type}" onClick="searchPvalue();">&lt;</a>
				<%
					}
				
					int thisPage = end / 20 - 1;
					int count = 0;
					int startIndex = start / 20 - 3;
					int addOne = 0;
					if (maxSize % 20 != 0)
						addOne = 1;
					if (startIndex < 0)
						startIndex = 0;
					for (int i=startIndex, size=maxSize / 20 + addOne; i<size; i++) {
						if (count < 7)
							count++;
						else
							break;
						
						pageContext.setAttribute("pageNumber", i + 1);
						pageContext.setAttribute("indexStart", i * 20 + 1);
						pageContext.setAttribute("indexEnd", i * 20 + 20);
						
						if (i != thisPage) {
				%>
						<a style="color: white;text-decoration: none;" href="right_tcgaPvalue.jsp?subset1=${subset1}&subset2=${subset2}&isUpRegulation=${isUpRegulation}&pValue=${pValue}&start=${indexStart}&end=${indexEnd}&type=${type}" onClick="searchPvalue();">${pageNumber}</a>
				<%
						} else {
				%>
						<span style="color: black;">${pageNumber}</span>
				<%
						}
					}
					
					if (end  < maxSize) {
				%>
					<a style="color: black;text-decoration: none;" href="right_tcgaPvalue.jsp?subset1=${subset1}&subset2=${subset2}&isUpRegulation=${isUpRegulation}&pValue=${pValue}&start=<%= start + 20 %>&end=<%= start + 39 %>&type=${type}" onClick="searchPvalue();">&gt;</a>
				<%
					}
					pageContext.setAttribute("maxPage", (int) (maxSize / 20) + addOne);
				%>
					<input type="text" style="width: 3em; text-align: right;" onkeypress="return changePage(event, this, '${subset1}', '${subset2}', '${isUpRegulation}', '${pValue}', '${type}');"> / ${maxPage}
				<%
					if (start == 1 && index < 10 && isUpRegulationStr == null) {
					%>
						<script>
							window.location.href = "right_tcgaPvalue.jsp?subset1=${subset1}&subset2=${subset2}&isUpRegulation=${!isUpRegulation}&pValue=${pValue}&type=${type}";
						</script>
					<%
					}			
				}
				%>
			</div>
		</td>
	</tr>
	
</table>
<%
	subsetExpService.close();
%>

</body>

</html>