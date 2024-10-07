-- 3 Functions Exercises

-- 3.1 Text Functions

-- 3.1.1 LEFT / RIGHT / UPPER / LOWER Functions
SELECT
    dept_name,
	LEFT(dept_name,3) AS 'First Three Characters',
    RIGHT(dept_name,3) AS 'Last Three Characters',
    SUBSTRING(dept_name,5,2) AS '5th and 6th Characters',
    UPPER(dept_name) AS 'Upper Case',
    LOWER(dept_name) AS 'Lower Case'
FROM dept;

-- 3.1.2 INSTR / LOCATE Functions
SELECT
	dept_name,
    CHARINDEX('i',dept_name) AS 'Position of First "i"',
    CHARINDEX('systems',dept_name) AS 'Starting Position of "systems"'
FROM dept;

-- 3.2 Date / Time Functions

-- 3.2.1 Date Functions
SELECT
    order_date,
	CAST(order_date AS DATE) AS 'Date of Order',
    CONCAT(LEFT(DATENAME(WEEKDAY,order_date),3),' ',DATEPART(mm,order_date),' ',
	       LEFT(DATENAME(MONTH,order_date),3),' ',DATEPART(yyyy,order_date)) AS 'Formatted Date'
FROM
    sale;    

-- 3.2.2 Time Functions
SELECT
    order_date,
	CAST(order_date AS TIME) AS 'Time of Order',
    CONCAT(DATENAME(hh,order_date),':',DATENAME(mi,order_date),':',DATENAME(s,order_date)) AS 'Formated Time'
FROM
    sale;    

-- 3.2.3 Current Date / Time Functions
SELECT
	order_date,
    CAST(GETDATE() AS INT) AS 'Now',
    CAST(GETUTCDATE() AS INT) AS 'Sysdate',
    CAST(GETUTCDATE() AS DATE) AS 'UTC_Date',
    CAST(GETUTCDATE() AS TIME) AS 'UTC_Time'
FROM
	sale;
    
-- 3.2.4 Date / Time Calculation Functions
SELECT
	GETDATE(),
    order_date,
    DATEADD(WEEK,1,order_date) AS 'Order Date + 1 Week',
    DATEADD(HOUR,-1,order_date) AS 'Order Date - 1 Hour',
    DATEDIFF(hh,order_date,'2017-01-20 12:00:00') AS 'Hours Since Order',
	DATEDIFF(dd,order_date,'2017-01-20 12:00:00') AS 'Days Since Order',
	DATEDIFF(mm,order_date,'2017-01-20 12:00:00') AS 'Months Since Order',
	DATEDIFF(yy,order_date,'2017-01-20 12:00:00') AS 'Years Since Order',
	DATEDIFF(yy,order_date, GETDATE()) AS 'Years Since Order'
FROM 
	sale;

-- 3.3 NULL Functions

-- 3.3.1 ISNULL / COALESCE Functions
SELECT
	emp_no,
    notes,
    ISNULL(notes,'No Notes specifed') AS 'NULL Notes',
    COALESCE(notes,'No Notes Specified') AS 'COALESCE Notes'
FROM
	salesperson;


SELECT
    SUM(order_value) as 'order_value total',
    AVG(order_value) as 'average order value (null ignored)',
    AVG(ISNULL(order_value, 0)) as 'average order value (null as zero)'
FROM 
    sale;

-- 3.4 Conversion Functions

-- 3.4.1 CAST / CONVERT / ROUND Functions
SELECT
	order_date,
    CAST(order_date AS TIME) AS 'CAST Order Time',
    CONVERT(TIME,order_date) AS 'CONVERT Order Time',
	CONVERT(varchar(20), order_date) AS 'CONVERT Order Date',
	CONVERT(varchar(20), order_date, 106) AS 'CONVERT Order Date to dd MON yy format',
    order_value,
    CAST(order_value AS CHAR(20)) AS 'CAST Order Value as Text',
    CONVERT(CHAR(20),order_value) AS 'CONVERT Order Value as Text',
    ROUND(order_value,2) AS 'ROUND Order Value to 2 DP',
	PARSE('1234' AS INTEGER) AS 'PARSE Text as integer',
	TRY_PARSE('1234X' AS INTEGER) AS 'TRY_PARSE Text as integer'
FROM
	sale;



-- 3.5 Nested Functions

-- 3.5.1 Nested Functions
SELECT
	order_date,
    GETDATE() AS 'GetDate',
    DATEPART(mm,GETDATE()) AS 'Minute',
    ROUND(DATEPART(mm,GETDATE()),-1) AS 'Nearest 10 Minutes'
FROM
	sale;
    