function deleteMessage(mid, url, sender)
{
    if (confirm('Are you sure you want to hide the message #' + mid + '?'))
    {
        $.post(url, { mid: mid }, function (data)
        {
            $("#msg" + mid + " > div.msgBody").html("<p class=\"removed\">Message removed</p>");
            alert('The message was removed.');
            if (sender)
            {
                $(sender).closest("li").remove();
            }
        });
    }
    return false;
}
function flagMessage(mid, url)
{
    $.post(url, { mid: mid }, function (data)
    {
        alert('Thanks you, a moderator will review the message.');
    });
    return false;
}