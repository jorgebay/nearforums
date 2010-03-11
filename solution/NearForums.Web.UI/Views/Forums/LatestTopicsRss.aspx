<%@ Page Language="C#" Inherits="NearForums.Web.UI.BaseViewPage<Forum>" %><?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
	<channel>
		<title>Latest topics on &apos;<%=this.Model.Name %>&apos; forum</title>
		<link><%= this.Domain + Url.Action("Detail", new{forum=Model.ShortName}) %></link>
		<description>Forum description: <%=SecurityElement.Escape(Utils.RemoveTags(this.Model.Description))%></description>
<%
		foreach (Topic t in this.Model.Topics)
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