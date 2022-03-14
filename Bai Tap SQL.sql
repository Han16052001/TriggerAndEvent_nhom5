--CREATE DATABASE QLMUAHANG;
--USE QLMUAHANG;
--drop database QLMUAHANG
CREATE TABLE CUSTOMER (
       MaKH VARCHAR (10) PRIMARY KEY,
	   TenKH NVARCHAR (100),
	   Email VARCHAR (100),
	   SoDT VARCHAR (10),
	   DiaChi VARCHAR (100)
	  )
GO
CREATE TABLE PAYMENT (
       MaPTTT VARCHAR (10) PRIMARY KEY,
	   TenPhuongThucTT NVARCHAR (100),
	   PhiTT INT
	  )
GO
CREATE TABLE PRODUCT (
       MaSP VARCHAR (10) PRIMARY KEY,
	   TenSP NVARCHAR (100),
	   MoTa NVARCHAR(225),
	   GiaSP INT,
	   SoLuongSP INT,
	  )
GO
CREATE TABLE ORDERS (
       MaDH VARCHAR (10) PRIMARY KEY,
	   MaKH VARCHAR (10)
	   FOREIGN KEY (MaKH) REFERENCES CUSTOMER (MaKH),
	   MaPTTT VARCHAR (10),
	   FOREIGN KEY (MaPTTT) REFERENCES PAYMENT (MaPTTT),
	   NgayDat DATE,	
	   TrangThaiDatHang NVARCHAR(100),
	   TongTien INT
	   )
GO

CREATE TABLE ORDER_DETAIL (
       MaOD VARCHAR (10) PRIMARY KEY,
	   MaDH VARCHAR (10)
	   FOREIGN KEY(MaDH) REFERENCES ORDERS (MaDH),
	   MaSP VARCHAR (10),
	   FOREIGN KEY(MaSP) REFERENCES PRODUCT (MaSP),
	   SoLuong INT,
	   GiaSP INT ,
	   ThanhTien INT 	   
	  )
GO

INSERT INTO CUSTOMER VALUES  
--           MaKH        TenKH           Email            SoDT      DiaChi 
            ('KH0001', 'Bui Nhi',    'nhi@gmail.com',  09012345, 'Lien Chieu'),
			('KH0002', 'Bui Anh',    'anh@gmail.com',  09112345, 'Thanh Khe'),
			('KH0003', 'Nguyen Van', 'van@gmail.com',  09112346, 'Lien Chieu'),
			('KH0004', 'Nguyen Bao', 'bao@gmail.com',  09012346, 'Thanh Khe'),
			('KH0005', 'Bui Lan',    'lan@gmail.com',  09012347, 'Hai Chau'),
			('KH0006', 'Nguyen Tai', 'tai@gmail.com',  09112347, 'Hai Chau');
GO
INSERT INTO PAYMENT VALUES
--           MaPTTT   TenPhuongThucTT           PhiTT 
            ('TT001',  N'Visa',                 2000),
            ('TT002',  N'Banking',              1000),
            ('TT003',  N'MoMo',                 1000),
			('TT004',  N'Thanh toán trực tiếp', 50000);
GO
INSERT INTO PRODUCT VALUES
--           MaSP           TenSP                 MoTa             GiaSP  SoLuongSP 
            ('SP001',  N'Bánh bông lan cốt mềm',N'Bánh bông lan ', 55000,  20),
            ('SP002',  N'Bánh ngọt socola'  ,   N'Bánh ngọt',      200000, 10),
            ('SP003',  N'Bánh 2 tầng',          N'Bánh ngọt',      250000, 15);
GO 
INSERT INTO ORDERS VALUES
--            MaDH       MaKH     MaPTTT     NgayDat      TrangThaiDatHang  TongTien 
            ('DH0001', 'KH0002', 'TT001',  '2021-05-25',    N'Đã giao',     277000),
			('DH0002', 'KH0002', 'TT002',  '2022-01-01',    N'Đang giao',   331000),
			('DH0003', 'KH0001', 'TT004',  '2022-01-15',    N'Đã giao',     1050000),
			('DH0004', 'KH0005', 'TT003',  '2021-08-25',    N'Đã giao',     1501000),
			('DH0005', 'KH0004', 'TT003',  '2021-06-30',    N'Đang giao',   251000);
GO
INSERT INTO ORDER_DETAIL VALUES
--           MaOD     MaDH    MaSP  SoLuong GiaSP ThanhTien 
            ('OD001','DH0001','SP001', 5,   55000,  275000),
            ('OD002','DH0002','SP001', 6,   55000,  330000),
            ('OD003','DH0003','SP003', 4,  250000, 1000000),
			('OD004','DH0004','SP002', 6,  200000, 1500000),
            ('OD005','DH0005','SP003', 1,  250000,  250000);
GO 

---- 1 Tạo View (khung nhìn)
--1.1 Tạo khung nhìn có tên là KH_ThanhToanTT để xem thông tin của 
--tất cả khách hàng đã sử dụng phương thức thanh toán trực tiếp (Khánh Nhi)
CREATE VIEW KH_ThanhToanTT AS
SELECT KH.* FROM CUSTOMER KH
JOIN ORDERS OD
ON OD.MaKH = KH.MaKH
JOIN PAYMENT PM
ON PM.MaPTTT = OD.MaPTTT
WHERE PM.TenPhuongThucTT = N'Thanh toán trực tiếp'

SELECT * FROM KH_ThanhToanTT

DROP VIEW KH_ThanhToanTT
----1.2 Tạo khung nhìn có tên là KH_DangGiao để xem thông tin của 
--khách hàng đã có trạng thái đặt hàng là đang giao (Bình Nhi)
CREATE VIEW KH_DangGiao AS
SELECT KH.* FROM CUSTOMER KH
JOIN ORDERS OD
ON OD.MaKH = KH.MaKH
WHERE OD.TrangThaiDatHang = N'Đang giao'

SELECT * FROM KH_DangGiao

DROP VIEW KH_DangGiao
---- 2 Tạo PROCEDER (Thủ tục)
--Phương Nam
---- 2.1 Update du lieu khach hang
CREATE PROCEDURE Proc_Customer (
	@MaKH CHAR(50),
	@TenKH VARCHAR(50),
	@Email VARCHAR(50),
	@SoDT VARCHAR(50),
	@DiaChi VARCHAR(50)
)
AS
BEGIN
    SELECT *
	FROM dbo.CUSTOMER
	WHERE @MaKH = MaKH

	UPDATE dbo.CUSTOMER
	SET TenKH = @TenKH, Email = @Email, SoDT = @SoDT, DiaChi = @DiaChi
	WHERE MaKH = @MaKH
END
GO 
EXECUTE dbo.Proc_Customer @MaKH = 'KH0006',  -- char(50)
                          @TenKH = 'Nguyen Tai', -- varchar(50)
                          @Email = 'tai@gmail.com', -- varchar(50)
                          @SoDT = '9112347',  -- varchar(50)
                          @DiaChi = 'Cam Le' -- varchar(50)
 GO

SELECT * FROM dbo.CUSTOMER
GO 

DROP PROCEDURE Proc_Customer
---- 2.2 Delete san pham trong db
CREATE PROCEDURE Proc_DeProduct (
	@MaSP CHAR(50)
)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM dbo.PRODUCT WHERE MaSP = @MaSP)
	BEGIN
	    PRINT 'MaSP khong ton tai'
	END

	DELETE FROM dbo.PRODUCT
	WHERE MaSP = @MaSP
END
GO 
EXECUTE dbo.Proc_DeProduct @MaSP = 'SP005' -- char(50)
SELECT * FROM dbo.PRODUCT
GO 

DROP PROCEDURE Proc_DeProduct
---- 2.3 Thong ke tong so luong ban hàng cua 1 san pham bat ky
CREATE PROCEDURE Proc_TKProduct (
	@MaSP CHAR(50)
)
AS
BEGIN
    SELECT pd.MaSP, pd.TenSP, SUM(od.SoLuong) AS Total_Product
	FROM dbo.PRODUCT pd LEFT JOIN dbo.ORDER_DETAIL od
	ON od.MaSP = pd.MaSP
	WHERE pd.MaSP = @MaSP
	GROUP BY pd.MaSP, pd.TenSP
END
GO
EXECUTE dbo.Proc_TKProduct @MaSP = 'SP001' -- char(50)

SELECT * FROM dbo.PRODUCT
SELECT * FROM dbo.ORDER_DETAIL

DROP PROCEDURE Proc_TKProduct

-- Nguyên
--2.4 Tạo một SP có tên là Add_Order để thêm một bản ghi mới vào bảng order với điều kiện 
--phải thực hiện kiểm tra tính 
--hợp lệ của dữ liệu được bổ sung, với nguyên tắc là không được 
--trùng khóa chính và đảm bảo toàn vẹn dữ liệu tham chiếu đến
--các bảng có liên quan

create proc SP_AddOrder @MaDH VARCHAR (10),
					   @MaKH VARCHAR (10),
					   @MaPTTT VARCHAR (10),
					   @NgayDat DATE,	
					   @TrangThaiDatHang NVARCHAR(100),
					   @TongTien INT
as
begin
	--Ktra trung khoa chinh
	if exists (select *from ORDERS where MaDH=@MaDH) 
	begin	
		print 'Trung khoa chinh'
		return 
	end

	--Ktra su ton tai cua MaKH
	if not exists(select *from CUSTOMER where MaKH=@MaKH)
	begin
		print @MaKH + ' ' + 'Chua ton tai trong bang CUSTOMER'
		return
	end

	--Ktra su ton tai cua MaPTTT
	if not exists(select *from PAYMENT where MaPTTT=@MaPTTT)
	begin
		print @MaPTTT + ' ' + 'Chua ton tai trong bang PAYMENT'
		return
	end

	 INSERT INTO ORDERS VALUES
	( @MaDH, @MaKH, @MaPTTT, @NgayDat,@TrangThaiDatHang,@TongTien)
end
go

exec SP_AddOrder 'DH0006', 'KH0007', 'TT005',  '2021-05-25',    N'Đã giao',     277000
go

drop proc SP_AddOrder
--2.5 Sử dụng Cursor để đưa các sản phẩm có mô tả là "Bánh ngọt" sẽ có giá sản phẩm đồng giá là 1000 
Declare BanhNgot1K cursor for select MoTa,GiaSP from dbo.PRODUCT

open BanhNgot1K

declare @MoTa NVARCHAR(225)
declare @GiaSP int

fetch next from BanhNgot1K into @MoTa, @GiaSP

while @@FETCH_STATUS=0
begin
	if @MoTa= N'Bánh ngọt'
	begin
		update dbo.PRODUCT set GiaSP=1000 where MoTa=@MoTa
	end

	fetch next from BanhNgot1K into @MoTa, @GiaSP
end
close BanhNgot1K
deallocate BanhNgot1K


select*from dbo.PRODUCT
---- 3 Tạo FUNCION (Hàm)
-- Ngân
-- 3.1 Viết hàm trả về 1 bảng với các thông tin MaKH, TenKH,Email,SoDT,DiaChi của khách hàng có trong bảng ORDERS
create function udf_customer()
returns table as
return 
(
    select DISTINCT CUSTOMER.MaKH, TenKH,Email,SoDT,DiaChi  
	from dbo.CUSTOMER join dbo.ORDERS 
	on  CUSTOMER.MaKH = ORDERS.MaKH		
)

select * from dbo.udf_customer();

drop function udf_customer
-- 3.2 Viết hàm trả về 1 giá trị những đơn hàng từ 1000000 trở lên
create function udf_hoadon
(
  @ThanhTien int
  )
  returns bit
  as 
  begin 
  declare @hoadon bit;
  if @ThanhTien >= 1000000
     set @hoadon =1 
	 else 
	 set @hoadon = 0;
	 return @hoadon;
  end

select * from 
(select *, dbo.udf_hoadon(ThanhTien) as HoaDon from ORDER_DETAIL ) as a
 where HoaDon = 1;

drop function udf_hoadon

--Viết hàm trả về 1 bảng dùng để đếm số hóa đơn của khách hàng

create function SL_DonHang(
@MaKH VARCHAR (10)
)
returns table as
return 
(
SELECT ORDERS.MaKH, COUNT(DISTINCT MaDH) as SL_DonHang
 FROM ORDERS
 where @MaKH = MaKH
 GROUP BY MaKH
 )

 select * from SL_DonHang('KH0002');

 drop function SL_DonHang

 -- Hoài Nam
 -- 3.4 tạo hàm có tên CUSTOMRAD dùng để trả về bảng khách hàng có địa chỉ là liên chiểu
CREATE FUNCTION CUSTOMRAD()
RETURNS TABLE 
AS RETURN SELECT * FROM dbo.CUSTOMER
	where CUSTOMER.DiaChi = 'Lien Chieu'
GO

SELECT * FROM CUSTOMRAD()

drop FUNCTION CUSTOMRAD

----4 Trigger
/* cập nhật số lượng hàng trong bảng sản phẩm sau khi đặt hàng hoặc cập nhật */
CREATE TRIGGER trg_DatHang ON ORDER_DETAIL AFTER INSERT AS 
BEGIN
	UPDATE PRODUCT
	SET SoLuongSP = SoLuongSP - (SELECT SoLuong
		                         FROM inserted
		                         WHERE MaSP = PRODUCT.MaSP)
	FROM PRODUCT
	JOIN inserted ON PRODUCT.MaSP = inserted.MaSP
END
GO


select * from ORDERS
select * from ORDER_DETAIL
select * from PRODUCT

INSERT INTO ORDER_DETAIL VALUES
--           MaOD     MaDH    MaSP  SoLuong GiaSP ThanhTien 
            ('OD007','DH0001','SP001', 5,   55000,  275000);


--TẠO TRIGGER VÀ EVENT
--PHƯƠNG NAM
---Trigger
--- Tao update trigger khi cap nhap so luong san pham thi phai lon hon so luong san pham cu
CREATE TRIGGER Trg_UpProduct
ON dbo.PRODUCT
AFTER UPDATE
AS
BEGIN
    IF EXISTS(SELECT * FROM Inserted ist JOIN Deleted det
			  ON det.MaSP = ist.MaSP
			  WHERE det.SoLuongSP > ist.SoLuongSP)
	BEGIN
	    PRINT 'So luong san pham moi khong duoc nho hon san pham cu'
		PRINT ''
		ROLLBACK TRANSACTION
	END
END
GO	
SELECT * FROM dbo.PRODUCT
INSERT INTO PRODUCT VALUES('SP004', 'Banh 3 tang', 'Banh ngot', 350000, 30)
UPDATE dbo.PRODUCT SET SoLuongSP = 20 WHERE MaSP = 'SP004'
GO 
---
--- Tao delete trigger khong cho phep xoa gia tien voi san pham co gia < 500000
ALTER TRIGGER Tri_DeProduct 
ON dbo.PRODUCT
AFTER DELETE
AS 
BEGIN
    DECLARE @Price INT = 0
	SELECT @Price = COUNT(*) FROM Deleted det
	WHERE det.GiaSP > 500000
	--Neu co sl sp > 500k bi xoa di thi price > 0 => fail
	IF (@Price > 0)
	BEGIN
	    PRINT 'Khong the xoa san pham co gia tien tren 500000 !!!'
		PRINT ''
		ROLLBACK TRANSACTION
	END
END
GO
SELECT *  FROM dbo.PRODUCT
INSERT INTO PRODUCT VALUES('SP005', 'Banh 4 tang', 'Banh ngot', 550000, 30)
DELETE FROM dbo.PRODUCT WHERE MaSP = 'SP005'
UPDATE dbo.PRODUCT SET GiaSP = 400000 WHERE MaSP = 'SP005'
GO

-- Event
-- Tao 1 onetime Evt_IsProduct voi 20 giay de them 1 san pham bat ky
CREATE EVENT Evt_IsProduct
ON SCHEDULE AT CURRENT_TIMESTAMP + interval 20 second
ON COMPLETION PRESERVE
DO
   INSERT INTO product (MaSP, TenSP, MoTa, GiaSP, SoLuongSP) 
   VALUES('SP006', 'Banh Donus', 'Banh ngot', 50000, 20);

drop event Evt_IsProduct2;
select * from product;
   
-- Tao 1 onetime Evt_DeProduct voi 40 giay de delete 1 san pham bat ky
create event Evt_DeProduct
on schedule at current_timestamp() + interval 40 second
on completion preserve
do
delete from product where MaSP = 'SP006';
select * from product;


-- HỒNG NHI
--Tạo trigger có tên là KTgia_insert tác động
--lên bảng PRODUCT khi thêm dữ liệu. Trigger này đảm bảo rằng
--giá hàng của sản phẩm có MoTa = Bánh ngọt
--không được ít hơn 150 ngàn.
CREATE TRIGGER KTgia_insert
ON PRODUCT 
FOR INSERT
AS
 IF (SELECT MH.GiaSP FROM PRODUCT SP JOIN inserted MH
	                   ON SP.MaSP = MH.MaSP	   	                  
		               WHERE SP.MoTa = N'Bánh ngọt' AND SP.TenSP LIKE '%2%' ) < 150000
BEGIN
     PRINT N'Bánh ngọt 2 tầng phải có giá lớn hơn 150 000';
	 ROLLBACK TRANSACTION	 
END

INSERT INTO PRODUCT VALUES
--           MaSP           TenSP                 MoTa        GiaSP  SoLuongSP 
            ('SP005',  N'Bánh Sinh nhật 2 tầng', N'Bánh ngọt', 55000,  20);


SELECT * FROM PRODUCT SP JOIN ORDER_DETAIL MH
	                   ON SP.MaSP = MH.MaSP	   	                  
		               WHERE SP.MoTa = N'Bánh ngọt' AND SP.TenSP LIKE '%2%'
--- KHÁNH NHI
CREATE TRIGGER Trigger_CheckBuyProduct
ON ORDER_DETAIL
FOR INSERT
AS
BEGIN
	DECLARE @QuantityBuy INT, @QuantityPr INT,@maSP Varchar(10)
	SELECT @QuantityPr = SoLuongSP FROM PRODUCT,inserted WHERE PRODUCT.MaSP = inserted.MaSP;
	SELECT @QuantityBuy = SoLuong, @maSP = MaSP FROM inserted
	IF(@QuantityBuy > 0)
	BEGIN
		IF(@QuantityBuy <= @QuantityPr)
		BEGIN
			UPDATE PRODUCT SET SoLuongSP = @QuantityPr - @QuantityBuy WHERE MaSP = @maSP
		END
		ELSE
			BEGIN
				PRINT 'SO LUONG KHONG DU'
				ROLLBACK TRANSACTION
			END
	END
	ELSE
		BEGIN
			PRINT 'SO LUONG MUA PHAI LON HON 0'
			ROLLBACK TRANSACTION
		END
END
INSERT INTO ORDER_DETAIL VALUES
--           MaOD     MaDH    MaSP  SoLuong GiaSP ThanhTien 
            ('OD08','DH0001','SP001', 20,   55000,  275000);

select * from PRODUCT
select * from ORDER_DETAIL

-- HOÀI NAM
-- Cập nhật những đơn đặt hàng lớn hơn 1 năm
CREATE TRIGGER update_dh
	ON ORDERS
	FOR update
	AS
	BEGIN
	if(update(TrangThaiDatHang))
	 begin
		DECLARE @COUNT INT
		SELECT @COUNT = COUNT(*) FROM inserted
		WHERE YEAR(GETDATE()) - YEAR(inserted.NgayDat) < 1
		if(@COUNT > 0)
		begin 
			print N' Không được cập nhật '
			ROLLBACK TRAN
		END
	 end
	END
	
select * from ORDERS;

drop TRIGGER update_dh;
UPDATE ORDERS
SET TrangThaiDatHang = N'Đã Được Duyệt'
WHERE maDH = 'DH0002'
UPDATE ORDERS
SET TrangThaiDatHang = 'chua duoc duyet p2'
WHERE maDH = 'DH0001'

---- Tạo trigger delete_pttt. Khi xóa một phương thức thanh toán thì sẽ trả về số lượng bản ghi các pttt còn lại trong bảng
CREATE TRIGGER delete_pttt
	 ON PAYMENT
	 FOR DELETE
	 AS
	 BEGIN
		DECLARE @tong INT 
		SELECT @tong = COUNT(*)
		FROM PAYMENT
		PRINT N'Tổng số lượng bản ghi còn lại :  '+ CAST(@tong AS varchar(5))
	 END

INSERT INTO PAYMENT VALUES
--           MaPTTT   TenPhuongThucTT           PhiTT 
            ('TT005',  N'thẻ',                 2000);
delete dbo.PAYMENT where MaPTTT = 'TT005'

-- Bình Nhi
create trigger testtop3 on CUSTOMER
FOR UPDATE, INSERT
AS
BEGIN
    PRINT'NHAP THANH CONG'
END
GO

INSERT INTO CUSTOMER VALUES
('MKH004','Nhi Nhi','Nhi1@gmail.com','0905898905','Thanh Khe');
go
---------------------------------
SELECT	* from CUSTOMER

-- Ngân
--Bảng Customer_audits có tất cả các cột từ bảng CUSTOMER
--Bên cạnh đó, nó có thêm một vài cột để ghi lại những thay đổi
create trigger Trg_Customer_audits
on CUSTOMER
after insert,delete 
as
begin
   --set nocount on;
   insert into Customer_audits
   (
        MaKH,
        TenKH,
        Email,
        SoDT,
        DiaChi,
		Updated_at,
        Operation
   )
   select
        i.MaKH,
        TenKH,
        Email,
        SoDT,
        DiaChi,
		GETDATE(),
		'INSERT'
	from inserted i
	union all
	select 
	    d.MaKH,
        TenKH,
        Email,
        SoDT,
        DiaChi,
		GETDATE(),
		'DELETE'
	from inserted d;
end

insert into CUSTOMER(MaKH,TenKH,Email,SoDT,DiaChi)
   values 
   ( 'KH0007','hoang lan','lan@gmail.com',0901233356,'Lien Chieu')

DELETE FROM CUSTOMER WHERE MaKH = 'KH0007';

SELECT * FROM Customer_audits