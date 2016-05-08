<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.*" %>
<%@ page import="model.*" %>
<%@ page import="service.*" %>
<%
String cuis = request.getParameter("cuis"),
			title = request.getParameter("title"),
			isNotFirst =  request.getParameter("isNotFirst");

SubsetInfoService subsetInfoService = new SubsetInfoService(); 
String subTitle = subsetInfoService.selectSubsetTitle(title);
subsetInfoService.close();

pageContext.setAttribute("title", title);
pageContext.setAttribute("subTitle", subTitle);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Index</title>

<link rel="stylesheet" href="js/jquery-ui/css/smoothness/jquery-ui-1.8.23.custom.css">
<link rel="stylesheet" href="css/easytree/skin_win8/ui.easytree.css" class="skins" type="text/css">

<script type="text/javascript" src="js/jquery/jquery-1.8.2.js"></script>
<script type="text/javascript" src="js/jquery/jquery.blockUI.js"></script>
<script type="text/javascript" src="js/jquery/jquery.easytree.min.js"></script>
  
<script type="text/javascript">
var easytree;
$(function() {
	setTimeout(function(){
		$("#left_bottom", parent.document).unblock();	
		

    	<%
    	if (isNotFirst != null) {
    	%>
		$("#right", parent.document).find("iframe").get(0).contentWindow.prompt2();	
		// prompt();
		<%
    	}
		%>
		
	}, 300);
	
	$("#top_list", parent.document).css("opacity", "");	
	
	easytree = $("#umls_menu").easytree({
    	ordering: "orderedFolder",
        disableIcons: true
    });
	
	/* setTimeout(function(){
		$("#left_bottom", parent.document).trigger("click");
		$("#top_list_title", parent.document).text("Subset Pairs");
	}, 500); */

	<%
	if (isNotFirst != null) {
	%>
	auto();
	<%
	}
	%>

	// $("#left_bottom_title", parent.document).text("${title} Subset Pairs");	
});

function auto() {
	if ($(".easytree-active").find("a").attr("href") != undefined)
		$("#right_iframe", parent.document).attr("src", $(".easytree-active").find("a").attr("href"));
}

function close() {
	
}

function prompt() {
	/* $("#left_bottom_iframe", parent.document).css("opacity", "");
	setTimeout(function(){
	    $("#left_bottom_iframe", parent.document).fadeOut(300, function() {
	        $("#left_bottom_iframe", parent.document).fadeIn(300, function() {
	            $("#left_bottom_iframe", parent.document).fadeOut(300, function() {   	
	                $("#left_bottom_iframe", parent.document).fadeIn(300, function() {
		                $("#promptMsg").fadeIn(1000, function() {
		                	setTimeout(function(){
				                $("#promptMsg").fadeOut(1000, function() {
				                });
		                	}, 2000);
		                });
	                });
	            });
	        });    		
	    });
	}, 300); */
	
    $("#promptMsg").fadeIn(1000, function() {
    	setTimeout(function(){
            $("#promptMsg").fadeOut(1000, function() {
            });
    	}, 3000);
    });
}
</script>

<style>
html, body {
	margin: 0;
}

body {
	padding: 8px;
	border: red solid 0px;
}

.isSubset {
	font-weight: normal;
}
</style>

</head>

<body>
<div style="font-weight: bold; display: inline;">${title}:</div>
<div id="umls_menu">
    <ul>             
		<%
		StringBuffer cvsc = new StringBuffer();
		StringBuffer cvsn = new StringBuffer();
		int cvscPairTotal = 0;
		int cvsnPairTotal = 0;
		SubsetExpService subsetExpService = new SubsetExpService();
		String defaultSubsetPair[] = subsetExpService.getDefaultSubsetPair(title);
		boolean hasActive = false;
		Set<String> cuiSet = new HashSet<String>();
		for (String pairs : cuis.split(","))
			cuiSet.add(pairs);
		int count = 0;
		for (String pairs : cuiSet) {
			String subsets[] = pairs.split("_"),
						subset1 = subsets[0],
						subset2 = subsets[1],
						subset1title = subsetExpService.selectSubsetSubTitle(subsets[0]),
						subset2title = subsetExpService.selectSubsetSubTitle(subsets[1]),
						isExist = subsetExpService.hasExist(subsets[0], subsets[1]) != null? " isFolder" : "",
						isActive = "";			
			int subset1number = subsetExpService.selectSubsetSampleNumber(subsets[0]),
					subset2number = subsetExpService.selectSubsetSampleNumber(subsets[1]);

			if (subsets[0].equals(defaultSubsetPair[0]) && subsets[1].equals(defaultSubsetPair[1])) {
				isActive = " isActive";
				hasActive = true;
			}
			
			if (subsetExpService.getSubsetPairType(subsets[0], subsets[1]) == 1) {
				if ((count + 1) == cuiSet.size() )
					if (!hasActive && defaultSubsetPair[0] == null) {
						isActive = " isActive";
						hasActive = true;
					}
				
				cvsc.append("<li class=\"" + isExist + " " + isActive + "\"><a href=\"right.jsp?subset1=" + subset1 + "&subset2=" + subset2 + "\" target=\"right\"><span class=\"isSubset\">" + subset1title + " (" + subset1number + ") v.s. " + subset2title + " (" + subset2number + ")</span></a></li>");
				cvscPairTotal++;				
			} else {
				if (!hasActive && defaultSubsetPair[0] == null) {
					isActive = " isActive";
					hasActive = true;
				}
				
				cvsn.append("<li class=\"" + isExist + " " + isActive + "\"><a href=\"right.jsp?subset1=" + subset1 + "&subset2=" + subset2 + "\" target=\"right\"><span class=\"isSubset\">" + subset1title + " (" + subset1number + ") v.s. " + subset2title + " (" + subset2number + ")</span></a></li>");
				cvsnPairTotal++;
			}
			
			count++;
		}
		subsetExpService.close();

		pageContext.setAttribute("cvsc", cvsc.toString());
		pageContext.setAttribute("cvsn", cvsn.toString());
		pageContext.setAttribute("cvscPairTotal", cvscPairTotal);
		pageContext.setAttribute("cvsnPairTotal", cvsnPairTotal);
		pageContext.setAttribute("cvscIsExpanded", cvsnPairTotal > 0? "" : "isExpanded");
		pageContext.setAttribute("cvsnIsExpanded", cvsnPairTotal > 0? "isExpanded" : "");
		%>
		
        <li class="isFolder ${cvscIsExpanded}">
            Cancer v.s. Cancer (${cvscPairTotal})
           	<ul>${cvsc}</ul>
        </li>
        
        <li class="isFolder  ${cvsnIsExpanded}">
            Cancer v.s. Normal (${cvsnPairTotal})
           	<ul>${cvsn}</ul>
        </li>   
        
	</ul>
</div>

<div id="promptMsg" style="width: 200px; background-color: white; position: fixed; left: calc(50% - 100px); left: -webkit-calc(50% - 100px); top: 45%; text-align: center; font-weight: bold; color: blue; display: none; border: black 1px solid;">
Select subset pair.
</div>

</body>

</html>