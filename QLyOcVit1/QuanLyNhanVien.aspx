<%@ Page Title="Quản lý nhân viên" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="QuanLyNhanVien.aspx.cs" Inherits="QLyOcVit1.QuanLyNhanVien" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <a id="back" href='NhanVien.aspx' class="btn btn-link d-inline-flex align-items-center">
        <span class="material-symbols-outlined">arrow_back</span>
        Quay về
        <span class="bg-primary underline-slide"></span>
    </a>
    <h2 id="sanphamHeading" class="text-center mb-4" runat="server">
        <%= fieldsBox.InsertMode ? "Thêm nhân viên mới" : "Thông tin về nhân viên" %>
    </h2>
    <form id="form1" runat="server">
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= maNV.ClientID %>">Mã nhân viên</label>
            <input class="col-md-4 col-7 form-control" type="text" id="maNV" runat="server" placeholder="NDVxxxxx" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvMaND" runat="server" ControlToValidate="maNV" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revMaND" runat="server" ControlToValidate="maNV" ErrorMessage="Mã nhân viên có dạng là NDVxxxxx, với mỗi x là mỗi chữ cái viết hoa hoặc chữ số" ValidationExpression="NDV[A-Z0-9]{5}" Display="Dynamic"></asp:RegularExpressionValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= tenNV.ClientID %>">Họ tên nhân viên</label>
            <input class="col-md-4 col-7 form-control" type="text" id="tenNV" runat="server" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvTenND" runat="server" ControlToValidate="tenNV" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
            </span>
        </div>
        <div class="row align-items-center">
            <label class="col-md-2 col-5 col-form-label" for="<%= gioiTinh.ClientID %>">Giới tính</label>
            <select class="col-md-4 col-7 form-control" id="gioiTinh" runat="server">
                <option value="false" selected="selected">Nam</option>
                <option value="true">Nữ</option>
            </select>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= email.ClientID %>">Email</label>
            <input class="col-md-4 col-7 form-control" type="text" id="email" runat="server" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="email" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="email" ErrorMessage="Email không đúng dạng." ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic"></asp:RegularExpressionValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= sdt.ClientID %>">SĐT</label>
            <input class="col-md-4 col-7 form-control" type="text" id="sdt" runat="server" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvSDT" runat="server" ControlToValidate="sdt" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revSDT" runat="server" ControlToValidate="sdt" ErrorMessage="Số điện thoại từ 9 tới 11 chữ số." ValidationExpression="\d{9,11}" Display="Dynamic"></asp:RegularExpressionValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= ngaySinh.ClientID %>">Ngày sinh</label>
            <input class="col-md-4 col-7 form-control" type="date" id="ngaySinh" runat="server" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvNgaySinh" runat="server" ControlToValidate="ngaySinh" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cmvNgaySinh" runat="server" ControlToValidate="ngaySinh" ErrorMessage="Ngày sinh không đúng dạng." Operator="DataTypeCheck" Type="Date" Display="Dynamic"></asp:CompareValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= taiKhoan.ClientID %>">Tài khoản</label>
            <input class="col-md-4 col-7 form-control" type="text" id="taiKhoan" runat="server" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvTaiKhoan" runat="server" ControlToValidate="taiKhoan" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= matKhau.ClientID %>">Mật khẩu mới</label>
            <input class="col-md-4 col-7 form-control" type="password" id="matKhau" runat="server" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <%  if (fieldsBox.InsertMode)
                    { %>
                        <asp:RequiredFieldValidator ID="rfvMatKhau" runat="server" ControlToValidate="matKhau" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                <%  } %>
            </span>
        </div>
        <div class="row d-none">
            <label class="col-md-2 col-5 col-form-label" for="<%= quyenNhanVien.ClientID %>">Quyền nhân viên</label>
            <input class="col-md-4 col-7 form-control" type="text" id="quyenNhanVien" runat="server" />
        </div>
        <div class="d-flex justify-content-center my-3">
            <button id="moi_fake" type="button" class="btn btn-success btn-lg d-flex align-items-center mx-1" data-toggle="modal" data-target="#xacNhanLamMoi">
                <span class="material-symbols-outlined mr-1">add</span>
                Mới
            </button>
        
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
    <div id="alertBox" class="alert" runat="server" visible="false">
        <div class="alert-dismissible">
            <a class="close" href="#" data-dismiss="alert"></a>
        </div>
        <div class="d-flex align-items-center">
            <span id="alertIcon" class="material-symbols-outlined mr-2" runat="server"></span>
            <span id="alertText" runat="server"></span>
        </div>
    </div>
    <div class="modal fade" id="xacNhanLamMoi">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Thêm khách hàng mới</h3>
                    <span class="close" data-dismiss="modal">&times;</span>
                </div>
                <div class="modal-body">
                    <p>Bạn có muốn thêm khách hàng mới không? Các dữ liệu đang nhập sẽ bị huỷ.</p>
                </div>
                <div class="modal-footer">
                    <a href="?id=-1" class="btn btn-success">Có</a>
                    <button class="btn btn-secondary" data-dismiss="modal">Không</button>
                </div>
            </div>
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