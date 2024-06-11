using QLyOcVit1.Model;
using System;
using System.Data;
using System.Globalization;
using System.Xml;
using System.Xml.Linq;

namespace QLyOcVit1.Model
{
    public class LoaiSanPhamModel
    {
        public string MaLoai, Name, Hinh;
        
        public LoaiSanPhamModel(DataRow row)
        {
            MaLoai = row.Field<string>("Ma");
            Name = row.Field<string>("Ten");
            Hinh = row.Field<string>("Hinh");
        }
    }
}