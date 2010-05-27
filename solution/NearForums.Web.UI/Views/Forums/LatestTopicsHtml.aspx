<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Forum>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%=Model.Name %> - Latest threads
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<div class="forumDetail">
		<ul class="path floatContainer">
			<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		</ul>
		<h1><%=Model.Name %> - Latest threads</h1>
		<% Html.RenderPartial("ForumOptions"); %>
<% 
		if (this.Model.Topics.Count > 0)
		{
			Html.RenderPartial("ForumTopicList", this.Model.Topics);
		}
		else
		{
%>
			<p class="warning">No threads for this forum.</p>
<%		
		}
%>
		<%=Html.Pager(Config.Forums.TopicsPerPage, this.PageIndex, (int)ViewData["TotalTopics"], "Previous", "Next") %>
		<% Html.RenderPartial("TagCloud", ViewData.Get<List<WeightTag>>("Tags")); %>
		
		<p class="action"><%= Html.ActionLink("Post a thread >>", "Add", "Topics", new{forum=this.Model.ShortName}, null) %></p>
	</div>
</asp:Content>