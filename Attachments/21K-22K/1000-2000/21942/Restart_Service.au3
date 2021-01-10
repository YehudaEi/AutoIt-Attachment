#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Allow_Decompile=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;
; WhoHasNTWPS.au3
; Script to Stop and Start Service with a service account
; Check working directory for security reasons. Only users with proper NTFS permissions
; can run this program. Prevent unauthorized users from copying and running
; this program from another unsecured folder.
; Set the RunAs parameters to use service account

RunAsSet("Service Account", "Domain", "password")

Run("CycleService.exe")


;NOTE if you are using the newest version of AutoIT then RunAsSet no longer exists.
;Instead of the above code it would look like this:
;RunAs("Service Account", "Domain", "password","CycleService.exe")









