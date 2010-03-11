<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Topic>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	<%= ViewData.WriteIf("IsEdit", "Edit topic", "Post new topic") %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li>&gt; <%=Html.ActionLink(Model.Forum.Name, "Detail", "Forums", new{forum=Model.Forum.ShortName}, null) %></li>
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
		<div class="formItem">
			<label for="title">Subject</label>
			<%=Html.TextBox("title", null, new{@class="text"}) %>
		</div>
		<div class="formItem">
			<label for="title">Tags</label>
			<%=Html.TextBox("tags", null, new{@class="text"}) %>
		</div>
		<div class="formItem textarea">
			<label for="description">Message</label>
			<%=Html.TextArea("description") %>
			<script type="text/javascript" src="/scripts/ckeditor/ckeditor.js"></script>
			<script type="text/javascript">
				//<![CDATA[
				CKEDITOR.replace("description", 
					{toolbar : 'Full'});
				//]]>
			</script>
		</div>
	</fieldset>
	<input type="submit" value="Send" />
	<% Html.EndForm(); %>
</asp:Content>