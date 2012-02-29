using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Web;
using NearForums.Validation;
using NearForums.ServiceClient;
using ICSharpCode.SharpZipLib.Zip;
using NearForums.Configuration;
using NearForums.Web.State;
using NearForums.Web.Extensions;
using System.Web.Mvc;

namespace NearForums.Web.Controllers.Helpers
{
	public static class TemplateHelper
	{
		#region Validation
		private static bool ValidateFileName(string fileName)
		{
			bool fileValid = true;
			if (!Regex.IsMatch(fileName, @"^((template\.html)|(screenshot\.png)|(.*\.txt)|(template-contents/((.*\.gif)|(.*\.png)|(.*\.jpg)|(.*\.css))?))$", RegexOptions.IgnoreCase))
			{
				fileValid = false;
			}
			return fileValid;
		}

		///// <summary>
		///// TODO: Checks that all required parts are there and the contents and containers are valid
		///// </summary>
		///// <exception cref="ValidationException"></exception>
		//private static void ValidateTemplateParts(List<StringBuilder> partsList)
		//{
		//    foreach (var part in partsList)
		//    {
		//        if (part.Length < 30 && part[0] == '{')
		//        {
		//            var placeholder = part.ToString();
		//        }
		//    }
		//    //throw new ValidationException(new ValidationError("postedFile", ValidationErrorType.FileFormat));
		//}
		#endregion

		#region Replace files paths
		/// <summary>
		/// Check that the html format is valid and replaces the paths from template-contents/ and special keywords
		/// </summary>
		/// <exception cref="ValidationException">Throws a ValidationException if the html does not contain the required placeholders.</exception>
		private static void PrepareTemplateBody(string filePath, string newPath, HttpContextBase context)
		{
			//Normally a template html file won't be larger than 100Kb, so read all in memory
			var content = File.ReadAllText(filePath);
			if (!Regex.IsMatch(content, "{-headcontainer-}.*{-bodycontainer-}", RegexOptions.IgnoreCase | RegexOptions.Singleline))
			{
				throw new ValidationException(new ValidationError("html", ValidationErrorType.FileFormat));
			}
			content = Regex.Replace(content, "template-contents/", newPath + "contents/", RegexOptions.IgnoreCase);
			content = Regex.Replace(content, "{-applicationpath-}", UrlHelper.GenerateContentUrl("~/", context), RegexOptions.IgnoreCase);
			content = Regex.Replace(content, "{-year-}", DateTime.UtcNow.ToApplicationDateTime().Year.ToString(), RegexOptions.IgnoreCase);
			System.IO.File.WriteAllText(filePath, content);
		}
		#endregion

		#region Chop template
		/// <summary>
		/// Chop the file template.html to template.part.1.html ... template.part.n.html
		/// </summary>
		/// <param name="fileName"></param>
		/// <returns>Amount of parts</returns>
		public static int ChopTemplateFile(string fileName)
		{
			List<StringBuilder> partsList = new List<StringBuilder>();

			string currentLine = null;
			using (FileStream inputStream = SafeIO.File_OpenRead(fileName))
			{
				using (var inputReader = new StreamReader(inputStream))
				{
					StringBuilder part = new StringBuilder();
					partsList.Add(part);
					while ((currentLine = inputReader.ReadLine()) != null)
					{
						//Search for 
						int matches = Regex.Matches(currentLine, @"{-\w+?-}").Count;
						if (matches > 0)
						{
							bool endReadingLine = false;
							int i = 0;
							while (i < currentLine.Length && !endReadingLine)
							{
								if (currentLine[i] == '{' && currentLine[i + 1] == '-')
								{
									//New part
									if (part.Length > 0)
									{
										part = new StringBuilder();
										partsList.Add(part);
									}
									part.Append(currentLine[i]);
								}
								else if (currentLine[i] == '}' && currentLine[i - 1] == '-')
								{
									part.Append(currentLine[i]);
									part = new StringBuilder();
									
									partsList.Add(part);
								}
								else
								{
									part.Append(currentLine[i]);
								}
								i++;
							}

						}
						else
						{
							part.AppendLine(currentLine);
						}

					}
				}
			}

			//Check parts
			//ValidateTemplateParts(partsList);

			//Save the files based on the partsList.
			int partNumber = 0;
			foreach (StringBuilder part in partsList)
			{
				if (part.Length > 0)
				{
					//template.part.1.html
					string directoryName = SafeIO.Path_GetDirectoryName(fileName);
					SafeIO.File_WriteAllText(directoryName + "\\template.part." + partNumber + ".html", part.ToString(), Encoding.UTF8);
					partNumber++;
				}
			}

			return partsList.Count;
		}
		#endregion

		#region Add
		/// <summary>
		/// Unpackages the template file and adds a new template in the db.
		/// </summary>
		/// <exception cref="ValidationException">Throws a ValidationException if the posted file is not valid or the application does not have access rights.</exception>
		public static void Add(Template template, Stream postedStream, HttpContextBase context)
		{
			string baseDirectory = null;
			try
			{

				if (postedStream == null)
				{
					throw new ValidationException(new ValidationError("postedFile", ValidationErrorType.NullOrEmpty));
				}
				else if (postedStream.Length > 1024 * 1024 * 3)
				{
					throw new ValidationException(new ValidationError("postedFile", ValidationErrorType.MaxLength));
				}
				var cache = new CacheWrapper(context);

				if (cache.Template != null && template.Key != null && cache.Template.Name.ToUpper() == template.Key.ToUpper())
				{
					throw new ValidationException(new ValidationError("postedFile", ValidationErrorType.DuplicateNotAllowed));
				}

				TemplatesServiceClient.AddOrUpdate(template);

				bool fileValid = true;
				baseDirectory = Config.TemplateFolderPathFull(template.Key);
				#region Create directories
				try
				{
					SafeIO.Directory_CreateDirectory(baseDirectory);
					SafeIO.Directory_CreateDirectory(baseDirectory + "\\contents");
				}
				catch (UnauthorizedAccessException)
				{
					throw new ValidationException(new ValidationError("postedFile", ValidationErrorType.AccessRights));
				}
				#endregion

				#region Save zip file to disk
				using (var fileStream = new FileStream(baseDirectory + "/template.zip", FileMode.Create))
				{
					postedStream.CopyTo(fileStream);
				}
				#endregion

				postedStream.Position = 0;
				#region Save the files in the zip file
				using (var zipStream = new ZipInputStream(postedStream))
				{
					ZipEntry entry;
					while (((entry = zipStream.GetNextEntry()) != null) && fileValid)
					{
						fileValid = ValidateFileName(entry.Name);

						if (fileValid && entry.IsFile)
						{
							string fileName = baseDirectory;

							if (SafeIO.Path_GetDirectoryName(entry.Name).ToUpper() == "TEMPLATE-CONTENTS")
							{
								fileName += "\\contents";
							}
							fileName += "\\" + SafeIO.Path_GetFileName(entry.Name);

							#region Save file
							using (System.IO.FileStream streamWriter = SafeIO.File_Create(fileName))
							{
								int size = 2048;
								byte[] data = new byte[2048];
								while (true)
								{
									size = zipStream.Read(data, 0, data.Length);
									if (size > 0)
									{
										streamWriter.Write(data, 0, size);
									}
									else
									{
										break;
									}
								}
								streamWriter.Close();
							}
							#endregion
						}
					}
				}
				#endregion

				if (fileValid)
				{
					PrepareTemplateBody(baseDirectory + "\\template.html", UrlHelper.GenerateContentUrl(Config.TemplateFolderPath(template.Key) + "/", context), context);
					
					ChopTemplateFile(baseDirectory + "\\template.html");
				}
				else
				{
					throw new ValidationException(new ValidationError("postedFile", ValidationErrorType.FileFormat));
				}
			}
			catch (ValidationException)
			{
				//Delete the folder
				if (baseDirectory != null)
				{
					try
					{
						SafeIO.Directory_Delete(baseDirectory, true);
					}
					catch (UnauthorizedAccessException)
					{

					}
				}
				if (template.Id > 0)
				{
					TemplatesServiceClient.Delete(template.Id);
				}
				throw;
			}
		}
		#endregion


		#region Add default templates
		/// <summary>
		/// 
		/// </summary>
		/// <exception cref="DirectoryNotFoundException"></exception>
		/// <exception cref="UnauthorizedAccessException"></exception>
		/// <exception cref="ValidationException">Throws a ValidationException if the posted file is not valid or the application does not have access rights.</exception>
		public static int AddDefaultTemplates(string path, HttpContextBase context)
		{
			var templatesLength = 0;
			var files = SafeIO.Directory_GetFiles(path, "*.zip");
			foreach (var fileName in files)
			{
				var template = new Template();
				template.Key = SafeIO.Path_GetFileNameWithoutExtension(fileName);
				template.Description = "Default";
				using (var file = new FileStream(fileName, FileMode.Open, FileAccess.Read))
				{
					TemplateHelper.Add(template, file, context);
				}
			}
			templatesLength = files.Length;
			return templatesLength;
		} 
		#endregion

		#region Config
		public static SiteConfiguration Config
		{
			get
			{
				return SiteConfiguration.Current;
			}
		} 
		#endregion

		#region Load TemplateState
		public static TemplateState GetCurrentTemplateState(HttpContextBase context)
		{
			return GetTemplateState(context, null);
		}

		public static TemplateState GetTemplateState(HttpContextBase context, int? id)
		{
			TemplateState template = null;
			Template t = null;
			if (id != null)
			{
				t = TemplatesServiceClient.Get(id.Value);
			}
			else
			{
				//Gets the current template code from db
				t = TemplatesServiceClient.GetCurrent();
			}

			if (t != null)
			{
				//Get all the files in the directory
				template = new TemplateState(t.Key);
				template.Id = t.Id;
				string[] fileNameList = SafeIO.Directory_GetFiles(Config.TemplateFolderPathFull(template.Name), "*.part.*.html");
				foreach (string fileName in fileNameList)
				{
					template.Items.Add(new TemplateState.TemplateItem(SafeIO.File_ReadAllText(fileName)));
				}
			}
			return template;
		}
		#endregion

		#region Load Template
		public static TemplateState LoadTemplate(HttpContextBase context)
		{
			TemplateState template = null;
			var session = new SessionWrapper(context);
			var cache = new CacheWrapper(context);
			int? previewTemplateId = context.Request.QueryString["_tid"].ToNullableInt();
			if (session.IsTemplatePreview)
			{
				if (previewTemplateId != null)
				{
					if (session.TemplatePreviewed == null || session.TemplatePreviewed.Id != previewTemplateId.Value)
					{
						//Load the previewed template into the session
						session.TemplatePreviewed = TemplateHelper.GetTemplateState(context, previewTemplateId);
					}
				}
				else
				{
					//Prevent for the previus previewed template to be shown in this 
					session.TemplatePreviewed = null;
				}
				template = session.TemplatePreviewed;
			}
			if (Config.UI.Template.UseTemplates && template == null)
			{
				if (cache.Template == null)
				{
					//Load the current template in the cache
					cache.Template = TemplateHelper.GetCurrentTemplateState(context);
				}
				template = cache.Template;
			}

			return template;
		}
		#endregion
	}
}
