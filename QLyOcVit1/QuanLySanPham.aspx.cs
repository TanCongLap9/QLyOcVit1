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
    public partial class QuanLySanPham : System.Web.UI.Page
    {
        public FieldsBox fieldsBox;
        public StatusBar statusBar;
        public XemSanPhamInfo info;
        private List<string> cacMa = new List<string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            info = new XemSanPhamInfo(Request.QueryString["id"]);
            if (!IsPostBack)
            {
                if (Request.Cookies["QuanTri"] == null || Request.Cookies["QuanTri"].Value != "1")
                    Response.Redirect("LoaiSanPham.aspx");
                loai.DataSource = SqlUtils.Query("SELECT Ma, Ten FROM LOAISANPHAM");
                loai.DataBind();
                nhaSanXuat.DataSource = SqlUtils.Query("SELECT Ma, Ten FROM NHAPHANPHOI");
                nhaSanXuat.DataBind();
            }
            statusBar = new StatusBar(alertBox, alertIcon, alertText);
            fieldsBox = new FieldsBox("SANPHAM")
            {
                page = this,
                Fields = new[] {
                    new FieldModel("Ma", maSP),
                    new FieldModel("Ten", tenSP),
                    new FieldModel("Hinh", hinh),
                    new FieldModel("Hinh", hinhSanPham),
                    new FieldModel("MoTa", moTa),
                    new FieldModel("XuatXu", xuatXu),
                    new FieldModel("SoLuong", soLuong),
                    new FieldModel("MaLoai", loai),
                    new FieldModel("MaNPP", nhaSanXuat)
                },
                ReadOnlyFields = new List<HtmlInputText> { maSP },
                UpdateButton = luu,
                StatusBar = statusBar,
                IdField = "Ma",
                IdValue = Request.QueryString["id"]
            };
            fieldsBox.Updating += ValidateInput;
            fieldsBox.Load();

            if (fieldsBox.InsertMode)
                soLuong.Value = "0";

            DataTable DocKhachHang = SqlUtils.Query("SELECT * FROM SANPHAM");
            foreach (DataRow row in DocKhachHang.Rows)
                cacMa.Add(row.Field<string>("Ma"));
        }

        private void ValidateInput(object sender, CancelEventArgs e)
        {
            if (fieldsBox.InsertMode)
            {
                if (cacMa.Contains(maSP.Value))
                {
                    statusBar.SetError($"Mã bị trùng. Vui lòng nhập mã khác. Gợi ý: {IdUtils.MaSP(cacMa)}");
                    e.Cancel = true;
                    return;
                }
            }
        }
    }
}