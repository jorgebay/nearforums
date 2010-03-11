<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= ViewData.WriteIf("IsEdit", "Edit forum", "Create a forum") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1><%= ViewData.WriteIf("IsEdit", "Edit forum", "Create a forum") %></h1>
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
		<div class="formItem">
			<label for="title">Name</label>
			<%=Html.TextBox("name", null, new{@class="text"}) %>
		</div>
		<div class="formItem textarea">
			<label for="description">Message</label>
			<%=Html.TextArea("description") %>
		</div>
	</fieldset>
	<input type="submit" value="Send" />
	<% Html.EndForm(); %>
</asp:Content>
