-- TODO : Daam noe 2
-- TODO : TRIGERAYE ADMIN MEMBBER OBSERVATOR loop nazne
-- TODO : remove 0912999999 & null -> account
-- TODO : remove time -> projectTable
-- TODO : add endDate -> projectTable
-- TODO : add us to ->account -> project
-- TODO : maybe this two are keys ->adminCreatesProject table
-- TODO : not every -->member needs to be a -->observator maybe other accounts can obser even  if they are not member of project
-- TODO : / actuaaly members doesn't  need to observ because they are already observing

-- CREATE table account
-- (
--     firstName NVARCHAR(max) not NULL,
--     lastName NVARCHAR(max) not null,
--     phoneNumber CHAR(8),
--     Email NVARCHAR(max) NOT NULL,
--     accountID nchar(32) NOT NULL PRIMARY KEY,
--     constraint numberAccount check (ISNUMERIC(phoneNumber) = 1)
-- )
INSERT INTO account
VALUES
    ('Hossein', 'Rahmani', 0912999999, 'h_rahmani@iust.ac.ir' , 'h_rahmani'),
    ('Shahrzad', 'Azari Rad', 0912999999, 'shahrzad_azari@comp.iust.ac.ir', 'shahrzad_azari'),
    ('Arshia', 'Arian Nejad', 0912999999, 'a_ariannejad@comp.iust.ac.ir', 'a_ariannejad'),
    ('Zahra', 'Amiri' , 0912999999, 'zahra_amiri@comp.iust.ac.ir' , 'zahra_amiri'),
    ('Alireza', 'Haghani', 0912999999, 'alireza_haqani@gmail.com', 'alireza_haqani'),
    ('Hanie', 'Jafari' , 0912999999, 'hanie_jafari@comp.iust.ac.ir', 'hanie_jafari'),
    ('Sadegh', 'Jafari', 0912999999 , 'sadegh_jafari@gmail.com', 'sadegh_jafari'),
    ('Babak' , 'Behkam Kia' , 0912999999, 'babak_behkamkia@comp.iust.ac.ir', 'babak_behkamkia'),
    ('Fateme' , 'Zahra Bakhshande' , 0912999999, 'fatemezahrabakhshande@gmail.com', 'fatemezahrabakhshande'),
    ('Sajjad', 'Ramezani' , 0912999999 , 'sajjad_ramezani@ind.iust.ac.ir', 'sajjad_ramezani'),
    ('Arman', 'Heidari' , 0912999999, 'heydari_arman@comp.iust.ac.ir' , 'heydari_arman'),
    ('Morteza', 'Shahrabi Farahani', 0912999999, 'm_shahrabi@comp.iust.ac.ir', 'm_shahrabi'),
    ('Saman' , 'Mohammadi Raoof', 0912999999, 'saman_mohammadi@comp.iust.ac.ir', 'saman_mohammadi'),
    ('Niki', 'Majidi Far' , 0912999999 , 'n_majidifard@comp.iust.ac.ir' , 'n_majidifard'),
    ('Banafshe', 'Gholinejad', 0912999999, 'b_gholinejad@comp.iust.ac.ir', 'b_gholinejad'),
    ('Parya' , 'Fasahat' , 0912999999 , 'parya_fasahat@comp.iust.ac.ir' , 'parya_fasahat'),
    ('Melika', 'Nobakhtian' , 0912999999 , 'm_nobakhtian@comp.iust.ac.ir', 'm_nobakhtian'),
    ('Ilia' , 'Mirzaei' , 0912999999, 'iliya_mirzaei@comp.iust.ac.ir' , 'iliya_mirzaei'),
    ('Aryan', 'Abdollahi Sabet Nejad' , 0912999999, 'aryan_abdollahi@comp.iust.ac.ir' , 'aryan_abdollahi'),
    ('Erfan', 'Ebrahimi Soviz' , 0912999999, 'er_ebrahimi@comp.iust.ac.ir' , 'er_ebrahimi'),
    ('Amir Ali', 'Farazmand' , 0912999999, 'amirali_farazmand@comp.iust.ac.ir', 'amirali_farazmand')

-- create TABLE project
-- (
--     ProjectID nchar(32) not NULL PRIMARY key,
--     kind NVARCHAR(max) not null,
--     date date NOT NULL,
--     time TIME not NULL,
--     discription NVARCHAR(max)
-- )

INSERT INTO project
VALUES
    ('Database Course', 'Course' , '2022-3-1' , 'Darse Database Daneshkade Computer'),
    ('Project Management Database' , 'Agile' , GETDATE(), 'Project modiriat proje')


-- CREATE TABLE member
-- (
--     accountID nchar(32) not NULL,
--     PRIMARY KEY (accountID),
--     constraint FK_member_account FOREIGN KEY(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE
-- )
INSERT INTO member
VALUES
    ('h_rahmani'),
    ('shahrzad_azari'),
    ('a_ariannejad' ),
    ('zahra_amiri' ),
    ('alireza_haqani' ),
    ('hanie_jafari'),
    ('sadegh_jafari'),
    ('babak_behkamkia'),
    ('fatemezahrabakhshande'),
    ('sajjad_ramezani' ),
    ('heydari_arman'),
    ('m_shahrabi'),
    ('saman_mohammadi'),
    ('n_majidifard'),
    ('b_gholinejad'),
    ('parya_fasahat' ),
    ('m_nobakhtian' ),
    ('iliya_mirzaei' ),
    ('amirali_farazmand'),
    ('aryan_abdollahi'),
    ('er_ebrahimi')


-- CREATE TABLE accountHasProject
-- (
--     accountID nchar(32) not NULL,
--     projectID nchar(32) not NULL,
--     PRIMARY KEY(accountID, projectID),
--     constraint FK_accountHasP_account FOREIGN key (accountID) REFERENCES account(accountID) on delete CASCADE on update CASCADE,
--     constraint FK_accountHasP_project FOREIGN key (projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE
-- )

INSERT INTO accountHasProject
VALUES
    ('h_rahmani' , 'Database Course'),
    ('shahrzad_azari', 'Database Course'),
    ('a_ariannejad' , 'Database Course'),
    ('zahra_amiri' , 'Database Course'),
    ('alireza_haqani' , 'Database Course'),
    ('hanie_jafari', 'Database Course'),
    ('sadegh_jafari', 'Database Course'),
    ('babak_behkamkia', 'Database Course'),
    ('fatemezahrabakhshande', 'Database Course'),
    ('sajjad_ramezani' , 'Database Course'),
    ('heydari_arman', 'Database Course'),
    ('m_shahrabi', 'Database Course'),
    ('saman_mohammadi' , 'Database Course'),
    ('n_majidifard', 'Database Course'),
    ('b_gholinejad', 'Database Course'),
    ('parya_fasahat' , 'Database Course'),
    ('m_nobakhtian', 'Database Course'),
    ('iliya_mirzaei' , 'Database Course'),
    ('amirali_farazmand', 'Project Management Database'),
    ('aryan_abdollahi', 'Project Management Database'),
    ('er_ebrahimi', 'Project Management Database')


-- CREATE TABLE admin
-- (
--     accountID nchar(32) not NULL,
--     PRIMARY KEY(accountID),
--     constraint FK_admin_account FOREIGN key(accountID) REFERENCES account(accountID)on delete CASCADE on update CASCADE
-- )
INSERT INTO admin
VALUES
    ('h_rahmani'),
    ('m_shahrabi'),
    ('er_ebrahimi')



-- CREATE TABLE adminCreateProject
-- (
--     projectID nchar(32) not null,
--     accountID nchar(32),
--     constraint adminCreateProject_project FOREIGN key(projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE,
--     constraint adminCreateProject_admin FOREIGN key(accountID) REFERENCES admin(accountID) on delete set null on update CASCADE,
-- )

INSERT INTO adminCreateProject
VALUES
    ('Database Course' , 'h_rahmani'),
    ('Project Management Database' , 'er_ebrahimi')
-- ('Database Course' , 'm_shahrabi')
-- TODO : CHECK THIS


-- CREATE TABLE observe
-- (
--     accountID nchar(32) not NULL,
--     PRIMARY KEY(accountID),
--     constraint FK_observe_account FOREIGN key(accountID) REFERENCES account(accountID) on delete CASCADE on update CASCADE
-- )

-- TODO : CHECK THIS
-- INSERT INTO observe
-- VALUES
--     ('m_shahrabi'),
--     ('heydari_arman'),
--     ('amirali_farazmand'),
--     ('aryan_abdollahi'),
--     ('er_ebrahimi')


-- CREATE table List
-- (
--     ListID nchar(32),
--     projectID nchar(32),
--     PRIMARY key(ListID, projectID),
--     constraint FK_List_project FOREIGN KEY(projectID) REFERENCES project(projectID) on DELETE CASCADE on update CASCADE
-- )



-- CREATE TABLE task
-- (
--     flag BIT,
--     startDate date not NULL,
--     endDate date not null,
--     discription NVARCHAR(max),
--     kind NVARCHAR(max),
--     ListID nchar(32),
--     projectID nchar(32),
--     taskID nchar(32) PRIMARY key,
--     accountIDCreated nchar(32),--I didn't set (not null) for it becuase if we delete it then the task shouldn't delete
--     accountIDMember nchar(32),
--     constraint FK_task_admin FOREIGN key (accountIDCreated) REFERENCES admin(accountID),
--     constraint FK_task_List FOREIGN key (ListID, projectID) REFERENCES List(ListID, projectID) ,
--     constraint dateTask check (startDate < endDate)
-- )


-- CREATE TABLE admins_task
-- (
--     accountID nchar(32) not NULL,
--     taskID nchar(32) not NULL,
--     constraint FK_admins_task_member FOREIGN key (accountID) REFERENCES member(accountID) on DELETE CASCADE on update CASCADE,
--     constraint FK_member_account_task FOREIGN KEY (taskID) REFERENCES task(taskID) on DELETE CASCADE on update CASCADE
-- )

-- CREATE TABLE complete
-- (
--     complete bit,
--     accountID nchar(32) not NULL,
--     taskID nchar(32) not NULL,
--     constraint FK_complete_member  FOREIGN key (accountID) REFERENCES member(accountID) on DELETE CASCADE on update CASCADE,
--     constraint FK_complete_task FOREIGN KEY (taskID) REFERENCES task(taskID) on DELETE CASCADE on update CASCADE
-- )


-- CREATE TABLE comment
-- (
--     content NVARCHAR(max),
--     data NVARCHAR(max),
--     accountID nchar(32),
--     taskID nchar(32) not NULL,
--     PRIMARY key( taskID),
--     constraint FK_comment_task FOREIGN key(taskID) REFERENCES task(taskID) on delete CASCADE on update CASCADE,
--     constraint FK_cmment_account FOREIGN key(accountID) REFERENCES account(accountID) on delete set null on update set NULL
-- )


-- create table watch
-- (
--     accountID nchar(32) not null,
--     projectID nchar(32) not null,
--     constraint FK_watch_observe FOREIGN key (accountID) REFERENCES observe(accountID) on delete CASCADE on update CASCADE,
--     constraint FK_watch_project FOREIGN key (projectID) REFERENCES project(projectID) on delete CASCADE on update CASCADE
-- )