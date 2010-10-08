<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<List<Topic>>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Unanswered Threads
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink("Admin", "Dashboard", "Admin") %></li>
	</ul>
	<h1>Unanswered Threads</h1>
<% 
	if (this.Model.Count > 0)
	{
%>
		<ul class="items">
<%
		foreach (Topic t in this.Model)
		{
%>
			<li>
				<%=Html.ActionLink(t.Forum.Name, "Detail", "Forums", new{forum=t.Forum.ShortName}, null) %> &gt; <%=Html.ActionLink(t.Title, "ShortUrl", "Topics", new{id=t.Id}, null) %>
				<span class="details"><strong><%=Html.Date(t.Date) %></strong> / <%=t.Views %> views</span>
			</li>
<%
		}
%>
		</ul>
<%
	}
	else
	{
%>
		<p class="warning">No unanswered threads, for now :)</p>
<%
	}
%>
</asp:Content>
