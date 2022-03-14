CREATE DATABASE QLMUAHANG;
USE QLMUAHANG;
drop database QLMUAHANG;
CREATE TABLE CUSTOMER (
       MaKH VARCHAR (10) PRIMARY KEY,
	   TenKH NVARCHAR (100),
	   Email VARCHAR (100),
	   SoDT VARCHAR (10),
	   DiaChi VARCHAR (100)
	  );

CREATE TABLE PAYMENT (
       MaPTTT VARCHAR (10) PRIMARY KEY,
	   TenPhuongThucTT NVARCHAR (100),
	   PhiTT INT
	  );

CREATE TABLE PRODUCT (
       MaSP VARCHAR (10) PRIMARY KEY,
	   TenSP NVARCHAR (100),
	   MoTa NVARCHAR(225),
	   GiaSP INT,
	   SoLuongSP INT
	  );

CREATE TABLE ORDERS (
       MaDH VARCHAR (10) PRIMARY KEY,
	   MaKH VARCHAR (10),
	   FOREIGN KEY (MaKH) REFERENCES CUSTOMER (MaKH),
	   MaPTTT VARCHAR (10),
	   FOREIGN KEY (MaPTTT) REFERENCES PAYMENT (MaPTTT),
	   NgayDat DATE,	
	   TrangThaiDatHang NVARCHAR(100),
	   TongTien INT
	   );


CREATE TABLE ORDER_DETAIL (
       MaOD VARCHAR (10) PRIMARY KEY,
	   MaDH VARCHAR (10),
	   FOREIGN KEY(MaDH) REFERENCES ORDERS (MaDH),
	   MaSP VARCHAR (10),
	   FOREIGN KEY(MaSP) REFERENCES PRODUCT (MaSP),
	   SoLuong INT,
	   GiaSP INT ,
	   ThanhTien INT 	   
	  );


INSERT INTO CUSTOMER VALUES  
--           MaKH        TenKH           Email            SoDT      DiaChi 
            ('KH0001', 'Bui Nhi',    'nhi@gmail.com',  09012345, 'Lien Chieu'),
			('KH0002', 'Bui Anh',    'anh@gmail.com',  09112345, 'Thanh Khe'),
			('KH0003', 'Nguyen Van', 'van@gmail.com',  09112346, 'Lien Chieu'),
			('KH0004', 'Nguyen Bao', 'bao@gmail.com',  09012346, 'Thanh Khe'),
			('KH0005', 'Bui Lan',    'lan@gmail.com',  09012347, 'Hai Chau'),
			('KH0006', 'Nguyen Tai', 'tai@gmail.com',  09112347, 'Hai Chau');

INSERT INTO PAYMENT VALUES
--           MaPTTT   TenPhuongThucTT           PhiTT 
            ('TT001',  N'Visa',                 2000),
            ('TT002',  N'Banking',              1000),
            ('TT003',  N'MoMo',                 1000),
			('TT004',  N'Thanh toán trực tiếp', 50000);

INSERT INTO PRODUCT VALUES
--           MaSP           TenSP                 MoTa             GiaSP  SoLuongSP 
            ('SP001',  N'Bánh bông lan cốt mềm',N'Bánh bông lan ', 55000,  20),
            ('SP002',  N'Bánh ngọt socola'  ,   N'Bánh ngọt',      200000, 10),
            ('SP003',  N'Bánh 2 tầng',          N'Bánh ngọt',      250000, 15);

INSERT INTO ORDERS VALUES
--            MaDH       MaKH     MaPTTT     NgayDat      TrangThaiDatHang  TongTien 
            ('DH0001', 'KH0002', 'TT001',  '2021-05-25',    N'Đã giao',     277000),
			('DH0002', 'KH0002', 'TT002',  '2022-01-01',    N'Đang giao',   331000),
			('DH0003', 'KH0001', 'TT004',  '2022-01-15',    N'Đã giao',     1050000),
			('DH0004', 'KH0005', 'TT003',  '2021-08-25',    N'Đã giao',     1501000),
			('DH0005', 'KH0004', 'TT003',  '2021-06-30',    N'Đang giao',   251000);

INSERT INTO ORDER_DETAIL VALUES
--           MaOD     MaDH    MaSP  SoLuong GiaSP ThanhTien 
            ('OD001','DH0001','SP001', 5,   55000,  275000),
            ('OD002','DH0002','SP001', 6,   55000,  330000),
            ('OD003','DH0003','SP003', 4,  250000, 1000000),
			('OD004','DH0004','SP002', 6,  200000, 1500000),
            ('OD005','DH0005','SP003', 1,  250000,  250000);

CREATE EVENT Evt_IsProduct
ON SCHEDULE AT CURRENT_TIMESTAMP + interval 20 second
ON COMPLETION PRESERVE
DO
   INSERT INTO product (MaSP, TenSP, MoTa, GiaSP, SoLuongSP) 
   VALUES('SP006', 'Banh Donus', 'Banh ngot', 50000, 20);

drop event Evt_IsProduct;
select * from product;
SHOW PROCESSLIST;
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

-- Nhi
-- Tạo 1 event tự động xóa hết số lượng bánh còn lại trong 
-- bảng Product sau 11h đêm hằng ngày 
create event Ev_xoahangdu
on schedule 
every '1' day 
starts '2022-03-13 23:00:00'
on completion preserve
do 
update  PRODUCT
SET SoLuongSP = 0
WHERE MaSP !='SP000';

drop event Ev_xoahangdu;

select * from PRODUCT;

show events from qlmuahang;
-- Tạo 1 event tự động cập nhật số lượng bánh trong 
-- bảng Product mỗi loại hàng đều là 20 sp sau 8h sáng hằng ngày 
create event Ev_updatehang
on schedule 
every '1' day 
starts '2022-03-14 08:00:00'
on completion preserve
do 
update  PRODUCT
SET SoLuongSP = 20
WHERE MaSP !='SP000';

drop event Ev_updatehang;

show events from qlmuahang;

select * from PRODUCT;

update PRODUCT
SET SoLuongSP = 99
WHERE MaSP !='SP001';


select * from PRODUCT;

SELECT curtime() today;

create event Ev_uptest
on schedule 
every '1' day 
starts '2022-03-12 13:42:00'
on completion preserve
do 
update  PRODUCT
SET SoLuongSP = 40
WHERE MaSP !='SP000';

drop event Ev_uptest;

show events from qlmuahang;

select * from PRODUCT;
-- Nguyên
-- Event: Tao mot event de update gia Phi phuong thuc thanh toan cua banking len 500VND sau moi 1 nam
-- Ket thuc event nay trong vong sau 3 nam (3 nam sau tinh tu ngay hien tai se la ngay ket thuc hop dong vs MoMo)
CREATE EVENT Event_UpBanking500DPerYearIn3Y
ON SCHEDULE EVERY 1 year
STARTS CURRENT_TIMESTAMP + INTERVAL 1 year
ENDS CURRENT_TIMESTAMP + INTERVAL 3 year
DO
   update qlmh.payment set  PhiTT= PhiTT+500 where MaPTTT='TT003';

drop event Event_UpBanking500DPerYearIn3Y;

-- trigger: Khach hang co the trung ten voi nhau hoac trung dia chi, 
-- Nhung moi khach hang khi dang ki dich vu chi duoc phep su dung 1 tai khoan gmail 
-- va 1 so dien thoai duy nhat, khong duoc phep trung lap mot trong hai.
-- Viet 1 trigger kiem tra 2 dieu kien o tren  

DELIMITER $$
create trigger trigger_CheckDupCusInfor after insert on customer
for each row
begin
	declare checkMail INT;
    declare checkPhone INT;
    select count(*) into checkMail from customer where Email = new.Email;
    select count(*) into checkPhone from customer where SoDT = new.SoDT;
    if(checkMail >= 2)then
		SIGNAL sqlstate '45001' set message_text = "email nay da duoc dang ki, Hay thu lai !!!";
	end if;
	if(checkPhone >= 2)then
		SIGNAL sqlstate '45001' set message_text = "So dien thoai nay duoc su dung, Hay thu lai !!!";
	end if;
end$$
DELIMITER 

show triggers from qlmuahang;