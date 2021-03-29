;region Script Settings

;<ScriptSettings xmlns="http://tempuri.org/ScriptSettings.xsd">

;  <ScriptPackager>

;    <process>autoit3.exe</process>

;    <arguments />

;    <extractdir>%TEMP%</extractdir>

;    <files />

;    <usedefaulticon>true</usedefaulticon>

;    <showinsystray>false</showinsystray>

;    <altcreds>false</altcreds>

;    <efs>true</efs>

;    <ntfs>true</ntfs>

;    <local>false</local>

;    <abortonfail>true</abortonfail>

;    <product />

;    <version>1.0.0.1</version>

;    <versionstring />

;    <comments />

;    <includeinterpreter>false</includeinterpreter>

;    <forcecomregistration>false</forcecomregistration>

;    <consolemode>false</consolemode>

;    <EnableChangelog>false</EnableChangelog>

;    <AutoBackup>false</AutoBackup>

;    <snapinforce>false</snapinforce>

;    <snapinshowprogress>false</snapinshowprogress>

;    <snapinautoadd>0</snapinautoadd>

;    <snapinpermanentpath />

;  </ScriptPackager>

;</ScriptSettings>

;endregion



#include <ComboConstants.au3>

#include <Excel.au3>

#include <GuiConstantsEx.au3>

#include <WinAPI.au3>

#include <WindowsConstants.au3>

#include <StaticConstants.au3>

#include <GDIPlus.au3>

#include <ButtonConstants.au3>

#include <EditConstants.au3>

#include <GUIConstantsEx.au3>

#Include <GuiListBox.au3>

#include <Array.au3>



Local $widthCell, $msg, $iOldOpt



Global $aArray[1]

Global $sFilePathOrigin = 'C:\pwc\'

Dim $Display1 = ""

Dim $sPathAUT = 'C:\pwc\Servers.xlsx'

Dim $sPathUSERS = 'C:\pwc\Biztalkserver.xlsx'

Dim $sPathENVS = 'C:\pwc\Sqlserver.xlsx'

Dim $oExcel1 = _ExcelBookOpen($sPathAUT, 0)

Dim $oExcel2 = _ExcelBookOpen($sPathUSERS, 0)

Dim $oExcel3 = _ExcelBookOpen($sPathENVS, 0)

Dim $aArrayAUT = _ExcelReadSheetToArray($oExcel1)

Dim $aArrayUSER = _ExcelReadSheetToArray($oExcel2)

Dim $aArrayENVS = _ExcelReadSheetToArray($oExcel3)

_ExcelBookClose($oExcel1, 0)



_ExcelBookClose($oExcel3, 0)

Dim $cellcount = 0

Dim $sCellValue = ''

Dim $sFilePath

Dim $vsheet

For $i = 1 to 256

	$sCellValue = _ExcelReadCell($oExcel2, $i, 1)

	If $sCellValue = '' Then

		;MsgBox(0x40, 'Cell count is ', $i)

		$cellcount = $i

		$i = 256

	EndIf

Next

$cellcount = $cellcount - 1



Dim $sStr = ''

For $i = 1 To $aArrayAUT[0][0]

    For $j = 1 To $aArrayAUT[0][1]

        If $aArrayAUT[$i][$j] <> "" Then $sStr &= $aArrayAUT[$i][$j] & '|'

    Next

Next

$sStr = StringTrimRight($sStr, 1)

Dim $sStr2 = ''

For $i = 1 to $cellcount

	$sStr2 &= _ExcelReadCell($oExcel2, $i, 1) & '|'

Next

_ExcelBookClose($oExcel2, 0)

; Open an Excel file - set to not visible and read-only

$oExcel = _ExcelBookOpen($sFilePath, 0, True)



; Move to correct sheet

_ExcelSheetActivate($oExcel, $vSheet)



; Read in cells

; Initialise an array

Global $aArray[1]

; Work down sheet until there is an empty cell

$iRow = 1

Do

    _ArrayAdd($aArray, _ExcelReadCell($oExcel, $iRow)); Default column is 1

    $aArray[0] += 1; Increase element count

    $iRow += 1 ; Move to next row

Until _ExcelReadCell($oExcel, $iRow) = ""; Looks for an empty cell to end



; Close Excel file

_ExcelBookClose($oExcel)

;Dim $sStr2 = ''

;For $i = 1 To $aArrayUSER[0][0]

;    For $j = 1 To $aArrayUSER[0][1]

;        If $aArrayUSER[$i][$j] <> "" Then $sStr2 &= $aArrayUSER[$i][$j] & '|'

;    Next

;Next

$sStr2 = StringTrimRight($sStr2, 1)

Dim $sStr3 = ''

For $i = 1 To $aArrayENVS[0][0]

    For $j = 1 To $aArrayENVS[0][1]

        If $aArrayENVS[$i][$j] <> "" Then $sStr3 &= $aArrayENVS[$i][$j] & '|'

    Next

Next

$sStr3 = StringTrimRight($sStr3, 1)



#Region ### START Koda GUI section ### Form=

$Form1 = GUICreate("Rundata Default Selection", 633, 447, 289, 213)

$Group1 = GUICtrlCreateGroup("User Profile Selection", 8, 0, 585, 105)

GUICtrlSetFont(-1, 10, 400, 0, "Verdana")

GUICtrlCreateGroup("1", -99, -99, 1, 1)

GUISetBkColor(0xA6CAF0)

;$Label1 = GUICtrlCreateLabel("   Please Select ", 16, 18, 216, 18)

;GUICtrlSetFont(-1, 9, 800, 0, "Verdana")

;GUICtrlSetColor(-1, 0x000080)







$Label1 = GUICtrlCreateLabel("RDC Computer", 32, 36, 216, 18)

GUICtrlSetFont(-1, 9, 800, 0, "Verdana")

GUICtrlSetColor(-1, 0x000080)

$AUT = GUICtrlCreateCombo("", 32, 56, 115, 25)

GUICtrlSetFont(-1, 8, 400, 0, "Verdana")

GUICtrlSetData($AUT, $sStr )



$Label2 = GUICtrlCreateLabel("Please Select Environment", 158, 24, 128, 36)

GUICtrlSetFont(-1, 9, 800, 0, "Verdana")

GUICtrlSetColor(-1, 0x000080)

$USER = GUICtrlCreateCombo("", 158, 56, 115, 25)

GUICtrlSetFont(-1, 8, 400, 0, "Verdana")

GUICtrlSetData($USER, $sStr2 )



$Label3 = GUICtrlCreateLabel("Please Select SQL Server", 295, 24, 128, 36)

GUICtrlSetFont(-1, 9, 800, 0, "Verdana")

GUICtrlSetColor(-1, 0x000080)

$ENVS = GUICtrlCreateCombo("", 295, 56, 160, 25)

GUICtrlSetFont(-1, 8, 400, 0, "Verdana")

GUICtrlSetData($ENVS, $sStr3 )

$Checkbox1 = GUICtrlCreateCheckbox("Online?", 475, 56, 97, 17)

GUICtrlSetFont(-1, 9, 800, 0, "Verdana")





$OK = GUICtrlCreateButton("OK", 32, 200, 75, 25, 0)

GUISetState()

#EndRegion ### END Koda GUI section ###



While 1

	$nMsg = GUIGetMsg()

	Switch $nMsg

		Case $GUI_EVENT_CLOSE

			Exit



		Case $Label1

		Case $AUT

			$Display = GUICtrlRead($AUT)

			;MsgBox(0x40, 'Combo Box AUT ', $Display)

		Case $USER

			$Display1 = GUICtrlRead($USER)

			;MsgBox(0x40, 'Combo Box User ', $Display1)

		Case $ENVS

			$Display2 = GUICtrlRead($ENVS)

			;MsgBox(0x40, 'Combo Box User ', $Display1)

			;MsgBox(0x40, 'Combo Box Items', GUICtrlRead($ENVS))

			;MsgBox(0x40, 'Combo Box ENVS ', $Display2)

			; Read in cells

			; Initialise an array

			;Global $aArray[1]



		Case $Checkbox1

			$Checkboxin1 = GUICtrlRead($Checkbox1)

			if $Checkboxin1 = 1 Then

				MsgBox(0x40, 'Check Box is on', $Checkboxin1 ,10)

				MsgBox(0x40, 'please make sure browsers are turned off', $Checkboxin1 ,10)

			endif

		Case $OK

			;MsgBox(0x40, 'Pressed Button - can I create a new gui?', "I create a new gui?")

			MsgBox(0x40, 'These are values retrieved', "RDC " & $Display & " ENV: " & $Display1 & " SQL " & $Display2)



			#Region ### START Koda GUI section ### Form=E:\Autoit-workarea\DET1.kxf

			;GUICtrlSetState(-1, $GUI_DISABLE + $GUI_HIDE )

			$Form2 = GUICreate("Run Defaults", 634, 448, 289, 213)

			GUISetBkColor(0xA6CAF0)

			$Group1 = GUICtrlCreateGroup("Global Default Details", 32, 8, 489, 57)

			GUICtrlSetFont(-1, 10, 400, 0, "Verdana")

			$Fullname = GUICtrlCreateLabel("Full Name", 48, 32, 60, 17)



			$Input1 = GUICtrlCreateInput($Display1, 112, 32, 121, 21)

			$oExcel2 = _ExcelBookOpen($sPathUSERS, 0)

			$aArrayUSER = _ExcelReadSheetToArray($oExcel2)

			Dim $sDetIdValue = ''

			For $i = 1 to 256

				;MsgBox(0x40, 'Read this DETID',_ExcelReadCell($oExcel2, $i, 1) &  _ExcelReadCell($oExcel2, $i, 2))

				;MsgBox(0x40, 'This is Display1 ', $Display1 )

				If _ExcelReadCell($oExcel2, $i, 1) = $Display1 Then

					;MsgBox(0x40, 'This is what was read ', _ExcelReadCell($oExcel2, $i, 1) )

					;MsgBox(0x40, 'This is Display1 ', $Display1 )

					$sDetIdValue = _ExcelReadCell($oExcel2, $i, 2)

				EndIf

				If _ExcelReadCell($oExcel2, $i, 1) = '' Then

					;MsgBox(0x40, 'Cell count is ', $i)

					$cellcount = $i

					$i = 256

				EndIf

			Next

			$cellcount = $cellcount - 1

			_ExcelBookClose($oExcel2, 0)



			$hForm1 = GUICtrlGetHandle($Form1)

			;GUIDelete();

			$Label1 = GUICtrlCreateLabel("DET User Id", 248, 32, 73, 17)

			$Input2 = GUICtrlCreateInput($sDetIdValue, 344, 32, 121, 21)

			GUICtrlCreateGroup("", -99, -99, 1, 1)

			$Group2 = GUICtrlCreateGroup("Course Offering Creation", 32, 80, 593, 113)

			GUICtrlSetFont(-1, 10, 400, 0, "Verdana")

			$Year = GUICtrlCreateLabel("Year", 40, 104, 30, 17)

			$Combo1 = GUICtrlCreateCombo("Year", 80, 104, 33, 25)

			$Semesterlabel = GUICtrlCreateLabel("Semester", 120, 104, 59, 17)

			$Semester = GUICtrlCreateCombo("Semester", 192, 104, 73, 25)

			$Label2 = GUICtrlCreateLabel("Course No", 272, 104, 64, 17)

			$Course = GUICtrlCreateCombo("Course No", 344, 104, 65, 25)

			$Label3 = GUICtrlCreateLabel("Location No", 40, 144, 70, 17)

			$Location = GUICtrlCreateCombo("Location No\", 120, 144, 89, 25)

			$Label4 = GUICtrlCreateLabel("Offer Type", 232, 144, 65, 17)

			$Combo2 = GUICtrlCreateCombo("Offer Type", 304, 144, 65, 25)

			$Label5 = GUICtrlCreateLabel("Offer Code", 392, 144, 67, 17)

			$Offer = GUICtrlCreateInput("Offer Code", 480, 144, 121, 21)

			$sFilePath = $sFilePathOrigin & $Display & '.xls'

			$oExcel = _ExcelBookOpen($sFilePath, 0, True)

			$vSheet = 'ScriptList'

			; Move to correct sheet

			_ExcelSheetActivate($oExcel, $vSheet)

			GUICtrlCreateGroup("", -99, -99, 1, 1)

			; Work down sheet until there is an empty cell

			$iRow = 1

			Do

				_ArrayAdd($aArray, _ExcelReadCell($oExcel, $iRow)); Default column is 1

				$aArray[0] += 1; Increase element count

				$iRow += 1 ; Move to next row

			Until _ExcelReadCell($oExcel, $iRow) = ""; Looks for an empty cell to end



			; Close Excel file

			_ExcelBookClose($oExcel)

			$hListBox = _GUICtrlListBox_Create ($Form1, "", 10, 230, 280, 180, $LBS_EXTENDEDSEL)

			_Update_ListBox()



            $aArray = ""

			$aSelected = _GUICtrlListBox_GetSelItems($hListBox)

			$sSelected = ""

			For $i = 1 To $aSelected[0]

                $sSelected &= $aArray[$aSelected[$i] + 1] & ", "

			Next

			GUICtrlCreateLabel($sSelected, 10, 230, 430, 20)



			$OK2 = GUICtrlCreateButton("OK", 32, 200, 75, 25, 0)

			GUISetState(@SW_SHOW)

			While 1

				$nMsg = GUIGetMsg()

			Switch $nMsg

				Case $GUI_EVENT_CLOSE

					Exit



				Case $OK2

					MsgBox(0x40, 'Pressed Ok2', "I can now process the input params?")

					Exit

	EndSwitch

WEnd

#EndRegion ### END Koda GUI section ###



	EndSwitch

WEnd

Func _Update_ListBox()



    _GUICtrlListBox_BeginUpdate($hListBox)

    _GUICtrlListBox_ResetContent($hListBox)

    _GUICtrlListBox_InitStorage($hListBox, 100, 4096)

;_GUICtrlListBox_AddString ($hListBox, "")

    For $i = 1 To $aArray[0]

        _GUICtrlListBox_AddString ($hListBox, $aArray[$i])

    Next

    _GUICtrlListBox_EndUpdate($hListBox)



EndFunc