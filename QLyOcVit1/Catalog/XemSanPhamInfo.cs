using System;
using QLyOcVit1.Model;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.Data;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Schema;
using QLyOcVit1;

namespace QLyOcVit1.Catalog
{
    public class XemSanPhamInfo
    {
        public string MaSP { get; set; }
        public XemSanPhamModel Model;

        public XemSanPhamInfo(string maSP)
        {
            MaSP = maSP;
            if (MaSP == null) return;
            DataTable table1 = SqlUtils.Query("PROC_SANPHAM_XEMSANPHAM", new Dictionary<string, object>
            {
                ["MaSP"] = MaSP
            }, null, CommandType.StoredProcedure);
            if (table1.Rows.Count == 0) return;
            Model = new XemSanPhamModel(table1.Rows[0]);
            Model.ChungLoai = new List<ChungLoaiModel>();
            DataTable table2 = SqlUtils.Query("PROC_SANPHAM_XEMCHITIET", new Dictionary<string, object>
            {
                ["MaSP"] = MaSP
            }, null, CommandType.StoredProcedure);
            foreach (DataRow row in table2.Rows)
                Model.ChungLoai.Add(new ChungLoaiModel(row));
        }
    }
}