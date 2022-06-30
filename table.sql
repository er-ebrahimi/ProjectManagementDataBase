--TODO when accounthasProject was null it means when nobody point to project then delete project
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
ALTER TABLE account add constraint numberAccount check (ISNUMERIC(phoneNumber) = 1)

go

create TABLE project
(
    ProjectID nchar(32) not NULL PRIMARY key,
    kind NVARCHAR(max) not null,
    date date NOT NULL,
    time TIME not NULL,
    --discription
)
GO

--Update table
ALTER TABLE project ADD discription NVARCHAR(max) 

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
--ADD constraint 
--alter TABLE member add CONSTRAINT FK_member_account FOREIGN KEY(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE

-- GO

-- CREATE TABLE accountHasProject
-- (
--     accountID nchar(32) not NULL,
--     projectID nchar(32) not NULL,
--     PRIMARY KEY(accountID, projectID),
--     constraint FK_accountHasP_account FOREIGN key (accountID) REFERENCES account(accountID) on delete CASCADE on update CASCADE,
--     constraint FK_accountHasP_project FOREIGN key (projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE
-- )

GO

CREATE TABLE admin
(
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    PRIMARY KEY(accountID,projectID),
    constraint FK_admin_account FOREIGN key(accountID) REFERENCES account(accountID),--on delete CASCADE on update CASCADE,
    constraint FK_admin_projectID FOREIGN key(projectID) REFERENCES project(projectID)--on delete CASCADE on update CASCADE
)

-- go

-- CREATE TABLE adminCreateProject
-- (
--     projectID nchar(32) not null,
--     accountID nchar(32),
--     constraint adminCreateProject_admin FOREIGN key(accountID,projectID) REFERENCES admin(accountID,projectID) on delete CASCADE on update CASCADE,
-- )

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
    kind NVARCHAR(max),--TODO what is this
    ListID nchar(32),
    projectID nchar(32),
    taskID nchar(32) PRIMARY key,
    constraint FK_task_List FOREIGN key (ListID, projectID) REFERENCES List(ListID, projectID) on DELETE CASCADE on update CASCADE
    ,
)

GO
--UPDATE table
ALTER TABLE task drop COLUMN flag

go
--update table
ALTER TABLE task add flag BIT

GO
--delete update
ALTER TABLE task DROP constraint FK_task_List;

GO


ALTER TABLE task add constraint FK_task_List FOREIGN key (ListID, projectID) REFERENCES List(ListID, projectID)   on DELETE CASCADE on update CASCADE

GO
--ADD constraint 
ALTER TABLE task ADD CONSTRAINT dateTask CHECK (startDate < endDate)

GO

CREATE TABLE admins_task
(
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    taskID nchar(32) not NULL,
    constraint FK_admins_task_member FOREIGN key (accountID,projectID) REFERENCES admin(accountID,projectID),
    constraint FK_member_account_task FOREIGN KEY (taskID) REFERENCES task(taskID) on DELETE CASCADE on update CASCADE
)

GO
--delete, update
--ALTER table admins_task DROP CONSTRAINT FK_admins_task_member

GO

--ALTER TABLE admins_task ADD constraint FK_admins_task_member FOREIGN key (accountID) REFERENCES member(accountID) on DELETE CASCADE on update CASCADE

go


CREATE TABLE complete
(
    complete bit,
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    taskID nchar(32) not NULL,
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
    PRIMARY key( taskID,commentID),
    constraint FK_comment_task FOREIGN key(taskID) REFERENCES task(taskID) on delete CASCADE on update CASCADE,
    constraint FK_cmment_account FOREIGN key(accountID,projectID) REFERENCES member(accountID,projectID)
)

-- go

-- create table watch
-- (
--     accountID nchar(32) not null,
--     projectID nchar(32) not null,
--     constraint FK_watch_observe FOREIGN key (accountID,projectID) REFERENCES observe(accountID,projectID) on delete CASCADE on update CASCADE,
-- )

go

create TRIGGER add_admin_member on admin after INSERT as BEGIN
    insert into member
    select *
    from inserted i
END


-- GO

-- create TRIGGER delete_admin_member on admin after delete as BEGIN
--     delete FROM member
--     from inserted i
--     where i.accountID = member.accountID
-- END

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

create TRIGGER delete_project_admin on project after DELETE as BEGIN--TODO maybe we have probleme in this becuase admin delete member to 
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
--no need to create trigger for update in admin becuase we can't change accountID
-- create TRIGGER delete_task_admin on admin after delete as begin
--     --TODO if an admin delete its account then its tasks will delete to
--     update task 
--     set accountIDCreated = NULL
--     from deleted 
--     where deleted.accountID = task.accountIDCreated
-- END

go
--TODO change alter
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
    ('Database Course', 'Course' , '20220301', '13:30' , 'Darse Database Daneshkade Computer' ),
    ('Project Management Database' , 'Agile' , GETDATE() , '13:30', 'Project modiriat proje')

GO

INSERT INTO [admin]
VALUES
    ('h_rahmani', 'Database Course'  ),
    ('m_shahrabi', 'Database Course' ),
    ('er_ebrahimi', 'Project Management Database')

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
    ( '20220610', '20220710' , 'quiz in middle of term', 'check', 'quiz', 'Database Course', 'quiz1' , 0  )
GO

--TODO how create project should added to admins_task
insert into admins_task
VALUES
    ('m_shahrabi' , 'Database Course', 'quiz1' ),
    ('h_rahmani' , 'Database Course', 'quiz1')

GO

insert into complete
VALUES
    (1, 'sadegh_jafari', 'Database Course' , 'quiz1' )

go

INSERT into comment
VALUEs
    ('hello', 'sadegh_jafari', 'Database Course' , 'quiz1' )

----deletes
-- delete from comment where commentID = 1


-- delete from member where accountID = 'sadegh_jafari'



-- delete from project WHERE projectID = 'Database Course'

