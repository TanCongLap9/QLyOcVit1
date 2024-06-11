<%@ Page Title="Thông tin về sản phẩm" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="XemSanPham.aspx.cs" Inherits="QLyOcVit1.XemSanPham" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <a id="back" href="LoaiSanPham.aspx" class="btn btn-link d-inline-flex align-items-center">
        <span class="material-symbols-outlined">arrow_back</span>
        Quay về
        <span class="bg-primary underline-slide"></span>
    </a>
    <div id="alertBox" class="alert" runat="server" visible="false">
        <div class="alert-dismissible">
            <a class="close" href="#" data-dismiss="alert"></a>
        </div>
        <div class="d-flex align-items-center">
            <span id="alertIcon" class="material-symbols-outlined mr-2" runat="server"></span>
            <span id="alertText" runat="server"></span>
        </div>
    </div>
    <h2 class="text-center mb-4">Thông tin về sản phẩm</h2>
    <div class="row">
        <div class="col-md-3 col-12 d-flex align-items-center">
            <img src="<%= Model.Hinh %>" alt="Hình" class="img-thumbnail" style="aspect-ratio: 1;" />
        </div>
        <div class="col-md-9 col-12">
            <h4><%= Model.Name %></h4>
            <p class="text-danger h5"><%= Model.DonGia %></p>
            <p class='<%= Model.SoLuong > 0 ? "text-success" : "text-danger" %>'>
                <%= Model.SoLuong > 0 ? $"Còn {Model.SoLuong} sản phẩm" : "Đã hết hàng" %>
            </p>
            <p>Xuất xứ: <%= Model.XuatXu %></p>
            <p>Nhà phân phối: <%= Model.TenNPP %></p>
        </div>
    </div>
    <div>
        <p>Các chủng loại:</p>
        <table id="cacChungLoai" class="table table-striped table-hover table-primary">
            <thead>
                <tr>
                    <th>Mã chủng loại</th>
                    <th>Chủng loại</th>
                    <th>Giá</th>
                </tr>
            </thead>
            <tbody>
        <%  foreach (var chungLoai in Model.ChungLoai)
            { %>
                <tr>
                    <td class="machungloai"><%= chungLoai.MaChungLoai %></td>
                    <td><%= chungLoai.Name %></td>
                    <td><%= chungLoai.Gia.ToString("n0") %>₫</td>
                </tr>
        <%  } %>
            </tbody>
        </table>
    </div>
    <h4>Mô tả</h4>
    <p><%= Model.MoTa %></p>
    <form id="formMua" runat="server">
        <asp:RequiredFieldValidator ID="rfvMaChungLoai" runat="server" ControlToValidate="maChungLoai" ErrorMessage="Vui lòng chọn chủng loại cần đặt" CssClass="text-danger" />
        <input type="text" id="maChungLoai" class="d-none" name="machungloai" runat="server" />
        <div class="row justify-content-center">
            <label class="col-auto col-form-label" for="<%= soLuongMua.ClientID %>">Số lượng cần mua: </label>
            <input class="col-2 form-control" type="number" id="soLuongMua" runat="server" value="1" min="1" />
        </div>
        <div class="d-flex justify-content-center my-3">
            <button id="mua" class="btn btn-success btn-lg d-flex align-items-center mx-1" runat="server" onserverclick="Mua">
                <span class="material-symbols-outlined mr-1">shopping_cart</span>
                Mua
            </button>

            <a id="chinhSua" href='QuanLySanPham.aspx?id=' class="btn btn-primary btn-lg d-flex align-items-center mx-1" runat="server">
                <span class="material-symbols-outlined mr-1">build</span>
                Sửa
            </a>
        </div>
    </form>
    <script>
        $(document).ready(() => {
            console.log($("#cacChungLoai tr"));
            $("#cacChungLoai tr").click((a) => {
                $("#<%= maChungLoai.ClientID %>").val(
                    $(a.currentTarget).find(".machungloai").text()
                );
                $("#cacChungLoai tr").removeClass("table-active");
                $(a.currentTarget).addClass("table-active");
            });
        });
    </script>
</asp:Content>