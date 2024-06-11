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
    public partial class LoaiSanPham : System.Web.UI.Page {
        protected List<LoaiSanPhamModel> Models = new List<LoaiSanPhamModel>();
        protected List<LoaiSanPhamModel> Results = new List<LoaiSanPhamModel>();

        protected void Page_Load(object sender, EventArgs e) {
            DataTable table = SqlUtils.Query("SELECT * FROM LOAISANPHAM");
            foreach (DataRow row in table.Rows)
            {
                LoaiSanPhamModel model = new LoaiSanPhamModel(row);
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
                    string maSP = new Regex("[\u0300-\u036f]").Replace(model.MaLoai.ToLower().Normalize(NormalizationForm.FormD).Replace("đ", "d"), "");
                    if (!tenSP.Contains(searchString) && maSP != searchString) continue;
                }
                Results.Add(model);
            }
        }
    }
}