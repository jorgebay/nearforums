using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.DataAccess
{
	public interface IPageContentsDataAccess
	{
		void Add(PageContent content);
		bool Delete(string name);
		void Edit(PageContent content);
		PageContent Get(string name);
		List<PageContent> GetAll();
		string GetAvailableShortName(string shortName);
	}
}
