<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>RNASeq</title>
<style type="text/css">
html, body {
	height: 100%;
	overflow: hidden;
}
</style>

<link rel="stylesheet" type="text/css" href="css/style.css" />
<link rel="stylesheet" type="text/css" href="css/easytree/skin_win8/ui.easytree.css" class="skins" />

<script type="text/javascript" src="js/jquery/jquery-1.8.2.js"></script>
<script type="text/javascript" src="js/jquery/jquery.blockUI.js"></script>
<script type="text/javascript" src="js/jquery/jquery.easytree.min.js"></script>

<script>
var easytree;
$(function(){
	$("#left_top").block({ message: "<div>Loading...<br>Please Wait ...</div>"});	
	$("#left_bottom").block({ message: "<div>Loading...<br>Please Wait ...</div>"});	

	easytree = $("#umls_menu").easytree({
    	ordering: "orderedFolder",
    	disableIcons: true
    });
});

function openTopList(target) {	
	$("#top_list").css("left", $(target).position().left + "px");
	$("#top_list").css("top", $(target).position().top + "px");
	$("#top_list").css("height", $(target).css("height"));
	
	easytree.rebuildTree($(target).find("iframe").get(0).contentWindow.easytree.getAllNodes());
	$("#top_list").fadeIn(500);
	$("#top_list_title").text($(target).find("div").text());
}

function closeTopList() {
	$("#top_list").fadeOut(500);
}

function searchPairs(cui) {
	closeTopList();
	$("#left_top").find("iframe").get(0).contentWindow.searchPairs(cui);
}
</script>

<style>
.isSubset {
	font-weight: normal;
}
</style>

</head>
<body style="background: #ffffff;">

<div id="left" style="width:30em;height:100%;float:left;">

	<!-- 
	<div id="left_top" style="width:100%;height:50%;float:left;cursor:pointer;" onClick="openTopList(this);">
		<div style="width:calc(100% - 10px);background-color: #555555;color: #FFFFFF;padding: 5px; margin: 0px;font-size: 16px;font-weight: bold;background-position:right;background-image: url(images/top_open.png);background-repeat: no-repeat;background-size: contain;">Diseases</div>
		<iframe name="left_top" width="100%" style="height:calc(100% - 25px);" src="left_top.jsp" frameborder="0" style="border-bottom: #F0F0F0 1px solid;"></iframe>
	</div>
	
	<div id="left_bottom" style="width:100%;height:50%;float:left;cursor:pointer;" onClick="openTopList(this);">
		<div style="width:calc(100% - 10px);background-color: #555555;color: #FFFFFF;padding: 5px; margin: 0px;font-size: 16px;font-weight: bold;background-position:right;background-image: url(images/top_open.png);background-repeat: no-repeat;background-size: contain;">Subset Pairs</div>
		<iframe name="left_bottom" width="100%" style="height:calc(100% - 25px);" frameborder="0" style="border-top: #F0F0F0 1px solid;"></iframe>
	</div>	
	 -->

	<div id="left_top" style="width:100%;height:50%;float:left;">
		<div style="width:calc(100% - 10px);width:-webkit-calc(100% - 10px);background-color: #555555;color: #FFFFFF;padding: 5px; margin: 0px;font-size: 16px;font-weight: bold;">Disease and dataset</div>
		<iframe id="left_top_iframe" name="left_top" width="100%" style="height:calc(100% - 25px);height:-webkit-calc(100% - 25px);" src="left_top.jsp" frameborder="0"></iframe>
	</div>
	
	<div id="left_bottom" style="width:100%;height:50%;float:left;">
		<div id="left_bottom_title" style="width:calc(100% - 10px);width:-webkit-calc(100% - 10px);background-color: #555555;color: #FFFFFF;padding: 5px; margin: 0px;font-size: 16px;font-weight: bold;">Subset pair</div>
		<iframe id="left_bottom_iframe" name="left_bottom" width="100%" style="height:calc(100% - 25px);height:-webkit-calc(100% - 25px);" frameborder="0"></iframe>
	</div>	
	 
</div>

<div id="right" style="width:calc(100% - 30em);width:-webkit-calc(100% - 30em);height:100%;float:left;">
	<iframe id="right_iframe" name="right" width="100%" height="100%" src="right.jsp" frameborder="0"></iframe>
</div>

<div id="top_list" style="width:50%;background-color: white;position: fixed;cursor:pointer;display: none;">
	<div id="top_list_title" style="width:calc(100% - 10px);width:-webkit-calc(100% - 10px);background-color: #555555;color: #FFFFFF;padding: 5px; margin: 0px;font-size: 16px;font-weight: bold;background-position:right;background-image: url(images/top_close.png);background-repeat: no-repeat;background-size: contain;" onClick="closeTopList();">
	</div>
	<div id="umls_menu" style="height:calc(100% - 37px);height:-webkit-calc(100% - 37px);overflow:auto;border-top: #F0F0F0 1px solid; padding-top: 8px; padding-left: 8px;">
	</div>
</div>

</body>
</html>