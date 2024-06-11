<%@ Page Title="Đăng nhập" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="DangNhap.aspx.cs" Inherits="QLyOcVit1.DangNhap" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-8 col-12">
            <form runat="server">
                <div class="card mb-4">
                    <div class="card-header">
                        <h2 class="text-center">Đăng nhập</h2>
                    </div>
                    <div class="card-body">
                        <div class="d-flex flex-column">
                            <div class="input-group form-group">
                                <div class="input-group-prepend">
                                    <p class="input-group-text">
                                        <span class="material-symbols-outlined">person</span>
                                        Tài khoản
                                    </p>
                                </div>
                                <input id="username" type="text" class="form-control" name="taikhoan" placeholder="Nhập tài khoản" runat="server" required="required" />
                            </div>
                            <div class="input-group form-group">
                                <div class="input-group-prepend">
                                    <p class="input-group-text">
                                        <span class="material-symbols-outlined">password</span>
                                        Mật khẩu
                                    </p>
                                </div>
                                <input id="password" type="password" class="form-control" name="matkhau" placeholder="Nhập mật khẩu" runat="server" required="required" />
                            </div>
                        </div>
                    </div>
                    <div class="card-footer d-flex justify-content-end">
                        <div class="btn-group">
                            <input type="submit" id="btnLogin" name="login" value="Đăng nhập" class="btn btn-primary" runat="server" onserverclick="btnLogin_ServerClick" />
                            <a href="DangKy.aspx" class="btn btn-info">Đăng ký</a>
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
        </div>
    </div>
</asp:Content>
