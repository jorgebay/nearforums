<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	An error occurred while processing your request.
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
	</ul>
    <h1>An error occurred</h1>
	<br />
	<p>An error occurred on the server when processing the URL.</p>
	<p>The error detail was sent to our support team. </p>
	<p>Sorry for the inconvenience.</p>
	<br />
	<p>Go to the <a href="/">homepage</a></p>

</asp:Content>