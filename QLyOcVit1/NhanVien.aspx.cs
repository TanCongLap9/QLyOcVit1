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
using System.Text;
using System.Text.RegularExpressions;

namespace QLyOcVit1
{
    public partial class NhanVien : System.Web.UI.Page
    {
        protected List<NhanVienModel> Models = new List<NhanVienModel>();
        protected List<NhanVienModel> Results = new List<NhanVienModel>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.Cookies["QuanTri"] == null || Request.Cookies["QuanTri"].Value != "1")
                    Response.Redirect("LoaiSanPham.aspx");
            }

            DataTable table = SqlUtils.Query("SELECT * FROM NGUOIDUNG WHERE QuyenNhanVien = 1");
            foreach (DataRow row in table.Rows)
            {
                NhanVienModel model = new NhanVienModel(row);
                Models.Add(model);
            }
            for (int i = 0; i < Models.Count; i++)
            {
                var model = Models[i];
                if (!string.IsNullOrEmpty(Request.QueryString["q"]))
                {
                    // Tìm mã, tên sản phẩm không phân biệt hoa thường, dấu
                    string searchString = new Regex("[\u0300-\u036f]").Replace(Request.QueryString["q"].ToLower().Normalize(NormalizationForm.FormD).Replace("đ", "d"), "");
                    string tenSP = new Regex("[\u0300-\u036f]").Replace(model.Name.ToLower().Normalize(NormalizationForm.FormD).Replace("đ", "d"), "");
                    string maSP = new Regex("[\u0300-\u036f]").Replace(model.MaNV.ToLower().Normalize(NormalizationForm.FormD).Replace("đ", "d"), "");
                    if (!tenSP.Contains(searchString) && !maSP.Contains(searchString)) continue;
                }
                Results.Add(model);
            }
        }
    }
}