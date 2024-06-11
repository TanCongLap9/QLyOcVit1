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
    public partial class SanPham : System.Web.UI.Page {
        private string MaLoai { get; set; }
        protected List<SanPhamModel> Models = new List<SanPhamModel>();

        protected List<SanPhamModel> Results = new List<SanPhamModel>();

        protected void Page_Load(object sender, EventArgs e) {
            MaLoai = Request.QueryString["MaLoai"];
            DataTable table = SqlUtils.Query("PROC_SANPHAM_DANHSACH", new Dictionary<string, object>
            {
                ["MaLoai"] = MaLoai
            }, null, CommandType.StoredProcedure);
            foreach (DataRow row in table.Rows)
            {
                SanPhamModel model = new SanPhamModel(row);
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
                    string maSP = new Regex("[\u0300-\u036f]").Replace(model.MaSP.ToLower().Normalize(NormalizationForm.FormD).Replace("đ", "d"), "");
                    if (!tenSP.Contains(searchString) && maSP != searchString) continue;
                }
                Results.Add(model);
            }
        }
    }
}