<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	About
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<ul class="path floatContainer">
		<li class="first"><%=Html.ActionLink("Forums", "List", "Forums") %></li>
	</ul>
	<h1>About the forum</h1>
	<!-- Add your about text here -->
	<!-- Leave this paragraph -->
	<p>
		This forum is powered by <a href="http://www.nearforums.com">Nearforums</a>, an open source forum engine. Nearforums is released under <a href="http://nearforums.codeplex.com/license" target="_blank">MIT License</a>. 
		<br />
		Get the source at <a href="http://www.nearforums.com/source-code">www.nearforums.com/source-code</a>.
	</p>
	<!-- About page: Add whatever you want -->
</asp:Content>
