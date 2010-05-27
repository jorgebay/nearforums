<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Forum>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%=ViewData["Tag"] %>
</asp:Content>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<div class="forumDetail">
		<ul class="path floatContainer">
			<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
			<li><%=Html.ActionLink(Model.Name, "Detail", "Forums", new{forum=Model.ShortName}, null) %></li>
		</ul>
		<h1>Threads tagged with &quot;<%=ViewData["Tag"] %>&quot;</h1>
<%
		PagedList<Topic> topics = new PagedList<Topic>(Model.Topics, this.PageIndex, Config.Forums.TopicsPerPage);
%>
		<% Html.RenderPartial("ForumTopicList", topics); %>
		<%=Html.Pager(Config.Forums.TopicsPerPage, this.PageIndex, topics.Count, "Previous", "Next") %>
	</div>
</asp:Content>