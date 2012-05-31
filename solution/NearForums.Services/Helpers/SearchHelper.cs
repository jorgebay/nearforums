using System;
using Lucene.Net.Documents;

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
	}
}
