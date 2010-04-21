<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl" %>
<%
	string toolbar = this.User.Group >= UserGroup.Moderator ? "Full" : "Basic";
%>
<script type="text/javascript" src="/scripts/ckeditor/ckeditor.js"></script>
<script type="text/javascript">
	//<![CDATA[
	CKEDITOR.replace('<%=ViewData["Name"] %>', 
		{toolbar : '<%=toolbar %>'});
	//]]>
</script>