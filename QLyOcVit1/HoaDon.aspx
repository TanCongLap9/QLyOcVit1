<%@ Page Title="Danh sách khách hàng" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="HoaDon.aspx.cs" Inherits="QLyOcVit1.HoaDon" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2 class="text-center mb-4">Danh sách hoá đơn</h2>
    <div class="d-flex justify-content-end">
        <form class="w-100 mb-2" style="max-width: 300px;">
            <div class="input-group">
                <input id="timKiem" type="text" class="form-control" name="q" value="<%= Request.QueryString["q"] %>" placeholder="Tìm theo mã hoá đơn hoặc họ tên khách hàng" />
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
                    <span class='card-img-top material-symbols-outlined-filled d-flex justify-content-center align-items-center' style='width: 100%; height: auto; aspect-ratio: 1; font-size: 120px;'>receipt_long</span>
                    <div class='card-body'>
                        <h4><%= model.MaHoaDon %></h4>
                        <p class="d-flex align-items-center"><span class='material-symbols-outlined mr-1'>person</span> <%= model.HoTenKH %></p>
                        <p class="d-flex align-items-center"><%= model.MaNV == null ? "Mới" : "" %></p>
                        <a class='stretched-link' href='/QuanLyHoaDon.aspx?id=<%= model.MaHoaDon %>'></a>
                    </div>
                </div>
            </div>
    <%  } %>
    <%  if (Request.Cookies["QuanTri"] != null && Request.Cookies["QuanTri"].Value == "1" && string.IsNullOrEmpty(Request.QueryString["q"]))
        { %>
    <%  }
        else if (!string.IsNullOrEmpty(Request.QueryString["q"]) && Results.Count == 0) { %>
            <div class='col-12'>
                <h4 class='text-center'>Không có kết quả.</h4>
            </div>
    <%  } %>
    </div>
</asp:Content>