<%@ Page Title="" Language="C#" Inherits="NearForums.Web.UI.BaseViewPage`1[[System.Collections.IList, mscorlib]]" AllowMaster="false" %>
<% 
	if (Model.Count > 0)
	{
		foreach (Message m in Model)
		{
			Html.RenderPartial("MessageItem", m);
		}
	}
%>