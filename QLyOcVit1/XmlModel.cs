using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Xml;

namespace QLyOcVit1
{
    public class XmlModel
    {
        public XmlNode Element;
        public XmlNamespaceManager Manager;

        public XmlModel(XmlNode element)
        {
            Element = element;
            Manager = XmlUtils.CreateNamespaceManager(element);
        }

        public string Get(string xpath)
        {
            xpath = GetQualifiedXPath(xpath);
            return Element.SelectSingleNode(xpath, Manager).InnerText;
        }

        public string this[string xpath]
        {
            get { return Get(xpath); }
        }

        public int GetInt(string xpath)
        {
            return int.Parse(this[xpath], CultureInfo.InvariantCulture);
        }

        public float GetFloat(string xpath)
        {
            return float.Parse(this[xpath], CultureInfo.InvariantCulture);
        }

        public bool GetBoolean(string xpath)
        {
            return this[xpath] == "true";
        }

        public string GetQualifiedXPath(string xpath)
        {
            string[] nodes = xpath.Split('/');
            for (int i = 0; i < nodes.Length; i++)
            {
                if (!nodes[i].StartsWith("@"))
                    nodes[i] = "tbl:" + nodes[i];
            }
            return string.Join("/", nodes);
        }
    }
}