<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl" %>
<script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php/<%=System.Threading.Thread.CurrentThread.CurrentUICulture %>" type="text/javascript"></script>
<script type="text/javascript">
	FB.init("<%= Config.Facebook.ApiKey %>", "<%=Url.Action("Static", "Base", new{key="FacebookXDReceiver"}) %>");
</script>
<p><a onclick="FB.Connect.requireSession(function(){window.location.reload();});return false;" href="#">Connect</a></p>