<%@ Page Title="Quản lý nhân viên" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="QuanLyHoaDon.aspx.cs" Inherits="QLyOcVit1.QuanLyHoaDon" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <a id="back" href='HoaDon.aspx' class="btn btn-link d-inline-flex align-items-center">
        <span class="material-symbols-outlined">arrow_back</span>
        Quay về
        <span class="bg-primary underline-slide"></span>
    </a>
    <h2 id="sanphamHeading" class="text-center mb-4" runat="server">
        <%= fieldsBox.InsertMode ? "Thêm hoá đơn mới" : "Thông tin về hoá đơn" %>
    </h2>
    <form id="form1" runat="server">
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= maHD.ClientID %>">Mã hoá đơn</label>
            <input class="col-md-4 col-7 form-control" type="text" id="maHD" runat="server" placeholder="HDxxxxxx" disabled="" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvMaND" runat="server" ControlToValidate="maHD" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revMaND" runat="server" ControlToValidate="maHD" ErrorMessage="Mã nhân viên có dạng là HDxxxxxx, với mỗi x là mỗi chữ cái viết hoa hoặc chữ số" ValidationExpression="HD[A-Z0-9]{6}" Display="Dynamic"></asp:RegularExpressionValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= khachHang.ClientID %>">Khách hàng</label>
            <select class="col-md-4 col-7 form-control" id="khachHang" runat="server" datavaluefield="Ma" datatextfield="HoTen" disabled="">
            
            </select>
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvKhachHang" runat="server" ControlToValidate="nhanVien" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= nhanVien.ClientID %>">Nhân viên thanh toán</label>
            <select class="col-md-4 col-7 form-control" id="nhanVien" runat="server" datavaluefield="Ma" datatextfield="HoTen" disabled="">

            </select>
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvNhanVien" runat="server" ControlToValidate="nhanVien" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= phuongThuc.ClientID %>">Phương thức</label>
            <select class="col-md-4 col-7 form-control" id="phuongThuc" runat="server" datavaluefield="Item1" datatextfield="Item2" disabled="">

            </select>
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvPhuongThuc" runat="server" ControlToValidate="phuongThuc" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= khachTra.ClientID %>">Tiền khách trả</label>
            <input class="col-md-4 col-7 form-control" type="number" id="khachTra" runat="server" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvKhachTra" runat="server" ControlToValidate="khachTra" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="rngKhachTra" runat="server" ControlToValidate="khachTra" Type="Integer" ErrorMessage="Tiền khách trả phải lớn hơn hoặc bằng 0." MinimumValue="0" MaximumValue="2147483647" Display="Dynamic"></asp:RangeValidator>
            </span>
        </div>
        
        <div class="d-flex justify-content-center my-3">
            <button id="luu" class="btn btn-primary btn-lg d-none" runat="server">
                <span class="material-symbols-outlined mr-1">edit</span>
                Lưu
            </button>

            <button id="luu_fake" type="button" class="btn btn-primary btn-lg d-flex align-items-center mx-1" onclick="confirmInsert()">
                <span class="material-symbols-outlined mr-1">edit</span>
                Lưu
            </button>
        </div>
    </form>
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
    <div id="alertBox" class="alert" runat="server" visible="false">
        <div class="alert-dismissible">
            <a class="close" href="#" data-dismiss="alert"></a>
        </div>
        <div class="d-flex align-items-center">
            <span id="alertIcon" class="material-symbols-outlined mr-2" runat="server"></span>
            <span id="alertText" runat="server"></span>
        </div>
    </div>
    <script>
        var insertMode = <%= fieldsBox.InsertMode ? "true" : "false" %>;
        function confirmInsert() {
            if (!validateInput()) return;
            $("#<%= luu.ClientID %>").click();
        }
        function clearStatus() {
            $(".input-error").text("");
        }
        function setError(jq, text) {
            jq.parent().find(".input-error").text(text);
        }
        function validateInput() {
            var valid = true;
            clearStatus();
            return valid;
        }
    </script>
</asp:Content>