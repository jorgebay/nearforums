using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.DataAccess
{
	public interface ITemplatesDataAccess
	{
		void AddOrUpdate(Template t);
		void Delete(int id);
		Template Get(int id);
		List<Template> GetAll();
		Template GetCurrent();
		void SetCurrent(int id);
	}
}
