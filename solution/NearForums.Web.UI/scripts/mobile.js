$("div").live("pagebeforecreate", function(){
	//inserts jquery mobile attributes to behave like a mobile interface
	$("div.toolbar, div.pager").attr("data-role", "controlgroup").attr("data-type", "horizontal");
	$("div.toolbar a, div.pager a, div.pager span").attr("data-role", "button");
	$("ul.items").attr("data-role", "listview");
	//$("ul.items span.details").addClass("ui-li-count");
});