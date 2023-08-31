/*
Mod 04 Lab B
Review backups made
*/

---------- Module 4 Lab B Execise 1 Step 3
RESTORE FILELISTONLY 
	FROM DISK = 'H:\Mod04LabA_Initial.bak'

---------- Module 4 Lab B Execise 1 Step 4
RESTORE HEADERONLY 
	FROM DISK = 'H:\Mod04LabA_Initial.bak'
RESTORE HEADERONLY 
	FROM DISK = 'H:\Mod04LabA_Mirror1.bak'
RESTORE HEADERONLY 
	FROM DISK = 'H:\Mod04LabA_Split1.bak'

---------- Module 4 Lab B Execise 1 Step 5
RESTORE VERIFYONLY 
	FROM DISK = 'H:\Mod04LabA_Mirror1.bak'

---------- Module 4 Lab B Execise 1 Step 6
RESTORE VERIFYONLY 
	FROM DISK = 'H:\Mod04LabA_Split1.bak'

RESTORE VERIFYONLY 
	FROM DISK = 'H:\Mod04LabA_Split1.bak',
		DISK = 'H:\Mod04LabA_Split2.bak'


