<%@ Page Title="Đăng ký" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="DangKy.aspx.cs" Inherits="QLyOcVit1.DangKy" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <a id="back" href="DangNhap.aspx" class="btn btn-link d-inline-flex align-items-center">
        <span class="material-symbols-outlined">arrow_back</span>
        Quay về
        <span class="bg-primary underline-slide"></span>
    </a>
    <h2 class="text-center mb-4" runat="server">Đăng ký</h2>
    <form id="form1" runat="server">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <input type="text" id="maKH" runat="server" class="form-control d-none" />
                <input type="number" id="quyenNhanVien" runat="server" class="form-control d-none" />
                <div class="row">
                    <label class="col-md-3 col-6 col-form-label" for="tenKH">Họ tên</label>
                    <input class="col-md-3 col-6 form-control" type="text" id="tenKH" runat="server" />
                    <span class="col-md-6 col-12 input-error text-danger col-form-label">
                        <asp:RequiredFieldValidator ID="rfvTenKH" runat="server" ControlToValidate="tenKH" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                    </span>
                </div>
                <div class="row">
                    <label class="col-md-3 col-6 col-form-label" for="gioiTinh">Giới tính</label>
                    <select class="col-md-3 col-6 form-control" id="gioiTinh" runat="server">
                        <option value="false" selected="selected">Nam</option>
                        <option value="true">Nữ</option>
                    </select>
                </div>
                <div class="row">
                    <label class="col-md-3 col-6 col-form-label" for="email">Email</label>
                    <input class="col-md-3 col-6 form-control" type="text" id="email" runat="server" placeholder="khachhang@email.com" />
                    <span class="col-md-6 col-12 input-error text-danger col-form-label">
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="email" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="email" ErrorMessage="Email không đúng dạng." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic"></asp:RegularExpressionValidator>
                    </span>
                </div>
                <div class="row">
                    <label class="col-md-3 col-6 col-form-label" for="sdt">SĐT</label>
                    <input class="col-md-3 col-6 form-control" type="text" id="sdt" runat="server" placeholder="0901234567" />
                    <span class="col-md-6 col-12 input-error text-danger col-form-label">
                        <asp:RequiredFieldValidator ID="rfvSDT" runat="server" ControlToValidate="sdt" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revSDT" runat="server" ControlToValidate="sdt" ErrorMessage="Số điện thoại từ 9 tới 11 chữ số." ValidationExpression="\d{9,11}" Display="Dynamic"></asp:RegularExpressionValidator>
                    </span>
                </div>
                <div class="row">
                    <label class="col-md-3 col-6 col-form-label" for="ngaySinh">Ngày sinh</label>
                    <input class="col-md-3 col-6 form-control" type="date" id="ngaySinh" runat="server" />
                    <span class="col-md-6 col-12 input-error text-danger col-form-label">
                        <asp:RequiredFieldValidator ID="rfvNgaySinh" runat="server" ControlToValidate="ngaySinh" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="cmvNgaySinh" runat="server" ControlToValidate="ngaySinh" ErrorMessage="Ngày sinh không đúng dạng." Operator="DataTypeCheck" Type="Date" Display="Dynamic"></asp:CompareValidator>
                    </span>
                </div>
                <div class="row">
                    <label class="col-md-3 col-6 col-form-label" for="taiKhoan">Tài khoản</label>
                    <input class="col-md-3 col-6 form-control" type="text" id="taiKhoan" runat="server" />
                    <span class="col-md-6 col-12 input-error text-danger col-form-label">
                        <asp:RequiredFieldValidator ID="rfvTaiKhoan" runat="server" ControlToValidate="taiKhoan" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                    </span>
                </div>
                <div class="row">
                    <label class="col-md-3 col-6 col-form-label" for="matKhau">Mật khẩu</label>
                    <input class="col-md-3 col-6 form-control" type="password" id="matKhau" runat="server" />
                    <span class="col-md-6 col-12 input-error text-danger col-form-label">
                        <asp:RequiredFieldValidator ID="rfvMatKhau" runat="server" ControlToValidate="matKhau" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revMatKhau" runat="server" ControlToValidate="matKhau" ErrorMessage="Vui lòng ghi mật khẩu với ít nhất 5 ký tự chữ thường, CHỮ HOA hoặc số." ValidationExpression="\w{5,}" Display="Dynamic"></asp:RegularExpressionValidator>
                    </span>
                </div>
                <div class="row">
                    <label class="col-md-3 col-6 col-form-label" for="xacNhanMatKhau">Nhập lại Mật khẩu</label>
                    <input class="col-md-3 col-6 form-control" type="password" id="xacNhanMatKhau" runat="server" />
                    <span class="col-md-6 col-12 input-error text-danger col-form-label">
                        <asp:RequiredFieldValidator ID="rfvXacNhanMatKhau" runat="server" ControlToValidate="xacNhanMatKhau" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="cmpXacNhanMatKhau" runat="server" ControlToValidate="xacNhanMatKhau" ErrorMessage="Vui lòng ghi lại mật khẩu đúng với mật khẩu đã nhập trước đó." Operator="Equal" ControlToCompare="matKhau" Display="Dynamic"></asp:CompareValidator>
                    </span>
                </div>
                <div class="d-flex justify-content-center my-3">
                    <button id="luu" class="btn btn-primary d-none" runat="server">
                        <span class="material-symbols-outlined mr-1">edit</span>
                        Tạo
                    </button>

                    <button id="luu_fake" type="button" class="btn btn-primary btn-lg d-flex align-items-center" onclick="confirmInsert()">
                        <span class="material-symbols-outlined mr-1">edit</span>
                        Tạo
                    </button>
                </div>
            </div>
        </div>
    </form>
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
            $(".input-error").text("");
            return valid;
        }
    </script>
</asp:Content>