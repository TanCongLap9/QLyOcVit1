using QLyOcVit1;
using QLyOcVit1.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Xml;
using System.Xml.Linq;

namespace QLyOcVit1.Model
{
    public class SanPhamModel
    {
        public string MaSP, Name, Hinh, DonGia;
        public int SoLuongTon;
        
        public SanPhamModel(DataRow row)
        {
            MaSP = row.Field<string>("Ma");
            Name = row.Field<string>("Ten");
            Hinh = row.Field<string>("Hinh");
            SoLuongTon = row.Field<int>("SoLuong");
            DonGia = row.Field<string>("Gia");
        }
    }
}