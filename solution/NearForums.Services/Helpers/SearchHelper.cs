using System;
using Lucene.Net.Documents;
using Lucene.Net.QueryParsers;
using Lucene.Net.Search;
using Lucene.Net.Analysis.Standard;
using System.Collections.Generic;

namespace NearForums.Services.Helpers
{
	public static class SearchHelper
	{
		public const string Id = "id";
		public const string Title = "title";
		public const string Description = "description";
		public const string Date = "date";
		public const string Tags = "tags";
		public const string ForumName = "forum-name";
		public const string ForumShortName = "forum-short-name";
		public const string Message = "message-{0}";

		private static string[] _searchFieldNames;
		/// <summary>
		/// Gets a list of field names that are indexed and can be searched
		/// </summary>
		private static string[] SearchFieldNames
		{
			get
			{
				if (_searchFieldNames == null)
				{
					var fields = new List<string>();
					fields.Add(Title);
					fields.Add(Description);
					fields.Add(Tags);
					for (var i = 0; i < 20; i++)
					{
						fields.Add(String.Format(Message, i));
					}

					_searchFieldNames = fields.ToArray();
				}
				return _searchFieldNames;
			}
		}

		/// <summary>
		/// Converts a Topic into a search document with proper fields
		/// </summary>
		/// <returns></returns>
		public static Document ToDocument(this Topic topic)
		{
			var doc = new Document();

			doc.Add(new Field(Id, topic.Id.ToString(), Field.Store.YES, Field.Index.NO));
			
			var title = new Field(Title, topic.Title.ToString(), Field.Store.YES, Field.Index.ANALYZED);
			title.SetBoost(2f); //TODO: Move to configuration
			doc.Add(title);
			
			var description = new Field(Description, Utils.RemoveTags(topic.Description), Field.Store.YES, Field.Index.ANALYZED);
			description.SetBoost(1.5f);
			doc.Add(description);

			doc.Add(new Field(Date, DateTools.DateToString(topic.Date, DateTools.Resolution.MINUTE), Field.Store.YES, Field.Index.NO));

			var tags = new Field(Tags, topic.Description, Field.Store.YES, Field.Index.ANALYZED);
			tags.SetBoost(3f);
			doc.Add(tags);

			doc.Add(new Field(ForumName, topic.Forum.Name, Field.Store.YES, Field.Index.NO));

			doc.Add(new Field(ForumShortName, topic.Forum.ShortName, Field.Store.YES, Field.Index.ANALYZED));

			return doc;
		}

		/// <summary>
		/// Converts a string into a Query containing all the analyzed fields
		/// </summary>
		/// <param name="searchQuery"></param>
		/// <returns></returns>
		public static Query ToQuery(this string searchQuery)
		{
			var analyzer = new StandardAnalyzer(Lucene.Net.Util.Version.LUCENE_29);
			var parser = new MultiFieldQueryParser(Lucene.Net.Util.Version.LUCENE_29, SearchFieldNames, analyzer);
			Query query;
			try
			{
				query = parser.Parse(searchQuery.Trim());
			}
			catch (ParseException)
			{
				query = parser.Parse(QueryParser.Escape(searchQuery.Trim()));
			}
			return query;
		}
	}
}
