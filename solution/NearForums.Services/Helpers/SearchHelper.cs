using System;
using Lucene.Net.Documents;
using Lucene.Net.QueryParsers;
using Lucene.Net.Search;
using Lucene.Net.Analysis.Standard;
using System.Collections.Generic;
using Lucene.Net.Analysis;
using Lucene.Net.Index;
using Lucene.Net.Util;
using System.Collections;
using System.Linq;

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
					for (var i = 1; i <= 20; i++)
					{
						fields.Add(String.Format(Message, i));
					}

					_searchFieldNames = fields.ToArray();
				}
				return _searchFieldNames;
			}
		}

		public static T GetFieldValue<T>(this Document doc, string fieldName)
		{
			T value = default(T);
			var type = typeof(T);
			if (type == typeof(int))
			{
				value = (T)Convert.ChangeType(NumericUtils.PrefixCodedToInt(doc.GetField(fieldName).StringValue()), type);
			}
			else
			{
				value = (T)Convert.ChangeType(doc.GetField(fieldName).StringValue(), type);
			}
			return value;
		}

		/// <summary>
		/// Searches the index by Id and returns the document (or null)
		/// </summary>
		/// <returns></returns>
		public static Document SearchById(this IndexSearcher searcher, int id)
		{
			Document doc = null;
			var results = searcher.Search(new TermQuery(new Term(Id, NumericUtils.IntToPrefixCoded(id))), 1).ScoreDocs;
			if (results.Length == 1)
			{
				//var fields = new Hashtable(StoredFieldNames.ToDictionary<string, string>(key => key));
				//var selector = new SetBasedFieldSelector(fields, new Hashtable());
				doc = searcher.Doc(results[0].doc);
			}
			else if (results.Length > 1)
			{
				throw new CorruptIndexException("There is more than one document for given id");
			}
			return doc;
		}

		/// <summary>
		/// Converts a Topic into a search document with proper fields
		/// </summary>
		/// <returns></returns>
		public static Document ToDocument(this Topic topic)
		{
			var doc = new Document();

			doc.Add(new Field(Id, NumericUtils.IntToPrefixCoded(topic.Id), Field.Store.YES, Field.Index.NOT_ANALYZED));

			var title = new Field(Title, topic.Title.ToString(), Field.Store.YES, Field.Index.ANALYZED);
			title.SetBoost(2f); //TODO: Move to configuration
			doc.Add(title);

			var description = new Field(Description, Utils.RemoveTags(topic.Description), Field.Store.YES, Field.Index.ANALYZED);
			description.SetBoost(1.5f);
			doc.Add(description);

			doc.Add(new Field(Date, DateTools.DateToString(topic.Date, DateTools.Resolution.MINUTE), Field.Store.YES, Field.Index.NO));

			var tags = new Field(Tags, topic.Tags.ToString(), Field.Store.YES, Field.Index.ANALYZED);
			tags.SetBoost(3f);
			doc.Add(tags);

			doc.Add(new Field(ForumName, topic.Forum.Name, Field.Store.YES, Field.Index.NO));

			doc.Add(new Field(ForumName, topic.Forum.Name, Field.Store.YES, Field.Index.NO));

			doc.Add(new Field(ForumShortName, topic.Forum.ShortName, Field.Store.YES, Field.Index.ANALYZED));

			return doc;
		}

		/// <summary>
		/// Converts a message into a document field.
		/// </summary>
		/// <returns></returns>
		public static Field ToField(this Message message)
		{
			var field = new Field(String.Format(Message, message.Id), Utils.RemoveTags(message.Body), Field.Store.YES, Field.Index.ANALYZED);
			return field;
		}

		/// <summary>
		/// Converts a document into topic
		/// </summary>
		/// <returns></returns>
		public static Topic ToTopic(this Document doc)
		{
			var topic = new Topic();
			topic.Id = doc.GetFieldValue<int>(Id);
			topic.Title = doc.GetFieldValue<string>(Title);
			return topic;
		}

		/// <summary>
		/// Converts a string into a Query containing all the analyzed fields
		/// </summary>
		/// <param name="searchQuery"></param>
		/// <returns></returns>
		public static Query ToQuery(this string searchQuery, Analyzer analyzer)
		{
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

		/// <summary>
		/// Deletes the original document and replaces with the new one.
		/// </summary>
		/// <param name="writer"></param>
		/// <param name="doc"></param>
		public static void Update(this IndexWriter writer, int topicId, Document doc, Analyzer analyzer)
		{
			//TODO: Change topic id param
			writer.DeleteDocuments(new TermQuery(new Term(Id, NumericUtils.IntToPrefixCoded(topicId))));
			writer.AddDocument(doc, analyzer);
		}
	}
}
