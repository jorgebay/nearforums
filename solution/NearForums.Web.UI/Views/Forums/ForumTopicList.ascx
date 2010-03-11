<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl<Forum>" %>
<ul class="items">
<%
	foreach (Topic topic in Model.Topics)
	{
%>
	<li>
		<%= Html.ActionLink(topic.Title, "Detail", "Topics", new{name=topic.ShortName,id=topic.Id,forum=Model.ShortName,page=0}, null) %>
		<span class="details"><%= topic.Replies %> replies / <%= topic.Views%> views</span>
	</li>
<%
	}
%>
</ul>
