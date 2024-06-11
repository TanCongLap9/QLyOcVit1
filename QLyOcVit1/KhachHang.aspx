<%@ Page Title="Danh sách khách hàng" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="KhachHang.aspx.cs" Inherits="QLyOcVit1.KhachHang" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2 class="text-center mb-4">Danh sách khách hàng</h2>
    <div class="d-flex justify-content-end">
        <form class="w-100 mb-2" style="max-width: 300px;">
            <div class="input-group">
                <input id="timKiem" type="text" class="form-control" name="q" value="<%= Request.QueryString["q"] %>" placeholder="Tìm theo mã hoặc họ tên" />
                <div class="input-group-append">
                    <button class="input-group-text btn btn-primary"><span class="material-symbols-outlined">search</span></button>
                </div>
            </div>
        </form>
    </div>
    <div id="cacSp" class="row catalog" runat="server">
    <%  foreach (var model in Results)
        { %>
            <div class='col-lg-3 col-md-4 col-12 p-1'>
                <div class='card'>
                    <span class='card-img-top material-symbols-outlined-filled d-flex justify-content-center align-items-center' style='width: 100%; height: auto; aspect-ratio: 1; font-size: 120px;'>person</span>
                    <div class='card-body'>
                        <h4><%= model.Name %></h4>
                        <p class="d-flex align-items-center"><span class='material-symbols-outlined mr-1'>key</span> <%= model.MaKH %></p>
                        <a class='stretched-link' href='/QuanLyKhachHang.aspx?id=<%= model.MaKH %>'></a>
                    </div>
                </div>
            </div>
    <%  } %>
    <%  if (Request.Cookies["QuanTri"] != null && Request.Cookies["QuanTri"].Value == "1" && string.IsNullOrEmpty(Request.QueryString["q"]))
        { %>
            <div class='col-lg-3 col-md-4 col-12 p-1'>
                <div class='card bg-success'>
                    <span class='card-img-top material-symbols-outlined-filled d-flex justify-content-center align-items-center' style='width: 100%; height: auto; aspect-ratio: 1; font-size: 120px;'>add_circle</span>
                    <div class='card-body'>
                        <h5>Thêm khách hàng</h5>
                        <p>Nhấn vào đây để thêm khách hàng</p>
                        <a class='stretched-link' href='/QuanLyKhachHang.aspx'></a>
                    </div>
                </div>
            </div>
    <%  }
        else if (!string.IsNullOrEmpty(Request.QueryString["q"]) && Results.Count == 0) { %>
            <div class='col-12'>
                <h4 class='text-center'>Không có kết quả.</h4>
            </div>
    <%  } %>
    </div>
</asp:Content>