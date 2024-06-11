using QLyOcVit1.Model;
using System;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace QLyOcVit1.Model
{
    public class FieldModel
    {
        public HtmlControl Control;
        public string Name, XPath;
        public bool ReadOnly;

        public FieldModel(string name, HtmlControl control, string xPath = null, bool readOnly = false)
        {
            Name = name;
            Control = control;
            ReadOnly = readOnly;
        }
    }
}