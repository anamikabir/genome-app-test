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
			top = request.getParameter("top"),
			isNegative = request.getParameter("isNegative");

SubsetExpService subsetExpService = new SubsetExpService();

SubsetExp se = subsetExpService.hasExistCorrelation(subset1, subset2);
if (se != null) {
	subset1 = se.getSubset1().getSubsetID();
	subset2 = se.getSubset2().getSubsetID();
}

List<String> geneList = subsetExpService.getlncRNARegulatoryNetworkGenes(subset1, subset2);
List<String> lncRNAList = subsetExpService.getlncRNARegulatoryNetworklncRNAs(subset1, subset2);
subsetExpService.close();

StringBuffer geneSb = new StringBuffer();
for (String gene : geneList)
	geneSb.append(gene + ",");
String geneName = "EZH2";
if (geneSb.length() > 0) {
	geneSb.delete(geneSb.length() - 1, geneSb.length());
	if (!geneSb.toString().contains("EZH2"))
		geneName = geneSb.toString().split(",")[0];
}

StringBuffer lncRNASb = new StringBuffer();
for (String lncRNA : lncRNAList)
	lncRNASb.append(lncRNA + ",");
String lncRNA = "HOTAIR";
if (lncRNASb.length() > 0) {
	lncRNASb.delete(lncRNASb.length() - 1, lncRNASb.length());
	if (!lncRNASb.toString().contains("HOTAIR"))
		lncRNA = lncRNASb.toString().split(",")[0];
}

pageContext.setAttribute("geneNameList", geneSb.toString());
pageContext.setAttribute("geneName", geneName);
pageContext.setAttribute("lncRNAList", lncRNASb.toString());
pageContext.setAttribute("lncRNA", lncRNA);
pageContext.setAttribute("subset1", subset1);
pageContext.setAttribute("subset2", subset2);
pageContext.setAttribute("top", top);
pageContext.setAttribute("isNegative", isNegative);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>

<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" /> 
<link rel="stylesheet" type="text/css" href="css/jbar_right.css" />

<script type="text/javascript" src="js/jquery/jquery-1.8.2.js"></script>
<script type="text/javascript" src="js/jquery/jquery-ui-1.8.12.custom.min.js"></script>
<script type="text/javascript" src="js/jquery/jquery.jbar.js"></script>
<script type="text/javascript" src="js/jquery/jquery.autocomplete.pack.js" ></script>
<script type="text/javascript" src="js/jquery/jquery.autocomplete.js"></script>
<script type="text/javascript" src="js/jquery/jquery.blockUI.js"></script>
	
<script type="text/javascript" src="js/cytoscape/json2.min.js"></script>
<script type="text/javascript" src="js/cytoscape/arbor.js"></script>
<script type="text/javascript" src="js/cytoscape/cola.v3.min.js"></script>
<script type="text/javascript" src="js/cytoscape/dagre.js"></script>
<script type="text/javascript" src="js/cytoscape/springy.js"></script>
<script type="text/javascript" src="js/cytoscape/cytoscape.js"></script>

<script type="text/javascript">
var cy;

$(function() {
	<%
	if (geneSb.length() > 0) {
	%>	
	$("a[href='#lncRNARegulatoryNetworkFromGene']", parent.document).parent().css("display", "block");
	<%
	}
	%>
	
	var geneNameList = '${geneNameList}'.split(',');
	$("#mRNA").autocomplete(geneNameList,{width:"7em", delay:50, minChars:0, autoFill:false, matchContains: true, cacheLength:0})
	.result(function() {
		search('${subset1}', '${subset2}', $("input[name='top']:checked").val(), '${isNegative}');
	})
	.keypress(function(event) {
		if (event.which == 13)
			search('${subset1}', '${subset2}', $("input[name='top']:checked").val(), '${isNegative}');
	});
	
	var lncRNAList = '${lncRNAList}'.split(',');
	$("#lncRNA").autocomplete(lncRNAList,{width:"7em", delay:50, minChars:0, autoFill:false, matchContains: true, cacheLength:0})
	.result(function() {
		search('${subset1}', '${subset2}', $("input[name='top']:checked").val(), '${isNegative}');
	})
	.keypress(function(event) {
		if (event.which == 13)
			search('${subset1}', '${subset2}', $("input[name='top']:checked").val(), '${isNegative}');
	});
	
	createCytoscape();
	$("#mRNA").val('${geneName}');
	$("#lncRNA").val('${lncRNA}');
	search('${subset1}', '${subset2}', $("input[name='top']:checked").val(), '${isNegative}');
});

function search(subset1, subset2, top, isNegative) {
	var gene = $("#mRNA").val();
	var lncRNA = $("#lncRNA").val();
	
	$("#lncRNARegulatoryNetworkFromGene", parent.document).block({ message: "<div>Loading...<br>Please Wait ...</div>"});
	$.ajax({
        url: "lncRNARegulatoryNetworkFromGene_json.jsp",
        data: "subset1=" + subset1 +
        			"&subset2=" + subset2 +
        			"&top=" + top +
        			"&gene=" + gene +
        			"&lncRNA=" + lncRNA +
        			"&isNegative=" + isNegative,
        type: "POST",
        dataType: "text",

        success: function(msg){
			var elements = JSON.parse(msg);
			
        	cy.remove("edge");
        	cy.remove("node");
			cy.layout({
				name: "cose",
				padding: 5,
				refresh: 0,
				animate: false,
				gravity: 500,
				nodeRepulsion: 4000000,
				nodeOverlap: 100
			}); 
        	cy.load(elements);
        	
    		$("#lncRNARegulatoryNetworkFromGene", parent.document).unblock();
        },

        error:function(xhr, ajaxOptions, thrownError){ 
        	
         }
    });
}

function createCytoscape(){
	cy = $("#cytoscape").cytoscape({
		
		textureOnViewport: true,
		boxSelectionEnabled: false,
		
		style: cytoscape.stylesheet()
		.selector("node")
			.css({
				"content": "data(name)",
				"color": "#000",
				"font-weight": "bold",
				"text-valign": "top",
				"border-color": "#333",
				"border-style": "solid",
				"border-width": "2",
		        "text-outline-width": "2",
		        "text-outline-color": "white"
			})
		.selector("$node > node")
			.css({
		        'padding-top': '20px',
		        'padding-left': '10px',
		        'padding-bottom': '10px',
		        'padding-right': '10px',
		        'font-weight': 'bold'
			})
		.selector("node.targetPc")
			.css({
				"background-color": "Orange",
				"border-color": "black",
				"border-style": "solid",
				"border-width": "4",
				"width": "40px",
				"height": "40px"
			})
		.selector("node.pc")
			.css({
				"background-color": "Orange"
			})
		.selector("node.targetlncRNA")
			.css({
				"background-color": "ForestGreen",
				"border-color": "black",
				"border-style": "solid",
				"border-width": "4",
				"width": "40px",
				"height": "40px"
			})
		.selector("node.lncRNA")
			.css({
				"background-color": "ForestGreen"
			})
		.selector("node.selected")
			.css({
				"border-width": 3,
				"border-color": "#000",
				"background-color": "#AB8EC6"
			})
		.selector("edge")
			.css({
		        'opacity': 0.666,
		        'width': 2,
		        'line-color': '#0000FF',
		        'source-arrow-shape': 'none',
		        'target-arrow-shape': 'none',
		        'source-arrow-color': 'data(faveColor)',
		        'target-arrow-color': 'data(faveColor)'
			})
		.selector("edge.pc2plncRNA")
			.css({
		        'width': 4,
				'line-color': 'Red',
		        'source-arrow-shape': 'none',
		        'target-arrow-shape': 'none',
		        'source-arrow-color': 'Red',
		        'target-arrow-color': 'Red'
			})
		.selector("edge.pc2nlncRNA")
			.css({
		        'width': 4,
				'line-color': 'Blue',
		        'source-arrow-shape': 'none',
		        'target-arrow-shape': 'none',
		        'source-arrow-color': 'Blue',
		        'target-arrow-color': 'Blue'
			})
		.selector(".faded")
			.css({
				"opacity": 0.25,
				"text-opacity": 0
			}),
	  
		elements: null,
	  
		layout: null,
	  
		ready: function(){
			window.cy = this;
			
			// giddy up...
			
			cy.elements().unselectify();
			
			cy.on("tap", "node", function(e){
				var node = e.cyTarget; 
				var neighborhood = node.neighborhood().add(node);

				cy.elements().addClass("faded");
				neighborhood.removeClass("faded");
				cy.elements().removeClass("selected");
				node.addClass("selected");
			});
			
			cy.on("tap", function(e){
				var node = e.cyTarget;
				if(  node == cy ) {
					cy.elements().removeClass("faded");
					cy.elements().removeClass("selected");
				}
			}); 

			createJBar(cy);
		}
	});	
}

function createJBar(target) {
	$(".jbar").jbar();
	$("#jbar_menu ul li a").click(function(){
		var value = $(this).attr("rel"); 
		switch(value){			
			case "Force Directed":
				cy.layout({
					name: "arbor",
	
				    liveUpdate: false, // whether to show the layout as it"s running
				    ready: undefined, // callback on layoutready 
				    stop: undefined, // callback on layoutstop
				    maxSimulationTime: 1000, // max length in ms to run the layout
				    fit: true, // reset viewport to fit default simulationBounds
				    padding: [ 50, 50, 50, 50 ], // top, right, bottom, left
				    simulationBounds: undefined, // [x1, y1, x2, y2]; [0, 0, width, height] by default
				    ungrabifyWhileSimulating: true, // so you can"t drag nodes during layout
	
				    // forces used by arbor (use arbor default on undefined)
				    repulsion: undefined,
				    stiffness: undefined,
				    friction: undefined,
				    gravity: true,
				    fps: undefined,
				    precision: undefined,
	
				    // static numbers or functions that dynamically return what these
				    // values should be for each element
				    nodeMass: undefined, 
				    edgeLength: undefined,
	
				    stepSize: 1, // size of timestep in simulation
	
				    // function that returns true if the system is stable to indicate
				    // that the layout can be stopped
				    stableEnergy: function( energy ){
				      var e = energy; 
				      return (e.max <= 0.5) || (e.mean <= 0.3);
				    }
				});
				break;
				
			case "Circle":
				cy.layout({
					name: "circle",
	
				    fit: true, // whether to fit the viewport to the graph
				    ready: undefined, // callback on layoutready
				    stop: undefined, // callback on layoutstop
				    rStepSize: 10, // the step size for increasing the radius if the nodes don"t fit on screen
				    padding: 30, // the padding on fit
				    startAngle: 3/2 * Math.PI, // the position of the first node
				    counterclockwise: false // whether the layout should go counterclockwise (true) or clockwise (false)
				});
				break;
				
			case "Radial":
				cy.layout({
				   name: "breadthfirst",
				   circle: true,
				   padding: 10
				});
				break;
				
			case "Tree":
				cy.layout({
				   name: "breadthfirst",
				   /* directed: true, */
				   padding: 10
				});
				break;
			
			case "Compound":
				cy.layout({
					name: "cose",
					padding: 5,
					refresh: 0,
					animate: false,
					gravity: 500,
					nodeRepulsion: 4000000,
					nodeOverlap: 100
				});				
				break; 
				
			case "Grid":
				cy.layout({
					  name: 'grid',
	
					  fit: true, // whether to fit the viewport to the graph
					  padding: 10, // padding used on fit
					  boundingBox: undefined, // constrain layout bounds; { x1, y1, x2, y2 } or { x1, y1, w, h }
					  avoidOverlap: true, // prevents node overlap, may overflow boundingBox if not enough space
					  rows: undefined, // force num of rows in the grid
					  columns: 4, // force num of cols in the grid
					  position: function( node ){}, // returns { row, col } for element
					  sort: undefined, // a sorting function to order the nodes; e.g. function(a, b){ return a.data('weight') - b.data('weight') }
					  animate: false, // whether to transition the node positions
					  animationDuration: 500, // duration of animation in ms if enabled
					  ready: undefined, // callback on layoutready
					  stop: undefined // callback on layoutstop
				});
				break;
		
			case "png":
				$("#png [name=content]").val(cy.png());
				$("#png").submit();
				break;
				
			case "Top10":
			case "Top15":
			case "Top20":
			case "Top25":
			case "Top30":
				$(this).find("input[name='top']").attr("checked", "checked");
				changeTop($("input[name='top']:checked").val(), '${subset1}', '${subset2}', '${isNegative}');
				break;
		}
	});
	
	$("#jbar_menu ul li a:first").trigger("click");
}

function changeTop(top, subset1, subset2, isNegative) {
	search(subset1, subset2, top, $("#gene").val(), isNegative);
}
</script>

<style>
    html, body { height: 100%; width: 100%; padding: 0; margin: 0; }
</style>

</head>

<body>

<div id="jbar_menu">
	<ul class="jbar">
		
    	<li>
    		<a href="#">Legend</a>
    		<ul>

    			<li>
    				<a>
    					Node<br>
	    				&nbsp;&nbsp;&nbsp;<label><font style="background-color:Orange; vertical-align:middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;DE coding transcript</label><br>
	    				&nbsp;&nbsp;&nbsp;<label><font style="background-color:ForestGreen; vertical-align:middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;DE lncRNA</label><br>
    				</a>
    			</li>
    			
    			<li>
    				<a>
    					Edge<br>
    					&nbsp;&nbsp;&nbsp;<label><font style="background-color:Red; vertical-align:middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;Positive correlation</label><br>
    					&nbsp;&nbsp;&nbsp;<label><font style="background-color:Blue; vertical-align:middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>&nbsp;&nbsp;Negative correlation</label><br>
    				</a>
    			</li>
    		</ul>
    	</li>

		<li>
			<a href="#">Layout</a>
			<ul>
				<li><a href="#" rel="Force Directed">Force Directed</a></li>
				<li><a href="#" rel="Circle">Circle</a></li>       
                <li><a href="#" rel="Radial">Radial</a></li>   
                <li><a href="#" rel="Tree">Tree</a></li>   
                <li><a href="#" rel="Compound">Compound</a></li>  
                <li><a href="#" rel="Grid">Grid</a></li>    
			</ul>
		</li>
    	
		<li>
			<a href="#">Top N threshold</a>
			<ul>
				<li><a href="#" rel="Top10"><input type="radio" name="top" value="10" />Top 10 connections</a></li>
				<li><a href="#" rel="Top15"><input type="radio" name="top" value="15" checked />Top 15 connections</a></li>       
                <li><a href="#" rel="Top20"><input type="radio" name="top" value="20" />Top 20 connections</a></li>   
                <li><a href="#" rel="Top25"><input type="radio" name="top" value="25" />Top 25 connections</a></li>
            </ul>
		</li>	
		 
		<li>
			<a href="#"><span style="color: #cecece;">Gene</span></a><input id="mRNA" type="text" placeholder="Search Gene ID" style="font-weight: bold;" size="12" tabindex="1">&nbsp;<a href="#"><span style="color: #cecece;">lncRNA</span></a><input id="lncRNA" type="text" placeholder="Search lncRNA ID" style="font-weight: bold;" size="12" tabindex="2">&nbsp;
		</li>
		 
		<li>
			<a href="#">Export</a>
			<ul>
				<li><a href="#" rel="png">png</a></li>
            </ul>
		</li>
		 
	</ul>
</div>

<div id="cytoscape" style="height: calc(100% - 40px); height: -webkit-calc(100% - 40px); width: 100%;">
</div>

<form id="png" method="post" action="exportNetwork.jsp">
	<input type="hidden" name="content">
	<input type="hidden" name="type" value="png">
</form>

</body>
</html>