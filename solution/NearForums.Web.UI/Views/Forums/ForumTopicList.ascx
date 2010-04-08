<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl<IList<Topic>>" %>
<ul class="items">
<%
	foreach (Topic topic in Model)
	{
%>
	<li>
		<%= Html.ActionLink(topic.Title, "Detail", "Topics", new{name=topic.ShortName,id=topic.Id,page=0}, null) %>
		<span class="details"><%= topic.Replies %> replies / <%= topic.Views%> views</span>
	</li>
<%
	}
%>
</ul>
