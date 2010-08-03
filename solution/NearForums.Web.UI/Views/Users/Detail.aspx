<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<User>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%=Model.UserName %> profile
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
	</ul>
    <h1><%=Model.UserName %> profile</h1>
    <p><strong>Group</strong>: <%=Model.GroupName %></p>
    <p>
		<strong>Member for</strong>: <% Html.RenderPartial("SinceDate", Model.RegistrationDate); %>
	</p>
<%
	if (Model.ExternalProfileUrl != null)
	{
%>
    <p><strong><%=new Uri(Model.ExternalProfileUrl).Host.Replace("www.", "").FirstUpperCase() %> profile</strong>: <%=Html.Link(Model.ExternalProfileUrl, new{@target="_blank"})%></p>
<%
	}
%>
	<h2>Threads posted by <%=Model.UserName %></h2>
	<h2>Messages posted by <%=Model.UserName %></h2>
	
</asp:Content>
