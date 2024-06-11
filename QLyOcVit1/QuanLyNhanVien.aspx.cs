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
    public partial class QuanLyNhanVien : System.Web.UI.Page
    {
        public FieldsBox fieldsBox;
        public StatusBar statusBar;
        public string password;
        private List<string>
            cacMa = new List<string>(),
            cacTaiKhoan = new List<string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.Cookies["QuanTri"] == null || Request.Cookies["QuanTri"].Value != "1")
                    Response.Redirect("LoaiSanPham.aspx");
                matKhau.Value = "";
            }
            statusBar = new StatusBar(alertBox, alertIcon, alertText);
            fieldsBox = new FieldsBox("NGUOIDUNG")
            {
                page = this,
                Fields = new[] {
                    new FieldModel("Ma", maNV),
                    new FieldModel("HoTen", tenNV),
                    new FieldModel("GioiTinh", gioiTinh),
                    new FieldModel("Email", email),
                    new FieldModel("SDT", sdt),
                    new FieldModel("NgaySinh", ngaySinh),
                    new FieldModel("TaiKhoan", taiKhoan),
                    new FieldModel("MatKhau", matKhau),
                    new FieldModel("QuyenNhanVien", quyenNhanVien)
                },
                ReadOnlyFields = new List<HtmlInputText> { maNV },
                UpdateButton = luu,
                StatusBar = statusBar,
                IdField = "Ma",
                IdValue = Request.QueryString["id"]
            };
            fieldsBox.Updating += ValidateInput;
            fieldsBox.Load();

            DataTable DocKhachHang = SqlUtils.Query("SELECT * FROM NGUOIDUNG");
            foreach (DataRow row in DocKhachHang.Rows)
            {
                cacMa.Add(row.Field<string>("Ma"));
                cacTaiKhoan.Add(row.Field<string>("TaiKhoan"));
            }
            quyenNhanVien.Value = "1";
            if (!fieldsBox.InsertMode)
                password = fieldsBox.Table.Rows[0].Field<string>("MatKhau");
        }
        
        protected void ValidateInput(object sender, CancelEventArgs e)
        {
            if (fieldsBox.InsertMode)
            {
                if (cacMa.Contains(maNV.Value))
                {
                    statusBar.SetError($"Mã bị trùng. Vui lòng nhập mã khác. Gợi ý: {IdUtils.MaNV(cacMa)}");
                    e.Cancel = true;
                    return;
                }
                if (cacTaiKhoan.Contains(this.taiKhoan.Value))
                {
                    statusBar.SetError($"Tài khoản này đã có người sử dụng. Vui lòng nhập tài khoản khác.");
                    e.Cancel = true;
                    return;
                }
            }
            if (matKhau.Value == "")
                matKhau.Value = password;
            else
                matKhau.Value = PasswordEncoder.Encode(maNV.Value, matKhau.Value);
        }
    }
}