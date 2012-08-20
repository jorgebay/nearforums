using System;
using System.Collections.Generic;

namespace NearForums.Services
{
	public interface IPageContentsService
	{
		/// <summary>
		/// Adds a new page content
		/// </summary>
		/// <param name="content"></param>
		void Add(PageContent content);
		bool Delete(string name);
		void Edit(PageContent content);
		/// <summary>
		/// Gets a page content by its key / name
		/// </summary>
		/// <param name="name"></param>
		/// <returns></returns>
		PageContent Get(string name);

		/// <summary>
		/// Gets all page contents in a list, sorted by title
		/// </summary>
		/// <returns></returns>
		List<PageContent> GetAll();

		/// <summary>
		/// Gets the available shortname (based on the current one) and assigns it 
		/// </summary>
		void SetAvailableShortName(PageContent content);
	}
}
