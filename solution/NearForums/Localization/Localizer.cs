using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Configuration;

namespace NearForums.Localization
{
	/// <summary>
	/// Converts neutral strings into localized strings 
	/// </summary>
	public class Localizer
	{
		#region Static Methods
		private static object lockCurrentLoad = new object();
		private static Localizer _current;
		public static Localizer Current
		{
			get
			{
				if (_current == null)
				{
					lock (lockCurrentLoad)
					{
						var cultureName = SiteConfiguration.Current.General.CultureName;
						SetCulture(cultureName, SiteConfiguration.Current.General.LocalizationFilePath(cultureName));
					}
				}
				return _current;
			}
			set
			{
				_current = value;
			}
		}

		/// <summary>
		/// Loads the translations of a culture and sets as current
		/// </summary>
		/// <param name="cultureName"></param>
		public static void SetCulture(string cultureName, string filePath)
		{
			var manager = new Localizer(cultureName, filePath);
			manager.LoadCulture();

			_current = manager;
		}
		#endregion

		private Dictionary<string, string> _translations;

		public Localizer()
		{
			_translations = new Dictionary<string, string>();
		}

		public Localizer(string cultureName, string filePath)
			: this()
		{
			CultureName = cultureName;
			FilePath = filePath;
		}

		/// <summary>
		/// Gets the number of loaded translations
		/// </summary>
		public virtual int Count
		{
			get
			{
				return _translations.Count;
			}
		}

		/// <summary>
		/// Gets or sets the name of the culture.
		/// </summary>
		public string CultureName 
		{ 
			get; 
			set; 
		}

		public string FilePath
		{
			get;
			set;
		}

		/// <summary>
		/// Gets the translation value for neutral value
		/// </summary>
		/// <param name="neutralValue"></param>
		/// <returns></returns>
		public virtual string Get(string neutralValue)
		{
			if (neutralValue == null)
			{
				throw new ArgumentNullException("neutralValue");
			}
			if (_translations.ContainsKey(neutralValue) && !String.IsNullOrEmpty(_translations[neutralValue]))
			{
				return _translations[neutralValue]; 
			}
			return neutralValue;
		}

		/// <summary>
		/// Gets the translation value for neutral value, 
		/// using the params to format the translation
		/// </summary>
		/// <param name="neutralValue"></param>
		/// <param name="args"></param>
		/// <returns></returns>
		public virtual string Get(string neutralValue, params object[] args)
		{
			if (args == null)
			{
				throw new ArgumentNullException("Args cannot be null, when localizing '" + neutralValue + "'", (Exception)null);
			}
			return String.Format(Get(neutralValue), args);
		}

		public void LoadCulture()
		{
			if (FilePath == null)
			{
				throw new NullReferenceException("FilePath can not be null");
			}
			_translations = LocalizationParser.ParseFile(FilePath);
		}

		/// <summary>
		/// Gets the translation value for a neutral string
		/// </summary>
		/// <param name="neutralValue"></param>
		/// <returns></returns>
		public virtual string this[string neutralValue]
		{
			get
			{
				return Get(neutralValue);
			}
		}
	}
}
