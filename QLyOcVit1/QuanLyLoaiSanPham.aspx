<%@ Page Title="Quản lý loại sản phẩm" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="QuanLyLoaiSanPham.aspx.cs" Inherits="QLyOcVit1.QuanLyLoaiSanPham" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <a id="back" href='<%= Request.RawUrl.Replace("QuanLyLoaiSanPham.aspx", "XemSanPham.aspx") %>' class="btn btn-link d-inline-flex align-items-center">
        <span class="material-symbols-outlined">arrow_back</span>
        Quay về
        <span class="bg-primary underline-slide"></span>
    </a>
    <h2 id="sanphamHeading" class="text-center mb-4" runat="server">
        <%= fieldsBox.InsertMode ? "Thêm loại sản phẩm mới" : "Thông tin về loại sản phẩm" %>
    </h2>
    <form id="form1" runat="server">
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= maSP.ClientID %>">Mã loại</label>
            <input class="col-md-4 col-7 form-control" type="text" id="maSP" runat="server" placeholder="LSxxxxxx" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvMaLoai" runat="server" ControlToValidate="maSP" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revMaLoai" runat="server" ControlToValidate="maSP" ErrorMessage="Loại sản phẩm có dạng là LSxxxxxx, với mỗi x là mỗi chữ cái viết hoa hoặc chữ số" ValidationExpression="LS[A-Z0-9]{6}" Display="Dynamic"></asp:RegularExpressionValidator>
            </span>
        </div>
        <div class="row">
            <label class="col-md-2 col-5 col-form-label" for="<%= tenSP.ClientID %>">Tên loại</label>
            <input class="col-md-4 col-7 form-control" type="text" id="tenSP" runat="server" />
            <span class="col-md-6 col-12 input-error text-danger col-form-label">
                <asp:RequiredFieldValidator ID="rfvTenLoai" runat="server" ControlToValidate="tenSP" ErrorMessage="Đây là thông tin bắt buộc." Display="Dynamic"></asp:RequiredFieldValidator>
            </span>
        </div>
        <div class="row align-items-center">
            <label class="col-md-2 col-5 col-form-label" for="<%= hinh.ClientID %>">Hình</label>
            <input class="col-md-4 col-7 form-control" type="text" id="hinh" runat="server" onblur="autoLoadImg()" />
            <img class="col-auto" src="" id="hinhSanPham" width="64" height="64" alt="Hình" runat="server" />
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
        function autoLoadImg() {
            $("#<%= hinhSanPham.ClientID %>").attr("src", $("#<%= hinh.ClientID %>").val());
        }
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