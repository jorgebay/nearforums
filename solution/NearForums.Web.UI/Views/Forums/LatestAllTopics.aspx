<%@ Page Language="C#" Inherits="NearForums.Web.UI.BaseViewPage<List<Topic>>" %><?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
	<channel>
		<title>Latest topics on all forums</title>
		<link><%= this.Domain %></link>
		<description>Latest topics on all forums at <%= this.Domain %></description>
<%
		foreach (Topic t in this.Model)
		{
%>
		<item>
			<title><%= SecurityElement.Escape(t.Title) %></title>
			<link><%=this.Domain + Url.Action("ShortUrl", "Topics", new{id=t.Id}) %></link>
			<guid><%=this.Domain + Url.Action("ShortUrl", "Topics", new{id=t.Id})  %></guid>
			<description><%= SecurityElement.Escape(Utils.RemoveTags(t.Description))%></description>
			<pubDate><%=t.Date.ToApplicationDateTime().ToString("r", new System.Globalization.CultureInfo("en-US")) %></pubDate>
		</item>
<%
		}
%>
	</channel>
</rss>