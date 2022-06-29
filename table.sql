--TODO when accounthasProject was null it means when nobody point to project then delete project
CREATE table account
(
    firstName NVARCHAR(max) not NULL,
    lastName NVARCHAR(max) not null,
    phoneNumber CHAR(8),
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
    constraint FK_member_account FOREIGN key(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE,
    constraint FK_member_projectID FOREIGN key(projectID) REFERENCES project(projectID)on delete CASCADE on update CASCADE
)
GO
--ADD constraint 
--alter TABLE member add CONSTRAINT FK_member_account FOREIGN KEY(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE

GO

CREATE TABLE accountHasProject
(
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    PRIMARY KEY(accountID, projectID),
    constraint FK_accountHasP_account FOREIGN key (accountID) REFERENCES account(accountID) on delete CASCADE on update CASCADE,
    constraint FK_accountHasP_project FOREIGN key (projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE
)

GO

CREATE TABLE admin
(
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    PRIMARY KEY(accountID,projectID),
    constraint FK_admin_account FOREIGN key(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE,
    constraint FK_admin_projectID FOREIGN key(projectID) REFERENCES project(projectID)on delete CASCADE on update CASCADE
)

go

CREATE TABLE adminCreateProject
(
    projectID nchar(32) not null,
    accountID nchar(32),
    constraint adminCreateProject_admin FOREIGN key(accountID,projectID) REFERENCES admin(accountID,projectID) on delete CASCADE on update CASCADE,
)

GO

CREATE TABLE observe
(
    accountID nchar(32) not NULL,
    projectID nchar(32) not NULL,
    PRIMARY KEY(accountID,projectID),
    constraint FK_observe_account FOREIGN key(accountID) REFERENCES account(accountID) on delete CASCADE on update CASCADE ,
    constraint FK_observe_projectID FOREIGN key(projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE
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
    accountIDCreated nchar(32),--I didn't set (not null) for it becuase if we delete it then the task shouldn't delete
    accountIDMember nchar(32),
    constraint FK_task_admin FOREIGN key (accountIDCreated,projectID) REFERENCES admin(accountID,projectID),
    constraint FK_task_List FOREIGN key (ListID, projectID) REFERENCES List(ListID, projectID)
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
    constraint FK_admins_task_member FOREIGN key (accountID,projectID) REFERENCES member(accountID,projectID),
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
    constraint FK_complete_task FOREIGN KEY (taskID) REFERENCES task(taskID) on DELETE CASCADE on update CASCADE
)

GO

CREATE TABLE comment
(
    content NVARCHAR(max),
    data NVARCHAR(max),
    accountID nchar(32),
    projectID nchar(32),
    taskID nchar(32) not NULL,
    PRIMARY key( taskID),
    constraint FK_comment_task FOREIGN key(taskID) REFERENCES task(taskID) on delete CASCADE on update CASCADE,
    constraint FK_cmment_account FOREIGN key(accountID,projectID) REFERENCES member(accountID,projectID)
)

go

create table watch
(
    accountID nchar(32) not null,
    projectID nchar(32) not null,
    constraint FK_watch_observe FOREIGN key (accountID,projectID) REFERENCES observe(accountID,projectID) on delete CASCADE on update CASCADE,
)

go

create TRIGGER add_admin_member on admin after INSERT as BEGIN
    insert into member
    select *
    from inserted i
END

GO

create TRIGGER add_admin_observator on admin after INSERT as BEGIN
    insert into observe
    select *
    from inserted i
END

GO

create TRIGGER delete_admin_member on admin after delete as BEGIN
    delete FROM member
    from inserted i
    where i.accountID = member.accountID
END

go

create TRIGGER delete_admin_observator on admin after delete as BEGIN
    delete from observe
    from inserted i
    where i.accountID = observe.accountID
END

GO

create TRIGGER add_member_observator on member after INSERT as BEGIN
    insert into observe
    select *
    from inserted i
END

go

create TRIGGER delete_member_observator on member after delete as BEGIN
    delete from observe
    from inserted i
    where i.accountID = observe.accountID
END

go

create TRIGGER delete_project_admin on project after DELETE as BEGIN--TODO maybe we have probleme in this becuase admin delete member to 
    DELETE from admin
    from deleted, adminCreateProject a
    where deleted.ProjectID = a.projectID AND a.accountID = admin.accountID
END

go

create TRIGGER delete_project_member on project after DELETE as BEGIN
    DELETE from member
    from deleted, adminCreateProject a
    where deleted.ProjectID = a.projectID AND a.accountID = member.accountID
end 
go

create TRIGGER delete_project_observe on project after DELETE as BEGIN
    DELETE from observe
    from deleted, adminCreateProject a
    where deleted.ProjectID = a.projectID AND a.accountID = observe.accountID
END

GO
--no need to create trigger for update in admin becuase we can't change accountID
create TRIGGER delete_task_admin on admin after delete as begin
    --TODO if an admin delete its account then its tasks will delete to
    update task 
    set accountIDCreated = NULL
    from deleted 
    where deleted.accountID = task.accountIDCreated
END

go

create TRIGGER delete_member_comment on comment after delete as BEGIN
    UPDATE member
    set accountID = null
    from deleted
    WHERE deleted.accountID = member.accountID and deleted.projectID = member.projectID
END













