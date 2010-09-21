<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Message>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Reply
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
	<script type="text/javascript">
		var submitted = false;
		$(document).ready(function(){
			//prevent multiple posts
			$("form#topicReplyForm").submit(function(){
				if (!submitted)
				{
					submitted = true;
					return true;
				}
				else
				{
					return false;
				}
			});
		});
		function toggleEmail()
		{
			if ($("#notify").is(":checked"))
			{
				$('#email').show().focus();
			}
			else
			{
				$('#email').hide();
			}
		}
		$(document).ready(toggleEmail);
	</script>
	
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink(Model.Topic.Forum.Name, "Detail", "Forums", new{forum=Model.Topic.Forum.ShortName}, null) %></li>
		<li><%=Html.ActionLink(Model.Topic.Title, "Detail", "Topics", new{id=Model.Topic.Id, name=Model.Topic.ShortName,forum=Model.Topic.Forum.ShortName}, null) %></li>
	</ul>
    <h1>Reply</h1>
    <%=Html.ValidationSummary("<h3>Please check the following errors:</h3>", new Dictionary<string, object>
		{
			{"Body", "Body must not be blank."}
			,{"email", new Dictionary<ValidationErrorType, string>(){
				{ValidationErrorType.NullOrEmpty, "Email must not be blank in order to notify of new posts."}
				,{ValidationErrorType.Format, "Email format is not valid."}}}
		}, null)%>
	<% Html.BeginForm(null, null, this.Model.InReplyOf == null ? null : new{msg=this.Model.InReplyOf.Id}, FormMethod.Post, new{@id="topicReplyForm"}); %>
	<div class="formItem textarea">
		<label for="body">Description</label>
		<%=Html.TextArea("body") %>
		<% Html.RenderPartial("EditorScripts", CreateViewData(new{Name="body"})); %>
	</div>
<%
	if (this.Config.Notifications.Subscription.IsDefined)
	{
%>
	<div class="formItem floatContainer">
		<div class="checkbox">
			<%= Html.CheckBox("notify", new{onclick = "toggleEmail();"})%>
			<label for="notify">Notify me of new posts on this thread via email</label>
			<%= this.User.Email == null ? Html.TextBox("email", null, new{@class="notifyEmail", @style="display:none;"}) : "" %>
		</div>
	</div>
<%
	}
	else
	{
%>
		<%=Html.Hidden("notify", false) %>
<%	
	}
%>
	<div class="formItem buttons">
		<div class="checkbox">
		<input type="submit" value="Send" />
	</div>
	<% Html.EndForm(); %>
<%
	if (this.Model.InReplyOf != null)
	{
%>	
	<script type="text/javascript">
		$(document).ready(function(){
			if ($.trim($('#body').val()) == "")
			{
				$('#body').val('<p>#<%= this.Model.InReplyOf.Id %>:&nbsp;</p>');
			}
		});
	</script>
<%
	}
%>
</asp:Content>