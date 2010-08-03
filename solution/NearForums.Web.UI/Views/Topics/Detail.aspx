<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Topic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%=Model.Title %>
</asp:Content>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
	<%=Html.MetaDescription(Utils.Summarize(Utils.RemoveTags(Model.Description), 160, ""))%>
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink(Model.Forum.Name, "Detail", "Forums", new{forum=Model.Forum.ShortName}, null) %></li>
	</ul>
	<div class="topicDetail">
		<h1><%=Model.Title %></h1>
		<div class="options">
			<a rel="nofollow" href="<%=Url.Action("LatestMessages") %>"><img src="/images/iconrss.gif" alt="rss" /></a>
		</div>
		<p class="info">
			Topic by <strong class="userName"><%= Html.ActionLink(Model.User.UserName, "Detail", "Users", new{id=Model.User.Id}, new{rel="nofollow"}) %></strong>
			at 
			<%=Html.Date(Model.Date) %>
		</p>
		<div class="description">
			<%=Model.Description %>
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
		if (messages.TotalItemCount > 0)
		{
%>
		<div class="pagerSummary">
			Displaying
			<span class="firstItem"><%=(this.PageIndex)*Config.Topics.MessagesPerPage + 1 %></span>
			to
			<span class="lastItem"><%=(this.PageIndex)*Config.Topics.MessagesPerPage + messages.Count %></span>
			of
			<span class="totalItems"><%=messages.TotalItemCount %></span>
			messages
		</div>
<%
		}
%>
		<div id="pagerClient" style="display:none;"><a href="#" onclick="pager.more();return false;"><img src="/images/loadingMini.gif" alt="" style="" />Show more messages</a></div>
		<%=Html.Pager(messages)%>
		<% Html.RenderPartial("Toolbar", this.Model); %>
		<% Html.RenderPartial("Related", this.Model); %>
	</div>
	<script type="text/javascript" src="/scripts/overtip.js"></script>
	<script type="text/javascript" src="/scripts/pager.js"></script>
	<script type="text/javascript" src="/scripts/quoting.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			quoting.init();
		});
		$(document).ready(function(){
			pager.init('<%=Url.Action("PageMore", "Topics", new{id=Model.Id}) %>', '<%=Url.Action("PageUntil", "Topics", new{id=Model.Id}) %>');
		});
	</script>
	<script type="text/javascript">
		$(document).bind("dataLoaded", function(){
			$("div.msgOptions a").unbind("mouseenter mouseleave").hover(
				function()
				{
					$(this).parents("li").addClass("over");
				}
				,
				function()
				{
					$(this).parents("li").removeClass("over");
				}
			);
		});
	</script>
</asp:Content>