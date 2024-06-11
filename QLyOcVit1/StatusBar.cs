using System;
using System.Web.UI.HtmlControls;

namespace QLyOcVit1
{
    public class StatusBar
    {
        public HtmlGenericControl Div, Icon, Text;
        public StatusBar(HtmlGenericControl div, HtmlGenericControl icon, HtmlGenericControl text) {
            Div = div;
            Icon = icon;
            Text = text;
        }

        public void SetError(string text)
        {
            Div.Visible = true;
            Div.Attributes["class"] = "alert alert-danger";
            Icon.InnerHtml = "error";
            Text.InnerHtml = text;
        }

        public void SetSuccess(string text)
        {
            Div.Visible = true;
            Div.Attributes["class"] = "alert alert-success";
            Icon.InnerHtml = "done";
            Text.InnerHtml = text;
        }

        public void Clear()
        {
            Div.Visible = false;
            Div.Attributes["class"] = "alert";
            Icon.InnerHtml = Text.InnerHtml = "";
        }
    }
}