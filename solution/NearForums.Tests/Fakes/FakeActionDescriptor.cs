using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace NearForums.Tests.Fakes
{


	public class FakeActionDescriptor : ActionDescriptor
	{
		public override string ActionName
		{
			get
			{
				return "Dummy";
			}
		}

		public override ControllerDescriptor ControllerDescriptor
		{
			get
			{
				return new FakeControllerDescriptor();
			}
		}

		public override object Execute(ControllerContext controllerContext, IDictionary<string, object> parameters)
		{
			return null;
		}

		public override ParameterDescriptor[] GetParameters()
		{
			return new ParameterDescriptor[] { };
		}
	}

	public class FakeControllerDescriptor : ControllerDescriptor
	{
		public override Type ControllerType
		{
			get
			{
				return this.GetType();
			}
		}

		public override ActionDescriptor FindAction(ControllerContext controllerContext, string actionName)
		{
			return null;
		}

		public override ActionDescriptor[] GetCanonicalActions()
		{
			return null;
		}
	}
}
