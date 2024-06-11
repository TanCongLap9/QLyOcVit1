using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;

namespace QLyOcVit1
{
    public static class XmlUtils
    {
        public static XmlNamespaceManager CreateNamespaceManager(XmlNode node, string prefix = "tbl")
        {
            XmlNamespaceManager manager = new XmlNamespaceManager(node.OwnerDocument.NameTable);
            manager.AddNamespace(prefix, node.NamespaceURI);
            return manager;
        }
    }
}