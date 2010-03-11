<%@ Page Language="C#" Inherits="NearForums.Web.UI.BaseViewPage<Topic>" %><?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
	<channel>
		<title>Latest messages on &apos;<%=SecurityElement.Escape(this.Model.Title) %>&apos; topic</title>
		<link><%= this.Domain + Url.RouteUrl(new{action="Detail",controller="Topics",id=this.Model.Id,forum=this.Model.Forum.ShortName,name=this.Model.ShortName}) %></link>
		<description><%=SecurityElement.Escape(Utils.RemoveTags(this.Model.Description))%></description>
<%
		foreach (Message m in this.Model.Messages)
		{
%>
		<item>
			<title>#<%=m.Id %> by <%=m.User.UserName %></title>
			<link><%=this.Domain + Url.Action("ShortUrl", new{id=Model.Id}) %>#msg<%=m.Id %></link>
			<guid><%=this.Domain + Url.Action("ShortUrl", new{id=Model.Id})  %>#msg<%=m.Id %></guid>
			<description><%= SecurityElement.Escape(Utils.RemoveTags(m.Body))%></description>
			<pubDate><%=m.Date.ToApplicationDateTime().ToString("r", new System.Globalization.CultureInfo("en-US")) %></pubDate>
		</item>
<%
		}
%>
	</channel>
</rss>