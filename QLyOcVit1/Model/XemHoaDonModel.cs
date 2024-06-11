using QLyOcVit1.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Xml;
using System.Xml.Linq;

namespace QLyOcVit1.Model
{
    public class XemHoaDonModel
    {
        public string MaHoaDon, MaKH, HoTenKH;
        public int PhuongThuc;
        public List<ChiTietHoaDonModel> ChiTiet;
        
        public XemHoaDonModel(DataRow row)
        {
            MaHoaDon = row.Field<string>("Ma");
            MaKH = row.Field<string>("MaKH");
            HoTenKH = row.Field<string>("HoTenKH");
            PhuongThuc = row.Field<int>("PhuongThuc");
        }
    }
}