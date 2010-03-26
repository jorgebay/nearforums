<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Forum>" %>
<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= ViewData.WriteIf("IsEdit", "Edit forum", "Create a forum") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1><%= ViewData.WriteIf("IsEdit", "Edit forum", "Create a forum") %></h1>
    <%=Html.ValidationSummary("<h3>Please check the following errors:</h3>", new Dictionary<string, object>
		{
			{"Description", "Description must not be blank."}
			,{"Name", "Subject must not be blank."}
			,{"ShortName", ""}
			,{"Category.Id", "Category must not be blank."}
		}, null)%>
	<% Html.BeginForm(); %>
	<fieldset>
		<legend>Fill in the fields and submit</legend>
		<div class="formItem floatContainer">
			<label for="name">Name</label>
			<%=Html.TextBox("name", null, new{@class="text"}) %>
		</div>
		<div class="formItem floatContainer">
			<label for="category_id">Category</label>
			<%=Html.DropDownListDefault("category.id", ViewData.Get<SelectList>("Categories"), "", "Select a Category") %>
		</div>
		<div class="formItem textarea">
			<label for="description">Message</label>
			<%=Html.TextArea("description") %>
		</div>
		<div class="formItem buttons">
			<input type="submit" value="Send" />
		</div>
	</fieldset>
	<% Html.EndForm(); %>
</asp:Content>
