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
		/// Gets all the forums to be indexed
		/// </summary>
		/// <returns></returns>
		List<ForumDto> GetForums();

		/// <summary>
		/// Indexes a group of topics belonging to the forum. Returns the amount of topics indexed.
		/// </summary>
		/// <param name="forumId"></param>
		/// <param name="index">index of the batch (zero based)</param>
		/// <returns>The amount of topics indexed</returns>
		int IndexBatch(int forumId, int index);
	}
}
