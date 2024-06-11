using System;
using System.Xml;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace QLyOcVit1
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool coTaiKhoan = Request.Cookies["MaND"] != null && !string.IsNullOrEmpty(Request.Cookies["MaND"].Value);
            bool quyenQuanTri = Request.Cookies["QuanTri"] != null && Request.Cookies["QuanTri"].Value == "1";
            dangNhap.Visible = !coTaiKhoan;
            dangXuat.Visible = coTaiKhoan;
            quanLy.Visible = quyenQuanTri;
        }

        protected string GetAccountName()
        {
            HttpCookie cookieMaND = Request.Cookies["MaND"];
            if (cookieMaND == null || string.IsNullOrEmpty(cookieMaND.Value)) return "Khách";
            
            try
            {
                DataTable table = SqlUtils.Query("SELECT Ma, HoTen FROM NGUOIDUNG WHERE Ma = @Ma", new Dictionary<string, object>
                {
                    ["Ma"] = cookieMaND.Value
                });
                if (table.Rows.Count != 0)
                    return table.Rows[0].Field<string>("HoTen");
            }
            catch (Exception)
            {
                
            }
            return "Khách";
        }
    }
}