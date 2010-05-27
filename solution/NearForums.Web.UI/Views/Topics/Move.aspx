<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="NearForums.Web.UI.BaseViewPage<Topic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Move thread &quot;<%=Model.Title %>&quot;
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
		<li><%=Html.ActionLink(Model.Forum.Name, "Detail", "Forums", new{forum=Model.Forum.ShortName}, null) %></li>
	</ul>
	<h1>Move thread &quot;<%=Model.Title %>&quot; to another forum</h1>
	<% Html.BeginForm(); %>
	<fieldset>
		<legend>Select the destination forum</legend>
		<div class="formItem floatContainer">
			<label for="forum_id">Forum</label>
			<select name="forum.id" id="forum_id">
<%
			int selectedValue = this.Html.GetStateValue<int>("forum.id");
			foreach (ForumCategory category in ViewData.Get<List<ForumCategory>>("Categories"))
			{
%>
				<optgroup label="<%=category.Name %>">
<%
					foreach (Forum forum in category.Forums)
					{
						if (selectedValue != forum.Id)
						{
%>
						<option value="<%=forum.Id %>"><%=forum.Name%></option>
<%
						}
						else
						{
%>
						<option value="<%=forum.Id %>" selected="selected"><%=forum.Name%></option>
<%
						}
					}
%>
				</optgroup>
<%
			}
%>
			</select>
		</div>
		<div class="formItem buttons">
			<input type="submit" value="Send" />
		</div>
	</fieldset>
	<% Html.EndForm(); %>
</asp:Content>