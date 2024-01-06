REM This .bat file is for use in systems that do not support the New-ADUser command (Powershell 5)
REM It will use dsadd to create 50 new users with weak passwords for testing purposes

FOR /L %%X in (1, 1, 50) DO dsadd user "CN=testuser%%X,CN=Users,DC=test,DC=net" -samid "testuser%%X" -pwd "badpwd" -disabled no -mustchpwd no
