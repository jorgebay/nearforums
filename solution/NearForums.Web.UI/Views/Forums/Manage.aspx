<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<List<ForumCategory>>" %>
<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Manage forums
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Manage forums</h1>
    <ul>
<%
	foreach (ForumCategory category in this.Model)
	{
		foreach (Forum f in category.Forums)
		{
%>
			<li><%=Html.ActionLink("Edit", "Edit", "Forums", new{id=f.Id}, null) %> - <%=category.Name + " &gt; " + f.Name%></li>
<%
		}	
	}
%>
	</ul>
	<p class="action"><%=Html.ActionLink("Create a new forum >>", "Add", "Forums") %></p>
</asp:Content>

