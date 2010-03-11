<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Topic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server"><%=Model.Title %></asp:Content>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
	<%=Html.MetaDescription(Utils.Summarize(Utils.RemoveTags(Model.Description), 160, ""))%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink(Model.Forum.Name, "Detail", "Forums", new{forum=Model.Forum.ShortName}, null) %></li>
	</ul>
	<div class="topicDetail">
		<h1><%=Model.Title %></h1>
		<p class="info">
			Topic by <strong class="userName"><%= Html.ActionLink(Model.User.UserName, "Detail", "Users", new{id=Model.User.Id}, new{rel="nofollow"}) %></strong>
			at 
			<%=Html.Date(Model.Date) %>
		</p>
		<div class="description">
			<p><%=Model.Description %></p>
		</div>
<% 
		PagedList<Message> messages = new PagedList<Message>(Model.Messages, this.PageIndex, Config.Topics.MessagesPerPage);
		if (messages.Count > 0)
		{
%>
			<ul id="messages">
<%			
			foreach (Message m in messages)
			{
				Html.RenderPartial("MessageItem", m);
			}
%>
			</ul>
<%
		}
%>
		<div class="pagerSummary"><span class="firstItem"><%=(this.PageIndex)*Config.Topics.MessagesPerPage + 1 %></span> to <span class="lastItem"><%=(this.PageIndex)*Config.Topics.MessagesPerPage + messages.Count %></span> of <span class="totalItems"><%=messages.TotalItemCount %></span> messages</div>
		<div id="pagerClient" style="display:none;"><a href="#" onclick="pager.more();return false;">More</a></div>
		<%=Html.Pager(messages)%>
		<div class="toolbar floatContainer">
			<ul>
				<li class="reply"><%=Html.ActionLink("Reply", "Reply", null, new{rel="nofollow"}) %></li>
				<li><a href="#" onclick="window.print();return false;">Print</a></li>
				<li><a href="#" onclick="return false;">Show all messages</a></li>
			</ul>
		</div>
		<h2>Related topics</h2>
<%
		if (this.Model.Related.Count > 0)
		{
%>
		<ul class="related">
<%
			foreach (Topic t in this.Model.Related)
			{
%>
			<li class="<%=t.IsClosed ? "isClosed" : "" %>"><%=Html.ActionLink(t.Title, "Detail", "Topics", new{id=t.Id, name=t.ShortName, forum=t.Forum.ShortName}, null) %></li>
<%
			}
%>
		</ul>
<%
		}
%>
	</div>
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
	<script type="text/javascript" src="/scripts/overtip.js"></script>
	<script type="text/javascript" src="/scripts/pager.js"></script>
	<script type="text/javascript" src="/scripts/quoting.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			quoting.init();
		});
		$(document).ready(function(){
			pager.init("<%=Url.Action("PageMore", "Topics", new{id=Model.Id}) %>", "<%=Url.Action("PageUntil", "Topics", new{id=Model.Id}) %>");
		});
		$(document).ready(function(){
			$(document).trigger("dataLoaded");
		});
	</script>
</asp:Content>