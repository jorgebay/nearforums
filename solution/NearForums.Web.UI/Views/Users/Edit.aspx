<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<User>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit profile
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
	</ul>
    <h1>Edit profile</h1>
    <%=Html.ValidationSummary("<h3>Please check the following errors:</h3>", new Dictionary<string, object>
		{
			{"Email", "Email format is invalid."}
			,{"Website", "Website url format is invalid."}
			,{"Photo", "Photo url format is invalid."}
		}, null)%>
	<% Html.BeginForm(null, null, FormMethod.Post, new{@id="accountForm"}); %>
	<fieldset>
		<legend>Change your account info</legend>
		<div class="formItem floatContainer">
			<label for="title">Name</label>
			<%=Html.TextBox("userName", null, new{@class="text"}) %>
		</div>
		<div class="formItem floatContainer">
			<label for="birthDate">Birthdate</label>
			<%=Html.TextBox("birthDate", this.Model.BirthDate != null ? this.Model.BirthDate.Value.ToString("d") : null, new{@class="text"}) %>
		</div>
		<div class="formItem floatContainer" style="display: none;">
			<label for="timezone">Timezone</label>
			<%=Html.TextBox("timezone", null, new{@class="text"}) %>
		</div>
		<div class="formItem floatContainer">
			<label for="photo">Photo url</label>
			<%=Html.TextBox("photo", null, new{@class="text"}) %>
			<span class="note"><img src="<%=Model.Photo %>" alt="Profile image" /></span>
		</div>
		<div class="formItem floatContainer">
			<label for="website">Website</label>
			<%=Html.TextBox("website", null, new{@class="text"}) %>
		</div>
	</fieldset>
	<h2>Email</h2>
	<fieldset>
		<legend>Your email will not be shared with anyone. We will not make a different use than detailed below.</legend>
		<div class="formItem floatContainer">
			<label for="email">Email address</label>
			<%=Html.TextBox("email", null, new{@class="text"}) %>
		</div>
		<div class="formItem floatContainer">
			<div class="checkbox" style="padding-top:10px;">
				<%=Html.CheckBoxBit<EmailPolicy>("policy1", this.Model.EmailPolicy, EmailPolicy.SendFromSubscriptions)%>
				<label for="policy1">Use my email to notify me of replies to threads I subscribed to</label>
			</div>
			<div class="checkbox" style="padding-top:10px;">
				<%=Html.CheckBoxBit<EmailPolicy>("policy2", this.Model.EmailPolicy, EmailPolicy.SendNewsletter)%>
				<label for="policy3">Send me a newsletter</label>
			
			<%=Html.Hidden("emailPolicy") %>
		</div>		
		<div class="formItem buttons">
			<input type="submit" value="Send" />
		</div>
	</fieldset>
	<% Html.EndForm(); %>
	<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#accountForm").submit(function(){
				calculateEmailPolicy();
			});
		});
		
		function calculateEmailPolicy()
		{
			var value = 0;
			$("input:checked", $("#emailPolicy").parents("div.formItem")).each(function(){
				value += parseInt($(this).val(), 10);
			});
			$("#emailPolicy").val(value);
		}
	</script>
</asp:Content>