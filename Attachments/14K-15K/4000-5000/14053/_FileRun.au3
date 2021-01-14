#include <GuiCombo.au3>
#NoTrayIcon
Dim $RunList = "http://www.autoitscript.com/autoit3/|notepad", $Current_hWnd = WinGetHandle(WinGetTitle(""))
$RegReadRunList = RegRead("HKEY_CURRENT_USER\Software\_FileRunApp", "")
If $RegReadRunList <> "" And StringInStr($RegReadRunList, "|") Then $RunList = $RegReadRunList

$RunList = _FileRun($RunList, "FileRun program App", "", $Current_hWnd)

If Not @error And $RunList <> $RegReadRunList Then RegWrite("HKEY_CURRENT_USER\Software\_FileRunApp", "", "REG_SZ", $RunList)

;===============================================================================
; Function Name:	_FileRun()
; Description: 		Run dialog that allow to execute file/application.
;
; Parameter(s): 	$RunList - The list with 'Run History' (separated with | ).
;					$Title [Optional] - The title of Run File Window.
;					$Label [Optional] - Label that will be shown at center of dialog,
;					If it set to -1, then will be shown a standard message.
;					$hWnd [Optional] - Window Handle, can be a title.
;
; Requirement(s):   AutoIt 3.2.2.0, #include <GuiCombo.au3>.
;
; Return Value(s):  If application/file was executed, then return the $RunList back with 'new executed' app/file.
;
;					If was pressed a 'Cancel' button, then set @error as 1, and return empty string ("").
;
; Author(s):        G.Sandler a.k.a CreatoR
;===============================================================================
Func _FileRun($RunList, $Title="", $Label=-1, $hWnd=0)
	If $Label = -1 Then $Label="Type the name of program, folder, document, or internet resource (Url), that you wish to run:"
	If Not IsHWnd($hWnd) Then $hWnd = WinGetHandle($hWnd)
	
	WinSetState($hWnd, "", @SW_DISABLE)

	Local $ComboCheck = False, $FOp, $LastRun="", $RunGui, $ComboBox, $RunButton
	Local $CancelButton, $BrowseButton, $LastRunArr = StringSplit($RunList, "|")
	Local $OldOptEvents = Opt("GuiOnEventMode", 0)
	Local $OldOptErrFatal = Opt("RunErrorsFatal", 0)
	Global $IsEnter, $IsCancel
	If IsArray($LastRunArr) Then $LastRun = $LastRunArr[$LastRunArr[0]]

	$RunGui = GUICreate($Title, 350, 210, -1, -1, 0x00080000, 0x00000400, $hWnd)
	GUICtrlCreateIcon("shell32.dll", 25, 20, 10, 32, 32)
	GUISetFont(10, 400, 4, "Georgia")
	GUICtrlCreateLabel($Label, 22, 45, 300, 60, 1, 4)
	GUICtrlSetColor(-1, 0x0000ff)
	
	GUISetFont(8.5, 400, 0)
	GUICtrlCreateLabel("Open:", 10, 113, 60)
	$ComboBox = GUICtrlCreateCombo("", 65, 110, 255, 18)
	GUICtrlSetData($ComboBox, $RunList, $LastRun)
	GUICtrlSetState($ComboBox, 256)

	$RunButton = GUICtrlCreateButton("Run", 40, 145, 80, 23)
	$CancelButton = GUICtrlCreateButton("Cancel", 140, 145, 80, 23)
	$BrowseButton = GUICtrlCreateButton("Browse...", 240, 145, 80, 23)
	
	If StringStripWS(GUICtrlRead($ComboBox), 8) = "" Then GuiCtrlSetState($RunButton, 128)

	GUISetState(@SW_SHOW, $RunGui)
	
	While 1
		$Msg = GUIGetMsg()
		If StringStripWS(GUICtrlRead($ComboBox), 8) = "" And Not $ComboCheck Then
			$ComboCheck = True
			GuiCtrlSetState($RunButton, 128)
		ElseIf StringStripWS(GUICtrlRead($ComboBox), 8) <> "" And $ComboCheck Then
			$ComboCheck = False
			GuiCtrlSetState($RunButton, 64)
		EndIf
		
		If WinActive($Title) Then
			HotKeySet("{enter}", "Enter")
		Else
			HotKeySet("{enter}")
		EndIf

		Select
			Case $Msg = -3 Or $Msg = $CancelButton
				WinSetState($hWnd, "", @SW_ENABLE)
				GUISetState(@SW_HIDE, $RunGui)
				WinActivate($hWnd)
				$IsCancel = True
				ExitLoop
			Case $Msg = $RunButton Or $IsEnter
				$IsEnter = 0
				$ComboRead = StringStripWS(ControlGetText($RunGui, "", $ComboBox), 3)
				If $ComboRead = "" Or @error = 1 Then $ComboRead = StringStripWS(GUICtrlRead($ComboBox), 3)
				WinSetState($hWnd, "", @SW_ENABLE)
				GUISetState(@SW_HIDE, $RunGui)
				WinActivate($hWnd)
				ShellExecute($ComboRead)
				If @error Then
					GUISetState(@SW_SHOW, $RunGui)
					WinSetState($hWnd, "", @SW_DISABLE)
					ContinueLoop
				EndIf
				If Not StringInStr($RunList, $ComboRead) Then
					$Delim = ""
					If $RunList <> "" Then $Delim = "|"
					$RunList &= $Delim & $ComboRead
				Else
					If StringInStr($RunList, "|") Then
						If StringInStr($RunList, "|" & $ComboRead & "|") Then
							$RunList = StringReplace($RunList, "|" & $ComboRead & "|", "|") & "|" & $ComboRead
						ElseIf StringLeft($RunList, StringLen($ComboRead)) = $ComboRead Then
							$RunList = StringReplace($RunList, $ComboRead & "|", "") & "|" & $ComboRead
						ElseIf StringRight($RunList, StringLen($ComboRead)) <> $ComboRead Then
							$RunList &= "|" & $ComboRead
						EndIf
					EndIf
				EndIf
				WinSetState($hWnd, "", @SW_ENABLE)
				ExitLoop
			Case $Msg = $BrowseButton
				While 1
					$FOp = _FileOpenDialog("Browse...", "", "Programs (*.exe) | All files (*.*)", 0, "", "", $RunGui)
					If @error Or $FOp = "" Then
						ExitLoop
					Else
						$FOp = StringStripWS($FOp, 3)
						ControlSetText($RunGui, "", $ComboBox, $FOp)
					EndIf
					ExitLoop
				Wend
		EndSelect
		_GUICtrlComboAutoComplete($ComboBox, $LastRun)
	Wend
	Opt("GuiOnEventMode", $OldOptEvents)
	Opt("RunErrorsFatal", $OldOptErrFatal)
	GUIDelete($RunGui)
	If $IsCancel Then Return SetError(1, 0, "")
	Return $RunList
EndFunc

;'Helper' func to allow execute by press Enter key.
Func Enter()
	$IsEnter = True
EndFunc

;Function to show FileOpenDialog() (API-function by amel27).
Func _FileOpenDialog ($sTitle, $sInitDir, $sFilter = 'All (*.*)', $iOpt = 0, $sDefaultFile = "", $sDefaultExt = "", $mainGUI = 0)
    Local $iFileLen = 65536 ; Max chars in returned string
    ; API flags prepare
    Local $iFlag = BitOR ( _
        BitShift (BitAND ($iOpt, 1),-12), BitShift (BitAND ($iOpt, 2),-10), BitShift (BitAND ($iOpt, 4),-7 ), _
        BitShift (BitAND ($iOpt, 8),-10), BitShift (BitAND ($iOpt, 4),-17) )
    ; Filter string to array convertion
    Local $asFLines = StringSplit ( $sFilter, '|'), $asFilter [$asFLines [0] *2+1]
    Local $i, $iStart, $iFinal, $suFilter = ''
    $asFilter [0] = $asFLines [0] *2
    For $i=1 To $asFLines [0]
        $iStart = StringInStr ($asFLines [$i], '(', 0, 1)
        $iFinal = StringInStr ($asFLines [$i], ')', 0,-1)
        $asFilter [$i*2-1] = StringStripWS (StringLeft ($asFLines [$i], $iStart-1), 3)
        $asFilter [$i*2] = StringStripWS (StringTrimRight (StringTrimLeft ($asFLines [$i], $iStart), StringLen ($asFLines [$i]) -$iFinal+1), 3)
        $suFilter = $suFilter & 'byte[' & StringLen ($asFilter [$i*2-1])+1 & '];byte[' & StringLen ($asFilter [$i*2])+1 & '];'
    Next
    ; Create API structures
    Local $uOFN = DllStructCreate ('dword;int;int;ptr;ptr;dword;dword;ptr;dword' & _
        ';ptr;int;ptr;ptr;dword;short;short;ptr;ptr;ptr;ptr;ptr;dword;dword' )
    Local $usTitle  = DllStructCreate ('byte[' & StringLen ($sTitle) +1 & ']')
    Local $usInitDir= DllStructCreate ('byte[' & StringLen ($sInitDir) +1 & ']')
    Local $usFilter = DllStructCreate ($suFilter & 'byte')
    Local $usFile   = DllStructCreate ('byte[' & $iFileLen & ']')
    Local $usExtn   = DllStructCreate ('byte[' & StringLen ($sDefaultExt) +1 & ']')
    For $i=1 To $asFilter [0]
        DllStructSetData ($usFilter, $i, $asFilter [$i])
    Next
    ; Set Data of API structures
    DllStructSetData ($usTitle, 1, $sTitle)
    DllStructSetData ($usInitDir, 1, $sInitDir)
    DllStructSetData ($usFile, 1, $sDefaultFile)
    DllStructSetData ($usExtn, 1, $sDefaultExt)
    DllStructSetData ($uOFN,  1, DllStructGetSize($uOFN))
    DllStructSetData ($uOFN,  2, $mainGUI)
    DllStructSetData ($uOFN,  4, DllStructGetPtr ($usFilter))
    DllStructSetData ($uOFN,  7, 1)
    DllStructSetData ($uOFN,  8, DllStructGetPtr ($usFile))
    DllStructSetData ($uOFN,  9, $iFileLen)
    DllStructSetData ($uOFN, 12, DllStructGetPtr ($usInitDir))
    DllStructSetData ($uOFN, 13, DllStructGetPtr ($usTitle))
    DllStructSetData ($uOFN, 14, $iFlag)
    DllStructSetData ($uOFN, 17, DllStructGetPtr ($usExtn))
    DllStructSetData ($uOFN, 23, BitShift (BitAND ($iOpt, 32), 5))
    ; Call API function
    $ret = DllCall ('comdlg32.dll', 'int', 'GetOpenFileName', _
            'ptr', DllStructGetPtr ($uOFN) )
    If $ret [0] Then
        If BitAND ($iOpt, 4) Then
            $i = 1
            While 1
                If DllStructGetData ($usFile, 1, $i) =0 Then
                    If DllStructGetData ($usFile, 1, $i+1) Then
                         DllStructSetData ($usFile, 1, 124, $i)
                    Else
                        ExitLoop
                    EndIf
                EndIf
                $i += 1
            Wend
        EndIf
        Return DllStructGetData ($usFile, 1)
    Else
        SetError (1)
        Return ""
    EndIf
EndFunc
