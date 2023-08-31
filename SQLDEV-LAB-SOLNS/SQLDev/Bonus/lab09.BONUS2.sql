--Column triggers (see the maths below)

--review the customers table

select * from sales.customers

-- We only want the trigger to fire if name and/or email columns are updated

--columns 2 (name) and 4 (email) using power(2(x-1))

--power(2,(2-1))+power(2,(4-1))=10

---------------------------------
CREATE TRIGGER update_name_email
ON sales.customers 
FOR update AS
IF (COLUMNS_UPDATED() & 10) =10 -- >0 to test for either column
Print 'both name & email were updated'
ELSE IF (COLUMNS_UPDATED() & 10) >0
Print 'either name or email was updated'
---------------------------------

-- Testing

--both columns updated
update sales.customers 
set name='Al', email='al@alanapple.com'
where accountno=1

--just one column updated
update sales.customers 
set name='Allen'
where accountno=1

--trigger does not fire
update sales.customers 
set phone='111111'
where accountno=1