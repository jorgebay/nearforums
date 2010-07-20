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
<%
			if (Config.AuthorizationProviders.Facebook.IsDefined)
			{
%>
				<h2>Sign in with your Facebook account</h2>
				<p class="button"><a onclick="FB.Connect.requireSession(function(){window.location.reload();});return false;" href="#"><img src="http://static.ak.fbcdn.net/images/fbconnect/login-buttons/connect_light_large_long.gif" alt="Login using facebook" /></a></p>
				<div class="connectMessage">
					<p>You should be entering the same email address and password that you would use to log into Facebook homepage. Twitter will not share your password with us.</p>
					<p>If you have any doubt, visit the <a href="http://www.facebook.com/help/?page=730" target="_blank">Facebook Connect Help Center</a>.</p>
				</div>
<%
			}
			if (Config.AuthorizationProviders.Twitter.IsDefined)
			{
%>
				<h2>Sign in with your Twitter account</h2>
				<p class="button"><a href="<%=Url.Action("TwitterStartLogin", "Home", new{returnUrl=this.Request.Url.PathAndQuery}) %>"><img src="http://a0.twimg.com/images/dev/buttons/sign-in-with-twitter-l.png" alt="Login using twitter" /></a></p>
				<div class="connectMessage">
					<p>You should be entering your twitter username and password at twitter.com website to login at the forums. Twitter will not share your password with us.</p>
					<p>If you have any doubt, visit the <a href="http://support.twitter.com/groups/31-twitter-basics/topics/113-online-safety/articles/76052-how-to-connect-to-third-party-applications" target="_blank">Twitter Help Center</a>.</p>
				</div>

<%
			}
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
