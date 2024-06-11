/*
Cửa hàng ốc vít
Ốc vít: 
Bu lông: 
Ren: đường xoắn
Long đền: Đĩa tròn dẹt
Tua vít
Cờ lê
*/

CREATE DATABASE QLYOCVIT;
GO
USE QLYOCVIT;
GO

CREATE TABLE NGUOIDUNG (
  Ma char(8) NOT NULL,
  HoTen nvarchar(50) NOT NULL,
  GioiTinh bit NOT NULL,
  Email varchar(50) NOT NULL,
  SDT varchar(11) NOT NULL,
  NgaySinh date NOT NULL,
  TaiKhoan varchar(50) NOT NULL,
  MatKhau char(64) NOT NULL,
  QuyenNhanVien bit NOT NULL,
  PRIMARY KEY (Ma),
  UNIQUE (TaiKhoan),
  CHECK (
      SDT LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
      SDT LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
      SDT LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
  )
);
GO
CREATE TABLE NHAPHANPHOI (
  Ma char(8) NOT NULL,
  Ten nvarchar(50) NOT NULL,
  DiaChi nvarchar(100) NOT NULL,
  SDT varchar(11) NOT NULL,
  PRIMARY KEY(Ma)
);
GO
CREATE TABLE LOAISANPHAM (
  Ma char(8) NOT NULL,
  Ten nvarchar(50) NOT NULL,
  Hinh varchar(255) NOT NULL,
  PRIMARY KEY (Ma)
);
GO
CREATE TABLE SANPHAM (
  Ma char(8) NOT NULL,
  Ten nvarchar(50) NOT NULL,
  Hinh varchar(255) NOT NULL,
  MoTa nvarchar(MAX) NOT NULL,
  XuatXu nvarchar(50) NOT NULL,
  SoLuong int NOT NULL,
  MaLoai char(8) NOT NULL,
  MaNPP char(8) NOT NULL,
  PRIMARY KEY (Ma),
  FOREIGN KEY (MaLoai) REFERENCES LOAISANPHAM(Ma),
  FOREIGN KEY (MaNPP) REFERENCES NHAPHANPHOI(Ma),
  CHECK (SoLuong >= 0)
);
GO
CREATE TABLE CHUNGLOAI (
  Ma char(8) NOT NULL,
  Ten nvarchar(50) NOT NULL,
  PRIMARY KEY (Ma)
);
GO
CREATE TABLE CHITIETCHUNGLOAI (
  MaSP char(8) NOT NULL,
  MaChungLoai char(8) NOT NULL,
  Gia int NOT NULL,
  PRIMARY KEY (MaSP, MaChungLoai),
  FOREIGN KEY (MaSP) REFERENCES SANPHAM(Ma),
  FOREIGN KEY (MaChungLoai) REFERENCES CHUNGLOAI(Ma),
  CHECK (Gia > 0)
);
GO
CREATE TABLE GIOHANG (
  MaND char(8) NOT NULL,
  MaSP char(8) NOT NULL,
  MaChungLoai char(8) NOT NULL,
  SoLuong int NOT NULL,
  PRIMARY KEY (MaND, MaSP, MaChungLoai),
  FOREIGN KEY (MaND) REFERENCES NGUOIDUNG(Ma),
  FOREIGN KEY (MaSP) REFERENCES SANPHAM(Ma),
  FOREIGN KEY (MaChungLoai) REFERENCES CHUNGLOAI(Ma),
  CHECK (SoLuong > 0)
);
GO
CREATE TABLE HOADON (
  Ma char(8) NOT NULL,
  MaNV char(8) NULL,
  MaKH char(8) NOT NULL,
  PhuongThuc int NOT NULL,
  KhachTra int NOT NULL,
  PRIMARY KEY (Ma),
  FOREIGN KEY (MaNV) REFERENCES NGUOIDUNG(Ma),
  FOREIGN KEY (MaKH) REFERENCES NGUOIDUNG(Ma)
);
GO
CREATE TABLE CHITIETHOADON (
  MaHD char(8) NOT NULL,
  MaSP char(8) NOT NULL,
  MaChungLoai char(8) NOT NULL,
  SoLuong int NOT NULL,
  PRIMARY KEY (MaHD, MaSP, MaChungLoai),
  FOREIGN KEY (MaSP) REFERENCES SANPHAM(Ma),
  FOREIGN KEY (MaChungLoai) REFERENCES CHUNGLOAI(Ma)
);
GO
CREATE FUNCTION FUNC_SANPHAM_GIA(@MaSP AS char(8)) RETURNS nvarchar(50) AS BEGIN
	RETURN (
    	SELECT CASE
    		WHEN MIN(Gia) <> MAX(Gia)
    			THEN CAST(MIN(Gia) AS varchar(50)) + N'₫ - ' + CAST(MAX(Gia) AS varchar(50)) + N'₫'
    		ELSE CAST(MIN(Gia) AS varchar(50)) + N'₫'
    	END AS Gia
    	FROM CHITIETCHUNGLOAI WHERE MaSP = @MaSP
    )
END
GO
CREATE PROCEDURE PROC_SANPHAM_GIA(@MaSP AS char(8)) AS BEGIN
	SELECT CASE
		WHEN MIN(Gia) <> MAX(Gia)
			THEN CAST(MIN(Gia) AS varchar(50)) + N'₫ - ' + CAST(MAX(Gia) AS varchar(50)) + N'₫'
		ELSE CAST(MIN(Gia) AS varchar(50)) + N'₫'
	END AS Gia
	FROM CHITIETCHUNGLOAI WHERE MaSP = @MaSP
END
GO
CREATE PROCEDURE PROC_SANPHAM_DANHSACH(@MaLoai AS char(8) = NULL) AS BEGIN
    SELECT SANPHAM.Ma, SANPHAM.Ten, SANPHAM.Hinh, dbo.FUNC_SANPHAM_GIA(SANPHAM.Ma) AS Gia, SANPHAM.SoLuong FROM SANPHAM
        LEFT JOIN CHITIETCHUNGLOAI ON SANPHAM.Ma = CHITIETCHUNGLOAI.MaSP
    WHERE @MaLoai IS NULL OR MaLoai = @MaLoai
    GROUP BY SANPHAM.Ma, SANPHAM.Ten, SANPHAM.Hinh, SANPHAM.SoLuong
END
GO
CREATE PROCEDURE PROC_GIOHANG_DANHSACH(@MaND AS char(8)) AS BEGIN
    SELECT GIOHANG.*, SANPHAM.Ten AS TenSP, SANPHAM.Hinh, CHUNGLOAI.Ten AS TenChungLoai, CHITIETCHUNGLOAI.Gia AS Gia, GIOHANG.SoLuong * CHITIETCHUNGLOAI.Gia AS Tong FROM GIOHANG
        JOIN SANPHAM ON GIOHANG.MaSP = SANPHAM.Ma
		JOIN CHUNGLOAI ON GIOHANG.MaChungLoai = CHUNGLOAI.Ma
		JOIN CHITIETCHUNGLOAI ON GIOHANG.MaChungLoai = CHITIETCHUNGLOAI.MaChungLoai AND GIOHANG.MaSP = CHITIETCHUNGLOAI.MaSP
    WHERE GIOHANG.MaND = @MaND
END
GO
CREATE PROCEDURE PROC_SANPHAM_XEMSANPHAM(@MaSP char(8)) AS BEGIN
    SELECT SANPHAM.Ma, SANPHAM.Ten, SANPHAM.MoTa, SANPHAM.Hinh, SANPHAM.XuatXu, dbo.FUNC_SANPHAM_GIA(SANPHAM.Ma) AS Gia, SANPHAM.SoLuong, LOAISANPHAM.Ten AS TenLoai, NHAPHANPHOI.Ten AS TenNPP, NHAPHANPHOI.DiaChi, NHAPHANPHOI.SDT
    FROM SANPHAM
		JOIN CHITIETCHUNGLOAI ON SANPHAM.Ma = CHITIETCHUNGLOAI.MaSP
        JOIN LOAISANPHAM ON SANPHAM.MaLoai = LOAISANPHAM.Ma
        JOIN NHAPHANPHOI ON SANPHAM.MaNPP = NHAPHANPHOI.Ma
    WHERE SANPHAM.Ma = @MaSP
    GROUP BY SANPHAM.Ma, SANPHAM.Ten, SANPHAM.MoTa, SANPHAM.Hinh, SANPHAM.XuatXu, SANPHAM.SoLuong, LOAISANPHAM.Ten, NHAPHANPHOI.Ten, NHAPHANPHOI.DiaChi, NHAPHANPHOI.SDT
END
GO
CREATE PROCEDURE PROC_SANPHAM_XEMCHITIET(@MaSP char(8)) AS BEGIN
    SELECT *, CHUNGLOAI.Ten FROM CHITIETCHUNGLOAI
        JOIN CHUNGLOAI ON CHITIETCHUNGLOAI.MaChungLoai = CHUNGLOAI.Ma
    WHERE MaSP = @MaSP
END
GO
INSERT INTO NGUOIDUNG VALUES
    ('NDKA98DF',    N'Hồ Hải Nam',          0,  'hohainam@gmail.com',       '0915619415',   '2000-01-06',   'kh1',      '8704d725e8a2ab5fe49a0c3862854ad7d587efd9fe360f11546f61d3dde60727',  0), -- mk1
    ('NDKWJ9A6',    N'Nguyễn Cung Đình',    0,  'ncdinh@example.com',       '0112223456',   '2001-11-26',   'kh2',      '869c1ed1cd102ff0554782de1f915ae7bff25ff9e2500212a3e18e16a2f97a8e',  0), -- mk2
    ('NDK98QS5',    N'Trần Xuân Sơn',       0,  'xuanson265@a.com',         '01513651661',  '2000-12-02',   'kh3',      'd0d2022dccd612000ad8a249b7259bdff4083873d3f3fc9b45cfee2f89d346bc',  0), -- mk3
    ('NDKJ9A8A',    N'Hồ Hảo Hớn',          0,  'h5h5h5@b.com',             '06345162165',  '1999-05-09',   'kh4',      'ac58dd9f91d348bae244a95f68b3c7a7c4098220f5b068f1197dca35000815c4',  0), -- mk4
    ('NDVAG4A9',    N'admin',               0,  'admin@admin.admin',        '01081281122',  '1999-04-01',   'admin',    '0708ae0b8acdc3b0996ba8b4bee88f0acf41e7839b7103d8b617f5d96cf1c89a',  1); -- admin
GO
INSERT INTO NHAPHANPHOI VALUES
  ('NPPHS89F', N'Nhà phân phối sản phẩm cơ khí Master 3000', N'205-207 đường Võ Văn Dũng, Tân Phú, Thành phố Hồ Chí Minh', '0982525354'),
  ('NPPFA18D', N'Nhà phân phối dụng cụ Hà Nam', N'1016 HL2, đường Bình Trị Đông A, Bình Tân, Thành phố Hồ Chí Minh', '0955864880'),
  ('NPPGFDA8', N'Nhà sản xuất ốc vít nhà Rider', N'2040-2042 TL8, Bình Mỹ, Củ Chi, Thành phố Hồ Chí Minh', '0918938215'), 
  ('NPPDSRT8', N'Nhà sản xuất ốc vít, bu lông Binh Hòa', N'51-49 Hòa Bình, Tân Thới Hoà, Tân Phú, Thành phố Hồ Chí Minh', '0962935648'),
  ('NPPBG4AS', N'Nhà phân phối đai ốc Liger', N'Số 2, đường Hồ Bá Phấn, Phước Long A, Quận 9, Thành phố Hồ Chí Minh', '0961014882');
GO
INSERT INTO LOAISANPHAM VALUES
  ('LSOH57KF', N'Ốc lục giác',  'https://img.ws.mms.shopee.vn/05710737c7539e29466b9b8bcecb093f'),
  ('LSL5662F', N'Long đền',     'https://bulongquangthai.vn/thumbs/540x540x2/upload/product/hq720-3653.jpg'),
  ('LSB56HS9', N'Bu lông',      'https://chatchongchay.com/wp-content/uploads/2021/07/bu-long-la-gi_optimized.jpg'),
  ('LSRFA489', N'Ren',          'https://cokhiviethan.com.vn/wp-content/uploads/2022/06/co-may-loai-ren.jpg'),
  ('LSPF89A9', N'Dụng cụ',      'https://thapxanh.com/images/thumbs/0018865_bo-dung-cu-thao-van-oc-vit-tv-46-bo-dung-cu-mo-oc-vit-46-chi-tiet-dung-cu-van-oc-da-nang_550.jpeg');
GO
DECLARE @NL AS varchar(9) = CHAR(13) + CHAR(10)
INSERT INTO SANPHAM VALUES
  ('SPS5GA89',  N'Long đền inox 304',                       'https://mecsu.vn/hinh-anh-17672',                                                                                          N'Long đền chất liệu inox không gỉ, chất lượng cao.',                       N'Trung Quốc',  50, 'LSL5662F', 'NPPGFDA8'),
  ('SPS129GF',  N'Ốc lục giác bằng Long An',                'https://ocvitsaigon.com/wp-content/uploads/2019/05/flat-screw.jpg',                                                        N'Ốc lục giác này có đầu bằng.',                                            N'Việt Nam',    18, 'LSOH57KF', 'NPPHS89F'),
  ('SPSG98GO',  N'Long đền vênh Strong',                    'https://mecsu.vn/hinh-anh-17684',                                                                                          N'Long đền.',                                                               N'Hoa Kỳ',      9, 'LSL5662F', 'NPPGFDA8'),
  ('SPSDGFA8',  N'Ren ống IK30',                            'https://phanphoivattudiennuoc.vn/Data/images/tintuc/ong-ren-thep.jpg',                                                     N'Ren ống.',                                                                N'Đức',         40, 'LSRFA489', 'NPPHS89F'),
  ('SPS4GH9A',  N'Long đền phẳng Đại Lộc',                  'https://mecsu.vn/hinh-anh-17668',                                                                                          N'Long đền.',                                                               N'Việt Nam',    39, 'LSL5662F', 'NPPBG4AS'),
  ('SPSF1GH8',  N'Tua vít 4 cạnh Vessel',                   'https://thietbicongnghiep.net/Images/product/detail/2022/9/16/1800/size/220ph-no2-x-75.jpg',                               N'Tua vít.',                                                                N'Hàn Quốc',    2, 'LSPF89A9', 'NPPGFDA8'),
  ('SPSD1F45',  N'Cờ lê lực Elora',                         'https://vinatools.com/wp-content/uploads/2023/03/CLLSET2-Bo-co-le-luc-65-335Nm-vuong-12-inch-Made-In-Germany-300x300.jpg', N'Cờ lê.',                                                                  N'Đức',         4, 'LSPF89A9', 'NPPBG4AS'),
  ('SPSOBOZP',  N'Ốc vít đầu tròn inox 304',                'https://nshopvn.com/wp-content/uploads/2023/02/oc-vit-dau-tron-inox-304-n1so-va25-11qx-vz0v-0bek-7.jpg',                   N'Ốc vít đầu tròn chất liệu inox, chất lượng cao',                          N'Nhật Bản',    0, 'LSOH57KF', 'NPPGFDA8'),
  ('SPSJUB3Q',  N'Ống ren SU304',                           'https://vntec.vn/wp-content/uploads/2020/12/ong-2-dau-ren-phu-kien-duong-ong-vntec.jpg',                                   N'Ren ống làm bằng nhựa với hai đầu kim loại.',                             N'Thổ Nhĩ Kỳ',  0, 'LSRFA489', 'NPPBG4AS'),
  ('SPSU1OD8',  N'Tua vít 4 cạnh Stanley STHT65172 có từ',  'https://bizweb.dktcdn.net/thumb/large/100/377/825/products/stht65172-8.png?v=1693732106303',                               N'Tua vít 4 cạnh có đầu mang từ tính.',                                     N'Hoa Kỳ',      6, 'LSPF89A9', 'NPPHS89F'),
  ('SPSTI99L',  N'Long đền phẳng M20',                      'https://bizweb.dktcdn.net/thumb/grande/100/319/648/products/long-den-phang-m20.jpg?v=1565318239277',                       N'Long đền phẳng làm bằng kim loại.',                                       N'Nhật Bản',    92, 'LSL5662F', 'NPPGFDA8'),
  ('SPS61U9V',  N'Long đền ASTM F844',                      'https://bulongquangthai.vn/thumbs/750x481x2/upload/product/plain-washer-5420.jpg',                                         N'Long đền phẳng với chất liệu cứng cáp, khó bị bẻ cong theo thời gian.',   N'Úc',          15, 'LSL5662F', 'NPPGFDA8'),
  ('SPSQK5CQ',  N'Bu lông cấp bền Nam Hải',                 'https://bulongnamhai.com/wp-content/uploads/2019/07/bulong-cap-ben-5.8.jpg',                                               N'Bu lông chất lượng cao',                                                  N'Việt Nam',    65, 'LSB56HS9', 'NPPGFDA8'),
  ('SPSS664Y',  N'Bu lông inox 304',                        'https://bulongdinhvit.com/wp-content/uploads/2021/01/bulong-dau-tru-m8x40.jpg',                                            N'Bu lông làm bằng chất liệu bền',                                          N'Hà Lan',      12, 'LSB56HS9', 'NPPGFDA8'),
  ('SPS9JUHF',  N'Bu lông thép Titan',                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSEDtE9AjMJ1YJqbvEhAwy-gU64PwYaktXVoM8C5KNyg&s',                     N'Bu lông chất lượng cao',                                                  N'Hoa Kỳ',      15, 'LSB56HS9', 'NPPGFDA8');

GO
INSERT INTO CHUNGLOAI VALUES
  ('CLO19A03',     'M3'),
  ('CLO19A04',     'M4'),
  ('CLO19A05',     'M5'),
  ('CLO19A06',     'M6'),
  ('CLO19A08',     'M8'),
  ('CLO19A10',     'M10'),
  ('CLO19A12',     'M12'),
  ('CLO19A14',     'M14'),
  ('CLO19A16',     'M16'),
  ('CLO19A18',     'M18'),
  ('CLO19A20',     'M20'),
  ('CLO19A24',     'M24'),
  ('CLO19A36',     'M36'),
  ('CLO19A42',     'M42'),
  ('CLO19A48',     'M48'),
  ('CLG1P304',     'M3X4'),
  ('CLG1P306',     'M3X6'),
  ('CLG1P308',     'M3X8'),
  ('CLG1P310',     'M3X10'),
  ('CLG1P312',     'M3X12'),
  ('CLG1P316',     'M3X16'),
  ('CLG1P320',     'M3X20'),
  ('CLG1P410',     'M4X10'),
  ('CLG1P415',     'M4X15'),
  ('CLG1P420',     'M4X20'),
  ('CLG1P425',     'M4X25'),
  ('CLG1P404',     'M4X4'),
  ('CLG1P406',     'M4X6'),
  ('CLG1P408',     'M4X8'),
  ('CLG1P506',     'M5X6'),
  ('CLG1P508',     'M5X8'),
  ('CLAFO639',     'Đỏ'),
  ('CLAFO640',     'Cam'),
  ('CLAFO641',     'Vàng'),
  ('CLAFO642',     'Xanh lá'),
  ('CLAFO643',     'Xanh dương'),
  ('CLAFO644',     'Hồng'),
  ('CLAFO645',     'Tím'),
  ('CLAFO646',     'Bạc'),
  ('CLG42106',     '1/2 inch'),
  ('CLG42107',     '1/3 inch'),
  ('CLG42108',     '1/4 inch'),
  ('CLJ42FAS',     'D-00'),
  ('CLJ42FAT',     'D-01'),
  ('CLJ42FAO',     'D-02'),
  ('CLJ42FAU',     'D-03');
GO
INSERT INTO CHITIETCHUNGLOAI VALUES
  ('SPS5GA89',  'CLO19A03', 100),
  ('SPS5GA89',  'CLO19A04', 100),
  ('SPS5GA89',  'CLO19A05', 100),
  ('SPS5GA89',  'CLO19A06', 100),
  ('SPS5GA89',  'CLO19A08', 150),
  ('SPS5GA89',  'CLO19A10', 150),
  ('SPS5GA89',  'CLO19A12', 200),
  ('SPS5GA89',  'CLO19A14', 300),
  ('SPS5GA89',  'CLO19A16', 300),
  ('SPS5GA89',  'CLO19A18', 400),
  ('SPS5GA89',  'CLO19A20', 500),
  ('SPS129GF',  'CLG1P306', 100),
  ('SPS129GF',  'CLG1P308', 100),
  ('SPS129GF',  'CLG1P310', 150),
  ('SPS129GF',  'CLG1P312', 200),
  ('SPS129GF',  'CLG1P316', 250),
  ('SPS129GF',  'CLG1P320', 300),
  ('SPS129GF',  'CLG1P410', 200),
  ('SPS129GF',  'CLG1P415', 300),
  ('SPS129GF',  'CLG1P420', 400),
  ('SPS129GF',  'CLG1P425', 500),
  ('SPSG98GO',  'CLO19A03', 200),
  ('SPSG98GO',  'CLO19A04', 200),
  ('SPSG98GO',  'CLO19A06', 250),
  ('SPSG98GO',  'CLO19A08', 300),
  ('SPSG98GO',  'CLO19A10', 350),
  ('SPSG98GO',  'CLO19A14', 400),
  ('SPSG98GO',  'CLO19A18', 500),
  ('SPSDGFA8',  'CLG1P304', 300),
  ('SPSDGFA8',  'CLG1P306', 400),
  ('SPSDGFA8',  'CLG1P308', 500),
  ('SPSDGFA8',  'CLG1P404', 350),
  ('SPSDGFA8',  'CLG1P406', 450),
  ('SPSDGFA8',  'CLG1P408', 600),
  ('SPSDGFA8',  'CLG1P506', 500),
  ('SPSDGFA8',  'CLG1P508', 700),
  ('SPS4GH9A',  'CLO19A03', 250),
  ('SPS4GH9A',  'CLO19A04', 220),
  ('SPS4GH9A',  'CLO19A05', 300),
  ('SPS4GH9A',  'CLO19A06', 350),
  ('SPS4GH9A',  'CLO19A08', 400),
  ('SPS4GH9A',  'CLO19A10', 500),
  ('SPS4GH9A',  'CLO19A12', 600),
  ('SPS4GH9A',  'CLO19A14', 750),
  ('SPS4GH9A',  'CLO19A16', 900),
  ('SPS4GH9A',  'CLO19A18', 1000),
  ('SPS4GH9A',  'CLO19A20', 1100),
  ('SPS4GH9A',  'CLO19A24', 1300),
  ('SPS4GH9A',  'CLO19A36', 1600),
  ('SPS4GH9A',  'CLO19A42', 1800),
  ('SPS4GH9A',  'CLO19A48', 2000),
  ('SPSF1GH8',  'CLAFO639', 170000),
  ('SPSF1GH8',  'CLAFO640', 199000),
  ('SPSF1GH8',  'CLAFO641', 180000),
  ('SPSF1GH8',  'CLAFO642', 170000),
  ('SPSF1GH8',  'CLAFO643', 180000),
  ('SPSF1GH8',  'CLAFO644', 179000),
  ('SPSF1GH8',  'CLAFO645', 170000),
  ('SPSF1GH8',  'CLAFO646', 189000),
  ('SPSD1F45',  'CLG42106', 799999),
  ('SPSD1F45',  'CLG42107', 799999),
  ('SPSD1F45',  'CLG42108', 799999),
  ('SPSOBOZP',  'CLO19A04', 100),
  ('SPSOBOZP',  'CLO19A06', 150),
  ('SPSOBOZP',  'CLO19A08', 200),
  ('SPSOBOZP',  'CLO19A10', 250),
  ('SPSOBOZP',  'CLO19A12', 300),
  ('SPSOBOZP',  'CLO19A14', 400),
  ('SPSOBOZP',  'CLO19A16', 500),
  ('SPSOBOZP',  'CLO19A18', 700),
  ('SPSJUB3Q',  'CLG1P304', 300),
  ('SPSJUB3Q',  'CLG1P306', 400),
  ('SPSJUB3Q',  'CLG1P308', 500),
  ('SPSJUB3Q',  'CLG1P310', 700),
  ('SPSJUB3Q',  'CLG1P312', 900),
  ('SPSU1OD8',  'CLJ42FAS', 299000),
  ('SPSU1OD8',  'CLJ42FAT', 299000),
  ('SPSU1OD8',  'CLJ42FAO', 299000),
  ('SPSU1OD8',  'CLJ42FAU', 299000),
  ('SPSTI99L',  'CLG1P304', 600),
  ('SPSTI99L',  'CLG1P308', 800),
  ('SPSTI99L',  'CLG1P312', 1000),
  ('SPSTI99L',  'CLG1P316', 1200),
  ('SPS61U9V',  'CLG1P406', 500),
  ('SPS61U9V',  'CLG1P506', 500),
  ('SPSQK5CQ',  'CLO19A18', 200),
  ('SPSQK5CQ',  'CLO19A20', 300),
  ('SPSQK5CQ',  'CLO19A36', 400),
  ('SPSQK5CQ',  'CLO19A42', 600),
  ('SPSS664Y',  'CLG1P308', 100),
  ('SPSS664Y',  'CLG1P310', 200),
  ('SPSS664Y',  'CLG1P312', 500),
  ('SPSS664Y',  'CLG1P316', 900),
  ('SPSS664Y',  'CLG1P320', 1000),
  ('SPS9JUHF',  'CLG1P304', 200),
  ('SPS9JUHF',  'CLG1P306', 300),
  ('SPS9JUHF',  'CLG1P404', 400),
  ('SPS9JUHF',  'CLG1P406', 500),
  ('SPS9JUHF',  'CLG1P408', 600),
  ('SPS9JUHF',  'CLG1P506', 700),
  ('SPS9JUHF',  'CLG1P508', 800);



/* Xoá bảng
DROP PROCEDURE PROC_SANPHAM_XEMCHITIET
DROP PROCEDURE PROC_SANPHAM_XEMSANPHAM
DROP PROCEDURE PROC_GIOHANG_DANHSACH
DROP PROCEDURE PROC_SANPHAM_DANHSACH
DROP PROCEDURE PROC_SANPHAM_GIA
DROP FUNCTION FUNC_SANPHAM_GIA
DROP TABLE CHITIETHOADON
DROP TABLE HOADON
DROP TABLE GIOHANG
DROP TABLE CHITIETCHUNGLOAI
DROP TABLE CHUNGLOAI
DROP TABLE SANPHAM
DROP TABLE LOAISANPHAM
DROP TABLE NHAPHANPHOI
DROP TABLE NGUOIDUNG
*/


