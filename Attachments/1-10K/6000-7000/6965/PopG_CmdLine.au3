; PopG_CmdLine.au3 - Andy Swarbrick - Command line parser for Au3
#region		Doc:
#region		Doc: Notes
; This library provides a structured parsing of command lines with additional support for setting default values in the registry.
; To call the routine you describe your command line in an (N+1)x3 array, where N is the number of arguments.
; On return any argument that is recognised has index 1 set to that value.
; If a parameter to the argument is required then index 2 has that value.
; Normal command line argument rules apply, with the following additional guidelines.
; Positional arguments are supported and must occur before all optional argumemts.
; Optional arguments are prefixed with either a '-' or a '/'.
; Positional arguments must be space separated (with required spaces must be embedded in quotation marks).
;
; This routine is useful when your command line is becoming complex & powerful.  
;
; The automatic registry support makes the implementation very powerful.
; Up to two registry locations are supported: typically you c/would use one for HKCU (user defaults) and another for HKLM (computer defaults)
#endregion	Doc: Notes
#region		Doc: Functions
; _CmdLineParse					Parses the command line, returning results in an array.
#endregion	Doc: Functions
#endregion	Doc:
#region		Init:
#region		Init: Includes
	#include '..\PopGincl\PopG_String.au3'
	#include '..\PopGincl\PopG_Reg.au3'
	#include '..\PopGincl\PopG_Array.au3'
#endregion	Init: Includes
#endregion	Init: 
#region		Run: 
#region		Run: TestHarness
;~ 	Dim $CmdArgs[7][3]
;~ 	$CmdArgs[0][0]=6
;~ 	$CmdArgs[1][0]='/D/Debug'
;~ 	$CmdArgs[2][0]='/L/Log:{file}'
;~ 	$CmdArgs[3][0]='/NA/NoAdmins'
;~ 	$CmdArgs[4][0]='/NG/NoGroup'
;~ 	$CmdArgs[5][0]='/QT/QueryThis:serveronly,citrixfarm,tsfarm'
;~ 	$CmdArgs[6][0]='/H/Help'
;~ 	Local $RegKey11=$HklmSwPopG&'\test'
;~ 	Local $RegKey12=$HkcuSwPopG&'\test'
;~ 	Local $RegNam='CmdLineArgs'
;~ 	RegWrite($RegKey1,$RegNam,$RegSZ,'/Log:%tmp%\alpha.log')
;~ 	_CmdLineParse($CmdArgs, $RegKey1,$RegNam)
;~ 	If @error Then
;~ 		MsgBox(4096,'@error',@error)
;~ 	Else
;~ 		_ArrayDisplay2($CmdArgs,'$CmdArgs')
;~ 	EndIf
;~ 	RegDelete($RegKey1)
;~ 	Exit
#endregion	Run: TestHarness
#region		Run: Functions
; _CmdLineParse					Parses the command line, returning results in an array.
Func _CmdLineParse(ByRef $CmdArgs, $RegKey1='',$RegNam='', $RegKey2='')
	If Not IsArray($CmdArgs) Then
		SetError(1)
		Return False
	EndIf
	Local $NoDims=UBound($CmdArgs,0)
	If $NoDims<>2 Then
		SetError(2)
		Return False
	EndIf
	Local $CmdLineReg=$CmdLine
	If $RegKey1<>'' Then
		Local $RegArgs=RegRead($RegKey1,$RegNam)
		If $RegArgs<>'' Then $CmdLineReg[$CmdLineReg[0]]=$CmdLine[$CmdLineReg[0]]&$RegArgs
	EndIf
	If $RegKey2<>'' Then
		Local $RegArgs=RegRead($RegKey2,$RegNam)
		If $RegArgs<>'' Then $CmdLineReg[$CmdLineReg[0]]=$CmdLine[$CmdLineReg[0]]&$RegArgs
	EndIf
	Local $cl,$ca,$cava,$clva
	Local $clVal,$clPar,$clValArr
	Local $caVal,$caPar,$caValArr
	Local $clBase=1
	For $ca=1 To $CmdArgs[0][0]
		If StringLeft($CmdArgs[$ca][0],1)<>'/' Then		; if does not begin with '/' then we are still on positional args
			If StringLeft($CmdLineReg[$ca],1)=='/' Then	; if we do not have enough positional args, then error...
				SetError(3)
				Return False
			EndIf
			$CmdArgs[$ca][1]=$CmdLineReg[$cl]
			$clBase=$ca+1
		Else
			_StringSplit2($CmdArgs[$ca][0],':',$caVal,$caPar)					; trim off any argtype parameters
			$caValArr=StringSplit(StringMid($caVal,2),'/')						; get array of argtypes
			For $cava=1 To $caValArr[0]											; for each argtype
				For $cl=$clBase To $CmdLineReg[0]								; for each cmdline arg
					$clValArr=StringSplit(StringMid($CmdLineReg[$cl],2),'/')	; get array of cmdline arg types
					For $clva=1 To $clValArr[0]
						_StringSplit2($clValArr[$clva],':',$clVal,$clPar)			; trim out cmdline arg parameters
						If StringLower($caValArr[$cava])==StringLower($clVal) Then
							$CmdArgs[$ca][1]=$clVal
							$CmdArgs[$ca][2]=$clPar
						EndIf
					Next	; $clva
				Next		; $cl
			Next			; $cava
		EndIf
	Next					; $ca
EndFunc ; _CmdLineParse
#endregion	Run: Functions
#endregion	Run:
