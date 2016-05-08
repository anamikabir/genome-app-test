<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>RNASeq</title>

<link rel="stylesheet" type="text/css" href="css/style.css" />

<script type="text/javascript" src="js/jquery/jquery-1.8.2.js"></script>

<script>
function changeTag(target) {
	$("a").prop("className", "");
	$(target).prop("className", "current");
}
</script>

</head>
<body style="overflow:hidden;">

<div id="content">
	<div style="width: 60%; text-align: left; float: left;">
		<a href="index.jsp" target="_top" onClick="changeTag($('a')[1]);">		
			<img src="images/logo.png" height="54em" style="float: left; padding-top: 4px; padding-left: 10px; padding-right: 20px;">		
			<img src="images/logo2.png" height="48em" style="float: left; padding-top: 18px; padding-left: 10px; padding-right: 20px;">
		</a>
	</div>
	<div style="width: 40%; text-align: left; float: left;">
		<ul id="top">
			<!-- 
			<li><a href="about.jsp" target="center" onClick="changeTag(this);" style="font-weight: bold;">ABOUT</a></li>
			 -->
			<li><a href="tutorial.jsp" target="center" onClick="changeTag(this);" style="font-weight: bold;">TUTORIAL</a></li>
			<li><a class="current" href="ttest.jsp" target="center" onClick="changeTag(this);" style="font-weight: bold;">ANALYSIS</a></li>
			<li><a href="download.jsp" target="center" onClick="changeTag(this);" style="font-weight: bold;">DOWNLOAD</a></li>
			<li><a href="contanctUs.jsp" target="center" onClick="changeTag(this);" style="font-weight: bold;">CONTANCT US</a></li>
		</ul>
	</div>
</div>

</body>
</html>