<%@ Page Title="Giỏ hàng" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="GioHang.aspx.cs" Inherits="QLyOcVit1.GioHang" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2 class="text-center mb-4">Giỏ hàng</h2>
    <div id="cacSp" class="row catalog" runat="server">
     <% int current = 0;
        for (int i = 0; i < Models.Count; i++)
        {
            var model = Models[i]; %>
            <div class='col-lg-3 col-md-4 col-12 p-1'>
                <a href='/XemSanPham.aspx?id=<%= model.MaSP %>' style="color: inherit; text-decoration: none;">
                    <div class='card'>
                        <img class="card-img-top" src="<%= model.Hinh %>" />
                        <div class='card-body'>
                            <h5><%= model.TenSP %></h5>
                            <p><span class='material-symbols-outlined'>category</span> Chủng loại: <%= model.TenChungLoai %></p>
                            <p><span class='material-symbols-outlined'>sell</span> Đơn giá: <%= model.Gia.ToString("n0") %>₫</p>
                            <p><span class='material-symbols-outlined'>stack</span> Số lượng đặt: <%= model.SoLuong %></p>
                            <p><span class='material-symbols-outlined'>sell</span> Tổng: <%= model.Tong.ToString("n0") %>₫</p>
                        
                            <div class="d-block text-right">
                                <a class="btn btn-danger p-2 d-inline-flex justify-content-center align-items-center" href="#xacNhanXoa" onclick="
                                    $('#<%= maSanPham.ClientID %>').val(event.currentTarget.dataset.masp);
                                    $('#<%= maChungLoai.ClientID %>').val(event.currentTarget.dataset.machungloai);
                                " data-toggle="modal" data-machungloai="<%= model.MaChungLoai %>" data-masp="<%= model.MaSP %>">
                                    <span class="material-symbols-outlined text-white">delete</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </a>
            </div>
     <%     current++;
         }
        if (Models.Count == 0) { %>
            <div class='col-12 my-2 text-center'>
                <h4>Các sản phẩm đã đặt sẽ xuất hiện tại đây.</h4>
                <h4>Nhấn vào mục <a href="SanPham.aspx">Sản phẩm</a> để đặt mua.</h4>
            </div>
     <% }
        else { %>
            <div class='col-12 my-2'>
                <h4 class='text-center'>Tổng số tiền: <%= tong.ToString("n0") %>₫</h4>
            </div>
     <% } %>
    </div>
    <div class="d-flex justify-content-center my-3">
        <a href="#xacNhanThanhToan" class="btn btn-success btn-lg d-flex align-items-center mx-1 <%= Models.Count == 0 ? "disabled" : "" %>" data-toggle="modal">
            <span class="material-symbols-outlined mr-1">payments</span>
            Thanh toán
        </a>
    </div>
    <form runat="server">
        <div class="modal fade" id="xacNhanThanhToan">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3>Xác nhận thanh toán</h3>
                        <a href="#" class="close" data-dismiss="modal">&times;</a>
                    </div>
                    <div class="modal-body">
                        <p>Chọn phương thức thanh toán</p>
                        <input type="radio" name="phuongthuc" id="tienMat" value="0" checked="" runat="server" />
                        <label for="tienMat">Tiền mặt</label>
                        <br />
                        <input type="radio" name="phuongthuc" id="theTinDung" value="1" runat="server" />
                        <label for="theTinDung">Thẻ tín dụng</label>
                        <br />
                        <input type="radio" name="phuongthuc" id="viDienTu" value="2" runat="server" />
                        <label for="viDienTu">Ví điện tử</label>
                        <p>Quý khách kiểm tra lại thông tin về sản phẩm đã đặt trước khi nhấn nút thanh toán.</p>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-success" runat="server" onserverclick="ThanhToan">Thanh toán</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy bỏ</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="xacNhanXoa">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3>Xoá sản phẩm</h3>
                        <a href="#" class="close" data-dismiss="modal">&times;</a>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xoá sản phẩm này khỏi giỏ hàng không?</p>
                    </div>
                    <div class="modal-footer">
                        <input id="maSanPham" type="hidden" runat="server" />
                        <input id="maChungLoai" type="hidden" runat="server" />
                        <button class="btn btn-primary" runat="server" onserverclick="Xoa">Có</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Không</button>
                    </div>
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
</asp:Content>