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
    public class GioHangModel
    {
        public string MaSP, MaChungLoai, TenSP, TenChungLoai, Hinh;
        public int SoLuong, Gia, Tong;

        public GioHangModel(DataRow row)
        {
            MaSP = row.Field<string>("MaSP");
            MaChungLoai = row.Field<string>("MaChungLoai");
            Hinh = row.Field<string>("Hinh");
            TenSP = row.Field<string>("TenSP");
            TenChungLoai = row.Field<string>("TenChungLoai");
            SoLuong = row.Field<int>("SoLuong");
            Gia = row.Field<int>("Gia");
            Tong = row.Field<int>("Tong");
        }
    }
}