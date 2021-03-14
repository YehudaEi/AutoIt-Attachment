#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <File.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=A:\AutoIt3\Koda\Forms\OmgaSearch.kxf
$OmgaSearch = GUICreate("Omga Search", 213, 211, 363, 219)
$Directory_Label = GUICtrlCreateLabel("Files Directory:", 32, 8, 70, 17)
$Search_For_Label = GUICtrlCreateLabel("Search For:", 8, 63, 56, 17)
$Directory_Input = GUICtrlCreateInput("", 4, 24, 121, 21)
$Search_For_Input = GUICtrlCreateInput("", 76, 60, 121, 21)
$Browse_Button = GUICtrlCreateButton("Browse..", 128, 21, 75, 25)
$Start_Button = GUICtrlCreateButton("Start!", 76, 172, 75, 25)
$Save_Log_Location = GUICtrlCreateLabel("Save Log In:", 32, 86, 65, 17)
$Save_Log_Input = GUICtrlCreateInput("", 4, 102, 121, 21)
$Browse_Button1 = GUICtrlCreateButton("Browse..", 128, 99, 75, 25)
$Sub_Dir_Label = GUICtrlCreateLabel("Search In Sub-Directories?", 8, 141, 131, 17)
$Combo_Box = GUICtrlCreateCombo("No", 144, 138, 57, 25)
GUICtrlSetData(-1, "Yes")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
$nMsg = GUIGetMsg()
Switch $nMsg
  Case $GUI_EVENT_CLOSE
   Exit
 
 Case $Browse_Button
   $Browse_Directory = FileSelectFolder("Open", "My Computer")
   GUICtrlSetData($Directory_Input,$Browse_Directory)
   $Browse_Directory_Text = GUICtrlRead($Directory_Input, 1) & "\"
   $Files_FileList1 = _FileListToArray($Browse_Directory_Text)
   GUICtrlRead($Browse_Directory_Text, 1)
 
 Case $Browse_Button1
	$Browse_Directory = FileSelectFolder("Open", "My Computer")
   GUICtrlSetData($Save_Log_Input,$Browse_Directory)
   $Save_Log_Text = GUICtrlRead($Save_Log_Input, 1) & "\"
   $Files_FileList2 = _FileListToArray($Save_Log_Text)
   GUICtrlRead($Save_Log_Text, 1)
	
Case $Start_Button
   $Browse_Directory_Text = GUICtrlRead($Directory_Input, 1)
   If $Browse_Directory_Text = "" Then
		MsgBox(0, "Error!", "Moron.. You have to select a directory first!")
	EndIf
  
   $Search_For_Text = GUICtrlRead($Search_For_Input, 1)
   If $Search_For_Text = "" Then
		MsgBox(0, "Error!", "What in the world am I going to search for?!")
	EndIf
	
	$Combo_Box_Input = GUICtrlRead($Combo_Box, 1)
	
	If $Combo_Box_Input = "Yes"	Then
		$aArray = _FindInFile("/C:" & GUICtrlRead($Search_For_Input), GUICtrlRead($Directory_Input), "*.txt;*.log", 1, 1)
			If Not @error Then
				For $i = 1 To $aArray[0]
					GUICtrlRead($Save_Log_Text, 1)
					_FileWriteLog($Save_Log_Text & "\Log.txt" ,$aArray[$i])
				Next
			EndIf
	EndIf

	If $Combo_Box_Input = "No" Then
		$aArray = _FindInFile("/C:" & GUICtrlRead($Search_For_Input), GUICtrlRead($Directory_Input), "*.txt;*.log", 0, 1)
			If Not @error Then
				For $i = 1 To $aArray[0]
					GUICtrlRead($Save_Log_Text, 1)
					_FileWriteLog($Save_Log_Text & "\Log.txt" ,$aArray[$i])
				Next
			EndIf
	EndIf

		   
		MsgBox(0, "Thank You!", "Operation Complete!")
  EndSwitch
WEnd

; #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
; #FUNCTION# =========================================================================================================
; Name...........: _FindInFile()
; Description ...: Search for a string within files located in a specific directory.
; Syntax ........: _FindInFile($sSearch, $sFilePath, [$sMask = "*", [$iRecursive = 1, [$iCaseSensitive = 0, [$iDetail = 0]]]])
; Parameters ....: $sSearch - The keyword to search for.
; Parameters ....: $sFilePath - The folder location of where to search.
;                 $sMask - [optional] A list of filetype extensions separated with ';' e.g. "*.au3;*.txt". [Default = All files.]
;                 Search for 'wildcards' in the help file for more details.
;                 $iRecursive - [optional] Search within subfolders. [Default = 1 - recursive / 0 - non-recursive.]
;                 $iCaseSensitive - [optional] Search is case sensitive. [Default = 0 - not case sensitive / 1 - case sensitive.]
;                 $iDetail - [optional] Show filenames only. [Default = 0 - full path / 1 - filenames only.]
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Returns a one-dimensional and is made up as follows:
;                           $aArray[0] = Number of rows
;                           $aArray[1] = 1st file
;                           $aArray[n] = nth file
;                 Failure - Returns an empty array and sets @error to 1.
; Author ........: guinness
; Example........; Yes
; Remarks........; For more details: http://ss64.com/nt/findstr.html
;=====================================================================================================================
Func _FindInFile($sSearch, $sFilePath, $sMask = "*", $iRecursive = 1, $iCaseSensitive = 0, $iDetail = 0)
    Local $aError[1] = [0], $aMask, $aReturn, $iError = 0, $iPID, $sCaseSensitive = "/i", $sDetail = "/m", $sRecursive = "", $sStdoutRead = ""

    If $iCaseSensitive Then
        $sCaseSensitive = ""
    EndIf
    If $iDetail Then
        $sDetail = "/n"
    EndIf
    If $iRecursive Then
        $sRecursive = "/s"
    EndIf

    $sFilePath = StringRegExpReplace($sFilePath, "[\\/]+\z", "") & "\"
    $aMask = StringSplit($sMask, ";")

    For $A = 1 To $aMask[0]
        $iPID = Run(@ComSpec & ' /c ' & 'findstr ' & $sCaseSensitive & ' ' & $sDetail & ' ' & $sRecursive & ' "' & $sSearch & '" "' & $sFilePath & $aMask[$A] & '"', @SystemDir, @SW_HIDE, 6)
        While 1
            $sStdoutRead &= StdoutRead($iPID)
            If @error Then
                ExitLoop
            EndIf
        WEnd
    Next
    $aReturn = StringRegExp(@CRLF & StringStripCR($sStdoutRead), '[^\n]+', 3)
    If @error Then
        Return SetError(1, 0, $aError)
    EndIf
    $aReturn[0] = UBound($aReturn) - 1
    If $aReturn[0] = 0 Then
        $iError = 1
    EndIf
    Return SetError($iError, 0, $aReturn)
EndFunc