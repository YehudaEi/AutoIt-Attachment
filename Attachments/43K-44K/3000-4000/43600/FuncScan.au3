#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
func scan()
Opt("ExpandEnvStrings", 1)
Global $quick = "/quick", $smart = "/smart", $deep = "/deep", $rootkit = "/rk", $memory = "/memory", $traces = "/traces", $cookies = "/cookies", $pup = "/pup"
;Nothing checked error!
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   MsgBox(48,"ERROR!","Please check a box before starting scan!")
EndIf
;cb1 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '"')
EndIf
;cb2 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '"')
EndIf
;cb3 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '"')
EndIf
;cb4 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '"')
EndIf
;cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $memory & '"')
EndIf
;cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $traces & '"')
EndIf
;cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $cookies & '"')
EndIf
;CB8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $pup & '"')
EndIf
;cb1,cb2 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '"')
EndIf
;cb1,cb3 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $deep & '"')
EndIf
;cb1,cb4 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $rootkit & '"')
EndIf
;cb1,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $memory & '"')
EndIf
;cb1,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $traces & '"')
EndIf
;cb1,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $cookies & '"')
EndIf
;cb1,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $pup & '"')
EndIf
;cb2,cb3 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $deep &'"')
EndIf
;cb2,cb4 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $rootkit &  '"')
EndIf
;cb2,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $memory &  '"')
EndIf
;cb2,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $traces &  '"')
EndIf
;cb2,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $cookies &  '"')
EndIf
;cb2,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $pup &  '"')
EndIf
;cb3,cb4 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $rootkit &  '"')
EndIf
;cb3,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $memory &  '"')
EndIf
;cb3,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $traces &  '"')
EndIf
;cb3,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $cookies &  '"')
EndIf
;cb3,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $pup &  '"')
EndIf
;cb4,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '" "' & $memory & '"')
EndIf
;cb4,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '" "' & $traces & '"')
EndIf
;cb4,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '" "' & $cookies & '"')
EndIf
;cb4,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '" "' & $pup & '"')
EndIf
;cb5,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $memory & '" "' & $traces & '"')
EndIf
;cb5,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $memory & '" "' & $cookies & '"')
EndIf
;cb5,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $memory & '" "' & $pup & '"')
EndIf
;cb6,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $traces & '" "' & $cookies & '"')
EndIf
;cb6,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $traces & '" "' & $pup & '"')
EndIf
;cb7,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $cookies & '" "' & $pup & '"')
EndIf
;cb1,cb2,cb4 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $rootkit & '"')
EndIf
;cb1,cb2,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $memory & '"')
EndIf
;cb1,cb2,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $traces & '"')
EndIf
;cb1,cb2,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $cookies & '"')
EndIf
;cb1,cb2,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $pup & '"')
EndIf
;cb1,cb3,cb4 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $deep & '" "' & $rootkit & '"')
EndIf
;cb1,cb3,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $deep & '" "' & $memory & '"')
EndIf
;cb1,cb3,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $deep & '" "' & $traces & '"')
EndIf
;cb1,cb3,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $deep & '" "' & $cookies & '"')
EndIf
;cb1,cb3,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $deep & '" "' & $pup & '"')
EndIf
;cb1,cb4,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $rootkit & '" "' & $memory & '"')
EndIf
;cb1,cb4,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $rootkit & '" "' & $traces & '"')
EndIf
;cb1,cb4,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $rootkit & '" "' & $cookies & '"')
EndIf
;cb1,cb4,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $rootkit & '" "' & $pup & '"')
EndIf
;cb1,cb5,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $memory & '" "' & $traces & '"')
EndIf
;cb1,cb5,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $memory & '" "' & $cookies & '"')
EndIf
;cb1,cb5,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $memory & '" "' & $pup & '"')
EndIf
;cb1,cb6,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $traces & '" "' & $cookies & '"')
EndIf
;cb1,cb6,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $traces & '" "' & $pup & '"')
EndIf
;cb1,cb7,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $cookies & '" "' & $pup & '"')
EndIf
;cb2,cb3,cb4 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $deep & '" "' & $rootkit & '"')
EndIf
;cb2,cb3,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $deep & '" "' & $memory & '"')
EndIf
;cb2,cb3,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $deep & '" "' & $traces & '"')
EndIf
;cb2,cb3,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $deep & '" "' & $cookies & '"')
EndIf
;cb2,cb3,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $deep & '" "' & $pup & '"')
EndIf
;cb2,cb4,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $rootkit & '" "' & $memory &  '"')
EndIf
;cb2,cb4,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $rootkit & '" "' & $traces &  '"')
EndIf
;cb2,cb4,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $rootkit & '" "' & $cookies &  '"')
EndIf
;cb2,cb4,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $rootkit & '" "' & $pup &  '"')
EndIf
;cb2,cb5,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $memory & '" "' & $traces & '"')
EndIf
;cb2,cb5,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $memory & '" "' & $cookies & '"')
EndIf
;cb2,cb5,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $memory & '" "' & $pup & '"')
EndIf
;cb2,cb6,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $traces & '" "' & $cookies & '"')
EndIf
;cb2,cb6,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $traces & '" "' & $pup & '"')
EndIf
;cb2,cb7,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $smart & '" "' & $cookies & '" "' & $pup &  '"')
EndIf
;cb3,cb4,cb5 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $rootkit & '" "' & $memory  & '"')
EndIf
;cb3,cb4,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $rootkit & '" "' & $traces & '"')
EndIf
;cb3,cb4,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $rootkit & '" "' & $cookies & '"')
EndIf
;cb3,cb4,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $rootkit & '" "' & $pup & '"')
EndIf
;cb3,cb5,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $memory & '" "' & $traces &  '"')
EndIf
;cb3,cb5,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $memory & '" "' & $cookies &  '"')
EndIf
;cb3,cb5,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $memory & '" "' & $pup &  '"')
EndIf
;cb3,cb6,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $traces & '" "' & $cookies &  '"')
EndIf
;cb3,cb6,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $traces & '" "' & $cookies &  '"')
EndIf
;cb3,cb7,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $deep & '" "' & $cookies & '" "' & $pup &  '"')
EndIf
;cb4,cb5,cb6 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '" "' & $memory & '" "' & $traces & '"')
EndIf
;cb4,cb5,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd", '"' & $rootkit & '" "' & $memory & '" "' & $cookies & '"')
EndIf
;cb4,cb5,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '" "' & $memory & '" "' & $pup & '"')
EndIf
;cb4,cb6,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '" "' & $traces & '" "' & $cookies & '"')
EndIf
;cb4,cb6,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '" "' & $traces & '" "' & $pup & '"')
EndIf
;cb4,cb7,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $rootkit & '" "' & $cookies & '" "' & $pup & '"')
EndIf
;cb5,cb6,cb7 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $memory & '" "' & $traces & '" "' & $cookies & '"')
EndIf
;cb5,cb6,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $memory & '" "' & $traces & '" "' & $pup & '"')
EndIf
;cb5,cb7,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $memory & '" "' & $cookies & '" "' & $pup & '"')
EndIf
;cb6,cb7,cb8 checked everything else unchecked
If GUICtrlRead($cb1) = $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $traces & '" "' & $cookies & '" "' & $pup & '"')
EndIf
;cb1,cb2,cb3,cb4,cb6 checked everything else unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $traces & '"')
EndIf
;cb1,cb2,cb3,cb4,cb7 checked everything else unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $cookies & '"')
EndIf
;cb1,cb2,cb3,cb4,cb8 checked everything else unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $pup & '"')
EndIf
;cb1,cb2,cb3,cb4,cb5,cb7 checked everything else unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $memory & '" "' & $cookies &  '"')
EndIf
;cb1,cb2,cb3,cb4,cb5,cb8 checked everything else unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $memory & '" "' & $cookies &  '"')
EndIf
;Only cb1,cb2,cb3,cb5 checked checked everything else unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $memory & '"')
EndIf
;Only cb1,cb2,cb3,cb6 checked checked everything else unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $traces & '"')
EndIf
;Only cb1,cb2,cb3,cb7 checked checked everything else unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $cookies & '"')
EndIf
;Only cb1,cb2,cb3,cb8 checked checked everything else unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $pup & '"')
EndIf

;cb1,cb3,cb5,cb7 checked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_UNCHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $memory & '" "' & $traces & '" "' & $cookies & '" "' & $pup & '"')
EndIf
;cb2,cb4,cb6,cb8
If GUICtrlRead($cb1) =  $GUI_UNCHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_UNCHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $memory & '" "' & $traces & '" "' & $cookies & '" "' & $pup & '"')
EndIf
;Only cb1,cb2,cb3 checked cb4,cb5,cb6,cb7,cb8 unchecked
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_UNCHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '"')
EndIf
;ALL checked but cb5,cb6,cb7,cb8
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_UNCHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '"')
EndIf
;ALL checked but cb6, cb7,cb8
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_UNCHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $memory &  '"')
EndIf
;ALL checked but cb7,cb8
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_UNCHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $memory & '" "' & $traces & '"')
EndIf
;ALL checked but cb8
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_UNCHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $memory & '" "' & $traces '" "' & $cookies & '"')
EndIf
;ALL CHECKED
If GUICtrlRead($cb1) =  $GUI_CHECKED And GUICtrlRead($cb2) = $GUI_CHECKED And GUICtrlRead($cb3) = $GUI_CHECKED And GUICtrlRead($cb4) = $GUI_CHECKED And GUICtrlRead($cb5) = $GUI_CHECKED And GUICtrlRead($cb6) = $GUI_CHECKED And GUICtrlRead($cb7) = $GUI_CHECKED And GUICtrlRead($cb8) = $GUI_CHECKED Then
   ShellExecute("C:\Users\%username%\Desktop\C1RepairUtility\Files\Scripts\Batch\Scan.cmd",'"' & $quick & '" "' & $smart & '" "' & $deep & '" "' & $rootkit & '" "' & $memory & '" "' & $traces & '" "' & $cookies & '" "' & $pup & '"')
EndIf

EndFunc