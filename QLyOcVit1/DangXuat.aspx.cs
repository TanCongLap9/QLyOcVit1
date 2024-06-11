using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QLyOcVit1
{
    public partial class DangXuat : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cookies.Set(new HttpCookie("MaND", ""));
            Response.Cookies.Set(new HttpCookie("QuanTri", ""));
            Response.Redirect("DangNhap.aspx");
        }
    }
}