<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Forum>" %>
<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= ViewData.WriteIf("IsEdit", "Edit forum", "Create a forum") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink("Admin", "Dashboard", "Admin") %></li>
		<li><%=Html.ActionLink("Manage forums", "Manage", "Forums") %></li>
	</ul>
    <h1><%= ViewData.WriteIf("IsEdit", "Edit forum", "Create a forum") %></h1>
    <%=Html.ValidationSummary("<h3>Please check the following errors:</h3>", new Dictionary<string, object>
		{
			{"Description", "Description must not be blank."}
			,{"Name", "Forum name must not be blank."}
			,{"ShortName", ""}
			,{"Category.Id", "Category must not be blank."}
		}, null)%>
	<% Html.BeginForm(null, null, this.Model == null ? null : new{forum=this.Model.ShortName}, FormMethod.Post, new{@id="forumEditForm"}); %>
	<fieldset>
		<legend>Fill in the fields and submit</legend>
		<div class="formItem floatContainer">
			<label for="name">Name</label>
			<%=Html.TextBox("name", null, new{@class="text"}) %>
		</div>
		<div class="formItem floatContainer">
			<label for="category_id">Category</label>
			<%=Html.DropDownListDefault("category.id", ViewData.Get<SelectList>("Categories"), "", "-Select a Category-") %>
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
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
	<script type="text/javascript">
		var submitted = false;
		$(document).ready(function(){
			//prevent multiple posts
			$("form#forumEditForm").submit(function(){
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
