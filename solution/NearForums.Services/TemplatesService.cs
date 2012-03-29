using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class TemplatesService : ITemplatesService
	{
		/// <summary>
		/// template repository
		/// </summary>
		private readonly ITemplatesDataAccess dataAccess;

		public TemplatesService(ITemplatesDataAccess da)
		{
			dataAccess = da;
		}

		public  List<Template> GetAll()
		{
			return dataAccess.GetAll();
		}

		public  Template Get(int templateId)
		{
			return dataAccess.Get(templateId);
		}

		public  void SetCurrent(int templateId)
		{
			dataAccess.SetCurrent(templateId);
		}

		public  Template GetCurrent()
		{
			return dataAccess.GetCurrent();
		}

		public  void AddOrUpdate(Template t)
		{
			t.ValidateFields();
			dataAccess.AddOrUpdate(t);
		}

		public  void Delete(int templateId)
		{
			dataAccess.Delete(templateId);
		}
	}
}
