; Set the RunAs parameters to use local adminstrator account
RunAsSet("Administrator", @Computername, "adminpassword")

; Run registry editor as admin
RunWait("taskpanl.exe","C:\Program Files\EarthLink TotalAccess")

; Reset user's permissions
RunAsSet()
