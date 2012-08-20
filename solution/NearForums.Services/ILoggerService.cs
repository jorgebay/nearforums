using System;
namespace NearForums.Services
{
	public interface ILoggerService
	{
		bool IsEnabled { get; }
		void LogError(Exception ex);
		void LogError(string message);
	}
}
