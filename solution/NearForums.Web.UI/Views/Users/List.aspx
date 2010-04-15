<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<List<User>>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Manage users
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="HeadContent">
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Admin", "Dashboard", "Admin") %></li>
	</ul>
    <h1>Manage users</h1>
    <% Html.BeginForm(null, null, FormMethod.Get); %>
    <div class="formItem floatContainer">
		<label for="userName">User name</label>
		<%=Html.TextBox("userName") %>
    </div>
    <div class="formItem buttons floatContainer">
		<input type="submit" value="Search" />
    </div>
    <% Html.EndForm(); %>
<%
	if (Model.Count > 0)
	{
%>    
    <table cellpadding="0" cellspacing="0">
		<thead>
			<tr>
				<th>Name</th>
				<th>Group</th>
				<th>Registration date</th>
				<th>Action</th>
			</tr>
		</thead>
		<tbody>
<%
		PagedList<User> list = new PagedList<User>(this.Model, this.PageIndex, 100);
		foreach (User u in list)
		{
%>
			<tr>
				<td><strong><%=u.UserName %></strong></td>
				<td><%=u.GroupName %></td>
				<td><%=Html.Date(u.RegistrationDate) %></td>
				<td>
					<%=Html.ActionLink("Promote", "Promote", new{id=u.Id,searched=ViewData.Get<string>("userName")}, new{onclick="return confirm('Are you sure you want to PROMOTE the user ' + $('td:first', $(this).parents('tr')).text() + '?');"}) %>,
					<%=Html.ActionLink("Demote", "Demote", new{id=u.Id,searched=ViewData.Get<string>("userName")}, new{onclick="return confirm('Are you sure you want to DEMOTE the user ' + $('td:first', $(this).parents('tr')).text() + '?');"}) %>,
					<%=Html.ActionLink("Delete", "Delete", new{id=u.Id,searched=ViewData.Get<string>("userName")}, new{onclick="return confirm('Are you sure you want to DELETE the user ' + $('td:first', $(this).parents('tr')).text() + '?');"}) %>
				</td>
			</tr>			
<%
		}
%>
		</tbody>
	</table>
	<%= Html.Pager(list.PageSize, list.PageIndex, list.TotalItemCount, new{userName = ViewData.Get<string>("userName")}, "Previous", "Next")%>
<%
	}
	else
	{
%>
		<p class="warning">No user found for the username &quot;<%=ViewData["userName"] %>&quot;.</p>
<%		
	}
%>	
</asp:Content>