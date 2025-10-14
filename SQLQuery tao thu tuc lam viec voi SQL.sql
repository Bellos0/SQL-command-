--làm việc và  tạo các thủ tục trong cơ sở dữ liệu 
-- thực hiên tạo thủ tục danh sách 

-- ví dụ lấy tất cả thông tin của quanlysinhvien 
create procedure SP_laythongtinsinhvien
as 
select masinhvien, hoten, diachi from SinhVien;



