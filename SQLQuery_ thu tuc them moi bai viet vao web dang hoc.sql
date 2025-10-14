use WebServer

--tao thu tuc load toan bo bai viet
create proc SP_LoadArticle

as 
select * from ArticleStorage

--thu tuc load article theo artID
create proc SP_LoadArt_via_artID
(
@artID int
)
as 
select * from ArticleStorage 
where 
artID=@artID;



-- tao thu tuc them moi bai viet cho web

create procedure SP_insertArticle
(
@artID int,
@title nvarchar(max),
@categories nvarchar(50),
@images nvarchar(max),
@description nvarchar(max),
@author nvarchar(50),
@dateCreate nvarchar(50)
)
as 
insert into ArticleStorage (artID,title,categories,images,description,author,dateCreate) values (@artID,@title,@categories,@images,@description, @author,@dateCreate);


-- tao thu chinh sua bai viet
create proc SP_EditArticle
(
@artID int,
@title nvarchar(max),
@categories nvarchar(50),
@images nvarchar(max),
@description nvarchar(max),
@author nvarchar(50),
@dateCreate nvarchar(50)
)
as 
update ArticleStorage 
SET 
title = @title, 
categories = @categories, 
description = @description, 
author = @author, 
dateCreate = @dateCreate, 
images = @images 
where 
artID = @artID;

--thu tuc xoa bai viet 
create proc SP_DelArticle
(
@artID int
)
as 
delete  from ArticleStorage 
where 
artID=@artID;


-- tao ham de dem so luong bai viet tu artID

create function F_countArticle
(
@artID int
)
returns int
begin

--khai bao bien nhan so luong tra ve
declare @AmountArticle int

-- gan gia tri cho bien
set @AmountArticle = (select count(*) from ArticleStorage where artID=@artID)

--tra ve ket qua
return @AmountArticle
end;

select * from ArticleStorage
--su dung ham
select dbo.F_countArticle(88151)

--su dung ham trong cau lenh truy van

select artID,title, categories, dbo.F_countArticle(88151) as 'amount article' from ArticleStorage 