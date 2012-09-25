var quoting = 
{
	init : function()
	{
		$(document).bind("dataLoaded", quoting.clean);
		quoting.bindQuotes();
	}
	,
	isNumber : function (n) 
	{
		return !isNaN(parseInt(n)) && isFinite(n);
	}
	,
	bindQuotes : function()
	{
		$("#messages")
			.on("mousemove", "a.fastQuote", quoting.showQuote)
			.on("mouseout", "a.fastQuote", quoting.hideQuotes);
	}
	,
	clean : function()
	{
		$("#messages a.fastQuote:contains('[')").each(function(){
			$(this).text($(this).text().replace("[", "").replace("]", ""));
		});
	}
	,
	showQuote : function(e)
	{
		var href = $(this).attr("href");
		if (href.length > 4)
		{
			var quotedId = href.substring(href.indexOf("#")+4);
			//Determine if quoteId is numeric
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
