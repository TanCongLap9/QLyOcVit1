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
    public partial class DangKy : System.Web.UI.Page
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
                if (Request.Cookies.Get("TaiKhoan") != null && !string.IsNullOrEmpty(Request.Cookies.Get("TaiKhoan").Value))
                    Response.Redirect("SanPham.aspx");
                matKhau.Value = "";
            }
            statusBar = new StatusBar(alertBox, alertIcon, alertText);
            fieldsBox = new FieldsBox("NGUOIDUNG")
            {
                page = this,
                Fields = new[] {
                    new FieldModel("Ma", maKH),
                    new FieldModel("HoTen", tenKH),
                    new FieldModel("GioiTinh", gioiTinh),
                    new FieldModel("Email", email),
                    new FieldModel("SDT", sdt),
                    new FieldModel("NgaySinh", ngaySinh),
                    new FieldModel("TaiKhoan", taiKhoan),
                    new FieldModel("MatKhau", matKhau),
                    new FieldModel("QuyenNhanVien", quyenNhanVien)
                },
                ReadOnlyFields = new List<HtmlInputText> { maKH },
                UpdateButton = luu,
                StatusBar = statusBar,
                IdField = "Ma",
                IdValue = Request.QueryString["id"]
            };
            fieldsBox.Updating += ValidateInput;
            fieldsBox.Updated += OnSuccess;
            fieldsBox.Load();

            DataTable DocNhanVien = SqlUtils.Query("SELECT * FROM NGUOIDUNG");
            foreach (DataRow row in DocNhanVien.Rows)
            {
                cacMa.Add(row.Field<string>("Ma"));
                cacTaiKhoan.Add(row.Field<string>("TaiKhoan"));
            }
            quyenNhanVien.Value = "0";

            if (!fieldsBox.InsertMode)
                password = fieldsBox.Table.Rows[fieldsBox.Index].Field<string>("MatKhau");

            maKH.Value = IdUtils.MaKH(cacMa);
        }

        private void OnSuccess(object sender, EventArgs e)
        {
            statusBar.SetSuccess("Tạo tài khoản thành công. Vui lòng nhấn nút Quay về để đăng nhập.");
        }

        private void ValidateInput(object sender, CancelEventArgs e)
        {
            if (fieldsBox.InsertMode)
            {
                if (cacMa.Contains(maKH.Value))
                {
                    statusBar.SetError($"Mã khách hàng bị trùng với khách hàng khác. Vui lòng nhập mã khác. Gợi ý: {IdUtils.MaKH(cacMa)}");
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
                matKhau.Value = PasswordEncoder.Encode(maKH.Value, matKhau.Value);
        }
    }
}