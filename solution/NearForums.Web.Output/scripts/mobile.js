$("div").live("pagebeforecreate", function(){
	//inserts jquery mobile attributes to behave like a mobile interface
	$.mobile.page.prototype.options.addBackBtn= true;
	$("div.toolbar, div.pager").attr("data-role", "controlgroup").attr("data-type", "horizontal");
	$("div.toolbar a, div.pager a, div.pager span").attr("data-role", "button");
	$("ul.items").attr("data-role", "listview");
	$("#messages").attr("data-role", "listview");
	$("ul.items div.topicCount, ul.items div.views, ul.items div.replies").addClass("ui-li-count");
	$("ul.items div.separator").hide();
	$(".facebook a, .twitter a").attr("rel", "external");
});
$("#messages li").live("tap", function () { $(this).toggleClass("over"); });