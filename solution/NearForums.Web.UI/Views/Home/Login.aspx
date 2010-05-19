<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Sign in
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
	</ul>
	<div id="login">
<%
		if (this.User == null)
		{
%>
		<h1>Sign in</h1>
		<p>Sign in with your Facebook Account by clicking the button below.</p>
		<p class="button"><a onclick="FB.Connect.requireSession(function(){window.location.reload();});return false;" href="#"><img src="http://static.ak.fbcdn.net/images/fbconnect/login-buttons/connect_light_large_long.gif" alt="Login using facebook" /></a></p>
		<div class="connectMessage">
			<p>You should be entering the same email address and password that you would use to log into Facebook homepage.</p>
			<p>If you have any doubt, you can visit the <a href="http://www.facebook.com/help/?page=730" target="_blank">Facebook Connect Help Center</a>.</p>
		</div>
<%
		}
		else
		{
%>
		<h1>Access denied</h1>
		<p>You must be a user of the group <strong><%=ViewData["UserGroupName"]%></strong> to perform this action.</p>
<%		
		}
%>
	</div>
</asp:Content>
