#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <md5.au3>

Opt("TrayIconHide", 1) 

Global $title, $screenWidth, $screenHeight, $key, $keyPath, $mainWin

$title="Screen Lock"
$screenWidth=@DesktopWidth
$screenHeight=@DesktopHeight
$key="Primary Key"
$keyPath="HKEY_LOCAL_MACHINE\SOFTWARE\Screen Lock"

$mainWin=GUICreate ($title, $screenWidth, $screenHeight, -1, -1)

;/////////////////////////////////////////////////

Func setPassword($pwd)
	RegDelete($keyPath, $key)
	RegWrite($keyPath, $key, "REG_SZ", MD5($pwd))
EndFunc

Func getPassword()
	Return RegRead($keyPath, $key)
EndFunc

Func checkPassword($input)
  Local $result, $pwd
  $result=False
	$pwd=getPassword()
	If $pwd <> "" And MD5($input) == $pwd Then
		$result=True
	EndIf
  Return $result
EndFunc

Func lock()
  GUISetState(@SW_SHOW, $mainWin)
  GUICtrlCreateLabel ("", 0, 0, $screenWidth, $screenHeight)
  GUISetBkColor(0xff0000)
EndFunc

Func unlock()
	GUISetState(@SW_HIDE, $mainWin)
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func getTop($winHeight)
  Return Ceiling(($screenHeight-$winHeight)/2)
EndFunc

Func getLeft($winWidth)
  Return Ceiling(($screenWidth-$winWidth)/2)
EndFunc

;/////////////////////////////////////////////////

Dim $keypwd, $pwdMaster, $pwdInput

$keypwd=getPassword()

If $keypwd=="" Then
  $pwdMaster=InputBox ( $title, "Create master password : ", "", "*", 240, 60, getLeft(250), getTop(60), 0, $mainWin)
	If $pwdMaster<>"" Then
	   setPassword($pwdMaster)
	EndIf
Else
	lock();
	  While checkPassword($pwdInput)==False
		$pwdInput=InputBox ( $title, "Do you want to unlock screen now ? ", "", "*", 250, 60, getLeft(250), getTop(60), 0, $mainWin)
		  If checkPassword($pwdInput)==True Then
			unlock()
			Exit
		  ElseIf  $pwdInput=="" Then
			MsgBox(0, "Error", "Please enter password to unlock ! ")
		  Else
			MsgBox(0, "Error", "Password you entered is not valid ! ")
		  EndIf
	  WEnd
  EndIf
  
; End Program