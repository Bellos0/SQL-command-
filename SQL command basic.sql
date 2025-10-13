use master
go

create database QuanLySinhVien

go

use QuanLySinhVien;
go
create table SinhVien
(
 id int identity(1,1) primary key,
 masinhvien char(8) not null,
 hoten nvarchar(50) not null,
 sex bit ,
 ngaysinh date ,
 dienthoai varchar(20),
 email varchar(20),
 diachi nvarchar(250)
 

) ;

-- tao bang chuyen khoa

create table chuyenkhoa
(
makhoa char(5),
tenkhoa nvarchar(50) ,
constraint PK_chuyenkhoaID primary key (makhoa),
)									;									   ;
--- sua cau truc 1 bang

alter table SinhVien
add chuyenkhoaID char(5) 

-- sua bang tao quan he sinh vien va chuyen khoa

alter table SinhVien
add constraint FK_chuyenkhoaID foreign key (chuyenkhoaID)
references chuyenkhoa(makhoa)


-- tao bang mon hoc
create table monhoc
(
  mamonhoc char(5) primary key,
  tenmonhon nvarchar(50) ,
  sodonvihoctrinh int
);

	-- tao bang phong hoc
   create table phonghoc
   (
	   ID int identity(1,1) primary key,
	   tenphong nvarchar(50)
   );

--them bang diem thi
create table diemthi
(
sinhvienID int,
monhocID char(5),
diem float,
ngaythi date,
phonghocID int,
constraint PK_diemthi_ID primary key (sinhvienID, monhocID)
); -- dung 2 gia tri lam primary key cho bang


-- tao quan he cua bang diem thi va sinh vien
alter table diemthi
add constraint FK_sinhvien_ID foreign key (sinhvienID)
references sinhvien(id);

-- tao quan he giua diem thi va mon hoc
alter table diemthi
add constraint FK_monhoc_ID foreign key (monhocID)
references monhoc(mamonhoc);

-- quan he diem thi va phong hoc
alter table diemthi
add constraint FK_phonghoc_ID foreign key (phonghocID)
references phonghoc(ID)		 ;



--them thong tin cho cac bang
-- them thong tin cho bang chuyen khoa

select * from chuyenkhoa
insert into chuyenkhoa values ('CNTT', 'cong nghe thong tin');
insert into chuyenkhoa values ('DT', 'dien tu');
insert into chuyenkhoa values ('KD', 'kinh doanh');


-- then thong tin sinh vien

select * from SinhVien
insert into SinhVien (masinhvien, hoten,diachi, chuyenkhoaID)
values ('SP001', 'tran van thanh', 'thai nguyen','CNTT');
insert into SinhVien (masinhvien, hoten,diachi, chuyenkhoaID)
values ('SP002', 'tran van than', 'ha noi','DT');
insert into SinhVien (masinhvien, hoten,diachi, chuyenkhoaID)
values ('SP001', 'tran van tha', 'thai nguyen','KD');

-- them thong tin mon hoc
insert into monhoc  values	('TCC', 'toan cao cap', 3);
insert into monhoc  values	('LTC', 'lap trinh c++', 3);
insert into monhoc  values	('CNW', 'cong nghe web', 3);

-- them thong tin phong hoc
select * from phonghoc
insert into phonghoc values ( 'phong hoc 201');
insert into phonghoc values ('phong hoc 202');
insert into phonghoc values ('phong hoc 203');

dbcc checkident ('phonghoc');

-- nhap diem thi
select * from diemthi
insert into		diemthi values (1, 'TCC', 6, '10/11/2025',1);
insert into		diemthi values (1, 'LTC', 7, '10/11/2025',2);