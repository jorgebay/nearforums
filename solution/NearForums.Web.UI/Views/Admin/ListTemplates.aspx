<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<List<Template>>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Templates
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Admin", "Dashboard", "Admin") %></li>
	</ul>
    <h1>Templates</h1>
	<p class="error">
		<%=ViewData.WriteIf("DeleteCurrent", "You cannot delete the current template.", "") %>
		<%=ViewData.WriteIf("Access", "The application does not have the necessary file read/write access.", "") %>
	</p> 
    <table cellpadding="0" cellspacing="0">
		<thead>
			<tr>
				<th>Action</th>
				<th>Key</th>
				<th>Description</th>
				<th>Current?</th>
			</tr>
		</thead>
		<tbody>
		
<%
	foreach (Template t in this.Model)
	{
%>
		<tr>
			<td><%=Html.ActionLink("Set", "TemplateSetCurrent", new{id=t.Id}) %>, <%=Html.ActionLink("Delete", "DeleteTemplate", new{id=t.Id}, new{onclick="return confirm('Are you sure you want to DELETE this template?\\nThis action is not reversible.');"}) %></td>
			<td><%=t.Key %></td>
			<td><%=t.Description %></td>
			<td><%=t.IsCurrent ? "Current" : "" %></td>
		</tr>
<%
	}
%>
		</tbody>
	</table>
	<p class=""><%=Html.ActionLink("Upload a new template", "AddTemplate") %></p>
	<p style="padding-top: 50px;">
		In order to enable templating in the site you must configure the template element on your Site.config file.
		<br />
		For example: 
	</p>
	<code>
		&lt;template path="/content/templates/" master="Templated" /&gt;
	</code>
	<p style="font-family: Courier;"></p>
</asp:Content>