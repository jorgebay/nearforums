using System.Web.Mvc;
using System.Web.Routing;
using NearForums.Web.Extensions;
using System.Web;
using NearForums.Services;

namespace NearForums.Web.Output
{
	// Note: For instructions on enabling IIS6 or IIS7 classic mode, 
	// visit http://go.microsoft.com/?LinkId=9394801
	public class MvcApplication : System.Web.HttpApplication
	{
		public static void RegisterGlobalFilters(GlobalFilterCollection filters)
		{
			filters.Add(new HandleErrorAttribute());
		}

		protected void Application_Start()
		{
			DependenciesHelper.Register(new HttpContextWrapper(Context));

			AreaRegistration.RegisterAllAreas();

			RegisterGlobalFilters(GlobalFilters.Filters);
			RoutingHelper.RegisterRoutes(RouteTable.Routes);
		}

		protected void Application_End()
		{
			//Should close the index
			//If this method is not executed, the search engine will still work.
			SearchService.CloseIndex();
		}
	}
}