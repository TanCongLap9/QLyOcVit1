using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace QLyOcVit1
{
    public partial class DangNhap : System.Web.UI.Page
    {
        private StatusBar statusBar;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies.Get("MaND") != null && !string.IsNullOrEmpty(Request.Cookies.Get("MaND").Value))
                Response.Redirect("SanPham.aspx");
            statusBar = new StatusBar(alertBox, alertIcon, alertText);
        }

        protected void btnLogin_ServerClick(object sender, EventArgs e)
        {
            try
            {
                foreach (DataRow row in SqlUtils.Query("SELECT Ma, TaiKhoan, MatKhau, QuyenNhanVien FROM NGUOIDUNG").Rows)
                {
                    if (username.Value == row.Field<string>("TaiKhoan") && PasswordEncoder.Encode(row.Field<string>("Ma"), password.Value) == row.Field<string>("MatKhau"))
                    {
                        Response.Cookies.Set(new HttpCookie("MaND", row.Field<string>("Ma")) { Expires = DateTime.Now.AddDays(7) });
                        Response.Cookies.Set(new HttpCookie("QuanTri", row.Field<bool>("QuyenNhanVien") ? "1" : "0") { Expires = DateTime.Now.AddDays(7) });
                        Response.Redirect("SanPham.aspx");
                    }
                }
                statusBar.SetError("Tài khoản hoặc mật khẩu nhập không đúng.");
            }
            catch (Exception exc)
            {
                statusBar.SetError("Có lỗi xảy ra trong lúc đăng nhập: " + exc.Message);
            }
        }
    }
}