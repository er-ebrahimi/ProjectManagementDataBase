--TODO when accounthasProject was null it means when nobody point to project then delete project
--TODO we add one table with complete name to relation model
CREATE table account
(
    firstName NVARCHAR(max) not NULL,
    lastName NVARCHAR(max) not null,
    phoneNumber CHAR(8),
    Email NVARCHAR(max) NOT NULL,
    address NVARCHAR(max) NOT NULL,
    accountID CHAR(10) NOT NULL PRIMARY KEY,
    constraint numberAccount check (ISNUMERIC(phoneNumber) = 1)
)

go

create TABLE project
(
    ProjectID CHAR(10) not NULL PRIMARY key,
    kind NVARCHAR(max) not null,
    date date NOT NULL,
    time TIME not NULL,
    discription NVARCHAR(max)
)

go

CREATE TABLE member
(
    accountID CHAR(10) not NULL,
    PRIMARY KEY (accountID),
    constraint FK_member_account FOREIGN KEY(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE
)

GO

CREATE TABLE accountHasProject
(
    accountID CHAR(10) not NULL,
    projectID CHAR(10) not NULL,
    PRIMARY KEY(accountID, projectID),
    constraint FK_accountHasP_account FOREIGN key (accountID) REFERENCES account(accountID) on delete CASCADE on update CASCADE,
    constraint FK_accountHasP_project FOREIGN key (projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE
)

GO

CREATE TABLE admin
(
    accountID CHAR(10) not NULL,
    PRIMARY KEY(accountID),
    constraint FK_admin_account FOREIGN key(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE
)

go

CREATE TABLE adminCreateProject
(
    projectID char(10) not null,
    accountID char(10),
    constraint adminCreateProject_project FOREIGN key(projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE,
    constraint adminCreateProject_admin FOREIGN key(accountID) REFERENCES admin(accountID) on delete set null on update CASCADE,
)

GO

CREATE TABLE observe
(
    accountID CHAR(10) not NULL,
    PRIMARY KEY(accountID),
    constraint FK_observe_account FOREIGN key(accountID) REFERENCES account(accountID) on delete CASCADE on update CASCADE
)

GO

CREATE table List
(
    ListID char(10),
    projectID char(10),
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
    ListID char(10),
    projectID char(10),
    taskID char(10) PRIMARY key,
    accountIDCreated char(10),--I didn't set (not null) for it becuase if we delete it then the task shouldn't delete
    accountIDMember char(10),
    constraint FK_task_admin FOREIGN key (accountIDCreated) REFERENCES admin(accountID),--TODO create trigger for it 
    constraint FK_task_List FOREIGN key (ListID, projectID) REFERENCES List(ListID, projectID) ,--TODO CREATE trigger for it
    constraint dateTask check (startDate < endDate)
)
GO

-- ALTER TABLE task DROP CONSTRAINT  FK_task_admin ;
ALTER TABLE task DROP constraint FK_task_List;

GO

-- ALTER TABLE task add constraint FK_task_admin foreign key (accountIDCreated) REFERENCES admin(accountID) on delete set NULL on update set NULL
ALTER TABLE task add constraint FK_task_List FOREIGN key (ListID, projectID) REFERENCES List(ListID, projectID)  on delete set NULL on update set NULL

-- GO

CREATE TABLE admins_task
(
    accountID char(10) not NULL,
    taskID char(10) not NULL,
    constraint FK_admins_task_member FOREIGN key (accountID) REFERENCES member(accountID) on DELETE CASCADE on update CASCADE,
    constraint FK_member_account_task FOREIGN KEY (taskID) REFERENCES task(taskID) on DELETE CASCADE on update CASCADE
)



go

CREATE TABLE complete
(
    complete bit,
    accountID char(10) not NULL,
    taskID char(10) not NULL,
    constraint FK_complete_member  FOREIGN key (accountID) REFERENCES member(accountID) on DELETE CASCADE on update CASCADE,
    constraint FK_complete_task FOREIGN KEY (taskID) REFERENCES task(taskID) on DELETE CASCADE on update CASCADE
)

GO

CREATE TABLE comment
(
    content NVARCHAR(max),
    data NVARCHAR(max),
    accountID char(10),
    taskID char(10) not NULL,
    PRIMARY key( taskID),
    constraint FK_comment_task FOREIGN key(taskID) REFERENCES task(taskID) on delete CASCADE on update CASCADE,
    constraint FK_cmment_account FOREIGN key(accountID) REFERENCES account(accountID) on delete set null on update set NULL
)

go

create table watch
(
    accountID CHAR(10) not null,
    projectID CHAR(10) not null,
    constraint FK_watch_observe FOREIGN key (accountID) REFERENCES observe(accountID) on delete CASCADE on update CASCADE,
    constraint FK_watch_project FOREIGN key (projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE
)

go

create TRIGGER add_admin_member on admin after INSERT as BEGIN
    insert into member
    select i.accountID
    from inserted i
END

GO

create TRIGGER add_admin_observator on admin after INSERT as BEGIN
    insert into observe
    select i.accountID
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
    select i.accountID
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














