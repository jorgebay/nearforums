using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NLog;

namespace NearForums.Services
{
	public class LoggerService : NearForums.Services.ILoggerService
	{
		private static Logger _logger = LogManager.GetCurrentClassLogger(typeof(LoggerService));

		public void LogError(Exception ex)
		{
			var message = new StringBuilder();
			if (ex.InnerException != null)
			{
				message.AppendLine("-------INNER EXCEPTION----------");
				message.AppendLine(ex.InnerException.Message);
				message.AppendLine(ex.InnerException.StackTrace);
				message.AppendLine("Inner Exception type: " + ex.InnerException.GetType().Name);
				message.AppendLine("-----------EXCEPTION------------");
			}
			message.AppendLine();
			message.AppendLine(ex.Message);
			message.AppendLine();
			message.AppendLine("ExceptionType:" + ex.GetType().Name);
			message.AppendLine("Stacktrace:");
			message.AppendLine(ex.StackTrace);

			_logger.Error(message.ToString());
		}

		public bool IsEnabled
		{
			get
			{
				return _logger.IsErrorEnabled;
			}
		}
	}
}
