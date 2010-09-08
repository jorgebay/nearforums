<%@ Control Language="C#" Inherits="NearForums.Web.UI.BaseViewUserControl" %>
<%
	var period = DateTime.UtcNow.Subtract((DateTime)Model);
	var periodDate = new DateTime(period.Ticks);
	var years = periodDate.Year - 1;
	var months = periodDate.Month-1;
	var days = periodDate.Day - 1;
	StringBuilder text = new StringBuilder();

	if (years > 0)
	{
		text.Append(years);
		text.Append(" year" + (years > 1 ? "s" : ""));
	}
	if (months > 0)
	{
		text.Append(" ");
		text.Append(months);
		text.Append(" month" + (months > 1 ? "s" : ""));
	}
	if (days > 0)
	{
		text.Append(" ");
		text.Append(days);
		text.Append(" day" + (days > 1 ? "s" : ""));
	}
	if (text.Length == 0)
	{
		text.Append("Less than a day");
	}
	Response.Write(text);
%>
