

----- Restore FileListOnly
RESTORE FILELISTONLY 
	FROM DISK = 'H:\Mod04LabA_Initial.bak'

----- Restore HeaderOnly
RESTORE HEADERONLY 
	FROM DISK = 'H:\Mod04LabA_Initial.bak'
RESTORE HEADERONLY 
	FROM DISK = 'H:\Mod04LabA_Mirror1.bak'
RESTORE HEADERONLY 
	FROM DISK = 'H:\Mod04LabA_Split1.bak'

----- Restore LabelOnly
RESTORE VERIFYONLY 
	FROM DISK = 'H:\Mod04LabA_Mirror1.bak'

RESTORE VERIFYONLY 
	FROM DISK = 'H:\Mod04LabA_Split1.bak'

RESTORE VERIFYONLY 
	FROM DISK = 'H:\Mod04LabA_Split1.bak',
		DISK = 'H:\Mod04LabA_Split2.bak'


