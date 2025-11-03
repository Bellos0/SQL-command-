use master
go

create database generalTest
go

use generalTest
go

create table test1
(
id int identity (1,1),
value11 int,
value12 int,
constraint PK_id primary key (id)
)

create table test2
(
id int identity (1,1),
value21 int,
value22 int,
constraint PK_id2 primary key (id)
);

-- sua bang 2 them 1 cot la ngay cap nhat
alter table test2
add updateTime date;

--sua dinh dang 
alter table test2
alter column updateTime char(15);

--tao trigger 
-- trong trigger luon ton tai 2 bang
	--inserted: chua nhung truong da insert vao bang bao gom ca update 
	--deleted: chua nhung truong bi xoa khoi bang

-- triger nay duoc kich hoat khi thao tac insert, update va delete len test1, trigger active no in ra dong chu 'UTG_insertTest1 passed'
create trigger UTG_insertTest1 
on test1 
for insert, update, delete
as
begin
--rollback tran
print 'UTG_insertTest1 passed'

end
go

alter trigger UTG_insertTest1 
on test1 
for insert, update, delete
as
begin
--rollback tran
print 'UTG_insertTest1 passed'

end
go

alter trigger UTG_insertTest1 
on test1 
for insert, update, delete
as
begin
	rollback tran -- huy bo thay doi
	print 'UTG_insertTest1 passed'
	

end
go

--tao trigger de ngan chan xoa value nho hon 3
create trigger UT_AbortDelValueOderThan3
on test1
for delete
as
begin
	declare @count int = 0

	select @count = COUNT(*) from deleted
	where value11 < 3

	if(@count < 3)
	begin
	
		rollback tran	
		print 'UT_AbortDelValueOderThan3 passed'
	end
end

--tao trigger de update gia tri tu test1 vao test2 tu dong
create trigger UT_AutoInsertValueTest1toTest2
on test1
for insert, update
as
begin
	insert test2(value21, value22)
	select value11,value12 from inserted
end
go

-- thu bo sung 2 gia tri tu bang test1 va thoi gian bo su
alter trigger UT_AutoInsertValueTest1toTest2
on test1
for insert
as
begin
	insert test2(value21, value22, updateTime)
	select 
	value11,
	value12, 
	FORMAT(GETDATE(),'dd/MM/yyyy') --ngay thang nam thi thang phai de MM thi moi nhan dung, con mm la nhan sai thang
	from inserted;
	print 'UT_AutoInsertValueTest1toTest2_datetime pass'
end
go

select COUNT(*) from test1
select * from test1
select * from test2
select * from inserted --bang nay loi vi la bang ao
delete from test2

insert into test1 values(1,2);
insert into test1 values(2,2);
insert into test1 values(3,3);
insert into test1 values(6,7);
update test1 set value11 = 4, value12=5
delete from test1 where value11<3

select FORMAT(GETDATE(),'dd/MM/yyyy')





