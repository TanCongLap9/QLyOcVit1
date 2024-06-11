using System;
using System.Collections;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QLyOcVit1.Model;
using QLyOcVit1.Catalog;
using System.Xml;
using System.Web.UI.HtmlControls;
using System.ComponentModel;
using System.Globalization;

namespace QLyOcVit1
{
    public partial class XemSanPham : System.Web.UI.Page {
        private StatusBar statusBar;
        public string MaSP { get; set; }
        public XemSanPhamModel Model;

        protected void Page_Load(object sender, EventArgs e)
        {
            MaSP = Request.QueryString["id"];
            if (MaSP == null) Response.Redirect("LoaiSanPham.aspx");
            DataTable table1 = SqlUtils.Query("PROC_SANPHAM_XEMSANPHAM", new Dictionary<string, object>
            {
                ["MaSP"] = MaSP
            }, null, CommandType.StoredProcedure);
            if (table1.Rows.Count == 0) Response.Redirect("LoaiSanPham.aspx");
            Model = new XemSanPhamModel(table1.Rows[0]);
            Model.ChungLoai = new List<ChungLoaiModel>();
            DataTable table2 = SqlUtils.Query("PROC_SANPHAM_XEMCHITIET", new Dictionary<string, object>
            {
                ["MaSP"] = MaSP
            }, null, CommandType.StoredProcedure);
            foreach (DataRow row in table2.Rows)
                Model.ChungLoai.Add(new ChungLoaiModel(row));

            chinhSua.Visible = (Request.Cookies["QuanTri"] != null) && (Request.Cookies["QuanTri"].Value == "1");
            statusBar = new StatusBar(alertBox, alertIcon, alertText);
            if (!IsPostBack)
            {
                mua.Disabled = Model.SoLuong == 0;
                chinhSua.HRef += Request.QueryString["id"];
            }
        }

        protected void Mua(object sender, EventArgs e)
        {
            if (Request.Cookies["MaND"] == null || string.IsNullOrEmpty(Request.Cookies["MaND"].Value))
                Response.Redirect("DangNhap.aspx");
            try
            {

                Dictionary<string, object> sqlParameters = new Dictionary<string, object>
                {
                    ["MaND"] = Request.Cookies["MaND"].Value,
                    ["MaSP"] = Model.MaSP,
                    ["MaChungLoai"] = maChungLoai.Value,
                    ["SoLuong"] = soLuongMua.Value
                };
                if (SqlUtils.Query("SELECT MaChungLoai FROM GIOHANG WHERE MaND = @MaND AND MaSP = @MaSP AND MaChungLoai = @MaChungLoai", sqlParameters).Rows.Count != 0)
                { // Chủng loại đã có trong giỏ hàng
                    SqlUtils.ExecuteNonQuery("UPDATE GIOHANG SET SoLuong = SoLuong + @SoLuong WHERE MaND = @MaND AND MaSP = @MaSP AND MaChungLoai = @MaChungLoai", sqlParameters);
                }
                else
                { // Chủng loại chưa có trong giỏ hàng
                    SqlUtils.ExecuteNonQuery("INSERT INTO GIOHANG VALUES (@MaND, @MaSP, @MaChungLoai, @SoLuong);", sqlParameters);
                }
                statusBar.SetSuccess("Đặt sản phẩm thành công. Nhấn vào mục Giỏ hàng để biết các sản phẩm đã đặt.");
                maChungLoai.Value = string.Empty;
            }
            catch (Exception exc)
            {
                statusBar.SetError("Có lỗi xảy ra trong lúc đặt sản phẩm: " + exc.Message);
            }
        }
    }
}