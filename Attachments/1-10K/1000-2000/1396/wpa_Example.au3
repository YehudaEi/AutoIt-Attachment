#include <wpa.au3>

; info at http://msdn.microsoft.com/library/default.asp?url=/library/en-us/wmisdk/wmi/win32_windowsproductactivation.asp
; still needs some testing and code improvement
; currently (March,09,2005) this works only with development version of autoit
; get current beta from http://www.autoitscript.com/autoit3/files/beta/autoit/
; then get the newest build from                                                          and extract the zip file
; in the autoit folder

; if you can test any of the functions, please tell me, or post in forum

; Tested means: I tried it, and the results were as expected
; Untested means: i could not (yet) test it, or i am not sure if the results are correct

;untested
MsgBox(0, "DecodeProductKey", _WPA_DecodeProductKey (_WPA_getBinaryDPID_OFFICEXP ()))

;untested
MsgBox(0, "DecodeProductKey", _WPA_DecodeProductKey (_WPA_getBinaryDPID_VS2003 ()))

;Tested
MsgBox(0, "DecodeProductKey", _WPA_DecodeProductKey (_WPA_getBinaryDPID_WINDOWS ()))

;Tested
MsgBox(0, "DecodeProductKey", _WPA_DecodeProductKey (_WPA_getBinaryDPID_OFFICE2K3 ()))

;Tested
MsgBox(0, "ActivationRequired", _WPA_ActivationRequired ())

;Unested
MsgBox(0, "Description", _WPA_Description ())

;Untested
MsgBox(0, "Caption", _WPA_Caption ())

;Tested
MsgBox(0, "IsNotificationOn", _WPA_IsNotificationOn ())

;Tested
MsgBox(0, "RemainingEvaluationPeriod", _WPA_RemainingEvaluationPeriod ())

;Tested
MsgBox(0, "RemainingGracePeriod", _WPA_RemainingGracePeriod ())

;Tested
MsgBox(0, "ServerName", _WPA_ServerName ())

;Untested
MsgBox(0, "SettingID", _WPA_SettingID ())

;Untested
;Msgbox(0,"ActivateOffline",_WPA_ActivateOffline("2112312-232312-1231232"))

;Untested
;Msgbox(0,"ActivateOnline",_WPA_ActivateOnline())

;Untested
MsgBox(0, "GetInstallationID", _WPA_GetInstallationID ())

;Untested
MsgBox(0, "SetNotification", _WPA_SetNotification (1))

;Tested
;$key="ENTER-SOMEK-EYHER-ETOTE-STIT!"
;Msgbox(0,"SetProductKey",_WPA_SetProductKey($key))
