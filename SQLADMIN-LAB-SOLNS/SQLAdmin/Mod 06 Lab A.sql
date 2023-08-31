/*
Mod 06 Lab A
Maintain Server roles
*/

---------- Module 6 Lab A Execise 1b Step 2
use [master]
CREATE SERVER ROLE SecondLineSupport
GO

---------- Module 6 Lab A Execise 2b Step 1
GRANT ALTER ANY DATABASE TO SecondLineSupport
GRANT ALTER ANY LINKED SERVER TO SecondLineSupport
GRANT ALTER ANY LOGIN TO SecondLineSupport
GRANT ALTER SERVER STATE TO SecondLineSupport
GRANT ALTER SETTINGS TO SecondLineSupport
GRANT CONNECT ANY DATABASE TO SecondLineSupport
GO

---------- Module 6 Lab A Execise 4 Step 1
ALTER SERVER ROLE SecondLineSupport ADD MEMBER [SQL\AAdamson]
ALTER SERVER ROLE FirstLineSupport ADD MEMBER SecondLineSupport
ALTER SERVER ROLE FirstLineSupport ADD MEMBER [SQL\BBenson]
GO

---------- Module 6 Lab A Execise 6 Step 1
ALTER SERVER ROLE [SecondLineSupport] DROP MEMBER [SQL\AAdamson]
ALTER SERVER ROLE [FirstLineSupport] DROP MEMBER [SQL\BBenson]
DROP SERVER ROLE SecondLineSupport
DROP SERVER ROLE FirstLineSupport
