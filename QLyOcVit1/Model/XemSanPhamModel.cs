using QLyOcVit1.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Xml;
using System.Xml.Linq;

namespace QLyOcVit1.Model
{
    public class XemSanPhamModel
    {
        public string MaSP, Name, Hinh, DonGia, XuatXu, TenLoai, TenNPP, DiaChiNPP, SDTNPP, MoTa;
        public int SoLuong;
        public List<ChungLoaiModel> ChungLoai;
        
        public XemSanPhamModel(DataRow row)
        {
            MaSP = row.Field<string>("Ma");
            Name = row.Field<string>("Ten");
            Hinh = row.Field<string>("Hinh");
            MoTa = row.Field<string>("MoTa");
            DonGia = row.Field<string>("Gia");
            SoLuong = row.Field<int>("SoLuong");
            XuatXu = row.Field<string>("XuatXu");
            TenLoai = row.Field<string>("TenLoai");
            TenNPP = row.Field<string>("TenNPP");
            DiaChiNPP = row.Field<string>("DiaChi");
            SDTNPP = row.Field<string>("Sdt");
        }
    }
}