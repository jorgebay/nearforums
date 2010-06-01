<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl<Topic>" %>
<% if (this.Model.Related.Count > 0)
   { 
%>
	<h2>Related thread</h2>
	<ul class="related">
<%
		foreach (Topic t in this.Model.Related)
		{
%>
		<li class="<%=t.IsClosed ? "isClosed" : "" %>"><%=Html.ActionLink(t.Title, "Detail", "Topics", new{id=t.Id, name=t.ShortName, forum=t.Forum.ShortName}, null) %></li>
<%
		}
%>
	</ul>
<%
	}
%>