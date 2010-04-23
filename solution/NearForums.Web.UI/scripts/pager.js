var pager = 
{
	firstItem : -1
	,
	totalItems : -1
	,
	lastItem : -1
	,
	tempText : null
	,
	enabled : false
	,
	postUrl : null
	,
	postUrlToId : null
	,
	init : function(postUrl,postUrlToId)
	{
		if ($(".firstItem").length > 0)
		{
			pager.firstItem = parseInt($(".firstItem").text(), 10);
			pager.lastItem = parseInt($(".lastItem").text(), 10);
			pager.totalItems = parseInt($(".totalItems").text(), 10);
			pager.enabled = true;
			
			pager.postUrl = postUrl;
			pager.postUrlToId = postUrlToId;
			if (pager.firstItem == 1)
			{
				$("div.pager").hide();
				pager.showCurrentStatus();
				if (window.location.hash)
				{
					pager.navigateToId();
				}
			}
		}
		$(document).trigger("dataLoaded");
	}
	,
	loadingStart : function()
	{
		//loading
		pager.enabled = false;
		$("#pagerClient").toggleClass("loading");
	}
	,
	loadingEnd : function()
	{
		$("#pagerClient").toggleClass("loading");
		pager.enabled = true;
	}
	,
	showCurrentStatus : function()
	{
		$(".lastItem").text(pager.lastItem.toString());
		if (pager.lastItem == pager.totalItems)
		{
			//Don't hide it, just disable it
			$("#pagerClient").hide();
		}
		else
		{
			$("#pagerClient").slideDown();
		}
	}
	,
	more : function()
	{
		if (pager.enabled && pager.lastItem < pager.totalItems)
		{
			var fromId = $("#messages li:last").attr("id").substring(3);
			$.post(pager.postUrl, {from:fromId, initIndex:$("#messages li").length}, pager.moreCallback);
			pager.loadingStart();
		}
	}
	,
	moreCallback : function(htmlText)
	{
		$("#messages").append(htmlText);
		pager.lastItem = $("#messages li").length;
		pager.loadingEnd();
		pager.showCurrentStatus();
		$(document).trigger("dataLoaded");
	}
	,
	navigateToId : function()
	{
		if (pager.enabled && $(window.location.hash).length == 0)
		{
			//Load messages until that id
			if (window.location.hash.indexOf("msg") == 1)
			{
				pager.loadingStart();
				var lastMsg = window.location.hash.substring(4);
				var firstMsg = $("#messages li:last").attr("id").substring(3);
				$.post(pager.postUrlToId, {firstMsg:firstMsg,lastMsg:lastMsg,initIndex:$("#messages li").length}, pager.navigateToIdCallback);
			}
		}
	}
	,
	navigateToIdCallback : function(htmlText)
	{
		$("#messages").append(htmlText);
		pager.lastItem = $("#messages li").length;
		$("#messages li:last").addClass("highlight");
		var temp = window.location.hash;
		window.location.hash = "#";
		window.location.hash = temp;
		pager.loadingEnd();
		pager.showCurrentStatus();
		$(document).trigger("dataLoaded");
	}
	,
	showAll : function()
	{
		if (pager.enabled)
		{
			pager.loadingStart();
			var lastMsg = 1000;
			var firstMsg = $("#messages li:last").attr("id").substring(3);
			$.post(pager.postUrlToId, {firstMsg:firstMsg,lastMsg:lastMsg,initIndex:$("#messages li").length}, pager.showAllCallback);
		}
		return false;
	}
	,
	showAllCallback : function(htmlText)
	{
		$("#messages").append(htmlText);
		pager.lastItem = $("#messages li").length;
		pager.loadingEnd();
		pager.showCurrentStatus();
		$(document).trigger("dataLoaded");
	}
}	