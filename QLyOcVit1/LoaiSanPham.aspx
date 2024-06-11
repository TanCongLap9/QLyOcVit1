<%@ Page Title="Danh sách loại sản phẩm" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="LoaiSanPham.aspx.cs" Inherits="QLyOcVit1.LoaiSanPham" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2 class="text-center mb-4">Danh sách loại sản phẩm</h2>
    <div class="d-flex justify-content-end">
        <form class="w-100 mb-2" style="max-width: 300px;">
            <div class="input-group">
                <input id="timKiem" type="text" class="form-control" name="q" value="<%= Request.QueryString["q"] %>" placeholder="Tìm theo mã hoặc tên loại sản phẩm" />
                <div class="input-group-append">
                    <button class="input-group-text btn btn-primary"><span class="material-symbols-outlined">search</span></button>
                </div>
            </div>
        </form>
    </div>
    <div id="cacSp" class="row catalog" runat="server">
     <% foreach (var model in Results)
        { %>
            <div class='col-lg-3 col-md-4 col-12 p-1'>
                <div class='card'>
                    <img class="card-img-top" src="<%= model.Hinh %>" />
                    <div class='card-body'>
                        <h5><%= model.Name %></h5>
                        <a class='stretched-link' href='/SanPham.aspx?MaLoai=<%= model.MaLoai %>'></a>
                    </div>
                </div>
            </div>
     <% } %>
     <% if (Request.Cookies["QuanTri"] != null && Request.Cookies["QuanTri"].Value == "1" && string.IsNullOrEmpty(Request.QueryString["q"])) { %>
            <div class='col-lg-3 col-md-4 col-12 p-1'>
                <div class='card bg-success'>
                    <span class='card-img-top material-symbols-outlined-filled d-flex justify-content-center align-items-center' style='width: 100%; height: auto; aspect-ratio: 1; font-size: 120px;'>add_circle</span>
                    <div class='card-body'>
                        <h4>Thêm loại sản phẩm</h4>
                        <p>Nhấn vào đây để thêm loại sản phẩm</p>
                        <a class='stretched-link' href='/QuanLyLoaiSanPham.aspx'></a>
                    </div>
                </div>
            </div>
     <% }
        else if (!string.IsNullOrEmpty(Request.QueryString["q"]) && Results.Count == 0) { %>
            <div class='col-12'>
                <h4 class='text-center'>Không có kết quả.</h4>
            </div>
     <% } %>
    </div>
</asp:Content>