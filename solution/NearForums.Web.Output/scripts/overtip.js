var overTip = 
{
	getMousePosition : function(e)
	{
		var posX = 0;
		var posY = 0;
		if (!e) var e = window.event;
		if (e.pageX || e.pageY) 	{
			posX = e.pageX;
			posY = e.pageY;
		}
		else if (e.clientX || e.clientY) 	{
			posX = e.clientX + document.body.scrollLeft
				+ document.documentElement.scrollLeft;
			posY = e.clientY + document.body.scrollTop
				+ document.documentElement.scrollTop;
		}
		return {x:posX, y:posY};
	}
	,
	exist : function(id)
	{
		return ($("#" + id).length > 0);
	}
	,
	show : function(e,id,content,width,persist)
	{
		var position = overTip.getMousePosition(e);
	
		if (!overTip.exist(id))
		{
			$(document.body).append("<div id=\"" + id + "\" class=\"overTip\" style=\"display:none;\"></div>");
			$("#" + id).html(content);
		}
		else
		{
			if (!persist)
			{
				$("#" + id).html(content);
			}
		}
		var tip = $("#" + id);
		tip.css("left", position.x + "px").css("top", (position.y + 20) + "px");
		
		if (width)
		{
			tip.width(width);
		}

		if (tip.is(":hidden"))
		{
			overTip.hideAll();
			tip.fadeIn("fast");
		}

		if (e.stopPropagation)
		{
			e.stopPropagation();
		}
		else
		{
			e.cancelBubble = true
		}
	}
	,
	hideAll : function()
	{
		$("div.overTip").hide();
	}
};