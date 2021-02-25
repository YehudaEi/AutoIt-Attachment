#Region - TimeStamp
; 2011-11-08 13:43:46   v 0.1
#EndRegion - TimeStamp

; ==
; Idea integration NET.Framework: paulpmeier (http://www.autoitscript.com/forum/topic/129164-create-a-net-class-and-run-it-as-object-from-your-autoit-script/)
; ==
;===============================================================================
; Script Name......: NETFramework.au3
; Description......: Run a .net class as object from AutoIt script
; AutoIt version...: 3.3.6.1
; Author(s)........: paulpmeier, (BugFix - cast into a function, automated NET-detection)
;===============================================================================

#include-once
#include <File.au3>

OnAutoItExitRegister('__UnLoad_NET_Dll')

Global $__User_NET_Dll = '', $__RegAsmPath

;===============================================================================
; Function Name....: _NETFramework_Load
; Description......: Loads .vb or .cs file into a library and register them
;                    If another one always registered - will unregister that at first
; Parameter(s).....: $sVB_CS_File  Name of .vb/.cs file
; Requirement(s)...: $sVB_CS_File must be stored in @ScriptDir
; Return Value(s)..: Succes   1
;                    Failure  0  set @error - 1  wrong filetype given
;                                             2  given file not exists
;                                             3  NET Framework 2.0 or 4.0 required, not installed
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _NETFramework_Load($sVB_CS_File) ; == $sVB_CS_File must stored in @ScriptDir!!
	If $__User_NET_Dll <> '' Then __UnLoad_NET_Dll()
	Local $sExt = StringRight($sVB_CS_File, 3)
	If Not StringInStr('.vb .cs', $sExt) Then Return SetError(1,0,0) ; == .vb / .cs required
	If Not FileExists(@ScriptDir & '\' & $sVB_CS_File) Then Return SetError(2,0,0) ; == file does not exist
	Local $sRoot = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework", "InstallRoot")
	If @error Then Return SetError(3,0,0) ; == NET Framework 2.0 or 4.0 required!
	Local $aFolder = _FileListToArray($sRoot , "*", 2), $sNETFolder = ''
	For $i = $aFolder[0] To 1 Step -1
		If StringRegExp($aFolder[$i], "v4\.0\.\d+", 0) Then
			$sNETFolder = $aFolder[$i]
			ExitLoop
		ElseIf StringRegExp($aFolder[$i], "v2\.0\.\d+", 0) Then
			$sNETFolder = $aFolder[$i]
			ExitLoop
		EndIf
	Next
	If $sNETFolder = '' Then Return SetError(3,0,0) ; == NET Framework 2.0 or 4.0 required!
	If $sExt = '.vb' Then
		RunWait($sRoot & $sNETFolder & "\vbc.exe /target:library " & $sVB_CS_File, @ScriptDir, @SW_HIDE) ; compile the .net DLL
	Else
		RunWait($sRoot & $sNETFolder & "\csc.exe /target:library " & $sVB_CS_File, @ScriptDir, @SW_HIDE) ; compile the .net DLL
	EndIf
	$__User_NET_Dll = StringTrimRight($sVB_CS_File, 2) & 'dll'
	$__RegAsmPath = $sRoot & $sNETFolder & "\RegAsm.exe"
	RunWait($__RegAsmPath & " /codebase " & $__User_NET_Dll, @ScriptDir, @SW_HIDE) ; register the .net DLL
	Return 1
EndFunc  ;==>_NETFramework_Load

Func __UnLoad_NET_Dll()
	RunWait($__RegAsmPath & " /unregister " & $__User_NET_Dll, @ScriptDir, @SW_HIDE) ; unregister the .net DLL
EndFunc