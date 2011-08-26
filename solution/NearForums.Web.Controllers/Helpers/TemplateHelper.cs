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

namespace NearForums.Web.Controllers.Helpers
{
	public static class TemplateHelper
	{
		#region Validate filename
		private static bool ValidateFileName(string fileName)
		{
			bool fileValid = true;
			if (!Regex.IsMatch(fileName, @"^((template\.html)|(screenshot\.png)|(.*\.txt)|(template-contents/((.*\.gif)|(.*\.png)|(.*\.jpg)|(.*\.css))?))$", RegexOptions.IgnoreCase))
			{
				fileValid = false;
			}
			return fileValid;
		}
		#endregion

		#region Replace files paths
		/// <summary>
		/// Replaces the paths from template-contents/ to /Content/Templates/{NameOfTheTemplate}/contents/ in the files .html and css
		/// </summary>
		private static void ReplaceFilePaths(string filePath, string newPath)
		{
			System.IO.File.WriteAllText(filePath, Regex.Replace(System.IO.File.ReadAllText(filePath), "template-contents/", newPath + "contents/"));
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
									//TODO: Save part?
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
		public static void Add(Template template, HttpPostedFileBase postedFile, HttpContextBase context)
		{
			string baseDirectory = null;
			try
			{

				bool fileValid = true;
				if (postedFile == null)
				{
					throw new ValidationException(new ValidationError("postedFile", ValidationErrorType.NullOrEmpty));
				}

				TemplatesServiceClient.Add(template);

				if (SafeIO.Path_GetExtension(postedFile.FileName) == ".zip")
				{
					//Validate max length
					if (postedFile.ContentLength > 1024 * 1024 * 3)
					{
						fileValid = false;
					}
				}
				else
				{
					fileValid = false;
				}

				if (fileValid)
				{
					baseDirectory = context.Server.MapPath(Config.Template.Path + template.Key);
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
					postedFile.SaveAs(baseDirectory + "/template.zip");
					#endregion

					#region Save the files in the zip file
					using (ZipInputStream zipStream = new ZipInputStream(postedFile.InputStream))
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
						zipStream.Close();
					}
					#endregion
				}

				if (fileValid)
				{
					//All worked file
					ReplaceFilePaths(baseDirectory + "\\template.html", Config.Template.Path + template.Key + "/");

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

		#region Config
		public static SiteConfiguration Config
		{
			get
			{
				return SiteConfiguration.Current;
			}
		} 
		#endregion
	}
}
