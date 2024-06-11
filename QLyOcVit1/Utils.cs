using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;

namespace QLyOcVit1
{
    public static class Validator
    {

        public static string Email(string email)
        {
            return new Regex(@"^[a-zA-Z0-9_-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*(?:\.[a-z]{2,3})$").IsMatch(email) ?
                null :
                "Email không đúng dạng.";
        }

        public static string Sdt(string sdt)
        {
            return new Regex(@"^0\d{8,10}$").IsMatch(sdt) ?
                null :
                "Vui lòng nhập đúng dạng với từ 9 tới 11 chữ số.";
        }

        public static string MatKhau(string matKhau)
        {
            return matKhau.Length > 5 &&
                new Regex("[a-z]").IsMatch(matKhau) &&
                new Regex("[A-Z]").IsMatch(matKhau) &&
                new Regex("[0-9]").IsMatch(matKhau) ?
                null :
                "Mật khẩu phải hơn 5 ký tự với chữ thường, chữ hoa và cả chữ số.";
        }

        public static string TaiKhoan(DataTable table, string taiKhoan)
        {
            foreach (DataRow row in table.Rows)
                if (row.Field<string>("TenDangNhap") == taiKhoan)
                    return "Tài khoản này đã được sử dụng.";
            return null;
        }

        public static string Id(DataTable table, string idFieldName, string id)
        {
            foreach (DataRow row in table.Rows)
                if (row.Field<string>(idFieldName) == id)
                    return "Mã bị trùng - Vui lòng nhập mã khác.";
            return null;
        }
    }

    public static class SqlUtils
    {
        public static readonly SqlConnection Conn = new SqlConnection("Data Source=localhost; Initial Catalog=QLYOCVIT; Integrated Security=True");

        public static void BuildConnection(string dataSource, int mode, string userId, string password)
        {
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            builder.DataSource = dataSource;
            builder.MultipleActiveResultSets = true;
            builder.InitialCatalog = "QLYOCVIT";
            if (mode != 0)
            {
                builder.UserID = userId;
                builder.Password = password;
            }
            else
                builder.IntegratedSecurity = true;
            Conn.ConnectionString = builder.ConnectionString;
        }

        #region Sync functions

        public static SqlConnection Open()
        {
            if (Conn.State != ConnectionState.Open) Conn.Open();
            return Conn;
        }

        public static object ExecuteScalar(string commStr, Dictionary<string, object> parameters = null, CommandType commandType = CommandType.Text)
        {
            SqlConnection conn = Open();
            object result;
            try
            {
                SqlCommand comm = new SqlCommand(commStr, conn)
                {
                    CommandType = commandType
                };
                if (parameters != null)
                    foreach (KeyValuePair<string, object> param in parameters)
                        comm.Parameters.AddWithValue(param.Key, param.Value);
                result = comm.ExecuteScalar();
            }
            finally
            {
                conn.Close();
            }
            return result;
        }
        
        public static int ExecuteNonQuery(string commStr, Dictionary<string, object> parameters = null, CommandType commandType = CommandType.Text)
        {
            SqlConnection conn = Open();
            try
            {
                SqlCommand comm = new SqlCommand(commStr, conn) {
                    CommandType = commandType
                };
                if (parameters != null)
                    foreach (KeyValuePair<string, object> param in parameters)
                        comm.Parameters.AddWithValue(param.Key, param.Value);
                int rowsAffected = comm.ExecuteNonQuery();
                return rowsAffected;
            }
            finally
            {
                conn.Close();
            }
        }
        
        public static int ExecuteNonQuery(SqlTransaction transaction, string commStr, Dictionary<string, object> parameters = null, CommandType commandType = CommandType.Text)
        {
            SqlConnection conn = transaction.Connection;
            try
            {
                SqlCommand comm = new SqlCommand(commStr, conn, transaction)
                {
                    CommandType = commandType
                };
                if (parameters != null)
                    foreach (KeyValuePair<string, object> param in parameters)
                        comm.Parameters.AddWithValue(param.Key, param.Value);
                int rowsAffected = comm.ExecuteNonQuery();
                return rowsAffected;
            }
            finally
            {
                //conn.Close();
            }
        }
        
        public static DataTable Query(string commStr, Dictionary<string, object> parameters = null, DataTable table = null, CommandType commandType = CommandType.Text)
        {
            SqlConnection conn = Open();
            try
            {
                SqlCommand comm = new SqlCommand(commStr, conn)
                {
                    CommandType = commandType
                };
                if (parameters != null)
                    foreach (KeyValuePair<string, object> param in parameters)
                        comm.Parameters.AddWithValue(param.Key, param.Value);
                if (table == null) table = new DataTable();
                else
                {
                    table.Clear();
                    table.Columns.Clear();
                }
                SqlDataAdapter adapter = new SqlDataAdapter(comm);
                adapter.Fill(table);
                return table;
            }
            finally
            {
                conn.Close();
            }
        }

        public static DataTable Query(string commStr, object[] parameters = null, DataTable table = null, CommandType commandType = CommandType.Text)
        {
            SqlConnection conn = Open();
            try
            {
                SqlCommand comm = new SqlCommand(commStr, conn)
                {
                    CommandType = commandType
                };
                if (parameters != null)
                    foreach (object param in parameters)
                        comm.Parameters.Add(param);
                if (table == null) table = new DataTable();
                else
                {
                    table.Clear();
                    table.Columns.Clear();
                }
                SqlDataAdapter adapter = new SqlDataAdapter(comm);
                adapter.Fill(table);
                return table;
            }
            finally
            {
                conn.Close();
            }
        }

        public static SqlDataAdapter GetDataAdpater(string commStr, Dictionary<string, object> parameters = null, CommandType commandType = CommandType.Text, bool inferCommands = true)
        {
            SqlCommand comm = new SqlCommand(commStr, Conn)
            {
                CommandType = commandType
            };
            if (parameters != null)
                foreach (KeyValuePair<string, object> param in parameters)
                    comm.Parameters.AddWithValue(param.Key, param.Value);
            SqlDataAdapter adapter = new SqlDataAdapter(comm);
            if (inferCommands)
            {
                SqlCommandBuilder builder = new SqlCommandBuilder(adapter);
                adapter.UpdateCommand = builder.GetUpdateCommand();
                adapter.InsertCommand = builder.GetInsertCommand();
                adapter.DeleteCommand = builder.GetDeleteCommand();
            }
            return adapter;
        }
        
        public static DataTable Query(string commStr)
        {
            return Query(commStr, (object[])null);
        }

        public static SqlCommand GetCommand(string commStr, Dictionary<string, object> parameters = null, CommandType commandType = CommandType.Text)
        {
            SqlCommand comm = new SqlCommand(commStr, Conn)
            {
                CommandType = commandType
            };
            if (parameters != null)
                foreach (KeyValuePair<string, object> param in parameters)
                    comm.Parameters.AddWithValue(param.Key, param.Value);
            return comm;
        }

        #endregion
    }

    public static class IdUtils
    {
        public static char[]
            alnums = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".ToCharArray(),
            nums = "0123456789".ToCharArray();
        public static Random random = new Random();

        public static string RandomString(char[] range, int count)
        {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < count; i++)
                sb.Append(range[random.Next(range.Length)]);
            return sb.ToString();
        }

        public static string Ma(string tenMa, IList<string> except = null)
        {
            switch (tenMa)
            {
                case "MaNV":
                    return MaNV(except);
                case "MaKH":
                    return MaKH(except);
                case "MaHoaDon":
                    return MaHoaDon(except);
                case "MaChungLoai":
                    return MaChungLoai(except);
                case "MaSP":
                    return MaSP(except);
                case "MaPhieu":
                    return MaPhieu(except);
                case "MaNL":
                    return MaNL(except);
                case "MaLoai":
                    return MaLoai(except);
                case "MaPizza":
                    return MaPizza(except);
                case "MaQuyen":
                    return MaQuyen(except);
                default:
                    return string.Empty;
            }
        }

        public static string MaChungLoai(IList<string> except = null)
        {
            return Generate(() => "CL" + RandomString(alnums, 6), except);
        }

        public static string MaNV(IList<string> except = null)
        {
            return Generate(() => "NDV" + RandomString(alnums, 5), except);
        }
        
        public static string MaKH(IList<string> except = null)
        {
            return Generate(() => "NDK" + RandomString(alnums, 5), except);
        }

        public static string MaSP(IList<string> except = null)
        {
            return Generate(() => "SPS" + RandomString(alnums, 5), except);
        }

        public static string MaHoaDon(IList<string> except = null)
        {
            return Generate(() => "HD" + RandomString(alnums, 6), except);
        }

        public static string MaPhieu(IList<string> except = null)
        {
            return Generate(() => RandomString(alnums, 4) + "O", except);
        }

        public static string MaNL(IList<string> except = null)
        {
            return Generate(() => "NL" + RandomString(nums, 3), except);
        }

        public static string MaLoai(IList<string> except = null)
        {
            return Generate(() => "LS" + RandomString(nums, 6), except);
        }

        public static string MaPizza(IList<string> except = null)
        {
            return Generate(() => RandomString(alnums, 4) + "P", except);
        }

        public static string MaQuyen(IList<string> except = null)
        {
            return Generate(() => "QH" + RandomString(nums, 3), except);
        }

        public static string Generate(Func<string> generator, IList<string> except = null)
        {
            string result;
            do { result = generator.Invoke(); }
            while (except != null && except.Contains(result));
            return result;
        }
    }

    public static class PasswordEncoder
    {
        public const string SALT = "1q_X?8H%@2YZ[(06$NLflPMZg(<}M(`O'#%{Mk}?aZ$Z.O?Mf7eSf?vOc-/;`*iT";
        public static string Encode(string id, string password)
        {
            SHA256 sh2 = SHA256.Create();
            return string.Join("", sh2.ComputeHash(Encoding.UTF8.GetBytes(id + SALT + password))
                .Select(b => b.ToString("x2")));
        }
    }
}
