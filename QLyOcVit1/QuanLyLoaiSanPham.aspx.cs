using System;
using System.Collections;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QLyOcVit1.Model;
using System.Xml;
using System.Web.UI.HtmlControls;
using System.ComponentModel;

namespace QLyOcVit1
{
    public partial class QuanLyLoaiSanPham : System.Web.UI.Page
    {
        public FieldsBox fieldsBox;
        public StatusBar statusBar;
        private List<string> cacMa = new List<string>();
        
        protected void Page_Load(object sender, EventArgs e) {
            if (!IsPostBack)
            {
                if (Request.Cookies["QuanTri"] == null || Request.Cookies["QuanTri"].Value != "1")
                    Response.Redirect("LoaiSanPham.aspx");
            }
            statusBar = new StatusBar(alertBox, alertIcon, alertText);
            fieldsBox = new FieldsBox("LOAISANPHAM")
            {
                page = this,
                Fields = new[] {
                    new FieldModel("Ma", maSP),
                    new FieldModel("Ten", tenSP),
                    new FieldModel("Hinh", hinh),
                    new FieldModel("Hinh", hinhSanPham)
                },
                ReadOnlyFields = new List<HtmlInputText> { maSP },
                UpdateButton = luu,
                StatusBar = statusBar,
                IdField = "MaLoai",
                IdValue = Request.QueryString["id"]
            };
            fieldsBox.Updating += ValidateInput;
            fieldsBox.Load();

            DataTable DocKhachHang = SqlUtils.Query("SELECT * FROM LOAISANPHAM");
            foreach (DataRow row in DocKhachHang.Rows)
                cacMa.Add(row.Field<string>("Ma"));
        }

        private void ValidateInput(object sender, CancelEventArgs e)
        {
            if (fieldsBox.InsertMode)
            {
                if (cacMa.Contains(maSP.Value))
                {
                    statusBar.SetError($"Mã bị trùng. Vui lòng nhập mã khác. Gợi ý: {IdUtils.MaLoai(cacMa)}");
                    e.Cancel = true;
                    return;
                }
            }
        }
    }
}