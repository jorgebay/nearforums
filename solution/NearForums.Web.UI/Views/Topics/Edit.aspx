<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Topic>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= ViewData.WriteIf("IsEdit", "Edit topic", "Post new topic") %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink(Model.Forum.Name, "Detail", "Forums", new{forum=Model.Forum.ShortName}, null) %></li>
	</ul>
    <h1><%= ViewData.WriteIf("IsEdit", "Edit topic", "Post new topic") %></h1>
    <%=Html.ValidationSummary("<h3>Please check the following errors:</h3>", new Dictionary<string, object>
		{
			{"Description", "Topic message must not be blank."}
			,{"Tags", "Tags must not be blank, separated by a space and must not contain special characters."}
			,{"Title", "Subject must not be blank."}
			,{"ShortName", ""}
		}, null)%>
	<% Html.BeginForm(); %>
	<fieldset>
		<legend>Fill in the fields and submit</legend>
		<div class="formItem floatContainer">
			<label for="title">Subject</label>
			<%=Html.TextBox("title", null, new{@class="text"}) %>
		</div>
		<div class="formItem floatContainer">
			<label for="tags">Tags</label>
			<%=Html.TextBox("tags", null, new{@class="text"}) %>
		</div>
		<div class="formItem textarea floatContainer">
			<label for="description">Message</label>
			<%=Html.TextArea("description") %>
			<% Html.RenderPartial("EditorScripts", CreateViewData(new{Name="description"})); %>
		</div>
		<div class="formItem checkbox">
			<label for="isSticky">Sticky topic?</label>
			<%=Html.CheckBox("isSticky") %>
		</div>
		<div class="formItem buttons">
			<input type="submit" value="Send" />
		</div>
	</fieldset>
	<% Html.EndForm(); %>
</asp:Content>