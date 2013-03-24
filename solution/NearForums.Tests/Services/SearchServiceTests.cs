using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NearForums.Services;
using System.IO;
using Lucene.Net.Store;
using Lucene.Net.Index;
using Lucene.Net.Analysis.Standard;
using NearForums.Configuration;
using NearForums.Services.Helpers;

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
				Date = DateTime.UtcNow.AddDays(-1d),
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
				Date = DateTime.UtcNow.AddDays(-0.5d),
				Tags = new TagList(),
				Forum = new Forum()
				{
					Name = "Dummy forum 2",
					ShortName = "dummy-forum-2"
				}
			});

			var results = service.Search("TOPIC", 0);
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

			var results = service.Search("first", 0);
			Assert.AreEqual(1, results.Count);

			service.Add(new Message()
			{
				Id = 2,
				Body = "<p>This is the second message</p>",
				Date = baseDate.AddDays(2),
				Topic = topic
			});

			results = service.Search("second", 0);
			Assert.AreEqual(1, results.Count);
			//Check that the modification on the document date took place
			Assert.AreEqual(baseDate.AddDays(2), results[0].Date);

			results = service.Search("first", 0);
			Assert.AreEqual(1, results.Count);

			results = service.Search("topic", 0);
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

			var results = service.Search("initial", 0);
			Assert.AreEqual(1, results.Count);

			topic.Title = "Edited";
			service.Update(topic);

			results = service.Search("edited", 0);
			Assert.AreEqual(1, results.Count);

			results = service.Search("initial", 0);
			Assert.AreEqual(0, results.Count); //no results for the original title of the topic

			results = service.Search("message", 0);
			Assert.AreEqual(1, results.Count); //the messages should stay the same
		}

		[TestMethod]
		public void SearchIndex_DeleteMessage_Test()
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

			var results = service.Search("first", 0);
			Assert.AreEqual(1, results.Count);

			results = service.Search("second", 0);
			Assert.AreEqual(1, results.Count);

			service.DeleteMessage(topic.Id, 2);

			results = service.Search("second", 0);
			Assert.AreEqual(0, results.Count); //there must be no results for the deleted message

			results = service.Search("first", 0);
			Assert.AreEqual(1, results.Count); //results for the first message3

			results = service.Search("container", 0);
			Assert.AreEqual(1, results.Count); //the topic information should stay the same
		}

		[TestMethod]
		public void SearchIndex_DeleteTopic_Test()
		{
			var service = TestHelper.Resolve<ISearchService>();
			//Clear the index
			service.CreateIndex();
			service.Add(new Topic()
			{
				Id = 1,
				Title = "first topic",
				Description = "<p>Lorem ipsum</p>",
				Tags = new TagList(),
				Date = DateTime.Now,
				Forum = new Forum()
				{
					Name = "Dummy forum",
					ShortName = "dummy-forum"
				}
			});
			service.Add(new Topic()
			{
				Id = 2,
				Title = "second topic",
				Description = "<p>Lorem ipsum</p>",
				Tags = new TagList(),
				Date = DateTime.Now,
				Forum = new Forum()
				{
					Name = "Dummy forum",
					ShortName = "dummy-forum"
				}
			});
			var results = service.Search("topic", 0);
			Assert.AreEqual(2, results.Count);

			service.DeleteTopic(1);
			results = service.Search("topic", 0);
			Assert.AreEqual(1, results.Count);

			results = service.Search("first", 0);
			Assert.AreEqual(0, results.Count); //first message must not be showing.

			service.DeleteTopic(2);
			results = service.Search("second", 0);
			Assert.AreEqual(0, results.Count);
		}

		[TestMethod]
		public void SearchIndex_BatchIndex_Test()
		{
			var batchService = TestHelper.Resolve<ISearchIndexBatchService>();
			var indexService = TestHelper.Resolve<ISearchService>();
			indexService.CreateIndex();
			var forums = batchService.GetForums();
			int indexed = 0;
			for (var i = 0; i < 2 && i < forums.Count; i++)
			{
				indexed += batchService.IndexBatch(forums[i].Id, 0);
			}
			Assert.AreEqual(indexService.DocumentCount, indexed);
		}

		[TestMethod]
		public void SearchIndex_DocumentCount()
		{
			var indexService = TestHelper.Resolve<ISearchService>();
			Assert.IsTrue(indexService.DocumentCount >= 0);
		}

		[TestMethod]
		public void SearchIndex_ReservedWords_Test()
		{
			var service = TestHelper.Resolve<ISearchService>();
			//Delete all previous index data
			service.CreateIndex();
			service.Add(new Topic()
			{
				Id = 1,
				Title = "SOMETHING OR SOMETHING ELSE AND",
				Description = "<p>Lorem ipsum</p>",
				Tags = new TagList(),
				Date = DateTime.UtcNow.AddDays(-1d),
				Forum = new Forum()
				{
					Name = "Dummy forum",
					ShortName = "dummy-forum"
				}
			});
			service.Add(new Topic()
			{
				Id = 2,
				Title = "Cool n' the Gang: (In concert)",
				Description = "<p>Lorem ipsum</p>",
				Date = DateTime.UtcNow.AddDays(-0.5d),
				Tags = new TagList(),
				Forum = new Forum()
				{
					Name = "Dummy forum 2",
					ShortName = "dummy-forum-2"
				}
			});

			var results = service.Search("Cool n' the Gang", 0);
			Assert.IsTrue(results.Count == 1);

			results = service.Search("SOMETHING OR", 0);
			Assert.IsTrue(results.Count == 1);

			results = service.Search("SOMETHING AND", 0);
			Assert.IsTrue(results.Count == 1);

			results = service.Search("NOT ME", 0);
			Assert.IsTrue(results.Count == 0);

			results = service.Search("I NOT", 0);
			Assert.IsTrue(results.Count == 0);

			results = service.Search("AND", 0);
			Assert.IsTrue(results.Count == 0);
		}

		[TestMethod]
		public void SearchIndex_LockTest()
		{
			var config = SiteConfiguration.Current.Search;
			var directory = FSDirectory.Open(new DirectoryInfo(config.IndexPath), new Lucene.Net.Store.SimpleFSLockFactory());
			//Create a new index and a writer to that index.
			var writer = new IndexWriter(directory, new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_29), true, IndexWriter.MaxFieldLength.UNLIMITED);
			var doc = new Topic(99999) { Title = "Whatever", Tags = new TagList(), Description = "", Forum = new Forum() { Name = "safsd", ShortName = "snafyusfa" } }.ToDocument(config);
			writer.AddDocument(doc);
			writer.Commit();

			Assert.IsTrue(IndexWriter.IsLocked(directory));

			try
			{
				writer = new IndexWriter(directory, new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_29), IndexWriter.MaxFieldLength.UNLIMITED);
				Assert.Fail("It must not allow to create a new index writer on the same directory");
			}
			catch
			{

			}
			IndexWriter.Unlock(directory);
			writer = new IndexWriter(directory, new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_29), IndexWriter.MaxFieldLength.UNLIMITED);
		}

		/*
		/// <summary>
		/// Checks performance
		/// </summary>
		[TestMethod]
		public void Index_Performance_Test()
		{
			var baseDate = DateTime.UtcNow.Date;

			var searchService = TestHelper.Resolve<ISearchService>();
			searchService.CreateIndex();
			
			var results = searchService.Search("zzzzzzzzzzzzzz", 0);
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
			}
			results = searchService.Search("first", 0);
			Assert.IsTrue(results.Count > 0);
			//Check that the modification on the document date took place
			Assert.AreEqual(baseDate.AddDays(1), results[0].Date);

			results = searchService.Search("lorem", 0);
			Assert.IsTrue(results.Count > 0);
		}
		 * */
	}
}
