<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Forum>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%=Model.Name %> - Unanswered topics
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<div class="forumDetail">
		<ul class="path floatContainer">
			<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		</ul>
		<h1><%=Model.Name %> - Unanswered topics</h1>
		<% Html.RenderPartial("ForumOptions"); %>
<% 
		if (this.Model.Topics.Count > 0)
		{
			Html.RenderPartial("ForumTopicList", this.Model.Topics);
		}
		else
		{
%>
			<p class="warning">No unanswered topics for this forum.</p>
<%		
		}
%>
	</div>
</asp:Content>