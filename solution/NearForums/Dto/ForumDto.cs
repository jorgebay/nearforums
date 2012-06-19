using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NearForums.Dto
{
	/// <summary>
	/// Represents forum information that can be used to send over the wire
	/// </summary>
	public class ForumDto
	{
		public ForumDto()
		{

		}

		public ForumDto(Forum forum)
		{
			Id = forum.Id;
			Name = forum.Name;
			TopicCount = forum.TopicCount;
		}

		public int Id { get; set; }

		public string Name { get; set; }

		/// <summary>
		/// Amount of topics inside this forum
		/// </summary>
		public int TopicCount { get; set; }
	}
}
