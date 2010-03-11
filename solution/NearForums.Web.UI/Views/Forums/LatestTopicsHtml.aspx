<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Forum>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%=Model.Name %>
</asp:Content>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
	<%=Html.MetaDescription(Model.Description) %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<div class="forumDetail">
		<ul class="path floatContainer">
			<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		</ul>
		<h1><%=Model.Name %></h1>
		<div class="ordering">
			<%=Html.ActionLink("Most viewed topics", "Detail") %>
			<span>/</span>
			<%=Html.ActionLink("Latest topics", "LatestTopics", new{format=NearForums.Web.UI.ResultFormat.Html}, new{@class="selected"}) %>
			<a rel="nofollow" href="<%=Url.Action("LatestTopics", new{format=NearForums.Web.UI.ResultFormat.Rss}) %>"><img src="/images/iconrss.gif" alt="rss" /></a>
		</div>
		<% Html.RenderPartial("ForumTopicList", this.Model); %>
		<%=Html.Pager(Config.Forums.TopicsPerPage, this.PageIndex, (int)ViewData["TotalTopics"], "Previous", "Next") %>
		
		<h2>Tags</h2>
		<% Html.RenderPartial("TagCloud", ViewData.Get<List<WeightTag>>("Tags")); %>
		
		<p><%= Html.ActionLink("Post a topic >>", "Add", "Topics", new{forum=this.Model.ShortName}, null) %></p>
	</div>
</asp:Content>