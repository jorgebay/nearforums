var indexer = 
{
	maxCalls : 10
	,
	callsCounter : 0
	,
	finishedMessage : ""
	, 
	init : function(sender, url, message, finishMessage)
	{
		indexer.finishedMessage = finishMessage;
		if (!confirm(message))
		{
			return;
		}
		$(sender).hide();
		$("#loading").slideDown();

		$.post(url, indexer.defaultParams(), function(forums){
			var list = $("<ul></ul>").appendTo("#containerForm");
			$.each(forums, function(){
				$("<li></li>")
					.text(this.Name + " ")
					.append($("<span></span>")
						.addClass("status")
						.text("0 %"))
					.append($("<input />")
						.attr("type", "hidden")
						.attr("name", "total")
						.val(this.TopicCount))
					.append($("<input />")
						.attr("type", "hidden")
						.attr("name", "indexed")
						.val("0"))
					.append($("<input />")
						.attr("type", "hidden")
						.attr("name", "id")
						.val(this.Id))
					.appendTo(list);
			});
			indexer.batch();
		});	
	}
	, 
	batch : function()
	{
		var allIndexed = true;
		$("#containerForm > ul > li").each(function(){
			var listElement = $(this);
			var total = parseInt($("input[name='total']", listElement).val(), 10);
			var indexed = parseInt($("input[name='indexed']", listElement).val(), 10);
			if (indexed < total)
			{
				var id = $("input[name='id']", listElement).val();
				var url = $("#indexBatchUrl").val();
				var params = indexer.defaultParams();
				params.forumId = id;
				params.index = indexed;
				$.post(url, params, function(count){
					if (count == 0)
					{
						indexed = total;
					}
					indexed += count;
					$("input[name='indexed']", listElement).val(indexed);
					$("span.status", listElement).text(Math.round(indexed*100/total)).append(" %");
					indexer.callsCounter++;
					if (indexer.callsCounter < indexer.maxCalls)
					{
						setTimeout(indexer.batch, 500);
					}
				});
				allIndexed = false;
				return false;
			}
		});
		if (allIndexed)
		{
			$("#loading").fadeOut("fast", function(){
				alert(indexer.finishedMessage);
				document.location.reload();
			});
		}
	}
	, 
	defaultParams : function()
	{
		var params = new Object();
		$("#containerForm > input[type='hidden']:first").each(function(){
			params[$(this).attr("name")] = $(this).val();
		});
		return params;
	}
	,
	enableToggle : function(url)
	{
		$("#containerForm")
			.prop("action", url)
			.submit();
	}
}