<%@ Page Title="Thông tin về sản phẩm" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="XemHoaDon.aspx.cs" Inherits="QLyOcVit1.XemHoaDon" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <a id="back" href="LoaiSanPham.aspx" class="btn btn-link d-inline-flex align-items-center">
        <span class="material-symbols-outlined">arrow_back</span>
        Quay về
        <span class="bg-primary underline-slide"></span>
    </a>
    <h2 class="text-center mb-4">Thông tin về hoá đơn</h2>    
    <p>Mã hoá đơn: <%= Model.MaHoaDon %></p>
    <p>Khách hàng: <%= Model.HoTenKH %></p>
    <p>Phương thức: <%= Model.PhuongThuc == 0 ? "Tiền mặt" :
                        Model.PhuongThuc == 1 ? "Thẻ tín dụng" :
                        Model.PhuongThuc == 2 ? "Ví điện tử" :
                        "Phương thức khác" %></p>
    <div>
        <p>Chi tiết:</p>
        <table id="cacChungLoai" class="table table-striped table-hover table-primary">
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Chủng loại</th>
                    <th>Số lượng</th>
                    <th>Đơn giá</th>
                    <th>Tổng</th>
                </tr>
            </thead>
            <tbody>
        <%  foreach (var chiTiet in Model.ChiTiet)
            { %>
                <tr>
                    <td><%= chiTiet.TenSP %></td>
                    <td><%= chiTiet.TenChungLoai %></td>
                    <td><%= chiTiet.SoLuong %></td>
                    <td><%= chiTiet.Gia.ToString("n0") %> &#x20ab;</td>
                    <td><%= chiTiet.Tong.ToString("n0") %> &#x20ab;</td>
                </tr>
        <%  } %>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="4">Thành tiền</th>
                    <td><%= ThanhTien.ToString("n0") %> &#x20ab;</td>
                </tr>
            </tfoot>
        </table>
    </div>
    <p>Cảm ơn quý khách đã đặt hàng trên cửa hàng bán bu lông ốc vít Power 5E.</p>
</asp:Content>