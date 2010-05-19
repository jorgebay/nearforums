<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl" %>
<script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php/<%=System.Threading.Thread.CurrentThread.CurrentUICulture %>" type="text/javascript"></script>
<script type="text/javascript">
	FB.init('<%= Config.Facebook.ApiKey %>', '<%=Url.Action("FacebookReceiver", "Home") %>');
</script>
<%
	if (this.User == null)
	{
%>
		<p><a onclick="FB.Connect.requireSession(function(){window.location.reload();});return false;" href="#"><img src="http://static.ak.fbcdn.net/images/fbconnect/login-buttons/connect_light_medium_short.gif" alt="Login using facebook" /></a></p>
<%
	}
	else
	{
%>
		<p>User: <%=User.UserName %> | <a href="#" onclick="FB.Connect.logoutAndRedirect('<%=Url.Action("Logout", "Home", new{returnUrl=Request.Url.PathAndQuery}) %>');return false;">Logout</a></p>
<%
	}
%>