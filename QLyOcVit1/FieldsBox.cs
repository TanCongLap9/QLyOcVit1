using QLyOcVit1;
using QLyOcVit1.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Schema;

namespace QLyOcVit1
{
    public class FieldsBox
    {
        public FieldModel[] Fields = new FieldModel[0];
        public List<HtmlInputText> ReadOnlyFields;
        private HtmlButton _UpdateButton, _DeleteButton;
        public int Index;
        public string TableName;
        public string IdField, IdValue;
        public string[] IdFields, IdValues;
        public StatusBar StatusBar;
        public DataTable Table;
        public Page page;
        public SqlDataAdapter DataAdapter;

        public bool InsertMode
        {
            get { return Table == null || Table.Rows.Count == 0; }
        }

        public HtmlButton UpdateButton
        {
            get { return _UpdateButton; }
            set {
                if (_UpdateButton != null) _UpdateButton.ServerClick -= Update;
                if (value != null) value.ServerClick += Update;
                _UpdateButton = value;
            }
        }

        public HtmlButton DeleteButton
        {
            get { return _DeleteButton; }
            set
            {
                if (_DeleteButton != null) _DeleteButton.ServerClick -= Delete;
                if (value != null) value.ServerClick += Delete;
                _DeleteButton = value;
            }
        }

        public FieldsBox(string XmlFile)
        {
            this.TableName = XmlFile;
        }

        public void Update(object sender = null, EventArgs e = null)
        {
            CancelEventArgs ce = new CancelEventArgs();
            if (Updating != null) Updating.Invoke(this, ce);
            if (ce.Cancel) return;

            try
            {
                int rowsAffected = SqlUtils.ExecuteNonQuery(
                    InsertMode ?
                        GetInsertCommand(Fields) :
                        GetUpdateCommand(Fields),
                    GetSqlParameters(Fields)
                );
                if (rowsAffected != 0)
                    StatusBar.SetSuccess(InsertMode ? "Thêm dữ liệu thành công." : "Chỉnh sửa dữ liệu thành công.");
                else
                    StatusBar.SetSuccess(InsertMode ? "Dữ liệu không được thêm." : "Dữ liệu không đổi.");
                UpdateTable();
            }
            catch (Exception exc)
            {
                StatusBar.SetError("Có lỗi xảy ra: " + exc.Message);
                return;
            }

            if (Updated != null) Updated.Invoke(this, new EventArgs());
        }

        public Dictionary<string, object> GetSqlParameters(FieldModel[] fields)
        {
            Dictionary<string, object> dict = new Dictionary<string, object>();
            foreach (FieldModel field in Fields) {
                if (field.Control is HtmlImage) continue; // <img> are for display, not fields
                dict.Add(field.Name, GetValue(field));
            }
            return dict;
        }

        public string GetInsertCommand(FieldModel[] fields)
        {
            List<string> fieldNames = new List<string>();
            foreach (FieldModel field in Fields)
            {
                if (field.Control is HtmlImage) continue; // <img> are for display, not fields
                fieldNames.Add("@" + field.Name);
            }
            return $"INSERT INTO {TableName} VALUES (" + string.Join(", ", fieldNames) + ")";
        }

        public string GetUpdateCommand(FieldModel[] fields)
        {
            List<string> fieldNames = new List<string>();
            foreach (FieldModel field in Fields)
            {
                if (field.Control is HtmlImage) continue; // <img> are for display, not fields
                fieldNames.Add(field.Name + " = @" + field.Name);
            }
            if (IdFields != null)
            {
                string whereString = " WHERE";
                for (int i = 0; i < IdFields.Length; i++)
                    whereString += i == 0 ? $" {IdField} = '{IdValue}'" : $" AND {IdField} = '{IdValue}'";
                return $"UPDATE {TableName} SET " + string.Join(", ", fieldNames) + whereString;
            }
            return $"UPDATE {TableName} SET " + string.Join(", ", fieldNames) + $" WHERE {IdField} = '{IdValue}'";
        }

        public string GetDeleteCommand()
        {
            if (IdFields != null)
            {
                string whereString = " WHERE";
                for (int i = 0; i < IdFields.Length; i++)
                    whereString += i == 0 ? $" {IdField} = '{IdValue}'" : $" AND {IdField} = '{IdValue}'";
                return $"DELETE FROM {TableName}" + whereString;
            }
            return $"DELETE FROM {TableName} WHERE {IdField} = '{IdValue}'";
        }

        public void Delete(object sender = null, EventArgs e = null)
        {
            CancelEventArgs ce = new CancelEventArgs();
            if (Deleting != null) Deleting.Invoke(this, ce);
            if (ce.Cancel) return;

            try
            {
                SqlUtils.ExecuteNonQuery(GetDeleteCommand());
            }
            catch (Exception exc)
            {
                StatusBar.SetError("Có lỗi xảy ra: " + exc.Message);
                return;
            }
            StatusBar.SetSuccess("Xoá dữ liệu thành công.");
            
            if (Deleted != null) Deleted.Invoke(this, new EventArgs());
        }

        public void Load()
        {
            UpdateTable();
            if (page.IsPostBack) return;
            FillFields();
        }

        public void UpdateTable()
        {
            if (IdValue != null)
                Table = SqlUtils.Query($"SELECT * FROM {TableName} WHERE {IdField} = '{IdValue}'");
        }

        public void Clear(object sender = null, EventArgs e = null)
        {
            if (ReadOnlyFields != null)
                foreach (HtmlInputText ctl in ReadOnlyFields)
                    ctl.Disabled = false;
            foreach (FieldModel field in Fields)
            {
                HtmlControl ctl = field.Control;
                if (ctl is HtmlSelect) ((HtmlSelect)ctl).SelectedIndex = 0;
                else if (ctl is HtmlInputGenericControl) ((HtmlInputGenericControl)ctl).Value = "";
                else if (ctl is HtmlImage) { }
                else if (ctl is HtmlInputHidden) ((HtmlInputHidden)ctl).Value = "";
                else if (ctl is HtmlInputText) ((HtmlInputText)ctl).Value = "";
                else if (ctl is HtmlGenericControl) ((HtmlGenericControl)ctl).InnerText = "";
            }
        }

        public void FillFields(object sender = null, EventArgs e = null)
        {
            if (InsertMode) // If index is negative, go to insert mode
            {
                Clear(this, new EventArgs());
                return;
            }
            if (ReadOnlyFields != null)
                foreach (HtmlInputText ctl in ReadOnlyFields)
                    ctl.Disabled = true;
            foreach (FieldModel model in Fields)
                SetValue(model, Table.Rows[0].Field<object>(model.Name));
        }

        public string GetValue(FieldModel model)
        {
            if (model.Control is HtmlSelect) return ((HtmlSelect)model.Control).Value;
            else if (model.Control is HtmlInputGenericControl) return ((HtmlInputGenericControl)model.Control).Value;
            else if (model.Control is HtmlImage) return ((HtmlImage)model.Control).Src;
            else if (model.Control is HtmlInputHidden) return ((HtmlInputHidden)model.Control).Value;
            else if (model.Control is HtmlGenericControl) return ((HtmlGenericControl)model.Control).InnerText;
            else if (model.Control is HtmlInputText) return ((HtmlInputText)model.Control).Value;
            else if (model.Control is HtmlTextArea) return ((HtmlTextArea)model.Control).Value;
            return "";
        }

        public void SetValue(FieldModel model, object value)
        {
            if (model.Control is HtmlSelect)
            {
                if (value == null)
                    ((HtmlSelect)model.Control).SelectedIndex = -1;
                else
                    ((HtmlSelect)model.Control).Value = value.ToString();
            }
            else if (model.Control is HtmlInputGenericControl)
                ((HtmlInputGenericControl)model.Control).Value =
                    value is DateTime ?
                    ((DateTime)value).ToString("yyyy-MM-dd") :
                    value is TimeSpan ?
                    ((TimeSpan)value).ToString("HH:mm:ss") :
                    value.ToString();
            else if (model.Control is HtmlImage)
                ((HtmlImage)model.Control).Src = value.ToString();
            else if (model.Control is HtmlInputHidden)
                ((HtmlInputHidden)model.Control).Value = value.ToString();
            else if (model.Control is HtmlInputCheckBox)
                ((HtmlInputCheckBox)model.Control).Checked = (bool)value;
            else if (model.Control is HtmlInputRadioButton)
                ((HtmlInputRadioButton)model.Control).Checked = (bool)value;
            else if (model.Control is HtmlInputText)
                ((HtmlInputText)model.Control).Value = value.ToString();
            else if (model.Control is HtmlTextArea)
                ((HtmlTextArea)model.Control).Value = value.ToString();
            else if (model.Control is HtmlGenericControl)
                ((HtmlGenericControl)model.Control).InnerText = value.ToString();
        }

        public event CancelEventHandler Updating, Deleting;
        public event EventHandler Updated, Deleted;
    }
}