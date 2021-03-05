#include <Array.au3>
#include <Constants.au3>
#include <File.au3>
#include <Date.au3>
#include <OutlookEX.au3>
#include <OutlookEXConstants.au3>
#include <GUIConstants.au3>
#Include <HotKey_20b.au3>
#include <String.au3>



Global $AErrors[4], $FileList[2], $TIFIName[2]
Local $i = 1
Local $Security = 10

For $i = 1 To 3
	$AErrors[$i] = "Line " & $i & ", Column: " & $Security & ", Security =.U " & " Remove USD from column 251 in " & "$TIFIName[0]"
Next

$Subject = "EODCheckerCTL - Found error in MyFile"
SendErrEmail("MyFIle",$Subject)

Exit

;----------------------------------------------------------------------------------------------------------------------
Func SendErrEmail($FileName,$Subject)

	Local $tenBlanks = "          "
	Local $NewLine = @CR & @LF  & @CRLF
	$oOutlook = _OL_Open()
	$sCurrentUser = $oOutlook.GetNameSpace("MAPI" ).CurrentUser.Name
	Local $TextBody = "Error(s) for  file: " & $FileName & $tenBlanks & @CR & @LF

	For $i = 1 To 3
		$TextBody = $Textbody & $NewLine & $AErrors[$i]
	Next
	;
	$send = _OL_Wrapper_SendMail($oOutlook, $sCurrentUser, "", "",$Subject, $TextBody , "", $olFormatHTML, $olImportanceNormal)
	If @error <> 0 Then MsgBox(16, "Outlook Test", "Error sending mail: @error = " & @error)
	_OL_Close($oOutlook)

	Return
EndFunc

;~---------------------------------------------------
