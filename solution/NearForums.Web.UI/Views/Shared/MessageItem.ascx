<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl<Message>" %>
<li class="floatContainer" id="msg<%= Model.Id %>">
	<div class="msgHeader">
		<strong>
			<a class="msgId" rel="nofollow"
				href="<%=ViewData.Get<bool>("FullUrl", false) ? Url.Action(null, null, new{page=0}) : "" %>#msg<%= Model.Id %>" 
				onclick="window.location.hash='#msg<%= Model.Id %>';return false;">#<%= Model.Id %></a>
		</strong>
		by
		<strong class="userName"><%= Html.ActionLink(Model.User.UserName, "Detail", "Users", new{id=Model.User.Id}, new{rel="nofollow"}) %></strong>
		at
		<%= Html.Date(Model.Date) %>
	</div>
	<div class="msgBody">
		<%= Model.Body %>
	</div>
</li>