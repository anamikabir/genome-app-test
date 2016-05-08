<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="model.*" %>
<%@ page import="service.*" %>
<%@ page import="org.apache.commons.math3.stat.descriptive.moment.StandardDeviation" %>
<%
String subset1 = request.getParameter("subset1"),
			subset2 = request.getParameter("subset2");

if (subset1 == null || subset1.length() == 0)
	subset1 = "SRC10013";
if (subset2 == null || subset2.length() == 0)
	subset2 = "SRC10012";

SubsetExpService subsetExpService = new SubsetExpService();
SubsetExp se = subsetExpService.hasExist(subset1, subset2);
if (se != null) {
	pageContext.setAttribute("subset1", se.getSubset1().getSubsetID());
	pageContext.setAttribute("subset2", se.getSubset2().getSubsetID());
	pageContext.setAttribute("subset1Title", subsetExpService.selectSubsetTitle(se.getSubset1().getSubsetID()));
	pageContext.setAttribute("subset2Title", subsetExpService.selectSubsetTitle(se.getSubset2().getSubsetID()));
	pageContext.setAttribute("subset1SubTitle", subsetExpService.selectSubsetSubTitle(se.getSubset1().getSubsetID()));
	pageContext.setAttribute("subset2SubTitle", subsetExpService.selectSubsetSubTitle(se.getSubset2().getSubsetID()));
} else {
	pageContext.setAttribute("subset1", subset1);
	pageContext.setAttribute("subset2", subset2);	
	pageContext.setAttribute("subset1Title", subsetExpService.selectSubsetTitle(subset1));
	pageContext.setAttribute("subset2Title", subsetExpService.selectSubsetTitle(subset2));
	pageContext.setAttribute("subset1SubTitle", subsetExpService.selectSubsetSubTitle(subset1));
	pageContext.setAttribute("subset2SubTitle", subsetExpService.selectSubsetSubTitle(subset2));
}
subsetExpService.close();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Index</title>

<script type="text/javascript" src="js/jquery/jquery-1.8.2.js"></script>
<script type="text/javascript" src="js/jquery/jquery.blockUI.js"></script>
<script type="text/javascript" src="js/jquery/jquery.autocomplete.js"></script>
<script type="text/javascript" src="js/jquery/jquery-ui-1.8.12.custom.min.js"></script>

<script type="text/javascript">
var prompt1IsRun = false;
var prompt2IsRun = false;

$(function() {	
	$("#transcriptsPvalue").block({ message: "<div>Loading...<br>Please Wait ...</div>"});
	
	/* setTimeout(function(){		
		prompt();
	}, 500); */

    $("#pair", window.parent.document).fadeOut(500);
    $("#top_list", window.parent.document).fadeOut(500);
	
	$("#myTabs").tabs({
	    select: function(event, ui) {
	    	switch(ui.index) {
	    		case 1:
					// $("#lncRNAsPvalueFrame").attr("src", $("#lncRNAsPvalue").attr("src"));
					break;
					
				/* 
	    		case 2:
					$("#lncRNARegulatoryNetworkFrame").attr("src", $("#lncRNARegulatoryNetworkFrame").attr("src"));
					break;
				
	    		case 3:
					$("#lncRNARegulatoryNetworkFromGeneFrame").attr("src", $("#lncRNARegulatoryNetworkFromGeneFrame").attr("src"));
					break;
				
	    		case 4:
					$("#lncRNARegulatoryNegativeNetworkFromGeneFrame").attr("src", $("#lncRNARegulatoryNegativeNetworkFromGeneFrame").attr("src"));
					break;
			 	*/
				
	    		case 2:
					$("#lncRNARegulatoryNetworkFromGeneFrame").attr("src", $("#lncRNARegulatoryNetworkFromGeneFrame").attr("src"));
					break;
				/* 
	    		case 3:
					$("#lncRNARegulatoryNetworkFromGeneFrame").attr("src", $("#lncRNARegulatoryNetworkFromGeneFrame").attr("src"));
					break;
					 */
	    		case 4:
					// $("#searchGeneFrame").attr("src", $("#searchGeneFrame").attr("src"));
					break;
	    	}
	    }
	});

	<%
	if (se == null) {
	%>
		$("#myTabs").tabs("select", 1);
	<%
	}
	%>
});

function changePValue(target, subset1, subset2, isUpRegulation) {
	window.location.href = "right.jsp?subset1=" + subset1 +"&subset2=" + subset2 + "&isUpRegulation=" + isUpRegulation + "&pValue=" + $(target).val();
}

function changeRegulation(target, subset1, subset2, pValue) {
	window.location.href = "right.jsp?subset1=" + subset1 +"&subset2=" + subset2 + "&isUpRegulation=" + $(target).val() + "&pValue=" + pValue;
}

function changePage(e, target, subset1, subset2, isUpRegulation, pValue) {
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
		window.location.href = "right.jsp?subset1=" + subset1 +"&subset2=" + subset2 + "&isUpRegulation=" + isUpRegulation + "&pValue=" + pValue + "&start=" + start  + "&end=" + end;
	}
}

function resizeIframe(obj) {
	obj.style.height = (parseInt($("body").css("height")) - parseInt($("#info").css("height")) - 100) + 'px';
	
	/* if (parseInt(obj.style.height) < 400)
		obj.style.height = '400px'; */
		
	/* if (obj.contentWindow.document.body.scrollHeight < 350)
		obj.style.height = '350px';
	else
		obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';	 */
}

function searchGene() {
	$("#myTabs").tabs("select", "#searchGene");
	$("#serarchGeneAction").attr("src", "right_searchgene.jsp?subset1=${subset1}&subset2=${subset2}");
}

var leftWidth, rightWidth;
function changeCenterFrame() {
	if ($("#left", parent.document).css("width") == "0px") {
		$("#left", parent.document).css("display", "block");
    	$("#left", parent.document).animate({
			width: leftWidth
		}, 400, function(){
			$("#left", parent.document).css("width", "30em");
		});
    	$("#right", parent.document).animate({
			width: rightWidth
		}, 400, function(){
			var isSafari = /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor);
			if (!isSafari)
				$("#right", parent.document).css("width", "calc(100% - 30em)");
			else
				$("#right", parent.document).css("width", "-webkit-calc(100% - 30em)");
		});
		$("#changeCenterFrameImg").prop("src", "images/arrow2-open.png");
	} else {
		leftWidth = $("#left",parent.document).css("width");
		rightWidth = $("#right",parent.document).css("width");
    	$("#left", parent.document).animate({
			width: "0%"
		}, 400, function(){
			$("#left", parent.document).css("display", "none");
		});
    	$("#right", parent.document).animate({
			width: "100%"
		}, 400);
		$("#changeCenterFrameImg").prop("src", "images/arrow2-close.png");
	}
}

function prompt() {
    $("#promptMsg").fadeIn(1000, function() {
    	setTimeout(function(){
            $("#promptMsg").fadeOut(1000, function() {
            });
    	}, 4000);
    });
}

function prompt1() {
	if (!prompt1IsRun) {
		prompt1IsRun = true;

	    $("#promptMsg1").fadeIn(500);
	    $("#promptMsg1").animate({
	    	left:"0px"
	    }, 400, function() {
	    	$("#promptMsg1").animate({
	        	left:"10px"
	        }, 400, function() {
	        	$("#promptMsg1").animate({
	            	left:"0px"
	            }, 400, function() {
	            	$("#promptMsg1").animate({
	                	left:"10px"
	                }, 400, function() {
	                    $("#promptMsg1").fadeOut(500);
	            		prompt1IsRun = false;
	                });
	            });
	        });
	    });
	}
}

function prompt2() {
	if (!prompt2IsRun) {
		prompt2IsRun = true;
		
	    $("#promptMsg2").fadeIn(500);
	    $("#promptMsg2").animate({
	    	left:"0px"
	    }, 400, function() {
	    	$("#promptMsg2").animate({
	        	left:"10px"
	        }, 400, function() {
	        	$("#promptMsg2").animate({
	            	left:"0px"
	            }, 400, function() {
	            	$("#promptMsg2").animate({
	                	left:"10px"
	                }, 400, function() {
	                    $("#promptMsg2").fadeOut(500);
	            		prompt2IsRun = false;
	                });
	            });
	        });
    	});
	}
}
</script>

<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" /> 
<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.8.23.custom.css"/>

<style>
html, body {
	height: calc(100% - 10px);
	height: -webkit-calc(100% - 10px);
	margin: 0px;
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
}

td {
	text-align: center;
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

::-webkit-scrollbar {
    width: 10px;
    height: 10px;
}

::-webkit-scrollbar-button {
	width: 10px;	
}
	
::-webkit-scrollbar-button:vertical:decrement {
	display: none;
	/*-webkit-border-image: url(../images/H131.png) 0 2 0 2;*/
	background-color: white;
}

::-webkit-scrollbar-button:vertical:decrement:hover {
	/*-webkit-border-image: url(../images/H131.png) 0 2 0 2;*/
	background-color: white;
}

:::-webkit-scrollbar-button:vertical:decrement:active {
	/*-webkit-border-image: url(../images/H131.png) 0 2 0 2;*/
	background-color: white;
}

::-webkit-scrollbar-button:vertical:decrement:window-inactive {
	/*-webkit-border-image: url(../images/H131.png) 0 2 0 2;*/
	background-color: white;
}

::-webkit-scrollbar-button:vertical:increment {
	display: none;
	/*-webkit-border-image: url(../images/H132.png) 0 2 0 2;*/
	background-color: white;
}

::-webkit-scrollbar-button:vertical:increment:hover {
	/*-webkit-border-image: url(../images/H132.png) 0 2 0 2;*/
	background-color: white;
}

:::-webkit-scrollbar-button:vertical:increment:active {
	/*-webkit-border-image: url(../images/H132.png) 0 2 0 2;*/
	background-color: white;
}

::-webkit-scrollbar-button:vertical:increment:window-inactive {
	/*-webkit-border-image: url(../images/H132.png) 0 2 0 2;*/
	background-color: white;
}

::-webkit-scrollbar-track {
	background-color: white;	
}

::-webkit-scrollbar-track-piece { 
	background-color: white;
}

::-webkit-scrollbar-thumb {
	background-color: gray;
}

::-webkit-scrollbar-corner  {
	background-color: white;	
}
::-webkit-resizer {
	background-color: white;
}
</style>
</head>

<body style="border-left: #F0F0F0 1px solid;">

<img id="changeCenterFrameImg" src="images/arrow2-open.png" width="16px" style="border-width: 0px; display: inline; cursor: pointer;position: fixed;left: 0px;top: 0px;" onClick="changeCenterFrame();">

<div style="margin: 10px 10px 10px 20px; padding: 10px 0 10px; border: black 1px solid;min-width: 52em;">

<div id="info" style="width: 95%; margin: 0 auto;">
	<jsp:include page="/context.jsp">
		<jsp:param value="${subset1}" name="subset1"/>
		<jsp:param value="${subset2}" name="subset2"/>
		<jsp:param value="${subset1Title}" name="subset1Title"/>
		<jsp:param value="${subset2Title}" name="subset2Title"/>
		<jsp:param value="${subset1SubTitle}" name="subset1SubTitle"/>
		<jsp:param value="${subset2SubTitle}" name="subset2SubTitle"/>
	</jsp:include>
</div>

<%
GseInfoService gseInfoService = new GseInfoService();
GseInfo gseInfo = gseInfoService.selectFromSubset(subset1);
gseInfoService.close();

if (gseInfo != null) {
%>

<div id="myTabs" style="width: 95%; height: 90%; margin: 0px auto;">

	<ul class="tabs">
		<li><a href="#transcriptsPvalue" title="Differentially expressed coding RNA transcripts">DE coding transcripts</a></li>
		<li><a href="#lncRNAsPvalue" title="Differentially expressed long non-coding RNA transcripts">DE lncRNAs</a></li>
		<li style="display: none;"><a href="#lncRNARegulatoryNetworkFromGene">mRNA-lncRNA coexpression network</a></li>
		<!-- 
		<li style="display: none;"><a href="#lncRNARegulatoryNetwork">lncRNA regulatory network</a></li>
		<li style="display: none;"><a href="#lncRNARegulatoryNetworkFromGene">Network</a></li>
		<li style="display: none;"><a href="#lncRNARegulatoryNegativeNetworkFromGene">Negative Network</a></li>
		<li style="display: none;"><a href="#lncRNARegulatoryNetworkNew">mRNA-lncRNA coexpression network</a></li>
		 -->
	    <li><a href="#searchGene">Search</a></li>
	</ul>

	<div id="transcriptsPvalue" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe src="right_pvalue.jsp?subset1=${subset1}&subset2=${subset2}&type=pc" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>

	<div id="lncRNAsPvalue" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNAsPvalueFrame" src="right_pvalue.jsp?subset1=${subset1}&subset2=${subset2}&type=lncRNA" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>
	
	<!-- 
	<div id="lncRNARegulatoryNetwork" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNetworkFrame" src="lncRNARegulatoryNetwork.jsp?subset1=${subset1}&subset2=${subset2}" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>

	<div id="lncRNARegulatoryNetworkFromGene" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNetworkFromGeneFrame" src="lncRNARegulatoryNetworkFromGene.jsp?subset1=${subset1}&subset2=${subset2}&isNegative=false" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>

	<div id="lncRNARegulatoryNegativeNetworkFromGene" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNegativeNetworkFromGeneFrame" src="lncRNARegulatoryNetworkFromGene.jsp?subset1=${subset1}&subset2=${subset2}&isNegative=true" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>

	<div id="lncRNARegulatoryNetworkNew" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNetworkNewFrame" src="lncRNARegulatoryNetworkNew.jsp?subset1=${subset1}&subset2=${subset2}" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>
	 -->

	<div id="lncRNARegulatoryNetworkFromGene" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNetworkFromGeneFrame" src="lncRNARegulatoryNetworkFromGene.jsp?subset1=${subset1}&subset2=${subset2}&isNegative=false" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>
	 
	<div id="searchGene" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="searchGeneFrame" src="right_searchGene.jsp?subset1=${subset1}&subset2=${subset2}" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>
	
</div>

<%
} else {
%>

<div id="myTabs" style="width: 95%; height: 90%; margin: 0px auto;">

	<ul class="tabs">
		<li><a href="#transcriptsPvalue" title="Differentially expressed coding RNA transcripts">DE coding transcripts</a></li>
		<li><a href="#lncRNAsPvalue" title="Differentially expressed long non-coding RNA transcripts">DE lncRNAs</a></li>
		<li style="display: none;"><a href="#lncRNARegulatoryNetworkFromGene">mRNA-lncRNA coexpression network</a></li>
		<!-- 
		<li style="display: none;"><a href="#lncRNARegulatoryNetwork">lncRNA regulatory network</a></li>
		<li style="display: none;"><a href="#lncRNARegulatoryNetworkFromGene">Network</a></li>
		<li style="display: none;"><a href="#lncRNARegulatoryNegativeNetworkFromGene">Negative Network</a></li>
		<li style="display: none;"><a href="#lncRNARegulatoryNetworkNew">mRNA-lncRNA coexpression network</a></li>
	     -->
	    <li><a href="#searchGene">Search</a></li>
	</ul>

	<div id="transcriptsPvalue" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe src="right_tcgaPvalue.jsp?subset1=${subset1}&subset2=${subset2}&type=pc" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>

	<div id="lncRNAsPvalue" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNAsPvalueFrame" src="right_tcgaPvalue.jsp?subset1=${subset1}&subset2=${subset2}&type=lncRNA" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>
	
	<!-- 
	<div id="lncRNARegulatoryNetwork" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNetworkFrame" src="tcgalncRNARegulatoryNetwork.jsp?subset1=${subset1}&subset2=${subset2}" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>

	<div id="lncRNARegulatoryNetworkFromGene" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNetworkFromGeneFrame" src="tcgalncRNARegulatoryNetworkFromGene.jsp?subset1=${subset1}&subset2=${subset2}&isNegative=false" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>

	<div id="lncRNARegulatoryNegativeNetworkFromGene" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNegativeNetworkFromGeneFrame" src="tcgalncRNARegulatoryNetworkFromGene.jsp?subset1=${subset1}&subset2=${subset2}&isNegative=true" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>

	<div id="lncRNARegulatoryNetworkNew" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNetworkNewFrame" src="tcgalncRNARegulatoryNetworkNew.jsp?subset1=${subset1}&subset2=${subset2}" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>
	 -->

	<div id="lncRNARegulatoryNetworkFromGene" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="lncRNARegulatoryNetworkFromGeneFrame" src="tcgalncRNARegulatoryNetworkFromGene.jsp?subset1=${subset1}&subset2=${subset2}&isNegative=false" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>
	 
	<div id="searchGene" style="padding-right: 20px;border: 1px solid #aaa; border-top: none;">
		<iframe id="searchGeneFrame" src="right_searchIsoform.jsp?subset1=${subset1}&subset2=${subset2}" width="100%" marginwidth="0" frameborder="0" scrolling="yes" onload="javascript:resizeIframe(this);"></iframe>
	</div>
	
</div>

<%
}
%>
</div>

<div id="promptMsg" style="width: 200px; background-color: white; position: fixed; left: calc(50% - 100px); left: -webkit-calc(50% - 100px); top: 45%; text-align: center; font-weight: bold; color: blue; display: none; border: black 1px solid;">
This is analysis result.
</div>

<div id="promptMsg1" style="position: fixed; left: 10px; top: calc(25% - 40px); top: -webkit-calc(25% - 40px); display: none;">
	<img height="80px" src="images/prompt-arrow.png">
</div>

<div id="promptMsg2" style="position: fixed; left: 10px; top: calc(75% - 40px); top: -webkit-calc(75% - 40px); display: none;">
	<img height="80px" src="images/prompt-arrow.png">
</div>

</body>

</html>