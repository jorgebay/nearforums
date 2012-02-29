using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using NearForums.Configuration;

namespace NearForums.Web.State
{
	public class TemplateState
	{
		public TemplateState(string name)
		{
			this.Name = name;
			this.Items = new List<TemplateItem>();
		}

		public int Id 
		{
			get; 
			set; 
		}

		public string Name
		{
			get;
			set;
		}

		public List<TemplateItem> Items
		{
			get;
			set;
		}

		#region TemplateItem and TemplateItem type declarations
		public class TemplateItem
		{
			public TemplateItem(string fullText)
			{
				this.Type = TemplateItemType.Text;
				
				//parse the fullText
				if (fullText.StartsWith("{-"))
				{
					this.Value = Regex.Replace(fullText, @"{-(\w+?)-}", "$1");
					if (this.Value.ToUpper().Contains("CONTAINER"))
					{
						this.Type = TemplateItemType.Container;
					}
					else
					{
						this.Type = TemplateItemType.Partial;
					}
				}
				else
				{
					this.Value = fullText;
				}
			}

			public string Value
			{
				get;
				set;
			}

			public TemplateItemType Type
			{
				get;
				set;
			}
		}

		public enum TemplateItemType
		{
			Text,
			Partial,
			Container
		}
		#endregion
	}
}
