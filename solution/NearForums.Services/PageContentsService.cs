using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class PageContentsService : IPageContentsService
	{
		/// <summary>
		/// Page contents repository
		/// </summary>
		private readonly IPageContentsDataAccess _dataAccess;

		public PageContentsService(IPageContentsDataAccess da)
		{
			_dataAccess = da;
		}

		public List<PageContent> GetAll()
		{
			return _dataAccess.GetAll();
		}

		public PageContent Get(string name)
		{
			return _dataAccess.Get(name);
		}

		public void Add(PageContent content)
		{
			content.ValidateFields();
			SetAvailableShortName(content);
			_dataAccess.Add(content);
		}

		public void SetAvailableShortName(PageContent content)
		{
			content.ShortName = _dataAccess.GetAvailableShortName(content.ShortName);
		}

		public void Edit(PageContent content)
		{
			content.ValidateFields();
			_dataAccess.Edit(content);
		}

		public bool Delete(string name)
		{
			return _dataAccess.Delete(name);
		}
	}
}
