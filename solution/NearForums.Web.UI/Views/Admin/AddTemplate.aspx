<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Add Template
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Add Template</h1>
	<% Html.BeginForm(null, null, FormMethod.Post, new{enctype="multipart/form-data"}); %>
	<div>
		<label for="txtKey">Key</label><input type="text" name="key" id="txtKey" value="demo1" />
	</div>
	<div>
		<label for="txtPostedFile">File</label><input type="file" name="postedFile" id="txtPostedFile" />
	</div>
	<div>
		<input type="submit" value="Submit" />
	</div>
	<% Html.EndForm(); %>
</asp:Content>