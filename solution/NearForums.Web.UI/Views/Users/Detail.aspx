<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<User>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%=Model.UserName %> profile
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
	</ul>
    <h1><%=Model.UserName %> profile</h1>
    <p><strong>Group</strong>: <%=Model.GroupName %></p>
    <p>
		<strong>Member for</strong>: <% Html.RenderPartial("SinceDate", Model.RegistrationDate); %>
	</p>
<%
	if (Model.ExternalProfileUrl != null)
	{
%>
    <p><strong><%=new Uri(Model.ExternalProfileUrl).Host.Replace("www.", "").FirstUpperCase() %> profile</strong>: <%=Html.Link(Model.ExternalProfileUrl, new{@target="_blank"})%></p>
<%
	}
	if (ViewData.Get<IList>("Topics").Count > 0)
	{
%>
		<h2>Threads posted by <%=Model.UserName%></h2>
		<ul>
<%
		foreach (Topic t in (IList)ViewData["Topics"])
		{
%>
			<li><%=Html.ActionLink(t.Title, "ShortUrl", "Topics", new{id=t.Id}, null) %></li>	
<%
		}
%>
		</ul>
<%
	}
%>
	<h2>Messages posted by <%=Model.UserName%></h2>
	<p class="messageButton"><a href="#" onclick="return getMessages()">Get all messages posted by <%=Model.UserName%></a></p>
	<p class="loading" style="display:none;font-style: italic;"><img src="/images/loadingMini.gif" alt="" style="" /> Loading...</p>
	<div id="messagesResult" style="display:none;"></div>
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
	<script type="text/javascript">
	function getMessages()
	{
		$("p.messageButton").hide();
		$("p.loading").fadeIn();
		$.ajax({
			url: '<%=Url.Action("MessagesByUser") %>',
			cache: true,
			success: function(html){
				if ($.trim(html) != "")
				{
					$("p.loading").hide();
					$("#messagesResult").append(html).slideDown();
				}
				else
				{
					$("p.loading").fadeOut(function(){
						$("p.loading").html("No messages found posted by this user.").fadeIn();
					});
				}
			}
		});
		return false;
	}
	</script>
</asp:Content>
