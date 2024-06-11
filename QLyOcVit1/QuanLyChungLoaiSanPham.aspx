<%@ Page Title="Quản lý chủng loại" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="QuanLyChungLoaiSanPham.aspx.cs" Inherits="QLyOcVit1.QuanLyChungLoaiSanPham" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <a id="back" href='LoaiSanPham.aspx' class="btn btn-link d-inline-flex align-items-center">
        <span class="material-symbols-outlined">arrow_back</span>
        Quay về
        <span class="bg-primary underline-slide"></span>
    </a>
    <h2 id="sanphamHeading" class="text-center mb-4" runat="server">
        <%= fieldsBox.InsertMode ? "Thêm chủng loại mới" : "Thông tin về chủng loại" %>
    </h2>
    <form id="form1" runat="server">
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= maSP.ClientID %>">Mã sản phẩm</label>
            <input class="col-md-4 col-7 form-control" type="text" id="maSP" runat="server" disabled="" />
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= chungLoai.ClientID %>">Chủng loại</label>
            <select class="col-md-4 col-7 form-control" id="chungLoai" runat="server" datatextfield="Ten" datavaluefield="Ma"></select>
            <span class="col-md-6 col-12 input-error text-danger col-form-label"></span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= gia.ClientID %>">Giá</label>
            <input class="col-md-4 col-7 form-control" type="number" id="gia" runat="server" />
            <span>₫</span>
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvGia" runat="server" ControlToValidate="gia" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RangeValidator ID="rgvGia" runat="server" MinimumValue="0" MaximumValue="2147483647" ControlToValidate="gia" Display="Dynamic" />
            </span>
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

            <button type="button" id="luu_fake" class="btn btn-primary btn-lg d-flex align-items-center mx-1" onclick="confirmInsert()">
                <span class="material-symbols-outlined mr-1">edit</span>
                Lưu
            </button>
        
            <button id="xoa" class="btn btn-danger btn-lg d-none" runat="server">
                <span class="material-symbols-outlined mr-1">delete</span>
                Xoá
            </button>

            <button id="xoa_fake" type="button" class="btn btn-danger btn-lg d-flex align-items-center mx-1 <%= fieldsBox.InsertMode ? "disabled" : "" %>" data-toggle="modal" data-target="#xacNhanXoa">
                <span class="material-symbols-outlined mr-1">delete</span>
                Xoá
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
    <div class="modal fade" id="xacNhanXoa">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Xoá khách hàng</h3>
                    <span class="close" data-dismiss="modal">&times;</span>
                </div>
                <div class="modal-body">
                    <p>Bạn có muốn xoá dữ liệu này không?</p>
                </div>
                <div class="modal-footer">
                    <button onclick="$('#<%= xoa.ClientID %>').click()" class="btn btn-success">Có</button>
                    <button class="btn btn-secondary" data-dismiss="modal">Không</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="xacNhanLamMoi">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Thêm sản phẩm mới</h3>
                    <span class="close" data-dismiss="modal">&times;</span>
                </div>
                <div class="modal-body">
                    <p>Bạn có muốn thêm sản phẩm mới không? Các dữ liệu đang nhập sẽ bị huỷ.</p>
                </div>
                <div class="modal-footer">
                    <a href="?id=-1" class="btn btn-success">Có</a>
                    <button class="btn btn-secondary" data-dismiss="modal">Không</button>
                </div>
            </div>
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
            return valid;
        }
    </script>
</asp:Content>