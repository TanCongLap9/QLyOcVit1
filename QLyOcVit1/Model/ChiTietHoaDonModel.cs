using QLyOcVit1.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Xml;
using System.Xml.Linq;

namespace QLyOcVit1.Model
{
    public class ChiTietHoaDonModel
    {
        public string MaSP, TenSP, MaChungLoai, TenChungLoai;
        public int SoLuong, Gia, Tong;
        
        public ChiTietHoaDonModel(DataRow row)
        {
            MaSP = row.Field<string>("MaSP");
            TenSP = row.Field<string>("TenSP");
            MaChungLoai = row.Field<string>("MaChungLoai");
            TenChungLoai = row.Field<string>("TenChungLoai");
            SoLuong = row.Field<int>("SoLuong");
            Gia = row.Field<int>("Gia");
            Tong = SoLuong * Gia;
        }
    }
}