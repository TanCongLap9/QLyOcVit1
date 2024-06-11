using System;
using System.Collections;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace QLyOcVit1
{
    public partial class NhaSanXuat : System.Web.UI.Page
    {
        private static Dictionary<string, WebControl> fields;

        protected void Page_Load(object sender, EventArgs e)
        {
            fields = new Dictionary<string, WebControl>()
            {
                ["MaNSX"] = maNSX,
                ["TenNSX"] = tenNSX
            };

            BindList();
            ClearStatus();
            error.Visible = success.Visible = false;
        }

        private void ModifyXml(Action<XmlElement, XmlDocument> action)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(MapPath("~/NhaSanXuat.xml"));
            XmlElement root = doc.DocumentElement;
            action.Invoke(root, doc);
            doc.Save(MapPath("~/NhaSanXuat.xml"));
            BindList();
        }

        private void OpenXml(string fileName, Action<XmlElement, XmlDocument> action)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(MapPath(fileName));
            XmlElement root = doc.DocumentElement;
            action.Invoke(root, doc);
        }

        private void ClearStatus()
        {
            foreach (WebControl ctl in new WebControl[] { maNSX, tenNSX })
                ctl.CssClass = ctl.ToolTip = "";
            alertBox.CssClass = alertText.Text = "";
            success.Visible = error.Visible = false;
        }

        private bool ValidateFields(string mode)
        {
            ClearStatus();
            bool valid = true;
            if (mode != "xoa") foreach (TextBox ctl in new TextBox[] { maNSX, tenNSX })
                    if (ctl.Text == "")
                    {
                        SetError(ctl, "Vui lòng điền những thông tin còn thiếu!", "Đây là thông tin bắt buộc.");
                        valid = false;
                    }
            if (!valid) return false;
            if (mode != "xoa") foreach (TextBox ctl in new TextBox[] { maNSX })
                if (int.Parse(ctl.Text) <= 0)
                {
                    SetError(ctl, "Vui lòng điền số lớn hơn 0 vào các thông tin!", "Thông tin này phải lớn hơn 0.");
                    valid = false;
                }
            if (!valid) return false;
            if (mode == "them")
                OpenXml("~/NhaSanXuat.xml", (root, doc) =>
                {
                    foreach (XmlElement element in root.SelectNodes("NhaSanXuat"))
                        if (maNSX.Text == element.SelectSingleNode("MaNSX").InnerText)
                        {
                            SetError(maNSX, "Vui lòng điền mã khác biệt với những mã đã có!", "Mã bị trùng với mã khác.");
                            valid = false;
                        }
                });
            if (!valid) return false;
            return true;
        }

        protected void them_Click(object sender, EventArgs e)
        {
            if (!ValidateFields("them")) return;
            ModifyXml((root, doc) => {
                XmlElement nhaSanXuat = doc.CreateElement("NhaSanXuat");
                root.AppendChild(nhaSanXuat);
                foreach (KeyValuePair<string, WebControl> field in fields)
                {
                    XmlElement fieldElem = doc.CreateElement(field.Key.ToString());
                    fieldElem.InnerText = GetStringValue(field.Value);
                    nhaSanXuat.AppendChild(fieldElem);
                }
            });
            SetSuccess("Thêm thành công!");
        }

        protected void xoa_Click(object sender, EventArgs e)
        {
            if (!ValidateFields("xoa")) return;
            ModifyXml((root, doc) => {
                XmlNode node = root.SelectNodes("NhaSanXuat")[GridView1.SelectedIndex];
                root.RemoveChild(node);
            });
            SetSuccess("Xoá thành công!");
        }

        protected void sua_Click(object sender, EventArgs e)
        {
            if (!ValidateFields("sua")) return;
            ModifyXml((root, doc) => {
                foreach (KeyValuePair<string, WebControl> field in fields)
                {
                    XmlElement node = (XmlElement)root.SelectNodes("NhaSanXuat")[GridView1.SelectedIndex];
                    node.SelectSingleNode(field.Key).InnerText = GetStringValue(field.Value);
                }
            });
            SetSuccess("Sửa thành công!");
        }

        private string GetStringValue(Control ctl)
        {
            return ctl is TextBox
                ? ((TextBox)ctl).Text
                : ctl is CheckBox
                ? ((CheckBox)ctl).Checked.ToString()
                : ctl is DropDownList
                ? ((DropDownList)ctl).SelectedItem.Value
                : ctl.ToString();
        }

        private void SetError(string statusText)
        {
            alertBox.CssClass = "error";
            alertText.Text = statusText;
            error.Visible = true;
        }

        private void SetError(WebControl ctl, string toolTip)
        {
            ctl.CssClass = "error-border";
            ctl.ToolTip = toolTip;
        }

        private void SetError(WebControl ctl, string statusText, string toolTip)
        {
            SetError(ctl, toolTip);
            SetError(statusText);
        }

        private void SetSuccess(string text)
        {
            alertBox.CssClass = "success";
            alertText.Text = text;
            success.Visible = true;
        }

        private void BindList()
        {
            DataSet dSet = new DataSet();
            dSet.ReadXml(MapPath("~/NhaSanXuat.xml"));
            GridView1.DataSource = dSet;
            GridView1.DataBind();
        }

        private void FillFields(int index)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(MapPath("~/NhaSanXuat.xml"));

            XmlElement node = (XmlElement)doc.DocumentElement.SelectNodes("NhaSanXuat")[index];
            foreach (KeyValuePair<string, WebControl> field in fields)
            {
                string val = node.SelectSingleNode(field.Key).InnerText;
                if (field.Value is CheckBox)
                {
                    ((CheckBox)field.Value).Checked = val == "true" ? true : false;
                }
                else if (field.Value is DropDownList)
                {
                    DropDownList ddl = (DropDownList)field.Value;
                    ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(val));
                }
                else if (field.Value is TextBox)
                {
                    ((TextBox)field.Value).Text = val;
                }
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {
            FillFields(GridView1.SelectedIndex);
        }
    }
}