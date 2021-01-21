; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
$TweakListVersion=000
$TweakListBuild=1


#include "Engine_v2.au3"
TweakListVersion($TweakListVersion,$TweakListBuild)

;-------------Lanch Tweaks----------------------
TaskBar_AutoHide()

;-------------End Lanch Tweaks------------------

;--------------------Tweak Code------------------------------

Func TaskBar_AutoHide()
 $TweakAddedBy = "Code Junkie"
 $TweakAddedDate = "27/Feb/05"
 $TweakFirstImplomented = "v2.0000"
 $TweakVer = "v1.00"
 $TweakName = "Taskbar - Auto Hide"
 $TweakSection = "taskbar"
 $TweakKey = "auto_hide"
 
 $TweakCheckWinVer = 0
 
 $iniReturn = Read_ini_for_tweaks($TweakSection,$TweakKey)
	Select
     Case $iniReturn = 1
	  
	  ;~ ---------Local----------
	  $Action = "RegWrite"
	  $KeyName = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	  $ValName = "TaskbarSizeMove"
	  $ValType = "REG_DWORD"
	  $NewValue = 1
	  $EditStart = 1
	  TweakerRegEditComplete($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	  ;~ ------CurrentUser-------
	  $Action = "RegWrite"
	  $KeyName = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	  $ValName = "TaskbarSizeMove"
	  $ValType = "REG_DWORD"
	  $NewValue = 1
	  $EditStart = 1
	  TweakerRegEditComplete($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	  Implomented_YesNo(1,0,$TweakName)
     Case $iniReturn = 0
	  ;~ ---------Local----------
	  $Action = "RegWrite"
	  $KeyName = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	  $ValName = "TaskbarSizeMove"
	  $ValType = "REG_DWORD"
	  $NewValue = 0
	  $EditStart = 1
	  TweakerRegEditComplete($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	  ;~ ------CurrentUser-------
	  $Action = "RegWrite"
	  $KeyName = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	  $ValName = "TaskbarSizeMove"
	  $ValType = "REG_DWORD"
	  $NewValue = 0
	  $EditStart = 1
	  TweakerRegEditComplete($Action,$KeyName,$ValName,$ValType,$NewValue,$EditStart,$TweakName)
	  Implomented_YesNo(1,0,$TweakName)
     Case $iniReturn = -1
      Implomented_YesNo(0,1,$TweakName)
     Case Else
      Implomented_YesNo(0,2,$TweakName)
	  ErrorMessage(48,"Invalid ini entry",$TweakSection & " - " & $TweakKey & " is invalid")
	EndSelect
EndFunc

;--------------------Enf Of Tweak Code------------------------------