using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using ICSharpCode.SharpZipLib.Zip;
using System.IO;
using System.Text.RegularExpressions;
using System.Text;
using NearForums.Validation;
using NearForums.ServiceClient;
using NearForums.Web.Controllers.Filters;

namespace NearForums.Web.Controllers
{
	public class AdminController : BaseController
	{
		#region Templates
		#region Add template
		[AcceptVerbs(HttpVerbs.Get)]
		public ActionResult AddTemplate()
		{
			return View();
		}

		[AcceptVerbs(HttpVerbs.Post)]
		public ActionResult AddTemplate([Bind(Prefix = "")] Template template, HttpPostedFileBase postedFile)
		{
			bool fileValid = true;
			string baseDirectory = null;

			try
			{
				TemplatesServiceClient.Add(template);

				#region Check access rights
				UserFileAccessRights fileAccessRights = new UserFileAccessRights(Server.MapPath(Config.Template.Path));
				if (!(fileAccessRights.canWrite() && fileAccessRights.canModify() && fileAccessRights.canDelete()))
				{
					throw new ValidationError("postedFile", ValidationErrorType.AccessRights);
				}
				#endregion

				if (Path.GetExtension(postedFile.FileName).ToUpper() == ".ZIP")
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
					baseDirectory = Server.MapPath(Config.Template.Path + template.Key);
					#region Create directories
					Directory.CreateDirectory(baseDirectory);
					Directory.CreateDirectory(baseDirectory + "\\contents");
					#endregion
					//Open the zip file.
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

								if (Path.GetDirectoryName(entry.Name).ToUpper() == "TEMPLATE-CONTENTS")
								{
									fileName += "\\contents";
								}
								fileName += "\\" + Path.GetFileName(entry.Name);

								#region Save file
								using (FileStream streamWriter = System.IO.File.Create(fileName))
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

					return RedirectToAction("ListTemplates", "Admin");
				}
				else
				{
					TemplatesServiceClient.Delete(template.Id);

					throw new ValidationException(new ValidationError("postedFile", ValidationErrorType.FileFormat));
				}
			}
			catch (ValidationException ex)
			{
				this.AddErrors(this.ModelState, ex);

				//Delete the folder
				try
				{
					if (baseDirectory != null)
					{
						Directory.Delete(baseDirectory, true);
					}
				}
				catch
				{
				}
			}
			return View();
		}

		#region Validate filename
		private bool ValidateFileName(string fileName)
		{
			bool fileValid = true;
			if (!Regex.IsMatch(fileName, @"^((template\.html)|(template-contents/((.*\.gif)|(.*\.png)|(.*\.jpg)|(.*\.css))?))$", RegexOptions.IgnoreCase))
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
		public void ReplaceFilePaths(string filePath, string newPath)
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
		public int ChopTemplateFile(string fileName)
		{
			List<StringBuilder> partsList = new List<StringBuilder>();

			string currentLine = null;
			using (FileStream inputStream = System.IO.File.OpenRead(fileName))
			{
				using (StreamReader inputReader = new StreamReader(inputStream))
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

			//Save the files based on the partsList.
			int partNumber = 0;
			foreach (StringBuilder part in partsList)
			{
				if (part.Length > 0)
				{
					//template.part.1.html
					string directoryName = Path.GetDirectoryName(fileName);
					System.IO.File.WriteAllText(directoryName + "\\template.part." + partNumber + ".html", part.ToString(), Encoding.UTF8);
					partNumber++;
				}
			}

			return partsList.Count;
		}
		#endregion
		#endregion

		#region List template
		public ActionResult ListTemplates()
		{
			List<Template> list = TemplatesServiceClient.GetAll();
			return View(list);
		}
		#endregion 

		#region Set current
		public ActionResult TemplateSetCurrent(int id)
		{
			TemplatesServiceClient.SetCurrent(id);

			this.Cache.Template = null;

			return RedirectToAction("ListTemplates", "Admin");
		}
		#endregion
		#endregion

		#region Dashboard
		[RequireAuthorization(UserGroup.Moderator)]
		public ActionResult Dashboard()
		{
			return View();
		}
		#endregion
	}
}
