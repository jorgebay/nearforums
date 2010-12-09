<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<List<ForumCategory>>" %>
<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Manage forums
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink("Admin", "Dashboard", "Admin") %></li>
	</ul>
    <h1>Manage forums</h1>
    <% Html.BeginForm(null, null, FormMethod.Post, new{@id="manageForm"}); %>
    <%=Html.AntiForgeryToken() %>
    <input type="hidden" name="forum" id="shortName" value="" />
    <ul>
<%
	foreach (ForumCategory category in this.Model)
	{
		foreach (Forum f in category.Forums)
		{
%>
			<li>
				<%=Html.ActionLink("Edit", "Edit", "Forums", new{forum=f.ShortName}, null) %>,
				<a href="#" onclick="return deleteForum('<%= f.ShortName %>');">Delete</a>,
				<%=Html.ActionLink("View", "Detail", "Forums", new{forum=f.ShortName}, null) %>
				- 
				<%=category.Name + " &gt; " + f.Name%></li>
<%
		}	
	}
%>
	</ul>
	<% Html.EndForm(); %>
	<p class="action"><%=Html.ActionLink("Create a new forum >>", "Add", "Forums") %></p>
	
	<script type="text/javascript">
		function deleteForum(name)
		{
			if (confirm("Are you sure you want to delete this forum?.\nAll threads and posts of this forum will not be accessible."))
			{
				$("#shortName").val(name);
				$('#manageForm').attr('action', '<%= Url.Action("Delete", "Forums")%>').submit();
			}
			return false;
		}
	</script>
</asp:Content>