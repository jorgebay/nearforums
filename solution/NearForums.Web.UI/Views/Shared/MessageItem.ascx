<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl<Message>" %>
<li class="floatContainer" id="msg<%= Model.Id %>">
	<div class="msgHeader">
		<strong>
			<a class="msgId" rel="nofollow"
				href="<%=ViewData.Get<bool>("FullUrl", false) ? Url.Action(null, null, new{page=0}) : "" %>#msg<%= Model.Id %>" 
				onclick="window.location.hash='#msg<%= Model.Id %>';return false;">#<%= Model.Id %></a>
		</strong>
		<span class="userSep">
		by
		</span>
		<strong class="userName"><%= Html.ActionLink(Model.User.UserName, "Detail", "Users", new{id=Model.User.Id}, new{rel="nofollow"}) %></strong>
		<span class="dateSep">
		 
		</span>
		<%= Html.Date(Model.Date) %>
	</div>
	<div class="msgBody">
<%
	if (this.Model.Active)
	{
%>
		<%=Model.Body%>
<%
	}
	else
	{
%>
		<p class="removed">The message was removed by the forum moderator.</p>
<%
	}
%>
	</div>
	<div class="msgOptions">
<%
	if (this.User != null && this.User.Group >= UserGroup.Moderator && Model.Active)
	{
%>
		<%=Html.ActionLink("remove", "DeleteMessage", new{mid=Model.Id}, new{onclick="return confirm('Are you sure you want to hide this message?');"})%>
<%
	}
%>
	</div>
</li>