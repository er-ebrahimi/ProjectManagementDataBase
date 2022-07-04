--@20_query 
--@insert_in_to_table 
--@update_table 
--@update_rows_line 
--@delete_from_table 
--@add_constraint 
--@update_constraint 
--@trigger 
--@view
--@function
--@procedure
CREATE table account
(
    firstName NVARCHAR(max) not NULL,
    lastName NVARCHAR(max) not null,
    phoneNumber CHAR(10),
    Email NVARCHAR(max) NOT NULL,
    accountID nchar(32) NOT NULL PRIMARY KEY
)
GO
--ADD constraint
----------------@add_constraint 
ALTER TABLE account add constraint numberAccount check (ISNUMERIC(phoneNumber) = 1)

go

create TABLE project
(
    ProjectID nchar(32) not NULL PRIMARY key,
    kind NVARCHAR(max) not null,
    startDate date NOT NULL,
    time TIME not NULL,
    endDate Date,

    --discription
)
GO

--Update table
-------------------------------------@update_table 
ALTER TABLE project ADD discription NVARCHAR(max) 

GO
---------------------------------------@add_constraint 
Alter table project ADD CONSTRAINT Project_date CHECK (endDate > startDate)

go

CREATE TABLE member
(
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    PRIMARY KEY (accountID,projectID),
    constraint FK_member_account FOREIGN key(accountID) REFERENCES account(accountID),--on delete CASCADE on update CASCADE,
    constraint FK_member_projectID FOREIGN key(projectID) REFERENCES project(projectID)--on delete CASCADE on update CASCADE
)


GO

CREATE TABLE admin
(
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    PRIMARY KEY(accountID,projectID),
    constraint FK_admin_account FOREIGN key(accountID) REFERENCES account(accountID),--on delete CASCADE on update CASCADE,
    constraint FK_admin_projectID FOREIGN key(projectID) REFERENCES project(projectID)--on delete CASCADE on update CASCADE
)


GO

CREATE TABLE observe
(
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    PRIMARY KEY(accountID,projectID),
    constraint FK_observe_account FOREIGN key(accountID) REFERENCES account(accountID),-- on delete CASCADE on update CASCADE ,
    constraint FK_observe_projectID FOREIGN key(projectID) REFERENCES project(projectID),-- on delete CASCADE on update CASCADE
)
GO

CREATE table List
(
    ListID nchar(32),
    projectID nchar(32),
    PRIMARY key(ListID, projectID),
    constraint FK_List_project FOREIGN KEY(projectID) REFERENCES project(projectID) on DELETE CASCADE on update CASCADE
)

go

CREATE TABLE task
(
    flag BIT,
    startDate date not NULL,
    endDate date not null,
    discription NVARCHAR(max),
    kind NVARCHAR(max),
    ListID nchar(32),
    projectID nchar(32),
    taskID nchar(32) PRIMARY key,
    constraint FK_task_List FOREIGN key (ListID, projectID) REFERENCES List(ListID, projectID) on DELETE CASCADE on update CASCADE
    ,
)

GO
-------------------------------------@update_table 
--UPDATE table
ALTER TABLE task drop COLUMN flag
-------------------------------------@update_table 
go
--update table
ALTER TABLE task add flag BIT

GO
--delete update
-----------------------@update_constraint 
ALTER TABLE task DROP constraint FK_task_List;

GO


ALTER TABLE task add constraint FK_task_List FOREIGN key (ListID, projectID) REFERENCES List(ListID, projectID)   on DELETE CASCADE on update CASCADE

GO
--ADD constraint 
----------------------------------------@add_constraint 
ALTER TABLE task ADD CONSTRAINT dateTask CHECK (startDate < endDate)

GO

CREATE TABLE admins_task
(
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    taskID nchar(32) not NULL,
    constraint FK_admins_task_member FOREIGN key (accountID,projectID) REFERENCES admin(accountID,projectID),
    constraint FK_member_account_task FOREIGN KEY (taskID) REFERENCES task(taskID)
)

GO
--delete, update
-------------------------------@update_constraint 
ALTER table admins_task DROP CONSTRAINT FK_member_account_task

GO

ALTER TABLE admins_task ADD constraint FK_member_account_task FOREIGN KEY (taskID) REFERENCES task(taskID) on DELETE CASCADE on update CASCADE

go


CREATE TABLE complete
(
    complete bit,
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    taskID nchar(32) not NULL,
    Date DATE not null,
    time time not null,
    constraint FK_complete_member  FOREIGN key (accountID,projectID) REFERENCES member(accountID,projectID),
    constraint FK_complete_task FOREIGN KEY (taskID) REFERENCES task(taskID)  on DELETE CASCADE on update CASCADE
)
GO
--delete, update

GO

CREATE TABLE comment
(
    content NVARCHAR(max),
    accountID nchar(32),
    projectID nchar(32),
    taskID nchar(32) not NULL,
    commentID int not NULL IDENTITY(1,1),
    Date DATE not null,
    time Date not null,
    PRIMARY key( taskID,commentID),
    constraint FK_comment_task FOREIGN key(taskID) REFERENCES task(taskID) on delete CASCADE on update CASCADE,
    constraint FK_cmment_account FOREIGN key(accountID,projectID) REFERENCES member(accountID,projectID)
)


----------------------------------------------@trigger 
go

create TRIGGER add_admin_member on admin after INSERT as BEGIN
    insert into member
    select *
    from inserted i
END


go

create TRIGGER delete_admin_member on member after delete as BEGIN
    delete from admin
    from inserted i
    where i.accountID = admin.accountID
END

GO

create TRIGGER add_member_observator on member after INSERT as BEGIN
    insert into observe
    select *
    from inserted i
END

go

create TRIGGER delete_member_observator on observe after delete as BEGIN
    delete from member
    from inserted i
    where i.accountID = member.accountID
END

go

create TRIGGER delete_project_admin on project after DELETE as BEGIN
    DELETE from admin
    from deleted
    where deleted.ProjectID  = admin.ProjectID
END

go

create TRIGGER delete_project_member on project after DELETE as BEGIN
    DELETE from member
    from deleted
    where deleted.ProjectID = member.ProjectID
end 
go

create TRIGGER delete_project_observe on project after DELETE as BEGIN
    DELETE from observe
    from deleted
    where deleted.ProjectID =  observe.ProjectID
END

GO

go
create TRIGGER delete_member_comment on complete after  delete as BEGIN
    UPDATE comment
    set accountID = null
    from deleted
    WHERE deleted.accountID = comment.accountID and deleted.projectID = comment.projectID
END
GO

CREATE TRIGGER delete_member_complete on member after delete as BEGIN
    delete from complete from deleted WHERE deleted.accountID = complete.accountID and deleted.projectID = complete.projectID
end

GO

CREATE TRIGGER delete_project on project INSTEAD of DELETE as BEGIN
    DELETE from observe FROM deleted WHERE observe.projectID = deleted.ProjectID
    DELETE from member FROM deleted WHERE member.projectID = deleted.ProjectID
    DELETE from admin FROM deleted WHERE admin.projectID = deleted.ProjectID
    DELETE from project FROM deleted WHERE project.projectID = deleted.ProjectID
END

GO

CREATE TRIGGER delete_account on account INSTEAD of DELETE as BEGIN
    DELETE from observe FROM deleted WHERE observe.accountID = deleted.accountID
    DELETE from member FROM deleted WHERE member.accountID = deleted.accountID
    DELETE from admin FROM deleted WHERE admin.accountID = deleted.accountID
    DELETE from account FROM deleted WHERE account.accountID = deleted.accountID
END

GO

CREATE TRIGGER delete_member on member INSTEAD of DELETE as BEGIN
    DELETE from complete FROM deleted WHERE complete.accountID = deleted.accountID
    DELETE from member FROM deleted WHERE member.accountID = deleted.accountID
END
GO

CREATE TRIGGER delete_admin on admin INSTEAD of DELETE as BEGIN
    DELETE from admins_task FROM deleted WHERE admins_task.accountID = deleted.accountID
    DELETE from admin FROM deleted WHERE admin.accountID = deleted.accountID
END

go
-----------------------------------------------------------------@insert_in_to_table 
INSERT INTO account
VALUES
    ('Hossein', 'Rahmani', '0912999999', 'h_rahmani@iust.ac.ir' , 'h_rahmani'),
    ('Shahrzad', 'Azari Rad', '0912999999', 'shahrzad_azari@comp.iust.ac.ir', 'shahrzad_azari'),
    ('Arshia', 'Arian Nejad', '0912999999', 'a_ariannejad@comp.iust.ac.ir', 'a_ariannejad'),
    ('Zahra', 'Amiri' , '0912999999', 'zahra_amiri@comp.iust.ac.ir' , 'zahra_amiri'),
    ('Alireza', 'Haghani', '0912999999', 'alireza_haqani@gmail.com', 'alireza_haqani'),
    ('Hanie', 'Jafari' , '0912999999', 'hanie_jafari@comp.iust.ac.ir', 'hanie_jafari'),
    ('Sadegh', 'Jafari', '0912999999' , 'sadegh_jafari@gmail.com', 'sadegh_jafari'),
    ('Babak' , 'Behkam Kia' , '0912999999', 'babak_behkamkia@comp.iust.ac.ir', 'babak_behkamkia'),
    ('Fateme' , 'Zahra Bakhshande' , '0912999999', 'fatemezahrabakhshande@gmail.com', 'fatemezahrabakhshande'),
    ('Sajjad', 'Ramezani' , '0912999999' , 'sajjad_ramezani@ind.iust.ac.ir', 'sajjad_ramezani'),
    ('Arman', 'Heidari' , '0912999999', 'heydari_arman@comp.iust.ac.ir' , 'heydari_arman'),
    ('Morteza', 'Shahrabi Farahani', '0912999999', 'm_shahrabi@comp.iust.ac.ir', 'm_shahrabi'),
    ('Saman' , 'Mohammadi Raoof', '0912999999', 'saman_mohammadi@comp.iust.ac.ir', 'saman_mohammadi'),
    ('Niki', 'Majidi Far' , '0912999999' , 'n_majidifard@comp.iust.ac.ir' , 'n_majidifard'),
    ('Banafshe', 'Gholinejad', '0912999999', 'b_gholinejad@comp.iust.ac.ir', 'b_gholinejad'),
    ('Parya' , 'Fasahat' , '0912999999' , 'parya_fasahat@comp.iust.ac.ir' , 'parya_fasahat'),
    ('Melika', 'Nobakhtian' , '0912999999' , 'm_nobakhtian@comp.iust.ac.ir', 'm_nobakhtian'),
    ('Ilia' , 'Mirzaei' , '0912999999', 'iliya_mirzaei@comp.iust.ac.ir' , 'iliya_mirzaei'),
    ('Aryan', 'Abdollahi Sabet Nejad' , '0912999999', 'aryan_abdollahi@comp.iust.ac.ir' , 'aryan_abdollahi'),
    ('Erfan', 'Ebrahimi Soviz' , '0912999999', 'er_ebrahimi@comp.iust.ac.ir' , 'er_ebrahimi'),
    ('Amir Ali', 'Farazmand' , '0912999999', 'amirali_farazmand@comp.iust.ac.ir', 'amirali_farazmand')



GO

INSERT INTO project
VALUES
    ('Database Course', 'Course' , '20220301', '13:30' , '20230301', 'Darse Database Daneshkade Computer' ),
    ('Project Management Database' , 'Agile' , GETDATE() , '13:30', '20230301', 'Project modiriat proje')

GO

INSERT INTO [admin]
VALUES
    ('h_rahmani', 'Database Course'  ),
    ('m_shahrabi', 'Database Course' ),
    ('er_ebrahimi', 'Project Management Database'),
    ('heydari_arman', 'Project Management Database')

GO

INSERT INTO member
VALUES
    ('shahrzad_azari', 'Database Course'),
    ('a_ariannejad' , 'Database Course'),
    ('zahra_amiri' , 'Database Course'),
    ('alireza_haqani' , 'Database Course'),
    ('hanie_jafari', 'Database Course'),
    ('sadegh_jafari', 'Database Course'),
    ('babak_behkamkia', 'Database Course'),
    ('fatemezahrabakhshande', 'Database Course'),
    ('sajjad_ramezani', 'Database Course' ),
    ('heydari_arman', 'Database Course'),
    ('saman_mohammadi', 'Database Course'),
    ('n_majidifard', 'Database Course'),
    ('b_gholinejad', 'Database Course'),
    ('parya_fasahat' , 'Database Course'),
    ('m_nobakhtian', 'Database Course' ),
    ('iliya_mirzaei', 'Database Course' ),
    ('amirali_farazmand', 'Project Management Database' ),
    ('aryan_abdollahi', 'Project Management Database' )

GO

INSERT into List
VALUES
    ('quiz' , 'Database Course')
    
GO

insert into task
VALUES
    ( '20220610', '20220710' , 'quiz in middle of term', 'check', 'quiz', 'Database Course', 'quiz1' , 0  ),
    ( '20200610', '20210710' , 'quiz in middle of term', 'check', 'quiz', 'Database Course', 'quiz2' , 0  )
GO

insert into admins_task
VALUES
    ('m_shahrabi' , 'Database Course', 'quiz1' ),
    ('h_rahmani' , 'Database Course', 'quiz1')

GO

insert into complete
VALUES
    (1, 'sadegh_jafari', 'Database Course' , 'quiz1' , GETDATE() , '13:30'),
    (0, 'iliya_mirzaei', 'Database Course' , 'quiz1' , GETDATE() , '13:30'),
    (0, 'iliya_mirzaei', 'Database Course' , 'quiz2' , GETDATE() , '13:30')

go

INSERT into comment
VALUEs
    ('hello', 'sadegh_jafari', 'Database Course' , 'quiz1', GETDATE() , '13:30' )

----------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------@function
GO
--procedure:
--	show comments of a task
CREATE OR ALTER function show_all_comments (@taskID nchar(32))
returns TABLE
return
SELECT *
FROM comment c
WHERE  c.taskID= @taskID
GO
-- select *
-- from show_all_comments ('quiz1')
--exec @show_all_comments = taskID
GO
--order the time of task in every project
create or alter function order_completed_project (@projectID nchar(32))
returns TABLE
RETURN
select m.accountID, ROW_NUMBER() OVER (ORDER BY c.[Date] DESC) ordering
from member m join complete c on c.accountID = m.accountID
where m.projectID = @projectID
-- ORDER BY c.[Date]
GO
-- select *
-- from
--     order_completed_project( 'Database Course')

GO
------------------------------@procedure
--procedure:
--	compelete task 
create OR ALTER procedure compelete_task
    (@taskid nchar(32) ,
    @memberid nchar(32) ,
    @projectid nchar(32))
as
begin
    insert into dbo.complete
        (complete ,accountID , projectID, [Date], [time] ,taskID)
    values( 1, @memberid , @projectid, GETDATE(), '11:30', @taskid)

    update dbo.task
	set flag =1 
	where taskID= @taskid
end
GO
-- compelete_task @taskid = 'quiz1', @memberid = 'iliya_mirzaei' , @projectid = 'Database Course'
GO

--procedure:p03_(i11)
--	compelete task 
--query:
--	change list of a task
CREATE OR ALTER PROCEDURE change_list_taske(
    @taskid nchar(32) ,
    @newlistid nchar(32)
)
AS
BEGIN
    update dbo.task
	set ListID = @newlistid
	where taskID = @taskid
END
GO

-- change_list_taske @taskid = 'quiz1', @newlistid = 'quiz'

GO

------------------------------------------view:
-- --create view of projects includes more than av number of tasks 
-- --than AVG of it for other projects (susspended projects)
----------------------------------------------@view
create or alter view susspendedProjects
as
    select count(*) counting_task
    from project p, (select tt.*
        FROM task tt, project p
        where tt.projectID=p.projectID) pro ,
        (select count(*) count_all, pp.projectID
        from task t join project pp on pp.ProjectID = t.projectID
        GROUP by pp.ProjectID ) counted
    where  p.ProjectID = pro.projectID and counted.ProjectID = pro.projectID
    GROUP BY p.projectID
    HAVING avg(counted.count_all) <= count(pro.taskID) 

go
-- select * from susspendedProjects
GO
-----------------------------------------------view:show the top 10 how has project more

CREATE or ALTER view project_account_amount
AS
    select top 10
        a.accountID ac, COUNT(p.ProjectID) projectCount
    from account a join observe o on o.accountID = a.accountID
        join project p on p.ProjectID = o.projectID
    GROUP BY a.accountID
    ORDER BY COUNT(p.ProjectID) ASC
GO

----------------------------------------------------@20_query 
-- -----------------------------------------------query:members who didn't do their task 
go

-- select m.accountID, a.firstName, a.lastName
-- from member m join account a on a.accountID = m.accountID
--     join complete c on c.accountID = m.accountID
-- WHERE c.complete <> 1 AND not exists (select m.accountID, a.firstName, a.lastName
--     from admin m join account a on a.accountID = m.accountID
--         join complete c on c.accountID = m.accountID
--     WHERE c.complete = 1)

-- ----------------------------------------------query:the members who has more than two tasks

-- select m.accountID , COUNT(t.taskID) counting, a.firstName , a.lastName
-- from task t join complete c on t.taskID = c.taskID
--     JOIN member m on m.accountID = c.accountID
--     JOIN account a on m.accountID = a.accountID
-- GROUP BY m.accountID ,  a.firstName , a.lastName
-- HAVING COUNT(t.taskID) >= 2

-- ---------------------------------------------query:every member order by count of task

-- select m.accountID , COUNT(t.taskID) counting_task, a.firstName , a.lastName
-- from task t join complete c on t.taskID = c.taskID
--     JOIN member m on m.accountID = c.accountID
--     JOIN account a on m.accountID = a.accountID
-- GROUP BY m.accountID ,a.firstName , a.lastName
-- ORDER BY  COUNT(t.taskID) desc

-- ---------------------------------------------query:order project by observator

-- select p.projectID, COUNT(o.accountID) counting_account
-- from project p join observe o on o.projectID = p.ProjectID
-- GROUP by p.projectID
-- ORDER BY COUNT(o.accountID) desc

-- --------------------------------------------query:find someone how did all the task in one project 

-- select m.accountID , m.projectID, complete.complete
-- from member m join complete c on m.accountID = c.accountID
--     join task t on t.taskID = c.taskID join project p on p.ProjectID = m.projectID, member m2 join complete on m2.accountID = complete.accountID
-- -- where complete.complete = 1 and c.projectID = m2.projectID
-- where complete.complete = 1 and c.projectID = m2.projectID and c.accountID = m2.accountID and complete.taskID = c.taskID
-- group by m.projectID,m.accountID,complete.complete
-- HAVING count(complete.taskID) IN (select count(complete.taskID)
-- from member m join complete c on m.accountID = c.accountID
--     join task t on t.taskID = c.taskID, member m2 join complete on m2.accountID = complete.accountID
-- group by m.accountID, complete.taskID )



-- ----------------------------------------------query:
-- --	 Show accounts list and their name sorted by number of projects they attended 
-- SELECT a.accountID, concat(a.firstName,' ', a.lastName) as fullName , COUNT(p.ProjectID) AS TotalProjects
-- FROM account a
--     INNER JOIN member m ON m.accountID=a.accountID
--     LEFT JOIN project p
--     ON p.projectID = m.ProjectID
-- group by a.accountID , a.firstName ,a.lastName
-- order by count(p.projectID)

-- ------------------------------------------------query:
-- --	number of members,observers and admins for each project 
-- select p.ProjectID
--        , count(o.accountID) as accountsCount
-- from project p
--     left outer join observe o
--     on o.projectID=p.ProjectID
-- group by p.projectID;

-- ----------------------------------------------query:q5_(i12.5) 
-- --	show remaining time and passed time for each task of a project
-- select * , datediff(day ,t.startDate, getdate()) as passedTime_days, datediff(day ,getdate(),t.endDate) as remainigTime_days
-- from task t
-- where t.projectID= 'Database Course'

-- ----------------------------------------------qeury: q6_(i12)
-- --	show passed time for each project
-- select * , datediff(day ,p.startdate, getdate()) as passedTime_days
-- from project p
-- order by p.ProjectID


-- -----------------------------------------------query:q7_(i16)
-- --	show all unfinished tasks that their deadline time passed
-- select * , datediff(day  , t.endDate , getdate()) as passedDays
-- from task t
-- where GETDATE() > t.endDate

-- ---------------------------------------------query:q8_(i18)
-- --	show common members of 2 project
-- select m1.accountID
-- from member m1 inner join member m2 on m1.accountID=m2.accountID and m1.projectID<>m2.projectID
-- GROUP by  m1.accountID
-- ---------------------------------------------query:q9_(i19)
-- --	show members who hasnt done any task
-- select *
-- from account a join complete c on a.accountID = c.accountID
-- where  0 = all(select c.complete from complete co where a.accountID = co.accountID)

-- ----------------------------------------------query:q10_(i7)
-- --	show all projects that a person attends in as member
-- --	cnsider #aID as an accountID
-- select *
-- from account a
--     inner join admin ad on ad.accountID=a.accountID
-- ----------------------------------------------query:q10_(i7)
-- select *
-- from account a
--     inner join member m on m.accountID=a.accountID
-- ----------------------------------------------query:q10_(i7)
-- select *
-- from account a
--     inner join observe o on o.accountID=a.accountID

-- -----------------------------------------------query:q11_(i3)
-- --	show tasks of #listID 
-- select *
-- from task t
-- where  t.ListID='quiz'

-- -------------------------------------------------query:qa1_(i1)
-- -- i1 
-- -- show count & list of names of members of a #P project 
-- SELECT A.firstName + ' ' + A.lastName AS Member_of_project,
--     A.accountID AS UserID
-- FROM observe AS O
--     JOIN account AS A ON A.accountID = O.accountID
-- WHERE O.projectID = 'Database Course'
-- -- 'Database Course'

-- SELECT count(*)
-- FROM observe AS O
--     JOIN account AS A ON A.accountID = O.accountID
-- WHERE O.projectID = 'Database Course'
-- -- 'Database Course'
-- ---------------------------------------------------query:
-- -- i2 
-- -- show undone tasks from a project '#P' 
-- SELECT T.taskID AS TaskID,
--     T.discription AS TaskDescription
-- FROM task AS T
--     JOIN List AS L ON T.ListID = L.ListID
--     JOIN project AS P ON P.ProjectID = T.projectID
-- WHERE T.flag = 0 AND T.projectID = 'Database Course'
-- -- 'Database Course'
-- ----------------------------------------------------query:qa3_(i4)
-- -- i4
-- -- show names of lists of a project '#P'
-- SELECT L.ListID
-- FROM project AS P
--     JOIN List AS L ON L.projectID = p.ProjectID
-- WHERE p.ProjectID = 'Database Course'
-- GROUP BY L.ListID
-- -------------------------------------------------------query:q12_(i10.5)
-- --	who made a task(full informations ) + taskID
-- select a.* , t.taskID as createdTask
-- from task t right join admins_task ad on ad.taskID=t.taskID
--     left join account a on a.accountID=ad.accountID
-- -------------------------------------------------------query:maximum amount of comment
-- select MAX(counted.num) most_comment , counted.accountID
-- from ( select count(m.accountID )as num , m.accountID
--     from member m join comment on comment.accountID = m.accountID
--     group by m.accountID) as counted
-- group by counted.accountID


--------------------------update and delete
-----------------------------@update_rows_line 
-- UPDATE account set firstName = 'Hanyie' WHERE accountID = 'hanie_jafari'

-- UPDATE task set endDate = '20230710' where taskID = 'quiz1'

-- select * from account where accountID = 'hanie_jafari'
-- select * from task where taskID = 'quiz1'
----------------------------deletes
------------------------------@delete_from_table 
-- delete from comment where commentID = 1


-- delete from member where accountID = 'sadegh_jafari'


-- delete from project WHERE projectID = 'Database Course'



