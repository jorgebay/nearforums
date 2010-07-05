<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Topic>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= ViewData.WriteIf("IsEdit", "Edit thread", "Post new thread") %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink(Model.Forum.Name, "Detail", "Forums", new{forum=Model.Forum.ShortName}, null) %></li>
	</ul>
    <h1><%= ViewData.WriteIf("IsEdit", "Edit thread", "Post new thread") %></h1>
    <%=Html.ValidationSummary("<h3>Please check the following errors:</h3>", new Dictionary<string, object>
		{
			{"Description", "Thread message must not be blank."}
			,{"Tags", "Tags must not be blank, separated by spaces and must not contain special characters."}
			,{"Title", "Subject must not be blank."}
			,{"ShortName", ""}
		}, null)%>
	<% Html.BeginForm(null, null, null, FormMethod.Post, new{@id="topicEditForm"}); %>
	<fieldset>
		<legend>Fill in the fields and submit</legend>
		<div class="formItem floatContainer">
			<label for="title">Subject</label>
			<%=Html.TextBox("title", null, new{@class="text"}) %>
		</div>
		<div class="formItem floatContainer">
			<label for="tags">Tags </label>
			<%=Html.TextBox("tags", null, new{@class="text"}) %>
			<span class="note">Separated by spaces</span>
		</div>
		<div class="formItem textarea floatContainer">
			<label for="description">Message</label>
			<%=Html.TextArea("description") %>
			<% Html.RenderPartial("EditorScripts", CreateViewData(new{Name="description"})); %>
		</div>
<%		
		if (this.User.Group >= UserGroup.Moderator)
		{
%>
		<div class="formItem checkbox">
			<label for="isSticky">Sticky thread?</label>
			<%=Html.CheckBox("isSticky") %>
		</div>
<%
		}
%>
		<div class="formItem buttons">
			<input type="submit" value="Send" />
		</div>
	</fieldset>
	<% Html.EndForm(); %>
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
	<script type="text/javascript">
		var submitted = false;
		$(document).ready(function(){
			//prevent multiple posts
			$("form#topicEditForm").submit(function(){
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
	</script>
</asp:Content>