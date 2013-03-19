function deleteMessageCommon(mid, url, confirmMessage, removedMessage, sender)
{
    if (confirm(confirmMessage.replace('{0}', mid)))
    {
        $.post(url, { mid: mid }, function (data)
        {
            $("#msg" + mid + " > div.msgBody").html("<p class=\"removed\">" + removedMessage + "</p>");
            alert(removedMessage);
            if (sender)
            {
                $(sender).closest("li").remove();
            }
        });
    }
    return false;
}
function preventMultipleSubmit() {
    $(this).submit(function() {
        return false;
    });
    return true;
}
function postLink(sender, data, callback)
{
	if (!data)
	{
		data = new Object();
	}
	data.__RequestVerificationToken = $("input[name='__RequestVerificationToken']").val();
	$.post($(sender).attr("href"), data, callback);
	return false;
}
function postAndContinue(sender, data, confirmMessage)
{
	if ((!confirmMessage) || confirm(confirmMessage))
	{
		postLink(sender, data, function(responseData){
			if (responseData && responseData.nextUrl)
			{
				document.location.href = responseData.nextUrl;
			}
			else
			{
				window.location.reload();
			}
		});
	}
	return false;
}
$.fn.serializeObject = function () 
{
	var o = {};
	var a = this.serializeArray();
	$.each(a, function () {
		if (o[this.name] !== undefined) {
			if (!o[this.name].push) {
				o[this.name] = [o[this.name]];
			}
			o[this.name].push(this.value || '');
		} else {
			o[this.name] = this.value || '';
		}
	});
	return o;
};