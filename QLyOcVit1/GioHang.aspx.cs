using System;
using QLyOcVit1.Catalog;
using QLyOcVit1.Model;
using System.Collections;
using System.Data;
using System.Collections.Generic;
using QLyOcVit1.Catalog;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Data.SqlClient;

namespace QLyOcVit1
{
    public partial class GioHang : System.Web.UI.Page {
        protected StatusBar statusBar;
        protected int tong = 0;
        public string MaND { get; set; }
        public List<GioHangModel> Models = new List<GioHangModel>();

        protected void Page_Load(object sender, EventArgs e) {
            statusBar = new StatusBar(alertBox, alertIcon, alertText);
            if (!Page.IsPostBack)
            {
                if (Request.Cookies["MaND"] == null || string.IsNullOrEmpty(Request.Cookies["MaND"].Value))
                    Response.Redirect("DangNhap.aspx");
            }

            MaND = Request.Cookies["MaND"].Value;
            DataTable table = SqlUtils.Query("PROC_GIOHANG_DANHSACH", new Dictionary<string, object>
            {
                ["MaND"] = MaND
            }, null, CommandType.StoredProcedure);
            foreach (DataRow row in table.Rows)
            {
                GioHangModel model = new GioHangModel(row);
                Models.Add(model);
            }

            TinhTong();
        }

        private void TinhTong()
        {
            tong = 0;
            foreach (GioHangModel model in Models)
                tong += model.Gia * model.SoLuong;
        }

        protected void ThanhToan(object sender, EventArgs e)
        {
            List<string> cacMaHD = new List<string>();
            foreach (DataRow row in SqlUtils.Query("SELECT Ma FROM HOADON").Rows)
                cacMaHD.Add(row.Field<string>("Ma"));
            string maHoaDon = IdUtils.MaHoaDon(cacMaHD);
            SqlTransaction trans = SqlUtils.Open().BeginTransaction();
            int rowsAffected = 0;
            try
            {
                // Thêm hóa đơn
                rowsAffected += SqlUtils.ExecuteNonQuery(trans,
                    "INSERT INTO HOADON VALUES (@MaHoaDon, NULL, @MaKH, @PhuongThuc, 0)",
                    new Dictionary<string, object>
                    {
                        ["MaHoaDon"] = maHoaDon,
                        ["PhuongThuc"] = tienMat.Checked ? 0 : theTinDung.Checked ? 1 : viDienTu.Checked ? 2 : 3,
                        ["MaKH"] = Request.Cookies["MaND"].Value,
                    });
                // Thêm chi tiết hóa đơn
                foreach (GioHangModel model in Models)
                {
                    rowsAffected += SqlUtils.ExecuteNonQuery(trans,
                        "INSERT INTO CHITIETHOADON VALUES (@MaHoaDon, @MaSP, @MaChungLoai, @SoLuong)",
                        new Dictionary<string, object>
                        {
                            ["MaHoaDon"] = maHoaDon,
                            ["MaSP"] = model.MaSP,
                            ["MaChungLoai"] = model.MaChungLoai,
                            ["SoLuong"] = model.SoLuong,
                        });
                }
                // Bỏ giỏ hàng
                rowsAffected += SqlUtils.ExecuteNonQuery(trans, "DELETE FROM GIOHANG WHERE MaND = @MaND", new Dictionary<string, object>
                {
                    ["MaND"] = Request.Cookies["MaND"].Value
                });
                trans.Commit();
                SqlUtils.Conn.Close();
                
            }
            catch (Exception exc)
            {
                trans.Rollback();
                statusBar.SetError("Không thể thanh toán: " + exc.Message);
            }

            if (rowsAffected != 0)
                Response.Redirect($"XemHoaDon.aspx?id={maHoaDon}");
            else
                statusBar.SetError("Không thể thanh toán.");
        }

        protected void Xoa(object sender, EventArgs e)
        {
            try
            {
                int rowsAffected = SqlUtils.ExecuteNonQuery(
                    "DELETE FROM GIOHANG WHERE MaSP = @MaSP AND MaChungLoai = @MaChungLoai",
                    new Dictionary<string, object>
                    {
                        ["MaSP"] = maSanPham.Value,
                        ["MaChungLoai"] = maChungLoai.Value,
                    }
                );
                if (rowsAffected != 0)
                {
                    foreach (GioHangModel model in Models)
                        if (model.MaSP == maSanPham.Value && model.MaChungLoai == maChungLoai.Value)
                        {
                            Models.Remove(model);
                            TinhTong();
                            break;
                        }
                    statusBar.SetSuccess("Xoá thành công.");
                }
                else
                    statusBar.SetError("Không thể xoá.");
            }
            catch (Exception exc)
            {
                statusBar.SetError("Không thể xoá: " + exc.Message);
            }
        }
    }
}