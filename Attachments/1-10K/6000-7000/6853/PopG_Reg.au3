; PopG_Reg.au3 - Andy Swarbrick (c) 2005-6
#region		Doc:
#region		Doc: Notes
; Extends functionality of Registry functions
#endregion	Doc: Notes
#region		Doc: History
; 09-Feb-06 Als Coded _RegSetReset
; 06-Feb-06 Als Fixed bug in _RegSplit
; 17-Jan-06 Als Added _RegReRead
#endregion	Doc: History
#region		Doc: FunctionList
; _RegCreateKeys						Creates a range of delimited subkeys		
; _RegReRead							Checks if the value is a registry key\val and if true returns that value.
; _RegRenameVal							Renames registry $nam1 to $nam2 in key $Key
; _RegSearchAndReplace					Scans through the registry replacing one string for another.
; _RegSetReset							Updates the registry to either a set or reset value
; _RegSplit								Splits a registry key+name string into key and name.
; _RegSwapVal							Swaps registry $nam1 to $nam2 in key $Key
; _RegType								Returns the string value of the registry type.
; _RegWriteSetRst						Writes to the registry one of two values depending on $OkRst
#endregion	Doc: FunctionList
#endregion	Doc:
#region		Init:
#region		Init: Includes
	#include-once
	#include '..\PopGincl\PopG_MsgBox.au3'
	#include '..\PopGincl\PopG_String.au3'
	#include <GuiConstants.au3>
	#include <Constants.au3>
#endregion	Init: Includes
#region		Init: Absolute Constants
	Global Const $Hkcu										='HKEY_CURRENT_USER'
	Global Const $Hklm										='HKEY_LOCAL_MACHINE'
	Global Const $Hku										='HKEY_LOCAL_MACHINE'
	Global Const $Hkcr										='HKEY_CLASSES_ROOT'
	Global Const $REGGR_INDATA								=1
	Global Const $REGGR_INKEY								=2
	Global Const $REGGR_INVALUE								=3
	Global Const $RegBIN									='REG_BINARY'
	Global Const $RegDBE									='REG_DWORD_BIG_ENDIAN'
	Global Const $RegDWD									='REG_DWORD'
	Global Const $RegESZ									='REG_EXPAND_SZ'
	Global Const $RegFUL									='REG_FULL_RESOURCE_DESCRIPTOR'
	Global Const $RegLNK									='REG_LINK'
	Global Const $RegMSZ									='REG_MULTI_SZ'
	Global Const $RegNON									='REG_NONE'
	Global Const $RegREQ									='REG_RESOURCE_REQUIREMENTS_LIST'
	Global Const $RegRES									='REG_RESOURCE_LIST'
	Global Const $RegSZ										='REG_SZ'
#endregion	Init: Absolute Constants
#region		Init: Derived Constants
	Global Const $HkcrCls									=$Hkcr&'\CLSID'
	Global Const $HkcuCp									=$Hkcu&'\Control Panel'
	Global Const $HkcuCpDesk								=$HkcuCp&'\Desktop'
	Global Const $HkcuEnv									=$Hkcu&'\Environment'
	Global Const $HkcuSw									=$Hkcu&'\Software'
	Global Const $HkcuSwGrv									=$HkcuSw&'\Groove Networks, Inc.\Groove'
	Global Const $HkcuSwMs									=$HkcuSw&'\Microsoft'
	Global Const $HkcuSwMsIe								=$HkcuSwMs&'\Internet Explorer'
	Global Const $HkcuSwMsWin								=$HkcuSwMs&'\Windows'
	Global Const $HkcuSwMsWinCv								=$HkcuSwMsWin&'\CurrentVersion'
	Global Const $HkcuSwMsWinCvExp							=$HkcuSwMsWinCv&'\Explorer'
	Global Const $HkcuSwMsWinCvPol							=$HkcuSwMsWinCv&'\Policies'
	Global Const $HkcuSwMsWinCvPolExp						=$HkcuSwMsWinCvPol&'\Explorer'
	Global Const $HkcuSwMsWinCvPolNet						=$HkcuSwMsWinCvPol&'\Network'
	Global Const $HkcuSwMsWinCvPolSys						=$HkcuSwMsWinCvPol&'\System'
	Global Const $HkcuSwMsWinNt								=$HkcuSwMs&'\Windows NT'
	Global Const $HkcuSwMsWinNtCv							=$HkcuSwMsWinNt&'\CurrentVersion'
	Global Const $HkcuSwMsWinNtCvExp						=$HkcuSwMsWinNtCv&'\Explorer'
	Global Const $HkcuSwMsWinNtCvNet						=$HkcuSwMsWinNtCv&'\Network'
	Global Const $HkcuSwPol									=$HkcuSw&'\Policies'
	Global Const $HkcuSwPolMs								=$HkcuSwPol&'\Microsoft'
	Global Const $HkcuSwPolMsWin							=$HkcuSwPolMs&'\Windows'
	Global Const $HkcuSwPolMsWinSys							=$HkcuSwPolMsWin&'\System'
	Global Const $HkcuSwPopG								=$HkcuSw&'\PopG'
	Global Const $HklmSw									=$Hklm&'\Software'
	Global Const $HklmSwCls									=$HklmSw&'\Classes'
	Global Const $HklmSwGrv									=$HklmSw&'\Groove Networks, Inc.\Groove'
	Global Const $HklmSwMs									=$HklmSw&'\Microsoft'
	Global Const $HklmSwMsIe								=$HklmSwMs&'\Internet Explorer'
	Global Const $HklmSwMsWin								=$HklmSwMs&'\Windows'
	Global Const $HklmSwMsWinCv								=$HklmSwMsWin&'\CurrentVersion'
	Global Const $HklmSwMsWinCvExp							=$HklmSwMsWinCv&'\Explorer'
	Global Const $HklmSwMsWinNt								=$HklmSwMs&'\Windows NT'
	Global Const $HklmSwMsWinNtCv							=$HklmSwMsWinNt&'\CurrentVersion'
	Global Const $HklmSwMsWinNtCvWinl						=$HklmSwMsWinNtCv&'\Winlogon'
	Global Const $HklmSwPopG								=$HklmSw&'\PopG'
	Global Const $HklmSys									=$Hklm&'\System'
	Global Const $HklmSysCcs								=$HklmSys&'\CurrentControlSet'
	Global Const $HklmSysCcsCtl								=$HklmSysCcs&'\Control'
	Global Const $HklmSysCcsSvc								=$HklmSysCcs&'\Services'
	Global Const $HkuDef									=$Hku&'\.DEFAULT'
	Global Const $HkuDefCp									=$HkuDef&'\Control Panel'
	Global Const $HkuDefCpDesk								=$HkuDefCp&'\Desktop'
	Global Const $HkuDefEnv									=$HkuDef&'\Environment'
	Global Const $HkuDefSw									=$HkuDef&'\Software'
	Global Const $HkuDefSwMs								=$HkuDefSw&'\Microsoft'
	Global Const $HkuDefSwMsWinNt							=$HkuDefSwMs&'\Windows NT'
	Global Const $HkuDefSwMsWinNtCv							=$HkuDefSwMsWinNt&'\Current Version'
	Global Const $HkuDefSwMsWinNtCvNet						=$HkuDefSwMsWinNtCv&'\Network'
#endregion	Init: Derived Constants
#region		Init: Autoit options
	#NoTrayIcon
	Opt('MustDeclareVars', True)
	Opt('RunErrorsFatal',False)
#endregion	Init: Autoit options
#endregion	Init:
#region		Run:
#region		Run: Test Harness
#region		Run: Test _RegSearchAndReplace
;~ 	Local $Hive=$HkcuSwPopG&'\test'
;~ 	RegWrite($Hive,'fred',$RegSZ,'joar')
;~ 	RegWrite($Hive,'andy',$RegSZ,'tom')
;~ 	RegWrite($Hive,'barbara',$RegSZ,'zebedee')
;~ 	RegWrite($Hive&'\a','fred',$RegSZ,'joar')
;~ 	RegWrite($Hive&'\a','andy',$RegSZ,'tom')
;~ 	RegWrite($Hive&'\a','barbara',$RegSZ,'zebedee')
;~ 	RegWrite($Hive&'\b','fred',$RegSZ,'joar')
;~ 	RegWrite($Hive&'\b','andy',$RegSZ,'tom')
;~ 	RegWrite($Hive&'\b','barbara',$RegSZ,'zebedee')
;~ 	RegWrite($Hive&'\b\c','fred',$RegSZ,'joar')
;~ 	RegWrite($Hive&'\b\c','andy',$RegSZ,'tom')
;~ 	RegWrite($Hive&'\b\c','barbara',$RegSZ,'zebedee')
;~ 	Local $OkData=True
;~ 	Local $OkValue=False
;~ 	Local $Srch='ar'
;~ 	Local $Repl='H'
;~ 	Local $Occ=0
;~ 	Local $Case=0
;~ 	;ProgressOn('','')
;~ 	Local $ProgCnt=1
;~ 	Local $ProgMax=10
;~ 	_RegSearchAndReplace($Hive,$Srch,$Repl,$Occ,$Case,$OkData,$OkValue,$ProgCnt,$ProgMax)
;~ 	;ProgressOff()
#endregion	Run: Test _RegSearchAndReplace
#region		Run: Test _RegSplit
;~ 	Local $Reg,$Key,$Name,$Val
;~ 	$Reg=$HklmSwMsWinCvExp&'\Abc=Def'
;~ 	_RegSplit($Reg,$Key,$Name,$Val)
;~ 	MsgBox(0,'_RegSplit test',	'$Reg='&$Reg&@LF&'$Key='&$Key&@LF&'$Name='&$Name&@LF&'$Val='&$Val)
;~ 	Exit
#endregion	Run: Test _RegSplit
#region		Run: Test Gui
;~ 	Local $AppNam='Test Program for PopG_Array.au3'
;~ 	If WinExists($AppNam) Then _MsgBoxExit($mbfStop, $AppNam,'Already Running')
;~ 	AutoItWinSetTitle($AppNam)
;~ 	Local $msg,$Form1,$err,$new,$val1,$val2
;~ 	Local $Key=$HkcuSw&'\PopG\temp'
;~ 	Local $Test_RegRenameVal,$Test_RegSwapVal,$Test_RegCreateKeys,$Test_RegWriteSetRst,$Test_RegType
;~ 	$Form1 = GUICreate($AppNam, 300, 200, 192, 125)
;~ 	GUICtrlCreateLabel('Select from the functions below to initiate a test. To verify actions you may wish to have the registry open.',	10, 10, 280, 34)
;~ 	$Test_RegRenameVal			=GUICtrlCreateButton('$Test_RegRenameVal',		10, 40, 200, 21)
;~ 	GUICtrlSetTip($Test_RegRenameVal,'This test renames a registry string called "fred" to "joe"')
;~ 	Local $Test_RegSwapVal		=GUICtrlCreateButton('$Test_RegSwapVal',		10, 70, 200, 21)
;~ 	GUICtrlSetTip($Test_RegSwapVal,'This test creates two entries Fred and Joe and then swaps their values.')
;~ 	Local $Test_RegCreateKeys	=GUICtrlCreateButton('$Test_RegCreateKeys',		10, 100, 200, 21)
;~ 	GUICtrlSetTip($Test_RegCreateKeys,'Click me to add a 2dim array to another 2dim array. You will see three dialog boxes'&@LF&'1. TwoArr1 before'&@LF&'2. TwoArr2 before'&@LF&'3. TwoArr1 after'&@LF&'remember the first value is the number of entries')
;~ 	Local $Test_RegCreateKeys	=GUICtrlCreateButton('$Test_RegCreateKeys',		10, 130, 200, 21)
;~ 	GUICtrlSetTip($Test_RegCreateKeys,'Click me to add a 2dim array to another 2dim array. You will see three dialog boxes'&@LF&'1. TwoArr1 before'&@LF&'2. TwoArr2 before'&@LF&'3. TwoArr1 after'&@LF&'remember the first value is the number of entries')
;~ 	Local $Test_RegType	=GUICtrlCreateButton('$Test_RegType',		10, 130, 200, 21)
;~ 	GUICtrlSetTip($Test_RegType,'Click me to add a 2dim array to another 2dim array. You will see three dialog boxes'&@LF&'1. TwoArr1 before'&@LF&'2. TwoArr2 before'&@LF&'3. TwoArr1 after'&@LF&'remember the first value is the number of entries')
;~ 	Local $DoneBtn				=GUICtrlCreateButton('$DoneBtn', 				10, 160, 100, 21)
;~ 	GUISetState(@SW_SHOW)
;~ 	While True
;~ 		$msg = GuiGetMsg()
;~ 		Select
;~ 		Case $msg = $Test_RegRenameVal
;~ 			RegDelete($Key)
;~ 			RegWrite($Key,'fred',$RegSZ,'fredsvalue')
;~ 			_RegRenameVal($Key,'fred','joe')
;~ 			$err=@error
;~ 			$new=RegRead($Key,'joe')
;~ 			MsgBox($mbfInfo,'joes value is','"'&$new&'"'&' with an @error='&$err)
;~ 			RegDelete($Key)
;~ 		Case $msg = $Test_RegSwapVal
;~ 			RegDelete($Key)
;~ 			RegWrite($Key,'fred',$RegSZ,'fredsvalue')
;~ 			RegWrite($Key,'joe',$RegSZ,'joessvalue')
;~ 			_RegSwapVal($Key,'fred','joe')
;~ 			$err=@error
;~ 			$val1=RegRead($Key,'fred')
;~ 			$val2=RegRead($Key,'joe')
;~ 			MsgBox($mbfInfo,'_RegSwapVal result','freds value is "'&$val1&'"'&' and joes value is"'&$val2&'"'&' with an @error='&$err)
;~ 			RegDelete($Key)
;~ 		Case $msg = $Test_RegCreateKeys
;~ 			;;;
;~ 		Case $msg = $Test_RegType
;~ 			;;;
;~ 		Case $msg = $Test_RegWriteSetRst
;~ 			;;;
;~ 		Case $msg = $GUI_EVENT_CLOSE Or $msg=$DoneBtn
;~ 			ExitLoop
;~ 		Case Else
;~ 			;;;;;;;
;~ 		EndSelect
;~ 	WEnd
;~ 	Exit
#region		Run: Test _RegSetReset
;~ 	_RegSetReset
#endregion	Run: Test _RegSetReset
#endregion	Run: Test Gui
#endregion	Run: Test Harness
#region		Run: Functions:
; _RegSetReset							Updates the registry to either a set or reset value
Func _RegSetReset($Key,$Name,$Type,$SetVal,$OkReset=False,$OkSetDelete=False,$OkResetDelete=False,$RstVal='',$Desc='')
	Local $OldVal	=RegRead($Key,$Name)
	Local $OldErr	=@error
	Local $OldExt	=@extended
	;
;~ 	If $OldErr Then
;~ 		If $OldErr=1 Then 				;Key not found
;~ 			SetError(1)
;~ 			Return False
;~ 		ElseIf $OldErr=-1 Then 			;name not found - not an error in this program.
;~ 			SetError(0)
;~ 		ElseIf $OldErr=-2 Then			;unsupported type, so exit.
;~ 			SetError(2)
;~ 			Return False
;~ 		EndIf
;~ 	EndIf
	Local $OldType	=_RegType($OldExt)
	;
;~ 	If $OldType<>$Type Then 
;~ 		If MsgBox($mbfStop,$AppTtl,'Registry type mismatch for' _
;~ 			&@LF&'Key: '&$Key _
;~ 			&@LF&'Name: '&$Name _
;~ 			&@LF&'Old type was: '&$OldType _
;~ 			&@LF&'New type is: '&$Type)<>$mbaOk Then
;~ 			SetError(3)
;~ 			Return False
;~ 		EndIf
;~ 	EndIf
	;
;~ 	If $OkConfirm Then
;~ 		If MsgBox($mbfinfo,'Confirm','Ok to change: '_
;~ 		&@LF&'Key: '&$Key _
;~ 		&@LF&'Name: '&$Name _
;~ 		&@LF&'to: '&$SetVal _
;~ 		&@LF&'Purpose: '&$Desc)<>$mbaOk Then 
;~ 		SetError(4)
;~ 		Return False
;~ 	EndIf
	;
;~ 	RegDelete($Key,$Name)				; safety precaution. Trying to modify a value with a different (possibly wrong) type fails. But it could cause additional delays...
	;
	Local $result
	If $OkReset Then
		If $OkResetDelete Then
			RegDelete($Key,$Name)
			$result=1					;ignore errors
		Else
			$result=RegWrite($Key,$Name,$Type,$RstVal)
		EndIf
	Else
		If $OkSetDelete Then
			RegDelete($Key,$Name)
			$result=1					;ignore errors
		Else
			$result=RegWrite($Key,$Name,$Type,$SetVal)
		EndIf
	EndIf
	Return $result
EndFunc ; _RegSetReset
; _RegSearchAndReplace					Scans through the registry replacing one string for another.
Func _RegSearchAndReplace($Hive,$Srch,$Repl,$Occ,$Case,$OkData,$OkValue,$ProgCnt=0,$ProgMax=0)
	Local $Idx,$Jdx,$Error
	Local $Key,$Val,$New,$Data,$Type
		$Jdx=1
		While True
			$Val=RegEnumVal($Hive,$Jdx)
			If @error<>0 Then ExitLoop
			$Jdx=$Jdx+1
			If $OkData Then
				$Data=RegRead($Hive,$Val)
				If @error=0 Then
					$Type=_RegType(@extended)
					If $Type=$RegSZ Then			; we c/should extend this to extended string types.
						$Data=StringReplace($Data,$Srch,$Repl,$Occ,$Case)
						RegWrite($Hive,$Val,$Type,$Data)
					EndIf
				EndIf
			EndIf
			If $OkValue Then
				$New=StringReplace($Val,$Srch,$Repl,$Occ,$Case)
				_RegRenameVal($Hive,$Val,$New)
			EndIf
	If $ProgCnt>=1 Then
		ProgressSet($ProgCnt/$ProgMax*100)
		$ProgCnt=$ProgCnt+1
		If $ProgCnt>100 Then $ProgCnt=1
	EndIf
	WEnd
	;
	$Idx=1
	While True
		$Key=RegEnumKey($Hive,$Idx)
		If @error<>0 Then ExitLoop
		$Idx=$Idx+1
		_RegSearchAndReplace($Hive&'\'&$Key,$Srch,$Repl,$Occ,$Case,$OkData,$OkValue,$ProgCnt,$ProgMax)
		;
	WEnd
	;
	;Not supported yet.
;	If $OkKey Then
;		$New=StringReplace($Key,$Srch,$Repl,1,$Case)
;		_RegRenameKey($Hive&'\'&$Key,$New)
;	EndIf
EndFunc ; _RegSearchAndReplace
; _RegRenameVal							Renames registry $nam1 to $nam2 in key $Key
; @error - 1 if $nam1=$nam2
; @error - 2 if $nam2 already exists
; @error - 3 if error reading $nam1
; @error - 4 if error writing $nam2
Func _RegRenameVal($Key,$OldV,$NewV)
	If $OldV=$NewV Then
		SetError(1,0)
		Return False
	EndIf
	Local $NewD=RegRead($Key,$NewV)
	If Not @error Then ; If new exists then leave it in place.
		SetError(2,0)
		Return False
	EndIf
	Local $OldD=RegRead($Key,$OldV)
	If @error Then 
		SetError(3,0)
		Return False
	EndIf
	Local $Type=_RegType(@extended)
	RegWrite($Key,$NewV,$Type,$OldD)
	If @error Then 
		SetError(4,0)
		Return False
	EndIf
	RegDelete($Key,$OldV)
	SetError(0,0)
	Return True
EndFunc ; _RegRenameVal
; _RegType								Returns the string value of the registry type decimal constant,
Func _RegType($idx)
	Local $Type
	Select
	Case $idx=$REG_NONE
		$Type=''
	Case $idx=$REG_SZ
		$Type=$RegSZ
	Case $idx=$REG_EXPAND_SZ
		$Type=$RegESZ
	Case $idx=$REG_BINARY
		$Type=$RegBIN
	Case $idx=$REG_DWORD
		$Type=$RegDWD
	Case $idx=$REG_DWORD_BIG_ENDIAN
		$Type=$RegDBE
	Case $idx=$REG_LINK
		$Type=$RegLNK
	Case $idx=$REG_MULTI_SZ
		$Type=$RegMSZ
	Case $idx=$REG_RESOURCE_LIST
		$Type=$RegRES
	Case $idx=$REG_FULL_RESOURCE_DESCRIPTOR
		$Type=$RegFUL
	Case $idx=$REG_RESOURCE_REQUIREMENTS_LIST
		$Type=$RegREQ
	Case Else
		SetError(1)
	EndSelect
	Return $Type
EndFunc ; _RegType
; _RegSwapVal							Swaps registry $nam1 to $nam2 in key $Key
; @error - 1 if $nam1=$nam2
; @error - 2 if error reading $nam1
; @error - 3 if error reading $nam2
; @error - 4 if error deleting $nam1
; @error - 5 if error deleting $nam2
; @error - 6 if error writing $nam1
; @error - 7 if error writing $nam2
Func _RegSwapVal($Key,$nam1,$nam2)
	SetError(0)
	If $nam1=$nam2 Then
		SetError(1)
		Return False
	EndIf
	Local $val1=RegRead($Key,$nam1)
	If @error Then
		SetError(2)
		Return False
	EndIf
	Local $Type1=_RegType(@extended)
	Local $val2=RegRead($Key,$nam2)
	If @error Then
		SetError(3)
		Return False
	EndIf
	Local $Type2=_RegType(@extended)
	If $Type1<>$Type2 Then
		SetError(4)
		Return False
	EndIf
	If RegDelete($Key,$nam1) <> 1 Then
		SetError(5)
		Return False
	EndIf
	If RegDelete($Key,$nam2) <> 1 Then
		SetError(6)
		Return False
	EndIf
	If RegWrite($Key,$nam2,$Type1,$val1) <> 1 Then
		SetError(7)
		Return False
	EndIf
	If RegWrite($Key,$nam1,$Type1,$val2) <> 1 Then
		SetError(8)
		Return False
	EndIf
	Return True
EndFunc ;_RegSwapVal
; _RegSplit								Splits a registry key\name=val string into key, name & value
Func _RegSplit($RegKND,ByRef $Key,ByRef $Name, ByRef $dat)
	Const $KeyNamDlm='\'
	Const $NamValDlm='='
	Local $LeftSl,$RightSl,$LeftEq,$RightEq
	_StringSplit2($RegKND,$NamValDlm,$LeftEq,$RightEq,1)
	_StringSplit2($LeftEq,$KeyNamDlm,$LeftSl,$RightSl,-1)
	$Key=$LeftSl
	$Name=$RightSl
	$dat=$RightEq
EndFunc ;_RegSplit
; _RegCreateKeys						Creates a range of delimited subkeys		
Func _RegCreateKeys($base,$keys)
	Local $arr=StringSplit($keys,Opt('GUIDataSeparatorChar'))
	Local $Idx
	For $Idx=1 To $arr[0]
		RegWrite($base&'\'&$arr[$Idx])
	Next
EndFunc ;_RegCreateKeys
; _RegWriteSetRst						Writes to the registry one of two values depending on $OkRst
Func _RegWriteSetRst($Key,$name,$Type,$SetVal,$OkRst=False,$RstTyp=0,$RstVal='_RegWriteSetRst-novalue',$VfySecs=0,$VfyMsg='')
	Local $TgtVal=$SetVal
	If $OkRst Then $TgtVal=$RstVal
	If $VfySecs>0 Then _MsgBoxExit($mbfInfo+$mbfOkCancel,'_RegWriteSetRst','In registry key '&$Key&' for value '&$name&@LF&'Setting to: '&$TgtVal&@LF&'Notes: '&$VfyMsg,$mbaCancel)
	RegDelete($Key,$name)						; delete first then we can create a clean value.
	If $OkRst Then								; typically admins can reset.
		Select
		Case $RstTyp=0							; default: just delete
			;;;									; which we have already done
		Case $RstTyp=1							; reset to $RstVal
			If $RstVal='_RegWriteSetRst-novalue' Then _MsgBoxExit($mbfStop,'_RegWriteSetRst','Fatal error: no reset value specified!',$VfySecs)
			RegWrite($Key,$name,$Type,$TgtVal)
		EndSelect
	Else
		RegWrite($Key,$name,$Type,$TgtVal)
	EndIf
EndFunc
; _RegReRead							If the value read from the registry is registry key\val (ie begins with 'HKEY' then it reads and returns that value instead.
Func _RegReRead($Key,$Val)
	$Val=RegRead($Key,$Val)
	If StringLeft(StringLower($Val),5)='hkey_' = 0 Then Return $Val
	_StringSplit2($Val,Opt('GUIDataSeparatorChar'),$Key,$Val,-1)
	Return _RegReRead($Key,$Val)			; recursive call!
EndFunc
#endregion	Run: Functions
#endregion	Run:
