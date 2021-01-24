#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=WinXP_Baseline_Set_DCOM_A.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------
Boston Scientific Corporation Confidential
(c) 2008 Boston Scientific Corporation or its affiliates. All rights reserved.

 AutoIt Version: 3.2.12.1
 Author:         Steven J. Mattison
 Filename:       WinXP_Baseline_Set_DCOM_A.au3
 
 $Revision:   1.3  $
 $Archive:   //STPNAS01/SCM/SW_DVT_COMMON/vcs/tools/scripts/WinXP_Baseline_Install_Visual_C++.auv  $ 
 $Modtime:   04 Sep 2008 15:53:46  $ 
 $Author:   steven.mattison  $ 

 Script Function:
	Baseline script to be run upon completion of the Boston Scientific Medusa
	Baseline CD to set the DCOM configuration to allow SchWrp to communicate
	with RegressionRunner.

#ce ----------------------------------------------------------------------------

#include <Debug.au3>
#include <GuiListView.au3>
Dim Const $Debug_Flag = 1

if $Debug_Flag Then
	_DebugSetup("DCOM_Debug")
EndIf
; Define some constants
Dim Const $DefWinWait = 60
Dim Const $OneSec = 1000
Dim Const $DCOMCNFG_Path = "c:\Windows\System32\dcomcnfg.exe"
Dim Const $wCompSrv = "Component Services"
Dim Const $txtCompSrv = ""
Dim Const $ClsListView = "SysListView321"
Dim Const $cConTree = "[CLASS:SysTreeView32;INSTANCE:1]"
Dim Const $wMyComp = "My Computer Properties"
Dim Const $txtOKBut = "OK"
Dim Const $cDefAuth = "[CLASS:ComboBox;INSTANCE:1]"
Dim Const $cDefImp = "[CLASS:ComboBox;INSTANCE:2]"
Dim Const $wLimAccPerm = "Access Permission"
Dim Const $CritErr = 16 + 8192
Dim Const $mnuAction = "[CLASS:ToolBarWindow32;INSTANCE:2]"
Dim Const $NavErrTitle = "DCOMCNFG Navigation Error"
Dim Const $DCOM_Enable = "[CLASS:Button;INSTANCE:1]"
Dim Const $cDefAccPerm = "[CLASS:Button;INSTANCE:3]"
Dim Const $DefAccUsers = "[CLASS:SysListView32,INSTANCE:1}"
Dim Const $SelUserDialog = "Select Users, Computers, or Groups"
Dim Const $AddUserTxtBox = "[CLASS:RichEdit20W;INSTANCE:1]"
Dim Const $AddUserButton = "[CLASS:Button;INSTANCE:1]"


; Launch dcomcnfg
If(Run($DCOMCNFG_Path) == 0) Then
	MsgBox($CritErr,$NavErrTitle,"The attempt to launch DCOMCNF.EXE failed.  The script will be aborted.")
	Exit 1
ElseIf 0 == WinWaitActive($wCompSrv, $txtCompSrv, $DefWinWait) Then
	MsgBox($CritErr, $NavErrTitle, "The attempt to launch DCOMCNFG.EXE failed. The script will be aborted.")
	Exit 1
EndIf



; Get to "My Computer". 1st have to get to "Computers".
ControlListView($wCompSrv, $txtCompSrv, $ClsListView, "SelectClear")
$CompSrvIdx = ControlListView($wCompSrv, $txtCompSrv, $ClsListView, "FindItem", $wCompSrv)
DebugMsg($CompSrvIdx)
if(-1 == $CompSrvIdx) Then
	MsgBox($CritErr, $NavErrTitle, "Could not find the " + $wCompSrv + " element in the System List View control.  The script will be aborted.")
	Exit 1
Else
	ControlListView($wCompSrv, $txtCompSrv, $ClsListView, "Select", $CompSrvIdx)
	Sleep($OneSec)
	ControlFocus($wCompSrv, $txtCompSrv, $ClsListView)
	Sleep($OneSec)
	SendKeys("{ENTER}")
	ControlClick($wCompSrv, $txtCompSrv, $mnuAction)
EndIf

; Now go to "My Computer" by selecting "Computers".
ControlListView($wCompSrv, $txtCompSrv, $ClsListView, "SelectClear")
$CompSrvIdx = ControlListView($wCompSrv, $txtCompSrv, $ClsListView, "FindItem", "Computers")
DebugMsg($CompSrvIdx)
If(-1 == $CompSrvIdx) Then
	MsgBox($CritErr, $NavErrTitle, "Could not find the ""Computers"" list item.  The script will be aborted.")
	Exit 1
Else
	ControlListView($wCompSrv, $txtCompSrv, $ClsListView, "Select", $CompSrvIdx)
	Sleep($OneSec)
	ControlFocus($wCompSrv, $txtCompSrv, $ClsListView)
	Sleep($OneSec)
	SendKeys("{ENTER}")
EndIf

; Now select "My Computer" and open the Properties dialog.
ControlListView($wCompSrv, $txtCompSrv, $ClsListView, "SelectClear")
Sleep($OneSec)
ControlListView($wCompSrv, $txtCompSrv, $ClsListView, "Select", 0)
Sleep($OneSec)
ControlFocus($wCompSrv, $txtCompSrv, $ClsListView)
Sleep($OneSec)
SendKeys("{ALT}VD")
SendKeys("{ALT}AR")
If 0 == WinWaitActive($wMyComp, $txtOKBut, 10) Then
	MsgBox($CritErr, $NavErrTitle, "The ""My Computer Properties"" dialog did not open, as expected.  Aborting...")
	Exit 1
EndIf

; Move to the Default Properties tab
SendKeys("+{TAB}{RIGHT}{RIGHT}")

; And verify the Enable Distributed COM on this computer checkbox is checked.
; If not, check it.
If (0 == ControlCommand($wMyComp, $txtOKBut, $DCOM_Enable, "IsChecked", "")) Then
	DebugMsg("""Enable Distributed COM on this computer"" checkbox is not checked.")
	ControlCommand($wMyComp, $txtOKBut, $DCOM_Enable, "Check", "")
	if (@error == 1) Then
		MsgBox($CritErr, $NavErrTitle, "Could not check the ""Enable Distributed COM on this computer"" checkbox.  Aborting...")
		Exit 1
	EndIf
EndIf

; Make sure the Default Authentication Level is "Connect"
Set_Combo($wMyComp, $txtOKBut, $cDefAuth, "Connect")

; Make sure the Default Impersonation Level is "Identify"
Set_Combo($wMyComp, $txtOKBut, $cDefImp, "Identify")

; Now go to the COM Security tab
ControlFocus($wMyComp, $txtOKBut, $DCOM_Enable)
SendKeys("+{TAB}{RIGHT}+{TAB}{RIGHT}{RIGHT}")

; Open the Default Access Permissions dialog.
Open_Dialog($wMyComp, $txtOKBut, $cDefAccPerm, $wLimAccPerm, $txtOKBut)

; Ensure that ANONYMOUS LOGON is in the list.
Check_User($wLimAccPerm, $txtOKBut, $DefAccUsers, "SYSTEM", $AddUserButton)

#cs
******************************************************************************
*
* SendKeys function
*
* Send a sequence of keystrokes to the keyboard, then sleep for one second.
*
******************************************************************************
#ce
Func SendKeys($strKeys)
	Send($strKeys)
	Sleep($OneSec)
EndFunc

#cs
*******************************************************************************
*
* DebugMsg
*
*******************************************************************************
#ce
Func DebugMsg($Msg)
	If (1 = $Debug_Flag) Then
		_DebugOut($Msg)
	EndIf
EndFunc

#cs
*******************************************************************************
*
* SetComboBox
*
*******************************************************************************
#ce
Func Set_Combo($Window, $WinTxt, $Control, $Selection)
	; See if the combo box is already set. If it is, nothing to do.
	$DefAuthLevel = ControlCommand($Window, $WinTxt, $Control, "GetCurrentSelection", "")
	DebugMsg("For Control, """ & $Control & """, value is:  " & $DefAuthLevel)
	if ($Selection <> $DefAuthLevel) Then
		ControlCommand($Window, $WinTxt, $Control, "SelectString", $Selection)
		Sleep($OneSec)
		; Make sure it got set.
		if ($Selection <> ControlCommand($Window, $WinTxt, $Control, "GetCurrentSelection", "")) Then
			MsgBox($CritErr, $NavErrTitle, "Could not set the """ & $Control & """ to """ & $Selection & """. Aborting...")
			Exit 1
		EndIf
	EndIf
EndFunc

#cs
*******************************************************************************
*
* Open_Dialog
*
*******************************************************************************
#ce
Func Open_Dialog($StrtWind, $StrtWinTxt, $Button, $DestWind, $DestWinTxt)
	; Click on the button to open the dialog
	If ( 0 == ControlClick($StrtWind, $StrtWinTxt, $Button)) Then
		MsgBox($CritErr, $NavErrTitle, "Failed to click on the """ & $Button & "."" Aborting...")
		Exit 1
	ElseIf (0 == WinWaitActive($DestWind, $DestWinTxt, $DefWinWait)) Then
		MsgBox($CritErr, $NavErrTitle, "The """ & $DestWind & """ failed to open. Aborting...")
		Exit 1
	EndIf
EndFunc

#cs
*******************************************************************************
*
* Check_User
*
*******************************************************************************
#ce
Func Check_User($Window, $WinTxt, $Control, $Selection, $Button)
	DebugMsg("$Window: " & $Window)
	DebugMsg("$WinTxt: " & $WinTxt)
	DebugMsg("$Control: " & $Control)
	DebugMsg("$Selection: " & $Selection)
	DebugMsg("$Button: " & $Button)
	$hWnd = WinGetHandle("Access Permission", "A&dd...")
	ControlFocus($hWnd, "", $Control)
	DebugMsg("Window Handle:  " & $hWnd)
	
	DebugMsg("FindString:  " & ControlCommand($hWnd, "", $Control, "FindString", $Selection))
	
	ControlListView($hWnd, "", $Control, "SelectClear")
	ControlListView($hWnd, "", $Control, "Select", 1)
	$hListView = ControlGetHandle($hWnd, "", $Control)
	
	$iColCnt = _GUICtrlListView_GetColumnCount($hListView)
	DebugMsg("Column Count = " & $iColCnt)
	
	$iIndex = _GUICtrlListView_FindText($hListView, $Selection)
	
	DebugMsg("$iIndex = " & $iIndex)
EndFunc

#cs
*******************************************************************************
*
* Add_User
*
*******************************************************************************
#ce
Func Add_User($Window, $WinTxt, $Button, $Selection)
	; First need to open the "Select Users, Computers, or Groups" dialog
	Open_Dialog($Window, $WinTxt, $Button, $SelUserDialog, $txtOKBut)
	
	; Now, add the selection to the text box by, 1st, setting the focus,
	; then, pasting the selection into it and clicking on OK.
	ControlFocus($SelUserDialog, $txtOKBut, $AddUserTxtBox)
	ControlCommand($SelUserDialog, $txtOKBut, $AddUserTxtBox, "EditPaste", $Selection)
EndFunc
	