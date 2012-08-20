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
		private readonly ITemplatesDataAccess _dataAccess;

		public TemplatesService(ITemplatesDataAccess da)
		{
			_dataAccess = da;
		}

		public  List<Template> GetAll()
		{
			return _dataAccess.GetAll();
		}

		public  Template Get(int templateId)
		{
			return _dataAccess.Get(templateId);
		}

		public  void SetCurrent(int templateId)
		{
			_dataAccess.SetCurrent(templateId);
		}

		public  Template GetCurrent()
		{
			return _dataAccess.GetCurrent();
		}

		public  void AddOrUpdate(Template t)
		{
			t.ValidateFields();
			_dataAccess.AddOrUpdate(t);
		}

		public  void Delete(int templateId)
		{
			_dataAccess.Delete(templateId);
		}
	}
}
