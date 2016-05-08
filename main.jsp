<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Index</title>

<script type="text/javascript" src="js/jquery/jquery-1.8.2.js"></script>

<script type="text/javascript">
function openUMLS() {
	if ($("#pair").css("display") == "block") {
		$("#pair").fadeOut(500);
		$("#umls").fadeIn(500);
	} else if ($("#umls").css("display") == "none")
		$("#umls").fadeIn(500);
	else
		$("#umls").fadeOut(500);
}

function cancel(target) {
	$(target).parent().css("display", "none");
	if ($(target).parent().attr("id") == "pair")
		$("#umls").fadeIn(500);
}

function resizeIframe(obj) {	
	obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
}
</script>

<style>
html, body {
	height: 100%;
}

#umls_icon:hover {
	background-color: #888;
}

#umls_icon {
	width: 20px;
	height: 20px;
	
    position: fixed;
    left: 5px;
    top: 5px;
    
    border-color: #000;
    border-width: 1px;
    border-style: solid;
    
	background-color: #fff;
    
    cursor: pointer;
}

#umls {
	display: none;

	width: 50%;
	height: 50%;
	
    position: fixed;
    left: 35px;
    top: 5px;
    
    cursor: pointer;
}

#pair {
	display: none;
	
	width: 50%;
	height: 50%;
	
    position: fixed;
    left: 35px;
    top: 5px;
    
    cursor: pointer;
}
</style>
</head>

<body>

<div style="width: 100%;">
	<iframe id="pvalue" name="pvalue" src="right.jsp" width="100%" marginwidth="0" frameborder="0" scrolling="no" onload="javascript:resizeIframe(this);"></iframe>
</div>

<img src="images/list.svg" id="umls_icon" onClick="openUMLS()">

<div id="umls">
	<iframe src="left_top.jsp" width="100%" height="100%" marginwidth="0" frameborder="0" scrolling="yes"></iframe>	
</div>

<div id="pair">
	<iframe name="pair" width="100%" height="100%" marginwidth="0" frameborder="0" scrolling="yes"></iframe>
</div>

</body>

</html>