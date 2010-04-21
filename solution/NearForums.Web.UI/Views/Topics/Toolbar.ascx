<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl<Topic>" %>
<div class="toolbar floatContainer">
	<ul>
<%
		if (this.User != null && !this.Model.IsClosed)
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
		<li class="move"><%=Html.ActionLink("Move topic to another forum", "Move", new{forumName=Model.Forum.ShortName}) %></li>
<%
			if (!this.Model.IsClosed)
			{
%>
			<li class="close"><%=Html.ActionLink("Close", "CloseReplies") %></li>
		
<%
			}
			else
			{
%>
			<li class="close"><%=Html.ActionLink("Open to replies", "OpenReplies") %></li>
<%	
			}
		}
%>
	</ul>
</div>