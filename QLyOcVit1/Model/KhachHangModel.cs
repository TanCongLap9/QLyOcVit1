using QLyOcVit1.Model;
using System;
using System.Data;
using System.Xml;
using System.Xml.Linq;

namespace QLyOcVit1.Model
{
    public class KhachHangModel
    {
        public string MaKH, Name, Email, SDT, TaiKhoan, MatKhau;
        public DateTime NgaySinh;
        public bool GioiTinh;
        
        public KhachHangModel(DataRow row)
        {
            MaKH = row.Field<string>("Ma");
            Name = row.Field<string>("HoTen");
            GioiTinh = row.Field<bool>("GioiTinh");
            Email = row.Field<string>("Email");
            SDT = row.Field<string>("SDT");
            TaiKhoan = row.Field<string>("TaiKhoan");
            MatKhau = row.Field<string>("MatKhau");
        }
    }
}