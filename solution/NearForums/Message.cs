using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;

namespace NearForums
{
	public class Message : Entity
	{
		public Message()
		{

		}

		public Message(int id, DateTime date)
		{
			this.Id = id;
			this.Date = date;
		}

		public int Id
		{
			get;
			set;
		}

		[RequireField]
		public string Body
		{
			get;
			set;
		}

		public DateTime Date
		{
			get;
			set;
		}

		/// <summary>
		/// Author of the message
		/// </summary>
		public User User
		{
			get;
			set;
		}

		[RequireField]
		/// <summary>
		/// Topic to which the message belong
		/// </summary>
		public Topic Topic
		{
			get;
			set;
		}

		/// <summary>
		/// Determines if the message can be shown.
		/// </summary>
		public bool Active
		{
			get;
			set;
		}
	}
}
