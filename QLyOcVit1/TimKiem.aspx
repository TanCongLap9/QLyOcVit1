<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TimKiem.aspx.cs" Inherits="QLyOcVit1.TimKiem" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:GridView ID="GridView1" runat="server" SelectedIndex="0" AutoGenerateSelectButton="True" SelectedRowStyle-BackColor="Black" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" style="display: none;">
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <Columns>
                <asp:BoundField DataField="MaSP" HeaderText="Mã sản phẩm" />
                <asp:BoundField DataField="TenSP" HeaderText="Tên sản phẩm" />
                <asp:TemplateField HeaderText="Hình">
                    <ItemTemplate>
                        <img src="<%# Eval("Hinh") %>" width="64" height="64" alt="Hình" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="DonGia" HeaderText="Đơn giá" />
                <asp:BoundField DataField="TGBH" HeaderText="Thời gian bảo hành" />
                <asp:BoundField DataField="MoTa" HeaderText="Mô tả" />
                <asp:BoundField DataField="SoLuongTon" HeaderText="Số lượng tồn" />
                <asp:BoundField DataField="DVT" HeaderText="Đơn vị tính" />
                <asp:BoundField DataField="DanhGia" HeaderText="Đánh giá" />
                <asp:TemplateField HeaderText="Nhà sản xuất">
                    <ItemTemplate>
                        
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EditRowStyle BackColor="#999999" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#E2DED6" BorderColor="Black" BorderStyle="Solid" BorderWidth="2px" Font-Bold="True" ForeColor="#333333"></SelectedRowStyle>
            <SortedAscendingCellStyle BackColor="#E9E7E2" />
            <SortedAscendingHeaderStyle BackColor="#506C8C" />
            <SortedDescendingCellStyle BackColor="#FFFDF8" />
            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
        </asp:GridView>
    </form>
</body>
</html>
