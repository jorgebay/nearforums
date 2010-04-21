<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Forbidden
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Forbidden</h1>
    <p>The page you requested is forbidden.</p>
    <p>Go to <a href="/">Homepage&gt;&gt;</a></p>
</asp:Content>