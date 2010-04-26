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
			return Path.GetFileName(path).ToLower();
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

		public static void Directory_Delete(string path, bool recursive)
		{
			path = path.ToLower();
			Directory.Delete(path, recursive);
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
		#endregion
	}
}
