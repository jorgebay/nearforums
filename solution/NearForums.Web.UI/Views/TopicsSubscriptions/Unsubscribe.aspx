<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Topic>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Unsubscribe
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
	</ul>
	<h1>Unsubscribed from the thread</h1>
	<p>You have been unsubscribed from the thread <%= Html.ActionLink(Model.Title, "ShortUrl", "Topics", new{id=Model.Id}, null)%>.</p>
	<p style="padding-top: 50px;"><a href="/">Continue &gt;&gt;</a></p>
	<%= ViewData["User"] != null ? "<!-- removed -->" : ""  %>
</asp:Content>
