select * from diemthi
SELECt * from monhoc
insert into diemthi values (2, 'TCC', 6, '10/12/2025', 2);
insert into diemthi values (1, 'CNW', 6, '10/12/2025', 2) ;

select distinct  monhocID from diemthi

-- sap xep theo thu tu tang dan

select * from SinhVien order by hoten asc

-- sap xep theo thu tu giam dan
select * from SinhVien order by hoten desc;



-- truy van du lieu


--ham so hoc
--round(n,[m]): cho gia tri lam tron cua n den cap m
-- ceiling(n): cho so nguyen nho nhat lon hon hoac bang n
-- floor(n): cho so nguyen lon nhat  bang hoac nho hon  n
-- power(m,n): luy thua bac n cua m
--sqrt(n): can bang 2 cua n, n >= 0

use master
go

use QuanLySinhVien
select round(5.3265,2)

select ceiling(5.3265)

select FLOOR(5.3265)

select POWER(2,3)

select SQRT(16)

-- ham ky tu
-- chuyen ve chu thuong
select lower('HELLO HOW ARE YOU')

-- chuyen ve chu hoa
select upper('i am fine thank you')

-- loai bo khoang trang ben trai
select ltrim('     HELLO')

-- loai bo khoan trang ben phai
select rtrim('hello           ')

-- replace(char, search_str, replace str): thay the chuoi search_str co trong char bang chuoi replace
-- substring(char,m,[n]): lay chuoi con char tu vi tri m ve ben phai n ky tu, neu n =0 thi lay het chuoi
-- len(char): tra ve chieu dai chuoi

select replace('tran van thanh', 'van', 'chuong')

select substring(' tran van thanh', 4, 3) as result

select len('tran van thanh') as result


-- ham ngay thang
--month(date): lay thang cua thong tin date
--day(date) lay ngay trong date
--year(date) lay nam trong date
--dateadd(datepart, number, date): them thong tin vao date hien tai
--datediff(datepart, startdate, enddate) luon la end - start

select month(getdate())

select day(getdate())

select year(getdate())

select dateadd(d, 3, '10/13/2025')

select datediff(m, '10/13/2025','8/13/2025')

--ham chuyen doi
--convert(type, value) chuyen doi du lieu value ve dang type
--cast(value as type) chuyen du lieu ve dang tuong ung

select convert(int, 3.14)*3

select cast(3.14 as int)*5

select convert(date, '10/13/2025',101)

-- ham nhom
--count() dem so lan xuat hien cua thuoc tinh, * la dem het
--sum(column) tinh tong gia tri (value dang so)
--avg(column) tinh trung binh
--max(column) gia tri lon nhat
--min(colunm) gia tri nho nhat

select count(masinhvien)   from SinhVien

select sum(diem) from diemthi

select avg(diem) from diemthi

select max(diem	) from diemthi

select min(diem) from diemthi

--gop tong, trung binh min max

select sum(diem) tong, max(diem	)  max, min(diem)  min, avg(diem)  avg from diemthi 

select * from	SinhVien

--thong ke dia chi cua sinh vien 

select diachi, count(*) from SinhVien group by diachi

--thong ke dia chi cua sinh vien va dia chi nao co nhieu hon 1

select diachi, count(*) from SinhVien group by diachi having count(*) > 1

-- lay thong tin tu nhieu bang
-- luu y doan sinhvien.chuyenkhoaID = chuyenkhoa.makhoa thi chuyenkhoaID va makhoa phai cung loai bien va kich thuoc.
select * from chuyenkhoa
select masinhvien, hoten, makhoa from SinhVien, chuyenkhoa where SinhVien.chuyenkhoaID = chuyenkhoa.makhoa

-- lay thong tin tu nhieu bang bang thi khoa join
select masinhvien, hoten, diachi, makhoa, tenkhoa from SinhVien sv inner join chuyenkhoa ck on sv.chuyenkhoaID = ck.makhoa

-- lay thong tin uu tien tu bang ben trai/phai thi thay inner = left/right. vi du cho sinh vien chua phan khoa, hoac khoa thanh lap nhung k co sinh vien

insert into SinhVien (masinhvien, hoten) values ('SP225', 'bellos');

insert into chuyenkhoa values ('AUTO', (select upper('tu dong hoa')))

--hien thi thang bello khoa null vi dang left join uu tien bang sinh vien(ben trai)
select masinhvien, hoten, diachi, makhoa, tenkhoa from SinhVien sv left join chuyenkhoa ck on sv.chuyenkhoaID = ck.makhoa

-- hien thi tu dong hoa null do chua co sinh vien, tuc la uu tien bang ben phai chuyen khoa
select masinhvien, hoten, diachi, makhoa, tenkhoa from SinhVien sv right join chuyenkhoa ck on sv.chuyenkhoaID = ck.makhoa

--lay het ca 2 bang, chu full join
select masinhvien, hoten, diachi, makhoa, tenkhoa from SinhVien sv full join chuyenkhoa ck on sv.chuyenkhoaID = ck.makhoa


--sub-query va main-query

select * from monhoc where mamonhoc in (
select distinct monhocID from diemthi)

-- lay thong tinh diem thi cua sinh vien gom: ma sinh vien, ho ten, dia chi, ma mon hoc, ten mon hoc, ngay thi, diem thi

select masinhvien, hoten, diachi, monhocID, tenmonhoc, ngaythi, diem from SinhVien sv inner join diemthi dt 
on 
sv.id = dt.sinhvienID
inner join monhoc mh on dt.monhocID = mh.mamonhoc
-- from SinhVien sv inner join diemthi dt on sv.id = dt.sinhvienID inner join monhoc mh on dt.monhocID = mh.mamonhoc. cum nay ta chia thanh 2 bang.
-- bang 1: SinhVien sv inner join diemthi dt on sv.id = dt.sinhvienID
-- bang 2: bang 1 + inner join monhoc mh on dt.monhocID = mh.mamonhoc