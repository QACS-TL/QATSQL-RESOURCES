-- 1 SQL and RDBMS Basics Examples

-- 1.1 Create qastore database, tables, keys and insert records

-- USE master
-- DROP DATABASE
CREATE DATABASE qastore;

USE qastore;

CREATE TABLE company
	(
    company_no INT NOT NULL,
	company_name VARCHAR(20) NOT NULL,
	tel VARCHAR(15) NULL,
	county VARCHAR(15) NULL,
	post_code CHAR(8) NULL,
    PRIMARY KEY (company_no)
    );
     
INSERT INTO company (company_no,company_name,tel,county,post_code)
    VALUES (1000,'Happy Heaters PLC','(01306)345672','London','SE3 89L');
INSERT INTO company (company_no,company_name,tel,county,post_code)
    VALUES (2000,'Icicle Igloos Inc','0181-987-1265','London','N1 4LH');
INSERT INTO company (company_no,company_name,tel,county,post_code)
    VALUES (3000,'Judo Jeans PLC','0171-478-2990','London','N9 2FG');
INSERT INTO company (company_no,company_name,tel,county,post_code)
    VALUES (4000,'Kipper Kickers Inc','01254-987766','Devon','PL4 9RT');

CREATE TABLE contact
	(
	company_no INT NOT NULL,
	contact_code CHAR(2) NOT NULL,
	contact_name VARCHAR(20) NOT NULL,
	job_title VARCHAR(30) NULL,
	tel VARCHAR(25) NULL,
	notes VARCHAR(60) NULL,
    PRIMARY KEY (company_no,contact_code),
    FOREIGN KEY(company_no) REFERENCES company (company_no)
    );

INSERT INTO contact (company_no,contact_code,contact_name,job_title,tel,notes)
    VALUES (1000,'MM','Madonna Moncada','Accounts Officer','(0207)223-9887','We first visited her in January 1988');
INSERT INTO contact (company_no,contact_code,contact_name,job_title,tel,notes)
    VALUES (2000,'NN','Nadia Nowakowski','Bought Ledger Manager','01546-456566 Ext 22','Works only on Monday and Wednesdays');
INSERT INTO contact (company_no,contact_code,contact_name,job_title,tel,notes)
    VALUES (2000,'OO','Odell Onorato','Chief Executive Officer','0207-341-566670 ext 10','');
INSERT INTO contact (company_no,contact_code,contact_name,job_title,tel,notes)
    VALUES (3000,'PP','Perry Paulos','Development Director','0131 324545 ext 213','Insists on personally signing all orders');
INSERT INTO contact (company_no,contact_code,contact_name,job_title,tel,notes)
    VALUES (3000,'QQ','Quincy Quan','Electrical Manager','01456 801711 ext 44','Has been in his job a long time');
INSERT INTO contact (company_no,contact_code,contact_name,job_title,tel,notes)
    VALUES (3000,'RR','Rossana Roundy','Federal Reporting Officer','0208-111-11111','Has a preference for Apple Macintosh systems');
INSERT INTO contact (company_no,contact_code,contact_name,job_title,tel,notes)
    VALUES (4000,'SS','Sherell Sparacino','Gourmet Foods Purchaser','0207-988-0777','');
INSERT INTO contact (company_no,contact_code,contact_name,job_title,tel,notes)
    VALUES (4000,'TT','Takako Troyer','Head of Inter Office Systems','05673-476878 ext 221','Is listed in Whos Who 1988 onwards');
INSERT INTO contact (company_no,contact_code,contact_name,job_title,tel,notes) 
    VALUES (4000,'UU','Usha Upson','Accounts Officer','0823-598494 ext 1','Is upset becuase he is not chief executive!');
    
CREATE TABLE dept
	(
	dept_no INT NOT NULL,
	dept_name VARCHAR(20) NOT NULL,
	manager VARCHAR(20) NULL,
	sales_target DECIMAL(12, 4) NULL,
    PRIMARY KEY (dept_no)
    );

INSERT INTO dept (dept_no,dept_name,manager,sales_target)
    VALUES (1,'Animal Products','Amiee Amerson',5.0000);
INSERT INTO dept (dept_no,dept_name,manager,sales_target)
    VALUES (2,'Business Systems','Bart Bliss',15.0000);
INSERT INTO dept (dept_no,dept_name, manager,sales_target)
    VALUES (3,'Credit Control','Callie Casado',25.0000);
INSERT INTO dept (dept_no,dept_name, manager,sales_target) 
    VALUES (4,'Desktop Systems','Dale Danzy',5.0000);
INSERT INTO dept (dept_no,dept_name,manager,sales_target)
    VALUES (5,'Electrical Repairs','Eldon Eno',45.0000);

CREATE TABLE salesperson
	(
	emp_no INT NOT NULL,
	first_name VARCHAR(15) NOT NULL,
	last_name VARCHAR(15) NOT NULL,
	dept_no INT NOT NULL,
	salary DECIMAL(12,4) NULL,
    sales_target DECIMAL(12,4) NULL,
	county VARCHAR(15) NULL,
	post_code CHAR(8) NULL,
	tel VARCHAR(25) NULL,
	notes VARCHAR(50) NULL,
    PRIMARY KEY (emp_no),
    FOREIGN KEY(dept_no) REFERENCES dept (dept_no)
    );

INSERT INTO salesperson (emp_no,first_name,last_name,dept_no,salary,sales_target,county,post_code,tel,notes)
    VALUES (10,'Ferne','Filmore',1,10.0000,9.0000,'Surrey','RT8 8LP','0171-908-8765','Joined in Sept 1996');
INSERT INTO salesperson (emp_no,first_name,last_name,dept_no,salary,sales_target,county,post_code,tel,notes)
    VALUES (20,'Gertie','Gatling',2,11.0000,14.0000,'Hampshire','RF3 9UD','(0306)7871','Bright Prospect');
INSERT INTO salesperson (emp_no,first_name,last_name,dept_no,salary,sales_target,county,post_code,tel,notes)
    VALUES (30,'Hattie','Hardegree',2,12.0000,7.0000,'Hampshire','W45 TY3','(0908)922211','Should be promoted within the next 4 months');
INSERT INTO salesperson (emp_no,first_name,last_name,dept_no,salary,sales_target,county,post_code,tel,notes)
    VALUES (40,'Inge','Isman',3, 13.0000,11.0000,'London',NULL,'0171-898-9656',NULL);
INSERT INTO salesperson (emp_no,first_name,last_name,dept_no,salary,sales_target,county,post_code,tel,notes)
    VALUES (50,'Janene','Jent',3,14.0000,12.0000,'Surrey','CR1 2GH','0181-898-1126',NULL);
INSERT INTO salesperson (emp_no,first_name,last_name,dept_no,salary,sales_target,county, post_code,tel,notes)
    VALUES (60,'Karena','Kilburn',3,15.0000,13.0000,'Surrey',NULL,'0181-877-0123','Dislikes international travel');

CREATE TABLE sale
	(
	order_no INT NOT NULL,
	emp_no INT NOT NULL,
	company_order_no VARCHAR(15) NULL,
	company_no INT NOT NULL,
	contact_code CHAR(2) NOT NULL,
	order_value DECIMAL(12,2) NULL,
	order_date DATETIME NULL,
	description VARCHAR(140) NULL,
    PRIMARY KEY (order_no),
    FOREIGN KEY(emp_no) REFERENCES salesperson (emp_no),
    FOREIGN KEY(company_no, contact_code) REFERENCES contact (company_no, contact_code)
    );
    
INSERT INTO sale (order_no,emp_no,company_order_no,company_no,contact_code,order_value,order_date,description)
    VALUES (100,60,'AA1',1000,'MM',7.11,'2000-06-24 10:20:30','IBM Thinkpad 755CE');
INSERT INTO sale (order_no,emp_no,company_order_no,company_no,contact_code,order_value,order_date,description) 
    VALUES (200, 60,'Ord34',3000,'QQ',6.22,'2000-05-01 11:21:31','MS Office Professional * 30');
INSERT INTO sale (order_no,emp_no,company_order_no,company_no,contact_code,order_value,order_date,description)
    VALUES (300, 60,'Ord39',2000,'OO',12.33,'2000-07-14 12:22:32','25 ScanPRO 4800 Scanner');
INSERT INTO sale (order_no,emp_no,company_order_no,company_no,contact_code,order_value,order_date,description) 
    VALUES (400,10,'DGG5',1000,'MM',5.44,'2000-08-09 13:23:33','Modems and Cables etc');
INSERT INTO sale (order_no,emp_no,company_order_no,company_no,contact_code,order_value,order_date,description) 
    VALUES (500, 60,'DPF78',4000,'TT',2.55,'2000-07-23 14:24:34','Laser printer');
INSERT INTO sale (order_no,emp_no,company_order_no,company_no,contact_code,order_value,order_date,description) 
    VALUES (600, 50,'AC12',3000,'PP',27.66,'2000-05-23 15:25:35','Complete Desktop Publishing System');
INSERT INTO sale (order_no,emp_no,company_order_no,company_no,contact_code,order_value,order_date,description) 
    VALUES (700,10,'23',2000,'OO',3.77,'2000-01-23 16:26:36','SQL Server 7.0 20 user licence');
INSERT INTO sale (order_no,emp_no,company_order_no,company_no,contact_code,order_value,order_date,description) 
    VALUES (800, 60,'B-123E',3000,'RR',3.88,'2000-12-15 17:27:37','Printer cartridges');

-- 1.2 Check contents of qastore database

SELECT * FROM company;
SELECT * FROM contact;
SELECT * FROM dept;
SELECT * FROM salesperson;
SELECT * FROM sale;
