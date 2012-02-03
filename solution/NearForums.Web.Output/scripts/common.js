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