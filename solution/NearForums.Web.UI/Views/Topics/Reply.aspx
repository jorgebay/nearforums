<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Message>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Reply
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	
	<ul class="path floatContainer">
		<li><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li>&gt; <%=Html.ActionLink(Model.Topic.Forum.Name, "Detail", "Forums", new{forum=Model.Topic.Forum.ShortName}, null) %></li>
		<li>&gt; <%=Html.ActionLink(Model.Topic.Title, "Detail", "Topics", new{id=Model.Topic.Id, name=Model.Topic.ShortName,forum=Model.Topic.Forum.ShortName}, null) %></li>
	</ul>
    <h1>Reply</h1>
    <%=Html.ValidationSummary("<h3>Please check the following errors:</h3>", new Dictionary<string, object>
		{
			{"Body", "Body must not be blank."}
			,{"Tag", new Dictionary<ValidationErrorType, string>()
				{ 
					{ValidationErrorType.DuplicateNotAllowed, "Company already exist."}
					,{ValidationErrorType.Format, ""},{ValidationErrorType.MinLength, ""},{ValidationErrorType.NullOrEmpty, ""}
				}
			}
		}, null)%>
	<% Html.BeginForm(); %>
	<div class="formItem textarea">
		<label for="body">Description</label>
		<%=Html.TextArea("body") %>
		<script type="text/javascript" src="/scripts/ckeditor/ckeditor.js"></script>
		<script type="text/javascript">
			//<![CDATA[
			CKEDITOR.replace("body", 
				{toolbar : 'Full'});
			//]]>
		</script>
	</div>
	<input type="submit" value="Send" />
	<% Html.EndForm(); %>
</asp:Content>