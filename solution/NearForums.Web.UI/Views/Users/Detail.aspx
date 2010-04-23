<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<User>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%=Model.UserName %> profile
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1><%=Model.UserName %> profile</h1>
    <p><strong>Group</strong>: <%=Model.GroupName %></p>
    <p><strong>Member since</strong>: <%=Html.Date(Model.RegistrationDate, "d") %></p>
<%
	if (Model.ExternalProfileUrl != null)
	{
%>
    <p><strong><%=new Uri(Model.ExternalProfileUrl).Host.Replace("www.", "").FirstUpperCase() %> profile</strong>: <%=Html.Link(Model.ExternalProfileUrl, new{@target="_blank"})%></p>
<%
	}
%>
</asp:Content>
