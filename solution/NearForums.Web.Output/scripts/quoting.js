var quoting = 
{
	init : function()
	{
		$(document).bind("dataLoaded", quoting.bindQuotes);
	}
	,
	isNumber : function (n) 
	{
		return !isNaN(parseInt(n)) && isFinite(n);
	}
	,
	bindQuotes : function()
	{
		$("a.fastQuote").unbind().mousemove(quoting.showQuote).mouseout(quoting.hideQuotes).each(function(){
			$(this).text($(this).text().replace("[", "").replace("]", ""));
		});
	}
	,
	showQuote : function(e)
	{
		var href = $(this).attr("href");
		if (href.length > 4)
		{
			var quotedId = href.substring(4);
			//TODO: Determine if quoteId is numeric
			if (quoting.isNumber(quotedId))
			{
				quotedId = parseInt(quotedId, 10);
				if ($("#msg" + quotedId).length != 0)
				{
					var content = $("#msg" + quotedId).html();
					overTip.show(e, "overTip" + quotedId, content, null, true);
				}
			}
		}
	}
	,
	hideQuotes : function()
	{
		overTip.hideAll();
	}
};
