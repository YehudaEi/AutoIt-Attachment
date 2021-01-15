; AutoIt Version: 3.2.4.1
; ===============================================================================================================================
; Description ...: Extract email addresses from messages stored in Outlook Express
; Author ........: Steve Bateman (MisterBates)
; Parameters ....: 
; Return values .: 
; Remarks/Notes .: 
; ===============================================================================================================================
#include "OE_UDF.au3"
#include <array.au3>
#include <A3LMenu.au3>
; ===============================================================================================================================
; Global Variables
; ===============================================================================================================================
HotKeySet("^!e", "EndProgram")
Const $bOutputDetail = False ; True to create an output file containing details of each message
Const $bOneRecordPerToCC = True ; True to output one record for each To/CC address; False to output one record per message
Global $iFolderNum = 0, $iNumMessages = 0
; ===============================================================================================================================
; Main
; ===============================================================================================================================

if $bOutputDetail Then
	; Open report file
	$sOutFileName = StringLeft(@ScriptFullPath, StringLen(@ScriptFullPath) - 4) & ".CSV"
	$hOutFile = FileOpen($sOutFileName, 2)
	if $hOutFile = -1 Then
		MsgBox(16, @ScriptName, "Could not open output file:" & @CRLF & $sOutFileName, 15)
		Exit 1
	EndIf
EndIf
; Get handle to / start OE and make sure no child windows open
$hOE = _OE_Start()
if not _OE_CloseChildren($hOE) Then
	Exit 1
EndIf
if $bOutputDetail Then
	; Write the field names
	Dim $asInfo[11] = [9, "Folder Name", "From", "To", "CC", "Date", "Sent", "Received", "Subject", "Message Location", "Folder Filename"]
	FileWriteLine($hOutFile, _ArrayToString($asInfo, @TAB, 1, $asInfo[0]))
EndIf
; Process the folders sequentially (faster)
$sFolder = _OE_FolderMoveFirst($hOE)
While $sFolder <> ""
	$iFolderNum += 1
	$iMessageCount = _OE_FolderNumMessages($hOE)
	$iNumMessages += $iMessageCount
	ConsoleWrite($sFolder)
  if $iMessageCount >= 0 Then ConsoleWrite(" - " & _OE_FolderNumMessages($hOE))
  ConsoleWrite(@crlf)
	if $bOutputDetail Then
		$sFolderProperties = _OE_FolderGetProperties($hOE)
		if $iMessageCount > 0 Then
			$bAnother = _OE_MessageMoveFirst($hOE, "", False)
			While $bAnother
				$sMessageProperties = _OE_MessageGetProperties($hOE, False) ; ignore body text
				if @error > 0 Then
					; had a problem, try again
					_OE_CloseChildren($hOE)
					Sleep(3000)
					$sMessageProperties = _OE_MessageGetProperties($hOE, False) ; ignore body text
				EndIf
				if $sMessageProperties <> "" Then
					if not $bOneRecordPerToCC Then ; output one record per message
						Dim $asInfo[1] = [0]
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sFolderProperties, "Name"), True)
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "From"), True)
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "To"), True)
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Cc"), True)
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Date"), True)
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Sent Date"), True)
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Received Date"), True)
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Subject"), True)
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Location"), True)
						_ArrayAddItem($asInfo, _OE_GetPropertyValue($sFolderProperties, "This folder is stored in"), True)
						FileWriteLine($hOutFile, _ArrayToString($asInfo, @TAB, 1, $asInfo[0]))
					Else ; one record for each To/CC
						$sAddresses = StringReplace(_OE_GetPropertyValue($sMessageProperties, "To"), ", ", ",")
						if $sAddresses <> "" Then
							$asAddresses = StringSplit($sAddresses, ",")
							for $iI = 1 to $asAddresses[0]
								Dim $asInfo[1] = [0]
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sFolderProperties, "Name"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "From"), True)
								_ArrayAddItem($asInfo, $asAddresses[$iI], True)
								_ArrayAddItem($asInfo, "", True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Date"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Sent Date"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Received Date"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Subject"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Location"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sFolderProperties, "This folder is stored in"), True)
								FileWriteLine($hOutFile, _ArrayToString($asInfo, @TAB, 1, $asInfo[0]))
							Next
						EndIf
						$sAddresses = StringReplace(_OE_GetPropertyValue($sMessageProperties, "Cc"), ", ", ",")
						if $sAddresses <> "" Then
							$asAddresses = StringSplit($sAddresses, ",")
							for $iI = 1 to $asAddresses[0]
								Dim $asInfo[1] = [0]
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sFolderProperties, "Name"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "From"), True)
								_ArrayAddItem($asInfo, "", True)
								_ArrayAddItem($asInfo, $asAddresses[$iI], True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Date"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Sent Date"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Received Date"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Subject"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sMessageProperties, "Location"), True)
								_ArrayAddItem($asInfo, _OE_GetPropertyValue($sFolderProperties, "This folder is stored in"), True)
								FileWriteLine($hOutFile, _ArrayToString($asInfo, @TAB, 1, $asInfo[0]))
							Next
						EndIf
					EndIf
				EndIf
				$bAnother = _OE_MessageMoveNext($hOE, False)
			WEnd
		EndIf
	EndIf
	$sFolder = _OE_FolderMoveNext($hOE, True)
WEnd
; Finish up - close OE and report file
ConsoleWrite($iNumMessages & " messages in " & $iFolderNum & " folders" & @crlf)
_OE_CloseChildren($hOE)
_OE_Finish($hOE)
if $bOutputDetail Then FileClose($hOutFile)

Func EndProgram()
	Exit
EndFunc