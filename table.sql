--TODO when accounthasProject was null it means when nobody point to project then delete project
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
    FOREIGN KEY(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE
)

GO

CREATE TABLE accountHasProject
(
    accountID CHAR(10) not NULL,
    projectID CHAR(10) not NULL,
    PRIMARY KEY(accountID, projectID),
    FOREIGN key (accountID) REFERENCES account(accountID) on delete CASCADE on update CASCADE,
    FOREIGN key (projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE
)

GO

CREATE TABLE admin
(
    accountID CHAR(10) not NULL,
    PRIMARY KEY(accountID),
    FOREIGN key(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE
)

go

CREATE TABLE adminCreateProject
(
    projectID char(10) not null,
    accountID char(10),
    FOREIGN key(projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE,
    FOREIGN key(accountID) REFERENCES admin(accountID) on delete set null on update CASCADE,
)

GO

CREATE TABLE observe
(
    accountID CHAR(10) not NULL,
    PRIMARY KEY(accountID),
    FOREIGN key(accountID) REFERENCES account(accountID) on delete CASCADE on update CASCADE
)

GO

CREATE table List
(
    ListID char(10),
    projectID char(10),
    PRIMARY key(ListID, projectID),
    FOREIGN KEY(projectID) REFERENCES project(projectID) on DELETE CASCADE on update CASCADE
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
    accountID char(10),
    accountIDMember char(10),
    FOREIGN key (accountIDMember) REFERENCES member(accountIDMember) on DELETE set null on update CASCADE,--it is because of complete 
    FOREIGN key (accountID) REFERENCES admin(accountID) on DELETE set null on update CASCADE,--TODO check update is working
    FOREIGN key (ListID, projectID) REFERENCES List(ListID, projectID) on DELETE CASCADE on update CASCADE,
    constraint dateTask check (startDate < endDate)
)

GO

CREATE TABLE comment
(
    content NVARCHAR(max),
    data NVARCHAR(max),
    accountID char(10) not NULL,
    taskID char(10),
    PRIMARY key( accountID),
    FOREIGN key(taskID) REFERENCES task(taskID) on delete CASCADE on update CASCADE,
    FOREIGN key(accountID) REFERENCES account(accountID) on delete set null on update set NULL
)

go

create table watch
(
    accountID CHAR(10) not null,
    projectID CHAR(10) not null,
    FOREIGN key (accountID) REFERENCES observe(accountID) on delete CASCADE on update CASCADE,
    FOREIGN key (projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE
)

go

create TRIGGER add_admin_member on admin after INSERT as BEGIN
    insert into member
    select i.accountID
    from inserted i
END

GO

create TRIGGER add_admin_observator on admin after INSERT as BEGIN
    insert into observator
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
    delete from observator
    select i.accountID
    from inserted i
    where i.accountID = observator.accountID
END

GO

create TRIGGER add_member_observator on member after INSERT as BEGIN
    insert into observator
    select i.accountID
    from inserted i
END

go

create TRIGGER delete_member_observator on member after delete as BEGIN
    delete from observator
    select i.accountID
    from inserted i
    where i.accountID = observator.accountID
END

go

create TRIGGER delete_project_admin on project after DELETE as BEGIN--TODO maybe we have probleme in this becuase admin delete member to 
    DELETE from admin
    from deleted
    where deleted.accountID = accountID
END

go

create TRIGGER delete_project_admin on project after DELETE as BEGIN
    DELETE from member
    from deleted
    where deleted.accountID = accountID
END

go

create TRIGGER delete_project_admin on project after DELETE as BEGIN
    DELETE from observator
    from deleted
    where deleted.accountID = accountID
END















