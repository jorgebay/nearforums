<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Admin - Website status
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="HeadContent">
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
	<script type="text/javascript">
		function tm(id)
		{
			$("#m-" + id).slideToggle();
			return false;
		}
	</script>
	<style type="text/css">
		p.message
		{
			padding: 0 0 5px 5px;
			position: relative;
			top: -5px;
			font-size: 12px;
			color: #666666;
			display: none;
		}
	</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink("Admin", "Dashboard", "Admin") %></li>
	</ul>
    <h1>Website status</h1>
	
	<h2>Webserver</h2>
	<p><strong>Machine name</strong>: <%=ViewData["MachineName"] %></p>
	<p><strong>Webpages compilation debug</strong>: <%=ViewData["Debug"] %></p>
	<p><strong>Custom errors</strong>: <%=ViewData["CustomErrors"] %></p>
    <p><strong><a href="#" onclick="return tm('connectivity');">Connectivity test</a></strong>: <%=ViewData["Connectivity"]%></p>
    <p id="m-connectivity" class="message">
		The test is a http get request from the webserver to google.com
    </p>
    <p><strong>Proxy</strong>: <%=ViewData["Proxy"]%></p>
    <p><strong><a href="#" onclick="return tm('mail');">Mail client</a></strong>: <%=ViewData["Mail"]%></p>
    <p id="m-mail" class="message">
		Can be configured in the web.config file: system.net/mailSettings/smtp. Deliverymethod and From attributes.
    </p>
    
	<h2>Database</h2>
	<p><strong>Connection string</strong>: <%=ViewData["ConnectionString"] %></p>
	<p><strong>Provider</strong>: <%=ViewData["ConnectionStringProvider"] %></p>
	<p><strong>Test</strong>: <%=ViewData["DatabaseTest"] %></p>
	
	<h2>Logging</h2>
	<p><strong>Enabled</strong>: <%=ViewData["LoggingEnabled"] %></p>
    
    <h2>Nearforums</h2>
    <p><strong>Version</strong>: <%=ViewData["Version"] %></p>
    
    <h2>Notifications</h2>
    <p><strong>Subscriptions enabled</strong>: <%=ViewData["Subscriptions"]%></p>
    
    <h2>Authorization providers</h2>
    <p><strong>Facebook - configured</strong>: <%=ViewData["Facebook"]%></p>
    <p><strong>Twitter - configured</strong>: <%=ViewData["Twitter"]%></p>
    <p><strong>SSO through open id - enabled</strong>: <%=ViewData["SSOOpenId"]%></p>
	
</asp:Content>