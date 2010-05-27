<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<List<ForumCategory>>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Forum List
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<div class="forumList">
		<h1>Forums</h1>
<%
		foreach (ForumCategory category in this.Model)
		{
%>
			<h2><%=category.Name%></h2>
			<ul class="items">
<%		
			foreach (Forum forum in category.Forums)
			{
%>
				<li>
					<h3>
						<%=Html.ActionLink(forum.Name, "Detail", new{forum=forum.ShortName}) %>
						<span class="details"><%=forum.TopicCount %> threads / <%=forum.MessageCount %> posts</span>
					</h3>
					<p><%=forum.Description %></p>
				</li>
<%
			}
%>
			</ul>
<%
		}

		if (this.Model.Count == 0)
		{
%>
			<p>No forums found. Create <%=Html.ActionLink("a forum", "Add") %>.</p>
<%
		}
%>
	</div>
</asp:Content>
