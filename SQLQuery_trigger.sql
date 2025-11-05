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


-- thu nghiem trigger tinh toan tu dong trong database.
--yeu cau nhap diem kiem tra 15p va diem kiem tra 60p tinh ra diem trung binh roi cho dang xep loai
CREATE TABLE scoreboard
(
    stt int identity(1,1),
    score15 char(5),
	score60 char(5),
	avgScore char(5),
	rank_ char(5),
	constraint PK_stt primary key (stt)
);
alter table scoreboard
alter column score15 float
go
alter table scoreboard
alter column score60 float
go
alter table scoreboard
alter column avgScore float
go
alter table scoreboard
alter column score15 float
go;
-- trigger tu dong tinh toan va update so vao trong cot avgscore va rank_

create trigger UT_calculateScore
on scoreboard 
after insert, update
as
BEGIN
	set nocount on;
-- avgScore = score15*0.3 + score60*0.7
-- rank_ nhu ngay dai hoc
	update sb 
	set
	avgScore = i.score15*0.3 + i.score60*0.7,
	rank_= case
				when (i.score15 * 0.3 + i.score60 * 0.7) <= 8.5  and (i.score15 * 0.3 + i.score60 * 0.7)  <10.0  then 'A'
				when (i.score15 * 0.3 + i.score60 * 0.7) <= 7.0  and (i.score15 * 0.3 + i.score60 * 0.7)  <8.5 then 'B'
				when (i.score15 * 0.3 + i.score60 * 0.7) <= 5.0 and (i.score15 * 0.3 + i.score60 * 0.7)  <7.0  then 'C'
				when (i.score15 * 0.3 + i.score60 * 0.7) <= 3.0  and (i.score15 * 0.3 + i.score60 * 0.7)  <5.0  then 'D'
				else 'F'
			end
	from scoreboard sb
	inner join inserted i on sb.stt = i.stt;
END;
go
---------------------------
alter trigger UT_calculateScore
on scoreboard 
after insert, update
as
BEGIN
	set nocount on;
-- avgScore = score15*0.3 + score60*0.7
-- rank_ nhu ngay dai hoc
	update sb -- doan nay dung cau lenh update cua sql update tablename set val1='', val2='' from talename. 
	set
	avgScore = i.score15*0.3 + i.score60*0.7, -- i la viet tat cho inserted alias
	rank_= case
				when (i.score15 * 0.3 + i.score60 * 0.7) >= 8.5  and (i.score15 * 0.3 + i.score60 * 0.7)  <10.0  then 'A'
				when (i.score15 * 0.3 + i.score60 * 0.7) >= 7.0  and (i.score15 * 0.3 + i.score60 * 0.7)  <8.5 then 'B'
				when (i.score15 * 0.3 + i.score60 * 0.7) >= 5.0 and (i.score15 * 0.3 + i.score60 * 0.7)  <7.0  then 'C'
				when (i.score15 * 0.3 + i.score60 * 0.7) >= 3.0  and (i.score15 * 0.3 + i.score60 * 0.7)  <5.0  then 'D'
				else 'F'
			end
	from scoreboard sb -- tuong tu voi truong hop cua inserted
	inner join inserted i on sb.stt = i.stt; -- khia bao inserted viet tat la i
END;
go


---------------------------
-- tao trigger khi update 1 gia tri score15 thi gia tri score15 cu giu nguyen, gia tri moi duoc luu vao 1 cot moi score15_1, nhung la tiep theo la score15_i

create trigger UT_CreateNewColumn
on test1
after update
as

BEGIN

 set nocount on;
 --
 -- hang muc them gia tri
 insert test1( ) 
 select 
 -- new value 
 from inserted 
END
go




-- test trigger UT_calculateScore
insert into scoreboard (score15,score60) values (8.2,9.1);
go
select * from scoreboard;
go

create table testStore
(
id int identity(1,1),
val1 varchar(max),
val2 varchar(max)
constraint PK_id_testStore primary key (id)

)

---
-- trigger dynamic value khi update cac gia tri them vao ma khong can phai tao them cot trong database
create trigger UT_StoreDynamicVal1
on testStore
for update
as

BEGIN
	if update(val1)

		BEGIN
		update testStore 
		set val1 = d.val1+','+i.val1
		 from inserted i join deleted d on d.id=i.id
		 where testStore.id=i.id
		END
END


insert into testStore values ('aa','b')
update testStore set val1 = '22' from testStore
go
select * from testStore 