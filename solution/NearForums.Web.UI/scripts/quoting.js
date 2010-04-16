var quoting = 
{
	init : function()
	{
		$(document).bind("dataLoaded", quoting.bindQuotes);
	}
	,
	bindQuotes : function()
	{
		$("a.fastQuote").unbind().mousemove(quoting.showQuote).mouseout(quoting.hideQuotes);
	}
	,
	showQuote : function(e)
	{
		var quotedId = $(this).attr("href").substring(4);
		if ($("#msg" + quotedId).length != 0)
		{
			var content = $("#msg" + quotedId).html();
			overTip.show(e, "overTip" + quotedId, content, null, true);
		}
	}
	,
	hideQuotes : function()
	{
		overTip.hideAll();
	}
};
