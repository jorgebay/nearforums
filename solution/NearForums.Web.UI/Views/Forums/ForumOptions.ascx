<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl<Forum>" %>
<div class="options">
	<%=Html.ActionLink("Most viewed topics", "Detail", new{page=0}, IsAction("Detail") ? new{@class="selected"} : null) %>
	<span>/</span>
	<%=Html.ActionLink("Latest topics", "LatestTopics", new{page=0,format=NearForums.Web.UI.ResultFormat.Html}, IsAction("LatestTopics") ? new{@class="selected"} : null) %>
	<span>/</span>
	<%=Html.ActionLink("Unanswered topics", "ListUnansweredTopics", null, IsAction("ListUnansweredTopics") ? new{@class="selected"} : null) %>
	<a rel="nofollow" href="<%=Url.Action("LatestTopics", new{page=0,format=NearForums.Web.UI.ResultFormat.Rss}) %>"><img src="/images/iconrss.gif" alt="rss" /></a>
</div>