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
		[TestMethod]
		public void Index_Search_Topic_Test()
		{
			var service = TestHelper.Resolve<ISearchService>();
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
	}
}
