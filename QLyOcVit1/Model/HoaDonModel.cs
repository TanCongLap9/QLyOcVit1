using QLyOcVit1.Model;
using System;
using System.Data;
using System.Xml;
using System.Xml.Linq;

namespace QLyOcVit1.Model
{
    public class HoaDonModel
    {
        public string MaHoaDon, MaKH, HoTenKH, MaNV, HoTenNV;
        public int PhuongThuc, KhachTra;
        
        public HoaDonModel(DataRow row)
        {
            MaHoaDon = row.Field<string>("Ma");
            MaKH = row.Field<string>("MaKH");
            HoTenKH = row.Field<string>("HoTenKH");
            MaNV = row.Field<string>("MaNV");
            HoTenNV = row.Field<string>("HoTenNV");
            PhuongThuc = row.Field<int>("PhuongThuc");
            KhachTra = row.Field<int>("KhachTra");
        }
    }
}