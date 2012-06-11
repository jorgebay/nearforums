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
		public void SearchIndex_AddTopic_Test()
		{
			var service = TestHelper.Resolve<ISearchService>();
			//Delete all previous index data
			service.CreateIndex();
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
			Assert.AreEqual(2, results.Count);
		}

		/// <summary>
		/// Adds a topic and a message and searchs for message
		/// </summary>
		[TestMethod]
		public void SearchIndex_AddMessage_Test()
		{
			var service = TestHelper.Resolve<ISearchService>();
			//Clear the index
			service.CreateIndex();
			//initial date of index
			var baseDate = DateTime.UtcNow.Date;
			var topic = new Topic()
			{
				Id = 1,
				Title = "Dummy topic",
				Description = "<p>Lorem ipsum</p>",
				Tags = new TagList(),
				Date = baseDate,
				Forum = new Forum()
				{
					Name = "Dummy forum",
					ShortName = "dummy-forum"
				}
			};
			service.Add(topic);
			service.Add(new Message()
			{
				Id = 1,
				Body = "<p>This is the first message</p>",
				Date = baseDate.AddDays(1),
				Topic = topic
			});

			var results = service.Search("first");
			Assert.AreEqual(1, results.Count);

			service.Add(new Message()
			{
				Id = 2,
				Body = "<p>This is the second message</p>",
				Date = baseDate.AddDays(2),
				Topic = topic
			});

			results = service.Search("second");
			Assert.AreEqual(1, results.Count);
			//Check that the modification on the document date took place
			Assert.AreEqual(baseDate.AddDays(2), results[0].Date);

			results = service.Search("first");
			Assert.AreEqual(1, results.Count);
		}

		[TestMethod]
		public void SearchIndex_UpdateTopic_Test()
		{
			var service = TestHelper.Resolve<ISearchService>();
			//Clear the index
			service.CreateIndex();
			var topic = new Topic()
			{
				Id = 1,
				Title = "Initial",
				Description = "<p>Lorem ipsum</p>",
				Tags = new TagList(),
				Date = DateTime.Now,
				Forum = new Forum()
				{
					Name = "Dummy forum",
					ShortName = "dummy-forum"
				}
			};
			service.Add(topic);
			service.Add(new Message()
			{
				Id = 1,
				Body = "<p>This is the first message</p>",
				Date = DateTime.Now.AddDays(1),
				Topic = topic
			});

			var results = service.Search("initial");
			Assert.AreEqual(1, results.Count);

			topic.Title = "Edited";
			service.Update(topic);

			results = service.Search("edited");
			Assert.AreEqual(1, results.Count);

			results = service.Search("initial");
			Assert.AreEqual(0, results.Count); //no results for the original title of the topic

			results = service.Search("message");
			Assert.AreEqual(1, results.Count); //the messages should stay the same
		}

		[TestMethod]
		public void SearchIndex_RemoveMessage_Test()
		{
			var service = TestHelper.Resolve<ISearchService>();
			//Clear the index
			service.CreateIndex();
			var topic = new Topic()
			{
				Id = 1,
				Title = "container",
				Description = "<p>Lorem ipsum</p>",
				Tags = new TagList(),
				Date = DateTime.Now,
				Forum = new Forum()
				{
					Name = "Dummy forum",
					ShortName = "dummy-forum"
				}
			};
			service.Add(topic);
			service.Add(new Message()
			{
				Id = 1,
				Body = "<p>This is the first message</p>",
				Date = DateTime.Now.AddDays(1),
				Topic = topic
			});
			service.Add(new Message()
			{
				Id = 2,
				Body = "<p>This is the second message</p>",
				Date = DateTime.Now.AddDays(1),
				Topic = topic
			});

			var results = service.Search("first");
			Assert.AreEqual(1, results.Count);

			results = service.Search("second");
			Assert.AreEqual(1, results.Count);

			service.DeleteMessage(topic.Id, 2);

			results = service.Search("second");
			Assert.AreEqual(0, results.Count); //there must be no results for the deleted message

			results = service.Search("first");
			Assert.AreEqual(1, results.Count); //results for the first message3

			results = service.Search("container");
			Assert.AreEqual(1, results.Count); //the topic information should stay the same
		}

		/*
		/// <summary>
		/// Checks performance
		/// </summary>
		[TestMethod]
		public void Index_Performance()
		{
			var baseDate = DateTime.UtcNow.Date;

			var searchService = TestHelper.Resolve<ISearchService>();
			searchService.RecreateIndex = true;
			
			var results = searchService.Search("zzzzzzzzzzzzzz");
			Assert.AreEqual(0, results.Count);

			for (var i = 0; i < 50; i++)
			{
				var service = TestHelper.Resolve<ISearchService>();
				var topic = new Topic()
				{
					Id = i,
					Title = "Dummy topic",
					Description = "<p>Lorem ipsum</p>",
					Tags = new TagList(),
					Date = baseDate,
					Forum = new Forum()
					{
						Name = "Dummy forum",
						ShortName = "dummy-forum"
					}
				};
				service.Add(topic);

				service.Add(new Message()
				{
					Id = 1,
					Body = "<p>This is the first message</p>",
					Date = baseDate.AddDays(1),
					Topic = topic
				});

				service.Add(new Message()
				{
					Id = 2,
					Body = "<p>This is the second message</p>",
					Date = baseDate.AddDays(2),
					Topic = topic
				});
			}
			results = searchService.Search("second");
			Assert.IsTrue(results.Count > 0);
			//Check that the modification on the document date took place
			Assert.AreEqual(baseDate.AddDays(2), results[0].Date);

			results = searchService.Search("first");
			Assert.IsTrue(results.Count > 0);
		}
		 * */
	}
}
