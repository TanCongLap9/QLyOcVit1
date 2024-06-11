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
using QLyOcVit1.Catalog;

namespace QLyOcVit1
{
    public partial class QuanLyChungLoaiSanPham : System.Web.UI.Page
    {
        public FieldsBox fieldsBox;
        public StatusBar statusBar;
        public XemSanPhamInfo info;
        private List<string>
            cacMaSP = new List<string>(),
            cacMaChungLoai = new List<string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            info = new XemSanPhamInfo(Request.QueryString["id"]);
            if (!IsPostBack)
            {
                if (Request.Cookies["QuanTri"] == null || Request.Cookies["QuanTri"].Value != "1")
                    Response.Redirect("LoaiSanPham.aspx");
                chungLoai.DataSource = SqlUtils.Query("SELECT Ma, Ten FROM CHUNGLOAI");
                chungLoai.DataBind();
            }
            statusBar = new StatusBar(alertBox, alertIcon, alertText);
            fieldsBox = new FieldsBox("SANPHAM")
            {
                page = this,
                Fields = new[] {
                    new FieldModel("MaSP", maSP),
                    new FieldModel("MaChungLoai", chungLoai),
                    new FieldModel("Gia", gia)
                },
                ReadOnlyFields = new List<HtmlInputText> { maSP },
                UpdateButton = luu,
                StatusBar = statusBar,
                IdFields = new string[] { "MaSP", "MaChungLoai" },
                IdValues = new string[] { Request.QueryString["MaSP"], Request.QueryString["MaChungLoai"] }
            };
            fieldsBox.Updating += ValidateInput;
            fieldsBox.Load();

            DataTable DocNhanVien = SqlUtils.Query("SELECT * FROM CHITIETCHUNGLOAI WHERE MaSP = @MaSP", new Dictionary<string, object> {
                ["MaSP"] = Request.QueryString["MaSP"]
            });
            foreach (DataRow row in DocNhanVien.Rows)
                cacMaChungLoai.Add(row.Field<string>("Ma"));
        }

        private void ValidateInput(object sender, CancelEventArgs e)
        {
            if (fieldsBox.InsertMode)
            {
                if (cacMaSP.Contains(maSP.Value))
                {
                    statusBar.SetError($"Mã bị trùng. Vui lòng nhập mã khác. Gợi ý: {IdUtils.MaChungLoai(cacMaChungLoai)}");
                    e.Cancel = true;
                    return;
                }
            }
        }
    }
}