using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using System.Web.Mvc;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using NearForums.Web.State;
using System.Reflection;

namespace NearForums.Web.Extensions
{
	public static class CaptchaHelper
	{
		/// <summary>
		/// Creates an action result containing the file contents of a png/image with the captcha chars
		/// </summary>
		public static ActionResult CaptchaResult(SessionWrapper session)
		{
			var randomText = GenerateRandomText(6);
			var hash = Utils.GetMd5Hash(randomText + GetSalt(), Encoding.ASCII);
			session.CaptchaHash = hash;

			var rnd = new Random();
			var fonts = new[] { "Verdana", "Times New Roman" };
			float orientationAngle = rnd.Next(0, 359);
			const int height = 30;
			const int width = 120;
			var index0 = rnd.Next(0, fonts.Length);
			var familyName = fonts[index0];

			using (var bmpOut = new Bitmap(width, height))
			{
				var g = Graphics.FromImage(bmpOut);
				var gradientBrush = new LinearGradientBrush(new Rectangle(0, 0, width, height),
															Color.White, Color.DarkGray,
															orientationAngle);
				g.FillRectangle(gradientBrush, 0, 0, width, height);
				DrawRandomLines(ref g, width, height);
				g.DrawString(randomText, new Font(familyName, 18), new SolidBrush(Color.Gray), 0, 2);
				var ms = new MemoryStream();
				bmpOut.Save(ms, ImageFormat.Png);
				var bmpBytes = ms.GetBuffer();
				bmpOut.Dispose();
				ms.Close();

				return new FileContentResult(bmpBytes, "image/png");
			}
		}

		/// <summary>
		/// Determines if the value matches the rendered image
		/// </summary>
		public static bool IsValidCaptchaValue(string captchaValue, SessionWrapper session)
		{
			var expectedHash = session.CaptchaHash;
			var toCheck = captchaValue + GetSalt();
			var hash = Utils.GetMd5Hash(toCheck, Encoding.ASCII);
			return hash.Equals(expectedHash);
		}

		private static void DrawRandomLines(ref Graphics g, int width, int height)
		{
			var rnd = new Random();
			var pen = new Pen(Color.Gray);
			for (var i = 0; i < 10; i++)
			{
				g.DrawLine(pen, rnd.Next(0, width), rnd.Next(0, height),
								rnd.Next(0, width), rnd.Next(0, height));
			}
		}

		private static string GetSalt()
		{
			return Assembly.GetExecutingAssembly().FullName;
		}

		private static string GenerateRandomText(int textLength)
		{
			const string chars = "ABCDEFGHIJKLMNPQRSTUVWXYZ23456789abcdefghklmnpqrstuvw";
			var random = new Random();
			var result = new string(Enumerable.Repeat(chars, textLength)
				  .Select(s => s[random.Next(s.Length)]).ToArray());
			return result;
		}
	}
}
