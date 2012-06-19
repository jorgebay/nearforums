using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Dto;

namespace NearForums.Services
{
	/// <summary>
	/// Represents the service that indexes content in batches
	/// </summary>
	public interface ISearchIndexBatchService
	{
		/// <summary>
		/// Gets the 
		/// </summary>
		/// <returns></returns>
		List<ForumDto> GetForums();

		void IndexBatch(int forumId, int index);
	}
}
