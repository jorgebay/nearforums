using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.ServiceClient
{
	public static class TemplatesServiceClient
	{
		public static List<Template> GetAll()
		{
			TemplatesDataAccess da = new TemplatesDataAccess();
			return da.GetAll();
		}

		public static Template Get(int templateId)
		{
			TemplatesDataAccess da = new TemplatesDataAccess();
			return da.Get(templateId);
		}

		public static void SetCurrent(int templateId)
		{
			TemplatesDataAccess da = new TemplatesDataAccess();
			da.SetCurrent(templateId);
		}

		/// <summary>
		/// Gets the current template
		/// </summary>
		/// <returns></returns>
		public static Template GetCurrent()
		{
			TemplatesDataAccess da = new TemplatesDataAccess();
			return da.GetCurrent();
		}

		/// <summary>
		/// Adds or updates a template in the db
		/// </summary>
		/// <param name="t"></param>
		public static void AddOrUpdate(Template t)
		{
			t.ValidateFields();
			TemplatesDataAccess da = new TemplatesDataAccess();
			da.AddOrUpdate(t);
		}

		public static void Delete(int templateId)
		{
			TemplatesDataAccess da = new TemplatesDataAccess();
			da.Delete(templateId);
		}
	}
}
