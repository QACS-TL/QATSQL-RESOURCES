select * from sys.filegroups

ALTER DATABASE BIE2EDW
	MODIFY FILEGROUP Dimensions READ_ONLY
ALTER DATABASE BIE2EDW
	MODIFY FILEGROUP Dimensions READ_WRITE
go

use master
go
create master key encryption by password='MyStr0ngPassw0rd'
go
-- drop certificate BackupCert
create certificate BackupCert 
	with subject = 'Backup cert'
go

backup database BIE2EDW to disk='c:\backups\onenc.bak'
	with 
  COMPRESSION,  
  ENCRYPTION   
   (  
   ALGORITHM = AES_256,  
   SERVER CERTIFICATE = BackupCert  
   ),  
  STATS = 10 
go

backup database Master to disk='c:\backups\checksum1.bak'
	with checksum
go
restore verifyonly from disk='c:\backups\checksum1.bak' with checksum
go

restore labelonly from disk='c:\backups\checksum1.bak' with checksum
restore headeronly from disk='c:\backups\checksum1.bak'
restore filelistonly from disk='c:\backups\checksum1.bak' with file=1
restore filelistonly from disk='c:\backups\checksum1.bak' with file=2

select * from msdb.dbo.backupset
select * from msdb.dbo.backupfile
select * from msdb.dbo.backupfilegroup
select * from msdb.dbo.backupmediaset
select * from msdb.dbo.backupmediafamily

select * from msdb.dbo.restorefile
select * from msdb.dbo.restorefilegroup
select * from msdb.dbo.restorehistory

backup database [CableMES]
	to disk='c:\disks\f\cables3.bak',
	disk='c:\disks\f\cables4.bak'

SELECT BS.backup_set_id, BS.last_lsn, BS.backup_start_date,
		BS.backup_finish_date, BF.*
	FROM (select top 1 * from msdb.dbo.backupset
		ORDER BY backup_finish_date DESC)as BS
		INNER JOIN msdb.dbo.backupfile as BF
			ON BS.backup_set_id = BF.backup_set_id
	ORDER BY BS.backup_finish_date DESC
		
		



