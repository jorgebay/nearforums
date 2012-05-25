using System;
using System.Collections.Generic;
namespace NearForums.Services
{
	public interface ITemplatesService
	{
		/// <summary>
		/// Adds or updates a template in the db
		/// </summary>
		/// <param name="t"></param>
		void AddOrUpdate(Template t);
		/// <summary>
		/// Deletes a template from the repository
		/// </summary>
		/// <param name="templateId"></param>
		void Delete(int templateId);
		Template Get(int templateId);
		List<NearForums.Template> GetAll();
		/// <summary>
		/// Gets the current template
		/// </summary>
		/// <returns></returns>
		Template GetCurrent();
		void SetCurrent(int templateId);
	}
}
