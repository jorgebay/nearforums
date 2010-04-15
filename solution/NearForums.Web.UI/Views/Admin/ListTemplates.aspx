<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<List<Template>>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Templates
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Admin", "Dashboard", "Admin") %></li>
	</ul>
    <h1>Templates</h1>
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
			<td><%=Html.ActionLink("Set", "TemplateSetCurrent", new{id=t.Id}) %></td>
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
</asp:Content>