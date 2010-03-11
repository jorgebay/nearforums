using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NearForums.Validation;

namespace NearForums
{
	public class Message : Entity
	{
		public int Id
		{
			get;
			set;
		}

		/// <summary>
		/// Message index (number) relative to the topic. 1 based.
		/// </summary>
		public int Index
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
	}
}
