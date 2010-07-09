<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl" %>
<script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php/<%=System.Threading.Thread.CurrentThread.CurrentUICulture %>" type="text/javascript"></script>
<script type="text/javascript">
	FB.init('<%= Config.AuthorizationProviders.Facebook.ApiKey %>', '<%=Url.Action("FacebookReceiver", "Home") %>');
</script>
<ul id="userMenu">
	<li class="toContent"><a href="#content" accesskey="1">Go to content</a></li>
<%
	if (this.User == null)
	{
%>
		<li class="login"><a onclick="FB.Connect.requireSession(function(){window.location.reload();});return false;" href="#"><img src="http://static.ak.fbcdn.net/images/fbconnect/login-buttons/connect_light_medium_short.gif" alt="Login using facebook" /></a></li>
<%
	}
	else
	{
%>
		<li class="logged"><%=Html.Link("Profile", User.ExternalProfileUrl, new{target="_blank"}) %></li>
		<li class="logout"><a href="#" onclick="FB.Connect.logoutAndRedirect('<%=Url.Action("Logout", "Home", new{returnUrl=Request.Url.PathAndQuery}) %>');return false;">Logout</a></li>
<%
	}
%>
</ul>