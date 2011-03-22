using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;

namespace NearForums
{
	/// <summary>
	/// Represents a timeless content of the site like about pages / privacy policies /etc.
	/// </summary>
	public class PageContent : Entity
	{
		/// <summary>
		/// Creates a new instance of a timeless content.
		/// </summary>
		public PageContent()
		{

		}

		[RequireField]
		public string Body
		{
			get;
			set;
		}

		[RequireField]
		public string Title
		{
			get;
			set;
		}

		/// <summary>
		/// Short name identifier of the page. 
		/// </summary>
		[RequireField]
		[Length(128)]
		public string ShortName
		{
			get;
			set;
		}
	}
}
