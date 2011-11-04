using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace NearForums
{
	/// <summary>
	/// Makes IO in lower case. Safe for any operative system.
	/// </summary>
	public static class SafeIO
	{
		#region Path
		public static string Path_GetExtension(string fileName)
		{
			fileName = fileName.ToLower();
			return Path.GetExtension(fileName).ToLower();
		}

		public static string Path_GetDirectoryName(string path)
		{
			path = path.ToLower();
			return Path.GetDirectoryName(path).ToLower();
		}

		/// <summary>
		/// Returns the file name and extension of the specified path string.
		/// </summary>
		public static string Path_GetFileName(string path)
		{
			path = path.ToLower();
			return Path.GetFileName(path);
		}

		/// <summary>
		/// Returns the file name of the specified path string without the extension.
		/// </summary>
		public static string Path_GetFileNameWithoutExtension(string path)
		{
			path = path.ToLower();
			return Path.GetFileNameWithoutExtension(path);
		}
		#endregion

		#region Directory
		/// <summary>
		/// Creates all directories and subdirectories as specified by path.
		/// </summary>
		public static DirectoryInfo Directory_CreateDirectory(string path)
		{
			path = path.ToLower();
			return Directory.CreateDirectory(path);
		}

		/// <summary>
		/// Deletes the directory.
		/// Ignores if the directory does not exist. 
		/// </summary>
		/// <param name="path"></param>
		/// <param name="recursive"></param>
		public static void Directory_Delete(string path, bool recursive)
		{
			try
			{
				path = path.ToLower();
				Directory.Delete(path, recursive);
			}
			catch (DirectoryNotFoundException)
			{
				//if the directory is not found: Ignore.
			}
		}

		/// <summary>
		/// Returns the names of files in the specified directory that match the specified search pattern
		/// </summary>
		/// <returns></returns>
		public static string[] Directory_GetFiles(string path, string searchPattern)
		{
			if (path == null)
			{
				throw new ArgumentNullException("path");
			}
			path = path.ToLower();
			return Directory.GetFiles(path, searchPattern);
		}
		#endregion

		#region File
		public static FileStream File_OpenRead(string path)
		{
			path = path.ToLower();
			return File.OpenRead(path);
		}

		public static void File_WriteAllText(string path, string contents, Encoding encoding)
		{
			path = path.ToLower();
			File.WriteAllText(path, contents, encoding);
		}

		public static FileStream File_Create(string fileName)
		{
			fileName = fileName.ToLower();
			return File.Create(fileName);
		}

		public static bool File_Exists(string fileName)
		{
			fileName = fileName.ToLower();
			return File.Exists(fileName);
		}

		/// <summary>
		/// Opens a text file, reads all lines of the file, and then closes the file.
		/// </summary>
		public static string File_ReadAllText(string fileName)
		{
			if (fileName == null)
			{
				throw new ArgumentNullException("fileName");
			}
			fileName = fileName.ToLower();
			return File.ReadAllText(fileName);
		}
		#endregion
	}
}
