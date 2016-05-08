<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.*" %>
<%@ page import="model.*" %>
<%@ page import="service.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Index</title>

<link rel="stylesheet" type="text/css" href="js/jquery-ui/css/smoothness/jquery-ui-1.8.23.custom.css" />
<link rel="stylesheet" type="text/css" href="css/easytree/skin_win8/ui.easytree.css" class="skins" />

<script type="text/javascript" src="js/jquery/jquery-1.8.2.js"></script>
<script type="text/javascript" src="js/jquery/jquery.blockUI.js"></script>
<script type="text/javascript" src="js/jquery/jquery.easytree.min.js"></script>

<script type="text/javascript">
var easytree;
var isFirst = true;
$(function() {
	setTimeout(function(){
		$("#left_top", parent.document).unblock();	
		
		$("#right", parent.document).find("iframe").get(0).contentWindow.prompt1();
		// prompt();
	}, 300);
	
	easytree = $("#umls_menu").easytree({
    	ordering: "orderedFolder",
    	disableIcons: true,
    	toggling: toggling
    });
	
	auto();
});

function auto() {
	if ($(".easytree-active").find("a").attr("href") != undefined)
		window.location.href = $(".easytree-active").find("a").attr("href");
}

function searchPairs(cui, title) {
	$("#left_bottom", parent.document).block({ message: "<div>Loading...<br>Please Wait ...</div>"});	
	
    var form = document.createElement("form");
    form.setAttribute("method", "post");
    form.setAttribute("action", "left_bottom.jsp");
    form.setAttribute("target", "left_bottom");

    var hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("name", "cuis");
    hiddenField.setAttribute("value", $("#" + cui).val());
    form.appendChild(hiddenField);
    
    hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("name", "title");
    hiddenField.setAttribute("value", title);
    form.appendChild(hiddenField);    
    
    if (!isFirst) {
	    hiddenField = document.createElement("input");
	    hiddenField.setAttribute("type", "hidden");
	    hiddenField.setAttribute("name", "isNotFirst");
	    hiddenField.setAttribute("value", "true");
	    form.appendChild(hiddenField);
    } else
		isFirst = false;

    document.body.appendChild(form);
    form.submit();

    $("#top_list", window.parent.document).fadeOut(500);
    $("#umls", window.parent.document).fadeOut(500);
    $("#pair", window.parent.document).fadeIn(500);
    
}

function prompt() {
	/* $("#left_top_iframe", parent.document).css("opacity", "");
	setTimeout(function(){
	    $("#left_top_iframe", parent.document).fadeOut(300, function() {
	        $("#left_top_iframe", parent.document).fadeIn(300, function() {
	            $("#left_top_iframe", parent.document).fadeOut(300, function() {   	
	                $("#left_top_iframe", parent.document).fadeIn(300, function() {
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

function toggling(event, nodes, node) {
	if (!node.isExpanded)
    	eval(node.href);
}
</script>

<style>
html, body {
	margin: 0;
	overflow-x: hidden;
}

body {
	padding: 8px;
}

#umls_menu {
	height: 100%;
}

.isSubset {
	font-weight: normal;
}
</style>
  
</head>

<body>
<div id="umls_menu">
	<%
	SubsetExpService subsetExpService = new SubsetExpService();
	String tmp = null;
	/*2 Map<Integer, Set<SubsetPair>> cancerSubsetPairMap = subsetExpService.selectCancerPair();
	Map<Integer, Set<SubsetPair>> hlbsSubsetPairMap = subsetExpService.selectHLBSPair(); */
	
	/* Set<SubsetUMLS> rootSet = new HashSet<SubsetUMLS>();	
	SubsetUMLS root = new SubsetUMLS();
	root.setCUI("C0027651");
	root.setStr("Neoplasms");
	rootSet.add(root);
	tmp = subsetExpService.getTreeHtml(subsetExpService.createTree(cancerSubsetPairMap.get(1), rootSet)); */
	/*2 tmp = subsetExpService.getSelectedHierarchical(cancerSubsetPairMap.get(SubsetExpService.TYPE_DISEASE_DISEASE), "Cancer", SubsetExpService.TYPE_DISEASE_DISEASE, null, null);
	if (tmp.length() == 0)
		tmp = subsetExpService.getTreeHtml(subsetExpService.createReverseTree(cancerSubsetPairMap.get(SubsetExpService.TYPE_DISEASE_DISEASE)), null, null);
	pageContext.setAttribute("cvsc", tmp.substring(0, tmp.indexOf("<input") - 1));
	pageContext.setAttribute("cvscPair", tmp.substring(tmp.indexOf("<input"), tmp.length()));
	pageContext.setAttribute("cvscPairTotal", subsetExpService.getTotalPair(tmp)); */
	
	/* rootSet = new HashSet<SubsetUMLS>();
	root = new SubsetUMLS();
	root.setCUI("C0027651");
	root.setStr("Neoplasms");
	rootSet.add(root);
	tmp = subsetExpService.getTreeHtml(subsetExpService.createTree(cancerSubsetPairMap.get(2), rootSet)); */
	/* tmp = subsetExpService.getSelectedHierarchical(cancerSubsetPairMap.get(SubsetExpService.TYPE_TREATMENT_CONTROL), "Cancer", SubsetExpService.TYPE_TREATMENT_CONTROL);
	if (tmp.length() == 0)
		tmp = subsetExpService.getTreeHtml(subsetExpService.createReverseTree(cancerSubsetPairMap.get(SubsetExpService.TYPE_TREATMENT_CONTROL)));
	pageContext.setAttribute("tvsc", tmp.substring(0, tmp.indexOf("<input") - 1));
	pageContext.setAttribute("tvscPair", tmp.substring(tmp.indexOf("<input"), tmp.length())); */
	
	/* rootSet = new HashSet<SubsetUMLS>();
	root = new SubsetUMLS();
	root.setCUI("C0027651");
	root.setStr("Neoplasms");
	rootSet.add(root);
	tmp = subsetExpService.getTreeHtml(subsetExpService.createTree(cancerSubsetPairMap.get(3), rootSet)); */
	/*2 tmp = subsetExpService.getSelectedHierarchical(cancerSubsetPairMap.get(SubsetExpService.TYPE_DISEASE_NORMAL), "Cancer", SubsetExpService.TYPE_DISEASE_NORMAL, "Breast Carcinoma", "Triple Negative Breast Cancer Primary Tumor");
	if (tmp.length() == 0)
		tmp = subsetExpService.getTreeHtml(subsetExpService.createReverseTree(cancerSubsetPairMap.get(SubsetExpService.TYPE_DISEASE_NORMAL)), "Breast Carcinoma", "Triple Negative Breast Cancer Primary Tumor");
	pageContext.setAttribute("cvsn", tmp.substring(0, tmp.indexOf("<input") - 1));
	pageContext.setAttribute("cvsnPair", tmp.substring(tmp.indexOf("<input"), tmp.length()));
	pageContext.setAttribute("cvsnPairTotal", subsetExpService.getTotalPair(tmp)); 

	Set<SubsetPair> subsetPair = new HashSet<SubsetPair>();
	subsetPair.addAll(hlbsSubsetPairMap.get(SubsetExpService.TYPE_DISEASE_DISEASE));
	subsetPair.addAll(hlbsSubsetPairMap.get(SubsetExpService.TYPE_DISEASE_NORMAL));
	subsetPair.addAll(hlbsSubsetPairMap.get(SubsetExpService.TYPE_DISEASE_CONTROL));
	
	tmp = subsetExpService.getHLBSTreeHtml();*/
	/* tmp = subsetExpService.getSelectedHierarchical(subsetPair, "HLBS", 0);
	if (tmp.length() == 0)
		tmp = subsetExpService.getTreeHtml(subsetExpService.createReverseTree(subsetPair)); */
	/*2 pageContext.setAttribute("hlbs", tmp.substring(0, tmp.indexOf("<input") - 1));
	pageContext.setAttribute("hlbsPair", tmp.substring(tmp.indexOf("<input"), tmp.length())); 
	pageContext.setAttribute("hlbsPairTotal", 0); */
	
	tmp = subsetExpService.getSelectedHierarchical("Breast Carcinoma", "GSE58135", "Breast cancer - TNBC");
	pageContext.setAttribute("all", tmp.substring(0, tmp.indexOf("<input") - 1));
	pageContext.setAttribute("allPair", tmp.substring(tmp.indexOf("<input"), tmp.length()));
	pageContext.setAttribute("allPairTotal", subsetExpService.getTotalPair(tmp));
	%>
    <ul>
    
    	${all}
    
		<!--
        <li class="isFolder">
            Cancer v.s. Cancer (${cvscPairTotal})
           	<ul>${cvsc}</ul>
        </li>        
        
        <li class="isFolder">
            Treatment v.s. Control
           	<ul>${tvsc}</ul>
        </li>
        
        <li class="isFolder isExpanded">
            Cancer v.s. Normal (${cvsnPairTotal})
           	<ul>${cvsn}</ul>
        </li>
        
        ${hlbs}
        
        <li class="isFolder">
            HLBS (${hlbsPairTotal})
           	<ul>${hlbs}</ul>
        </li>
         -->
        
    </ul>
    <%
	subsetExpService.close();
    %>
</div>
<a href="../CRN2/getUMLSHierarchicalEdit" style="color: #fff" target="_blank">Edit</a>
${allPair}
<!-- 
${cvscPair}
${tvscPair}
${cvsnPair}
${hlbsPair}
 -->

<div id="promptMsg" style="width: 200px; background-color: white; position: fixed; left: calc(50% - 100px); left: -webkit-calc(50% - 100px); top: 45%; text-align: center; font-weight: bold; color: blue; display: none; border: black 1px solid;">
Select disease or disease stage.
</div>

</body>

</html>