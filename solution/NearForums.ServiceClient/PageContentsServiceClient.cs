using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.ServiceClient
{
	public static class PageContentsServiceClient
	{
		/// <summary>
		/// Gets all page contents in a list, sorted by title
		/// </summary>
		/// <returns></returns>
		public static List<PageContent> GetAll()
		{
			PageContentsDataAccess da = new PageContentsDataAccess();
			return da.GetAll();
		}

		public static PageContent Get(string name)
		{
			var da = new PageContentsDataAccess();
			return da.Get(name);
		}

		public static void Add(PageContent content)
		{
			content.ValidateFields();
			SetAvailableShortName(content);
			var da = new PageContentsDataAccess();
			da.Add(content);
		}

		/// <summary>
		/// Gets the available shortname (based on the current one) and assigns it 
		/// </summary>
		public static void SetAvailableShortName(PageContent content)
		{
			var da = new PageContentsDataAccess();
			content.ShortName = da.GetAvailableShortName(content.ShortName);
		}

		public static void Edit(PageContent content)
		{
			content.ValidateFields();
			var da = new PageContentsDataAccess();
			da.Edit(content);
		}

		public static bool Delete(string name)
		{
			var da = new PageContentsDataAccess();
			return da.Delete(name);
		}
	}
}
