using QLyOcVit1.Model;
using System;
using System.Data;
using System.Globalization;
using System.Xml;
using System.Xml.Linq;

namespace QLyOcVit1.Model
{
    public class ChungLoaiModel
    {
        public string MaChungLoai, Name;
        public int Gia;
        
        public ChungLoaiModel(DataRow row)
        {
            MaChungLoai = row.Field<string>("MaChungLoai");
            Name = row.Field<string>("Ten");
            Gia = row.Field<int>("Gia");
        }
    }
}