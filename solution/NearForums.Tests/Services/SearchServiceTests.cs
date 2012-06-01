using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Services;

namespace NearForums.Tests.Services
{
	[TestClass]
	public class SearchServiceTests
	{
		/// <summary>
		/// Tests that the add to index and search works properly
		/// </summary>
		[TestMethod]
		public void Index_AddTopic_Seach_Test()
		{
			var service = TestHelper.Resolve<ISearchService>();
			//Delete all previous index data
			service.RecreateIndex = true;
			service.Add(new Topic()
			{
				Id = 1,
				Title = "Dummy topic",
				Description = "<p>Lorem ipsum</p>",
				Tags = new TagList(),
				Forum = new Forum()
				{
					Name = "Dummy forum",
					ShortName = "dummy-forum"
				}
			});
			service.Add(new Topic()
			{
				Id = 2,
				Title = "Dummy topic 2",
				Description = "<p>Lorem ipsum</p>",
				Tags = new TagList(),
				Forum = new Forum()
				{
					Name = "Dummy forum 2",
					ShortName = "dummy-forum-2"
				}
			});

			var results = service.Search("TOPIC");
			Assert.IsTrue(results.Count > 0);
		}

		/// <summary>
		/// Adds a topic and a message and searchs for message
		/// </summary>
		[TestMethod]
		public void Index_AddMessage_Seach_Test()
		{
			var service = TestHelper.Resolve<ISearchService>();
			//Clear the index
			service.RecreateIndex = true;
			var topic = new Topic()
			{
				Id = 1,
				Title = "Dummy topic",
				Description = "<p>Lorem ipsum</p>",
				Tags = new TagList(),
				Date = DateTime.UtcNow.Date,
				Forum = new Forum()
				{
					Name = "Dummy forum",
					ShortName = "dummy-forum"
				}
			};
			service.Add(topic);
			service.RecreateIndex = false;
			service.Add(new Message()
			{
				Id = 1,
				Body = "<p>This is the first message</p>",
				Date = DateTime.UtcNow.Date.AddDays(1),
				Topic = topic
			});

			var results = service.Search("first");
			Assert.AreEqual(1, results.Count);

			service.Add(new Message()
			{
				Id = 2,
				Body = "<p>This is the second message</p>",
				Date = DateTime.UtcNow.Date.AddDays(2),
				Topic = topic
			});


			results = service.Search("second");
			Assert.AreEqual(1, results.Count);
			results = service.Search("first");
			Assert.AreEqual(1, results.Count);
		}
	}
}
