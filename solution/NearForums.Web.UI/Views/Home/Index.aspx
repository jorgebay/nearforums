<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Home
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Home</h1>
    <p>
        Welcome to homepage
    </p>
    <p class="highlight">Go to <%=Html.ActionLink("Forums list >>", "List", "Forums") %></p>
</asp:Content>
