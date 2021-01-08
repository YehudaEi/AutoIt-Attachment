; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.120
; Author(s):         Knight
;
;Thanks to: Celeri, taurus905
;
; Script Function:
;	Open Source Obfuscater
;  -Imports all Includes, -Renames Variables, -Renames Functions
;
;In Development:
; -Obfuscate Numbers and Strings
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <File.au3>
#include <Array.au3>
#include <String.au3>
#include <GUIConstants.au3>

$AutoItDir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt\", "betaInstallDir")&"\Include\"

$Source = FileOpenDialog("Choose a script to Obfuscate:", @DesktopCommonDir, "Scripts (*.au3)", 3)
If @error Then Exit

$Results = StringTrimRight($Source, 4) & "_Obfuscate.au3"

GUICreate("Obfuscator", 350, 163)  ; will create a dialog box that when displayed is centered
GUICtrlCreateLabel("Enter in Variable, Function, and Include Names that you would not like to be imported/obfuscated. Seperate each entry with a comma.", 5, 5, 340, 50)
GUICtrlCreateLabel("Includes:", 5, 53)
GUICtrlCreateLabel("Functions:", 5, 83)
GUICtrlCreateLabel("Variables:", 5, 113)
$Include_Input = GUICtrlCreateInput("", 70, 50, 250)
$Function_Input = GUICtrlCreateInput("", 70, 80, 250)
$Variable_Input = GUICtrlCreateInput("$CmdLine,", 70, 110, 250)
$Go = GUICtrlCreateButton("Go", 165, 135, 50)
GUISetState (@SW_SHOW)       ; will display an empty dialog box

While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then 
		Exit
	ElseIf $msg = $Go Then
		$ProtectedIncludes = StringSplit(GUICtrlRead($Include_Input), ",")
		$ProtectedFuncs = StringSplit(GUICtrlRead($Function_Input), ",")
		$ProtectedVars = StringSplit(GUICtrlRead($Variable_Input), ",")
		GUIDelete()
		ExitLoop
	EndIf
Wend

SplashTextOn("", "Stripping Comments...", -1, 50, -1, -1, 33)

;Strip Comments First Time
_StripComments($Source, $Results)
$Source = $Results

Dim $File_Array
_FileReadToArray($Source, $File_Array)
$File_String = FileRead($Source)

;Grab Includes
SplashTextOn("", "Importing Includes...", -1, 50, -1, -1, 33)

$Include_List = _ArrayCreate(1)
For $i = 1 To (UBound($File_Array, 1) - 1)
	$Include_Search = StringInStr($File_Array[$i], "#include")
	If $Include_Search > 0 Then
		$Include_Lines = StringSplit($File_Array[$i], "")
		$Include_Name_Pos = $Include_Search + 9
		If $Include_Lines[$Include_Name_Pos] = "<" Then
			$Include_Name = ""
			Do
				If $Include_Lines[$Include_Name_Pos] <> ">" Then
					$Include_Name &= $Include_Lines[$Include_Name_Pos]
				EndIf
				If (UBound($Include_Lines, 1) + 1) >= $Include_Name_Pos Then $Include_Name_Pos += 1
			Until $Include_Lines[$Include_Name_Pos] = ">"
			$Include_Name = StringTrimLeft($Include_Name, 1)
			If _ArraySearch($Include_List, $Include_Name) = -1 And _ArraySearch($ProtectedIncludes, $Include_Name) = -1 Then _ArrayAdd($Include_List, $Include_Name)
		EndIf
	EndIf
Next

$Include_List[0] = UBound($Include_List, 1) - 1

For $i = 1 To (UBound($Include_List, 1) - 1)
	If FileExists($Include_List[$i]) Then
		$File_String = FileRead($Include_List[$i])&$File_String
	ElseIf FileExists($AutoItDir&$Include_List[$i]) Then
		$File_String = FileRead($AutoItDir&$Include_List[$i])&$File_String
	Else
		MsgBox(0, "Include Missing", "Unable to open Include: "&$Include_List[$i])
	EndIf
	$File_String = StringReplace($File_String, "#include <"&$Include_List[$i]&">", "")
Next

$File_String = StringReplace($File_String, "#include-once", "")

If FileExists($Results) Then FileDelete($Results)
FileWrite($Results, $File_String)

;Strip Comments Second Time
SplashTextOn("", "Stripping Comments Again...", -1, 50, -1, -1, 33)

_StripComments($Results, $Results)
$Source = $Results
_FileReadToArray($Source, $File_Array)
$File_String = FileRead($Source)

;Find Funcs
SplashTextOn("", "Renaming Functions...", -1, 50, -1, -1, 33)

$Func_CharAllowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_"
$Func_List = _ArrayCreate(1)

For $i = 1 To (UBound($File_Array, 1) - 1)
	$Func_Search = StringInStr($File_Array[$i], "Func ")
	If $Func_Search > 0 Then
		$Func_Line = StringSplit($File_Array[$i], "")
		If (UBound($Func_Line, 1) - 1) >= $Func_Search And $Func_Line[$Func_Search-1] <> "d" Then
			$Func_Name_Pos = $Func_Search + 6
				$Func_Name = ""
				While 1
					If StringInStr($Func_CharAllowed, $Func_Line[$Func_Name_Pos]) > 0 Then
						$Func_Name &= $Func_Line[$Func_Name_Pos]
					Else
						ExitLoop
					EndIf
					If (UBound($Func_Line, 1)- 1) > $Func_Name_Pos Then 
						$Func_Name_Pos += 1
					Else
						ExitLoop
					EndIf
				WEnd
				If _ArraySearch($Func_List, $Func_Name) = -1 And _ArraySearch($ProtectedFuncs, $Func_Name) = -1 Then _ArrayAdd($Func_List, $Func_Name&"(")
		EndIf
	EndIf
Next

$Func_List[0] = UBound($Func_List, 1) - 1

;Sort Functions Names
_ArraySort($Func_List, 1, 1)
;Rename Functions
$Func_Replace = $File_String
$Funcs_Created = ""

For $i = 1 To UBound($Func_List, 1) - 1
	While 1
		$Func_New = Chr(Random(65, 90, 1))&Chr(Random(65, 90, 1))&Chr(Random(65, 90, 1))&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(100, 999, 1)&Chr(Random(65, 90, 1))&Random(100, 999, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Chr(Random(65, 90, 1))&Random(0, 9999, 1)&"("
		If StringInStr($Funcs_Created, $Func_New) = 0 Then
			$Funcs_Created &= $Func_New&","
			ExitLoop
		EndIf
	WEnd
	$Func_Replace = StringReplace($Func_Replace, $Func_List[$i], $Func_New, 0)
Next
$File_String = $Func_Replace

;Find Variables
SplashTextOn("", "Renaming Variables...", -1, 50, -1, -1, 33)

$Variable_CharAllowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_"
$Variables = _ArrayCreate(1)

For $i = 1 To (UBound($File_Array, 1) - 1)
	$Instance = 0
	$Line = StringSplit($File_Array[$i], "")
	Do
		$VarStart = _ArraySearch($Line, Chr(36), $Instance)
		$Instance = $VarStart + 1
		If $VarStart > 0 Then
			$Var = "$"
			For $t = $VarStart + 1 To UBound($Line, 1) - 1
				If StringInStr($Variable_CharAllowed, $Line[$t]) > 0 And $Line[$t] <> Chr(36)  Then
					$Var = $Var&$Line[$t]
				Else
					ExitLoop
				EndIf
			Next
			If $Var <> Chr(36) And StringLen($Var) > 1 And _ArraySearch($Variables, $Var) = -1  And _ArraySearch($ProtectedVars, $Var) = -1 Then _ArrayAdd($Variables, $Var)
		EndIf
	Until $VarStart <= 0
Next

$Variables[0] = UBound($Variables, 1) - 1

;Sort Variable Names
_ArraySort($Variables, 1, 1)

;Replace Variables
$Variable_Replace = $File_String
$Variables_Created = ""

For $i = 1 To UBound($Variables, 1) - 1
	While 1
		$Variable_New = Chr(36)&Random(100, 999, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)&Random(0, 9, 1)
		If StringInStr($Variables_Created, $Variable_New) = 0 Then
			$Variables_Created &= $Variable_New&","
			ExitLoop
		EndIf
	WEnd
	$Variable_Replace = StringReplace($Variable_Replace, $Variables[$i], $Variable_New, 0)
Next


;Output Result File
SplashOff()

If FileExists($Results) Then FileDelete($Results)
FileWrite($Results, $Variable_Replace)

MsgBox(0, "Done!", "Obfuscated Script saved to "&$Results)

;##########################################################################################################
;FUNCTIONS
;##########################################################################################################

;Strip Comments
;Created by: Celeri
;Reference: http://www.autoitscript.com/forum/index.php?showtopic=17457
Func _StripComments($s_Source, $s_Destination)
    Local $as_Src[99999], $as_Dst[99999], $i_SrcLen, $s_Read, $h_Write
    Local $i_FindComment, $i_Counter = 1, $s_Semicolon = Chr(59), $i_CommentLock
    
    _FileReadToArray($s_Source, $as_Src)
    $i_SrcLen = $as_Src[0]
    
    For $i_Loop = 1 To $i_SrcLen
        $s_Read = StringStripWS($as_Src[$i_Loop], 3); Clean up the string!
        
    ; Getting rid of blanks and comment lines
        If $s_Read = "" Or StringLeft($s_Read, 1) = $s_Semicolon Then ContinueLoop
    ; Getting rid of region identificators
        If StringLeft($s_Read, 7) = "#Region" Or StringLeft($s_Read, 10) = "#EndRegion" Then ContinueLoop
    ; Getting rid of region delimiters
        If StringLeft($s_Read, 3) = "#cs" Or StringLeft($s_Read, 15) = "#comments-start" Then
            $i_CommentLock = 1
            ContinueLoop
        EndIf
        If StringLeft($s_Read, 3) = "#ce" Or StringLeft($s_Read, 13) = "#comments-end" Then
            $i_CommentLock = 0
            ContinueLoop
        EndIf
        If $i_CommentLock Then ContinueLoop
        
    ; Finding a comment at the end of a line
        $i_FindComment = StringInStr($s_Read, $s_Semicolon, 0, -1); Find the semicolon, from the right
        If Not $i_FindComment Then
            $as_Dst[$i_Counter] = $s_Read; Not found so save the line as-is
            $i_Counter = $i_Counter + 1; Increment line counter
        Else
            $s_Read = StringLeft($s_Read, $i_FindComment - 1); Save whatever's before the colon
            $as_Dst[$i_Counter] = StringStripWS($s_Read, 2); And clean up trailing spaces (again!)
            $i_Counter = $i_Counter + 1; Increment line counter
        EndIf
    Next
    
    ReDim $as_Dst[$i_Counter + 1]; Resize $as_Dst (not absolutely necessary but nice
    
    $h_Write = FileOpen($s_Destination, 2); Open file for output
    For $i_Loop = 1 To $i_Counter - 1; Loop through all the lines
        FileWrite($h_Write, $as_Dst[$i_Loop] & @CRLF); and write them
    Next
    FileClose($h_Write); Close up open file handle
EndFunc  ;==>_StripComments