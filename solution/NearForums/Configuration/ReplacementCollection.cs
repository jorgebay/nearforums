//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Configuration;

//namespace NearForums.Configuration
//{
//    public class ReplacementCollection : ConfigurationElementCollection
//    {
//        protected override ConfigurationElement CreateNewElement()
//        {
//            return new ReplacementItem();
//        }

//        protected override object GetElementKey(ConfigurationElement element)
//        {
//            return ((ReplacementItem)(element)).Pattern;
//        }

//        public ReplacementItem this[int index]
//        {
//            get
//            {
//                return (ReplacementItem)BaseGet(index);
//            }
//        }

//        public override bool IsReadOnly()
//        {
//            return false;
//        }
//    }
//}
