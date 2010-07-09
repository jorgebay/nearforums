<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Dashboard
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
	</ul>
	<h1>Admin Dashboard</h1>
	<ul class="items">
		<li>
			<h3><%=Html.ActionLink("Manage forums", "Manage", "Forums") %></h3>
			<p>Add / edit / delete forums.</p>
		</li>
		<li>
			<h3><%=Html.ActionLink("Manage templates", "ListTemplates", "Admin") %></h3>
			<p>Manage the site templates for the forum.</p>
		</li>
		<li>
			<h3><%=Html.ActionLink("Manage users", "List", "Users") %></h3>
			<p>Promote, demote and delete forum users.</p>
		</li>
	</ul>
</asp:Content>

