using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.DataAccess;

namespace NearForums.Services
{
	public class PageContentsService : IPageContentsService
	{
		private readonly IPageContentsDataAccess dataAccess;

		public PageContentsService(IPageContentsDataAccess da)
		{
			dataAccess = da;
		}

		public List<PageContent> GetAll()
		{
			return dataAccess.GetAll();
		}

		public PageContent Get(string name)
		{
			return dataAccess.Get(name);
		}

		public void Add(PageContent content)
		{
			content.ValidateFields();
			SetAvailableShortName(content);
			dataAccess.Add(content);
		}

		public void SetAvailableShortName(PageContent content)
		{
			content.ShortName = dataAccess.GetAvailableShortName(content.ShortName);
		}

		public void Edit(PageContent content)
		{
			content.ValidateFields();
			dataAccess.Edit(content);
		}

		public bool Delete(string name)
		{
			return dataAccess.Delete(name);
		}
	}
}
