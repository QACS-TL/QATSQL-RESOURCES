--procedural logic

--step 1
Use DEV_Database
GO

SELECT  [ID]
      ,[Date]
      ,[CourseRef]
      ,[Location]
  FROM [Info].[Events]

SELECT  [ID]
      ,[CustomerRef]
      ,[EventRef]
  FROM .[Sales].[Bookings]


--Bookings for ID (EventRef)=1 but none for ID (EventRef)=7

--The following delete would succeed because we set the foreign key to on delete CASCADE
--***DO NOT RUN THIS CODE as currently it would succeed
--delete from [Info].[Events] where id=1

------------------------------------------------

--Step 2 
--alter the constraint to remove the delete CASCADE
ALTER TABLE [Sales].[Bookings] DROP CONSTRAINT [FK_BookingEvent]
GO

ALTER TABLE [Sales].[Bookings]  WITH CHECK ADD  CONSTRAINT [FK_BookingEvent] FOREIGN KEY([EventRef])
REFERENCES [Info].[Events] ([ID])
--ON DELETE CASCADE
GO

------------------------------------------------

--Step 3
--the following delete should now fail
delete from [Info].[Events] where id=1


------------------------------------------------

--Step 4 
--Develop a stored procedure called Info.RemoveEvent to remove Events for a particular ID. Use @ID as the parameter. 
--Using procedural logic, test for the following BEFORE you attempt the delete.
--1. Is the ID blank? Print 'You must supply an ID' and then STOP
--2. Is the ID NOT valid?  Print 'ID not known' and then STOP
--3. Is the ID associated with an EventRef in Sales.Bookings? Print 'Bookings are associated with the Event. This Event cannot be deleted', show the Evenref that exists in the Sales.Bookings table and then STOP
--4. Having passed tests 1,2 & 3 perform the delete and output the deleted ID


--Create the procedure

			--from here (to here - about 35 lines down)

Create proc Info.RemoveEvent @ID int=null
as

-- test no ID
if @ID is null
Begin
Print 'You must supply an ID'
RETURN
End

--test ID=99 - does not exist
if not exists (select [ID] from [Info].[Events] where ID=@ID)
Begin
Print 'ID not known'
RETURN
End

--test ID=1 - there is at least one booking
if exists (select [EventRef] from  [Sales].[Bookings] where [EventRef]=@ID)
Begin
Print 'Bookings are associated with the Event. This Event cannot be deleted'
select [EventRef] as 'Bookings exist' from  [Sales].[Bookings] where [EventRef]=@ID
RETURN
End

--having passed the tests above, perform the delete
--test ID=7
Begin
delete from [Info].[Events] 
output deleted.ID as 'Deleted ID' -- return deleted ID to screen
where ID=@ID
End

			--to here
---------------------------------------------

--step 5
--testing

-- test no ID
exec Info.RemoveEvent

--test ID=99 - does not exist
exec Info.RemoveEvent 99

--test ID=1 - there is at least one booking so this will FAIL
exec Info.RemoveEvent 1 -- also see the messages tab

--having passed the tests above, perform the delete. This will SUCCEED
--test ID=7
exec Info.RemoveEvent 7
