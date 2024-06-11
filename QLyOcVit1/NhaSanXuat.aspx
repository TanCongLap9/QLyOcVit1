<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NhaSanXuat.aspx.cs" Inherits="QLyOcVit1.NhaSanXuat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản lý nhà sản xuất</title>
    <style>
        .modify-button {
            display: flex;
            flex-flow: row;
            align-items: center;
            padding: 0px;
            padding-right: 6px;
            margin-right: 4px;
        }
        .delete-button {
            background-color: salmon;
            border: 1px solid firebrick;
        }
        .delete-button:hover {
            background-color: indianred;
        }
        .delete-button:active {
            background-color: firebrick;
        }
        .icon {
            padding: 6px;
            width: 28px;
            height: 28px;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .error-border {
            border: 2px solid red;
        }
        .error {
            background-color: lightcoral;
        }
        .success {
            background-color: lightgreen;
        }
        #alertBox {
            margin-top: 20px;
            padding: 10px;
            display: flex;
            flex-flow: row;
            align-items: center;
        }
        #alertText {
            margin: 0px;
        }
    </style>
</head>
<body>
    <h1 style="text-align: center;">Quản lý nhà sản xuất</h1>
    <form id="form1" runat="server">
        <asp:GridView ID="GridView1" runat="server" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" SelectedIndex="0" AutoGenerateSelectButton="True" SelectedRowStyle-BackColor="Black" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None">
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <Columns>
                <asp:BoundField DataField="MaNSX" HeaderText="Mã NSX" />
                <asp:BoundField DataField="TenNSX" HeaderText="Tên NSX" />
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
        <table>
            <tr>
                <td><asp:Label ID="Label1" runat="server" Text="Mã NSX"></asp:Label></td>
                <td><asp:TextBox ID="maNSX" runat="server" TextMode="Number" Width="50px"></asp:TextBox></td>
            </tr>
            <tr>
                <td><asp:Label ID="Label2" runat="server" Text="Tên NSX"></asp:Label></td>
                <td><asp:TextBox ID="tenNSX" runat="server"></asp:TextBox></td>
            </tr>
        </table>
        <div style="display: flex; flex-flow: row;">
            <button id="them" class="modify-button" runat="server" onserverclick="them_Click">
                <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" class="icon">
                    <g>
                        <ellipse style="stroke: black; fill: mediumseagreen;" cx="50" cy="50" rx="50" ry="50"></ellipse>
                        <line style="stroke: darkgreen; stroke-width: 10px;" x1="50" y1="25" x2="50" y2="75"></line>
                        <line style="stroke: darkgreen; stroke-width: 10px;" x1="25" y1="50" x2="75" y2="50"></line>
                    </g>
                </svg>
                Thêm
            </button>

            <button id="xoa" class="modify-button delete-button" runat="server" onserverclick='xoa_Click'>
                <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" class="icon">
                    <g>
                        <ellipse style="stroke: black; fill: indianred;" cx="50" cy="50" rx="50" ry="50"></ellipse>
                        <line style="stroke: maroon; stroke-width: 10px;" x1="27" y1="27" x2="72" y2="72"></line>
                        <line style="stroke: maroon; stroke-width: 10px;" x1="72" y1="27" x2="27" y2="72"></line>
                    </g>
                </svg>
                Xoá
            </button>
        
            <button id="sua" class="modify-button" runat="server" onserverclick="sua_Click">
                <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg" class="icon">
                    <g>
                        <circle style="stroke: black; fill: white;" cx="50" cy="50" r="50"></circle>
                        <polygon style="fill: deepskyblue; stroke: black;" points="20 20 65 20 80 35 80 80 20 80"/>
                        <rect x="30" y="20" width="25" height="15" style="fill: gainsboro; stroke: black;"></rect>
                        <rect x="45" y="21" width="5" height="11" style="fill: gray;"></rect>
                        <rect x="25" y="50" width="50" height="30" style="fill: gainsboro; stroke: black;"></rect>
                        <line x1="30" y1="56" x2="70" y2="56" style="stroke: black; stroke-linecap: round; stroke-width: 2px;"></line>
                        <line x1="30" y1="62" x2="70" y2="62" style="stroke: black; stroke-linecap: round; stroke-width: 2px;"></line>
                        <line x1="30" y1="68" x2="70" y2="68" style="stroke: black; stroke-linecap: round; stroke-width: 2px;"></line>
                        <line x1="30" y1="74" x2="70" y2="74" style="stroke: black; stroke-linecap: round; stroke-width: 2px;"></line>
                    </g>
                </svg>
                Sửa
            </button>
        </div>
    </form>
    <asp:Panel id="alertBox" runat="server">
        <svg id="success" runat="server" xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 -960 960 960" width="24"><path d="m424-296 282-282-56-56-226 226-114-114-56 56 170 170Zm56 216q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Zm0-320Z"/></svg>
        <svg id="error" runat="server" xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 -960 960 960" width="24"><path d="m336-280 144-144 144 144 56-56-144-144 144-144-56-56-144 144-144-144-56 56 144 144-144 144 56 56ZM480-80q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Zm0-320Z"/></svg>
        <asp:Label id="alertText" runat="server"></asp:Label>
    </asp:Panel>
    <script>
        function xacNhanXoa(e) {
            if (!confirm("Bạn có chắc chắn muốn xoá dữ liệu này không?")) {
                e.preventDefault();
                return;
            }
        }
    </script>
</body>
</html>