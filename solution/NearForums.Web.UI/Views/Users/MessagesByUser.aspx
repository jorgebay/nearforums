<%@ Page Title="" Language="C#" Inherits="NearForums.Web.UI.BaseViewPage`1[[System.Collections.IList, mscorlib]]" AllowMaster="false" %>
<% 
	if (Model.Count > 0)
	{
%>
		<ul>
<%
		foreach (Topic t in Model)
		{
%>
			<li>
				<%=t.Title %>:
<%
				foreach (Message m in t.Messages)
				{
%>
					<%=Html.ActionLink("#" + m.Id, "ShortUrl", "Topics", null, null, "msg" + m.Id, new{id=t.Id}, null) %>
<%
				}
%>
			</li>
<%
		}
%>
		</ul>
<%
	}
%>