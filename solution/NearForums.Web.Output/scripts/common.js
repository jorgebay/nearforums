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
function postAndContinue(sender, data, confirmMessage)
{
	if ((!confirmMessage) || confirm(confirmMessage))
	{
		data.__RequestVerificationToken = $("input[name='__RequestVerificationToken']").val();
		$.post($(sender).attr("href"), data, function(responseData){
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