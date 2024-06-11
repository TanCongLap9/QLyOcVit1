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
    public partial class XemHoaDon : System.Web.UI.Page {
        public string MaHoaDon { get; set; }
        protected XemHoaDonModel Model;
        protected long ThanhTien = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            MaHoaDon = Request.QueryString["id"];
            if (MaHoaDon == null) Response.Redirect("LoaiSanPham.aspx");
            DataTable table1 = SqlUtils.Query("SELECT HOADON.Ma, MaKH, HoTen AS HoTenKH, PhuongThuc FROM HOADON JOIN NGUOIDUNG ON HOADON.MaKH = NGUOIDUNG.Ma WHERE HOADON.Ma = @MaHoaDon",
                new Dictionary<string, object>
                {
                    ["MaHoaDon"] = MaHoaDon
                });
            if (table1.Rows.Count == 0) Response.Redirect("LoaiSanPham.aspx");
            Model = new XemHoaDonModel(table1.Rows[0]);
            Model.ChiTiet = new List<ChiTietHoaDonModel>();
            DataTable table2 = SqlUtils.Query(@"SELECT CHITIETHOADON.MaSP, SANPHAM.Ten AS TenSP, CHUNGLOAI.Ma AS MaChungLoai, CHUNGLOAI.Ten AS TenChungLoai, CHITIETHOADON.SoLuong, Gia FROM CHITIETHOADON
JOIN SANPHAM ON CHITIETHOADON.MaSP = SANPHAM.Ma
JOIN CHUNGLOAI ON CHITIETHOADON.MaChungLoai = CHUNGLOAI.Ma
JOIN CHITIETCHUNGLOAI ON CHITIETHOADON.MaChungLoai = CHITIETCHUNGLOAI.MaChungLoai AND CHITIETHOADON.MaSP = CHITIETCHUNGLOAI.MaSP WHERE MaHD = @MaHoaDon",
                new Dictionary<string, object>
                {
                    ["MaHoaDon"] = MaHoaDon
                });
            foreach (DataRow row in table2.Rows)
            {
                ChiTietHoaDonModel chiTietModel = new ChiTietHoaDonModel(row);
                Model.ChiTiet.Add(chiTietModel);
                ThanhTien += chiTietModel.Gia * chiTietModel.SoLuong;
            }
        }
    }
}