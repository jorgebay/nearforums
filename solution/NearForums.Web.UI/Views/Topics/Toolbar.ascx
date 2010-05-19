<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl<Topic>" %>
<div class="toolbar floatContainer">
	<ul>
<%
		if (!this.Model.IsClosed)
		{
%>
		<li class="reply"><%=Html.ActionLink("Reply", "Reply", null, new{rel="nofollow"}) %></li>
<%
		}
%>
		<li class="showAll"><a href="#" onclick="return pager.showAll();">Show all messages</a></li>
		<li class="print"><a href="#" onclick="window.print();return false;">Print</a></li>
<%
		if (this.User!= null && (this.User.Group >= UserGroup.Moderator || this.User.Id == Model.User.Id))
		{
%>
		<li class="edit"><%=Html.ActionLink("Edit", "Edit") %></li>
		<li class="move"><%=Html.ActionLink("Move topic", "Move", new{forumName=Model.Forum.ShortName}) %></li>
		<li class="delete"><%=Html.ActionLink("Delete", "Delete", null, new{@onclick="return confirm('Are you sure you want to DELETE this topic?');"}) %></li>
<%
			if (!this.Model.IsClosed)
			{
%>
			<li class="close"><%=Html.ActionLink("Close", "CloseReplies", null, new{@onclick="return confirm('Are you sure you want to CLOSE this topic for further replies?');"}) %></li>
		
<%
			}
			else
			{
%>
			<li class="open"><%=Html.ActionLink("Open to replies", "OpenReplies") %></li>
<%	
			}
		}
%>
	</ul>
</div>