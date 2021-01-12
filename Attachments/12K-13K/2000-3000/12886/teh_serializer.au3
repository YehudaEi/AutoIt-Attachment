; ----------------------------------------------------------------------------
; Author:         Noobster24 (andreas_vliegen [AT] hotmail [DOT] com)
;
; Script Function:
;	Search for the licenses registrations on this computer for:
;   Nero - Windows - Office - Alcohol 120% - Call of Duty 1 & 2 - mIRC - Partition Magic - OmniPage - Sony Vegas/Video Capture - TuneUP Utilities
; ----------------------------------------------------------------------------

; ------------------- Included Files ----------------------------------
#NoTrayIcon
#include <GuiConstants.au3>
#include <File.au3>
#Include <GuiListView.au3>
#include <Array.au3>
#include <String.au3>
#include <Date.au3>

; ------------------- Options ----------------------------------
Opt('GUICloseOnESC', 1)

; ------------------- Variables and globals ----------------------------------
Global $size1 = 180
Global $size2 = 170
Global $size3 = 245
Global $filedir2 = @ScriptDir & '\Files\'
Global $inifile = @ScriptDir & '\serializer_software.ini'
Global Const $WM_NOTIFY = 0x004E
Global Const $DebugIt = 1

; ------------------- ListView Events ----------------------------------
Global Const $NM_FIRST = 0
Global Const $NM_LAST = (-99)
Global Const $NM_OUTOFMEMORY = ($NM_FIRST - 1)
Global Const $NM_CLICK = ($NM_FIRST - 2)
Global Const $NM_DBLCLK = ($NM_FIRST - 3)
GUIRegisterMsg($WM_NOTIFY, 'WM_Notify_Events')

; ------------------- Check if folders & files excist----------------------------------
DirGetSize($filedir2)
If @error = 1 Then
	DirCreate($filedir2)
EndIf

; ------------------- GUI ----------------------------------
$win_1 = GUICreate('Teh Serializer', 720, 280)
GUISetIcon ('shell32.dll', 47)
$refresh = GuiCtrlCreateButton('Get Licenses',615,35,100,25)
GuiCtrlSetFont(-1,8,800,0,'Verdana')
$excel = GuiCtrlCreateButton('Export 2 Excel',615,71,100,25)
GuiCtrlSetFont(-1,8,800,0,'Verdana')
$2txt = GuiCtrlCreateButton('Export 2 TXT',615,107,100,25)
GuiCtrlSetFont(-1,8,800,0,'Verdana')
$Excelo = ObjCreate('Excel.Application')
If @error = 1 Then GUICtrlSetState($excel, $GUI_DISABLE)

;--------------------Listview---------------------------------------
GuiSetFont(8,100,0,'Verdana')
GuiCtrlCreateLabel('Licenses:',12,12,60,20)
GuiCtrlSetFont(-1,9,800,0,'Verdana')
$listview = GUICtrlCreateListView ('Product Name|User/ID|Serial/Code/License/Key',10,35,600,237,$LVS_SORTASCENDING,BitOR($LVS_EX_REGIONAL, $LVS_EX_FULLROWSELECT))
GUICtrlSetState(-1,$GUI_DROPACCEPTED)
GUICtrlSetBkColor($listview,0xf4f2ea)
_GUICtrlListViewSetColumnWidth($listview,0,$size1)
_GUICtrlListViewSetColumnWidth($listview,1,$size2)
_GUICtrlListViewSetColumnWidth($listview,2,$size3)
Dim $B_DESCENDING = _GUICtrlListViewGetSubItemsCount($listview)

; ------------------- Dim etc.----------------------------------
Dim $Bin
Dim $key4RegisteredOwner = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
GuiSetState()
TraySetState(2)
	
While 1
$msg = GuiGetMsg()
$msg1 = TrayGetMsg()

Switch $msg
		Case $GUI_EVENT_CLOSE
			ExitLoop				
		Case $listview			
			_GUICtrlListViewSort($listview, $B_DESCENDING, GUICtrlGetState($listview))			
		Case $refresh
			Refresh()
		Case $excel
			_OutExcel()
		Case $2txt
			ListView_DoubleClick()
EndSwitch
		
WEnd
GUIDelete($win_1)
Exit

; ------------------- Functions ----------------------------------
Func Refresh()	
	$begin = TimerInit()	
	_GUICtrlListViewDeleteAllItems ($listview)
	
	$Bin = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion','DigitalProductID') ;(Thanks to Thorsten Meger)
	$objWMIService = ObjGet('winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2') ;(Thanks to Thorsten Meger)
	$colSettings = $objWMIService.ExecQuery ('Select * from Win32_OperatingSystem')		;(Thanks to Thorsten Meger)
	For $objOperatingSystem In $colSettings
	Next		
	GuiCtrlCreateListViewItem('M$ Windows ' & StringMid($objOperatingSystem.Caption, 19) & ' Product Key' & '|' & StringMid($objOperatingSystem.SerialNumber, 1) & '|' & DecodeProductKey($Bin),$listview)
	GuiCtrlCreateListViewItem('M$ Internet Explorer' & '|' & RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration','ProductID') & '|' & DecodeProductKey(RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Registration','DigitalProductID')),$listview)
	$iniread = IniRead($inifile,'Program','Total',10)	
	Dim $regread[$iniread+1], $regname[$iniread+1], $officekey[$iniread+1], $regread2[$iniread+1], $inireadname[$iniread+1], $inireadread[$iniread+1], $inireadreadkey[$iniread+1], $inireadreadkey2[$iniread+1], $inireadenumkey[$iniread+1], $inireaduser[$iniread+1], $inireaduser2[$iniread+1], $inireaduser3[$iniread+1], $inireaduser4[$iniread+1]
	For $i = 1 TO $iniread
	$inireadname[$i] = IniRead($inifile,$i,'Name',@error)
	$inireadread[$i] = IniRead($inifile,$i,'Read',@error)
	$inireadreadkey[$i] = IniRead($inifile,$i,'Readkey',@error)
	$inireaduser[$i] = IniRead($inifile,$i,'Userkey',@error)
	$regread[$i] = RegRead($inireadread[$i],$inireadreadkey[$i])
	$regread2[$i] = RegRead($inireadread[$i],$inireaduser[$i])
	If $inireadreadkey[$i] = '(|1|)' Then
		$inireadreadkey2[$i] = IniRead($inifile,$i,'Readkey2',@error)
		$inireadenumkey[$i] = RegEnumKey($inireadread[$i], 1)
		$officekey[$i] = RegRead($inireadread[$i] & '\' & $inireadenumkey[$i], 'DigitalProductID')
		$regname[$i] = RegRead($inireadread[$i] & '\' & $inireadenumkey[$i], 'ProductID')
		If Not $officekey[$i] = '' Then	GuiCtrlCreateListViewItem($inireadname[$i] & '|' & $regname[$i] & '|' & DecodeProductKey($officekey[$i]),$listview)
	ElseIf $inireaduser[$i] = '(|2|)' Then
		$inireaduser2[$i] = IniRead($inifile,$i,'UserKey2',@error)
		$inireaduser3[$i] = IniRead($inifile,$i,'UserKey3',@error)
		$inireaduser4[$i] = RegRead($inireaduser2[$i],$inireaduser3[$i])
		If Not $inireaduser4[$i] = '' Then GUICtrlCreateListViewItem($inireadname[$i] & '|' & $inireaduser4[$i] & '|' & $regread[$i],$listview)
	Else
		If Not $regread[$i] = '' Then GUICtrlCreateListViewItem($inireadname[$i] & '|' & $regread2[$i] & '|' & $regread[$i],$listview)
	EndIf
Next	
	$dif = TimerDiff($begin)/1000
	$difround = Round($dif, 3) ;$difround is the amount of time in sec that teh Serializer needed to gather all your licenses..:) you can use this if you want to...	
EndFunc ;==>Refresh

Func DecodeProductKey($BinaryDPID)
   Local $bKey[15]
   Local $sKey[29]
   Local $Digits[24]
   Local $Value = 0
   Local $hi = 0
   local $n = 0
   Local $i = 0
   Local $dlen = 29
   Local $slen = 15
   Local $Result

   $Digits = StringSplit('BCDFGHJKMPQRTVWXY2346789','')

   $binaryDPID = stringmid($binaryDPID,105,30)

   For $i = 1 to 29 step 2
       $bKey[int($i / 2)] = dec(stringmid($binaryDPID,$i,2))
   next

   For $i = $dlen -1 To 0 Step -1
       If Mod(($i + 1), 6) = 0 Then
           $sKey[$i] = '-'
       Else
           $hi = 0
           For $n = $slen -1 To 0 Step -1
               $Value = Bitor(bitshift($hi ,- 8) , $bKey[$n])
               $bKey[$n] = int($Value / 24)
               $hi = mod($Value , 24)
           Next
           $sKey[$i] = $Digits[$hi +1]
       EndIf

   Next
   For $i = 0 To 28
       $Result = $Result & $sKey[$i]
   Next

   Return $Result
EndFunc ;==>DecodeProductKey (Thanks to forum)

Func QuickOutput($Filename, $Output, $Mode)
    Local $File = FileOpen($Filename, $Mode)
    FileWriteLine($File, $Output)
    FileClose($File)
EndFunc ;==>QuickOutput

Func ListView_Click()
    ;If $DebugIt Then    ConsoleWrite (_DebugHeader ('$NM_CLICK'))
EndFunc  ;==>ListView_Click

Func ListView_DoubleClick()
			$ret = _GUICtrlListViewGetItemText ($listview)
            If $ret = '' Then
				Msgbox(0,'Nothing selected','You must select a serial to copy it into Notepad.')
			Else
				$namep = _GUICtrlListViewGetItemText ($listview, -1, 0)
				$idp = _GUICtrlListViewGetItemText ($listview, -1, 1)
				$serialp = _GUICtrlListViewGetItemText ($listview, -1, 2)
                $file2writetxt = @ScriptDir & '\Files\' & $namep & '.txt'
				$text2txt = 'Created by teh Serializer' & @CRLF & 'Date: ' & _Now() & @CRLF & '==========================' & @CRLF & 'Product Name: ' & $namep & @CRLF & 'User/ID: ' & $idp & @CRLF & 'Serial: ' & $serialp
				QuickOutput($file2writetxt, $text2txt, 2)
				Run('notepad.exe ' & $file2writetxt)                
            EndIf
EndFunc  ;==>ListView_DoubleClick

; WM_NOTIFY event handler
Func WM_Notify_Events($hWndGUI, $MsgID, $wParam, $lParam)
    #forceref $hWndGUI, $MsgID, $wParam
    Local $tagNMHDR, $event, $hwndFrom, $code
    $tagNMHDR = DllStructCreate('int;int;int', $lParam);NMHDR (hwndFrom, idFrom, code)
    If @error Then Return
    $event = DllStructGetData($tagNMHDR, 3)
    Select    
	Case $wParam = $ListView
        Select
            Case $event = $NM_CLICK
                ListView_Click ()
            Case $event = $NM_DBLCLK
                ListView_DoubleClick ()
            EndSelect	
    EndSelect
    $tagNMHDR = 0
    $event = 0
    $lParam = 0
EndFunc  ;==>WM_Notify_Events

Func _OutExcel()
	ProgressOn('Progress...', 'Wait for teh Serializer to export it to Excel', '0 percent')
	$oExcel = ObjCreate('Excel.Application')
	WITH $oExcel 
    .Visible = 1                                        
    .WorkBooks.Add                                      
	$a_Itema = _GUICtrlListViewGetItemCount($listview)
	$nowstatus = 100/$a_Itema
	.ActiveWorkBook.ActiveSheet.Cells(1,1).Value='Product Name'
	.ActiveWorkBook.ActiveSheet.Cells(1,2).Value='Name/ID'
	.ActiveWorkBook.ActiveSheet.Cells(1,3).Value='Serial/Key/License/Code'
	For $i = 2 To $a_Itema+1		
		$ret2 = _GUICtrlListViewGetItemText ($listview,$i-2,0)
		$ret3 = _GUICtrlListViewGetItemText ($listview,$i-2,1)
		$ret4 = _GUICtrlListViewGetItemText ($listview,$i-2,2)		
		.ActiveWorkBook.ActiveSheet.Cells($i,1).Value=$ret2
		.ActiveWorkBook.ActiveSheet.Cells($i,2).Value=$ret3
		.ActiveWorkBook.ActiveSheet.Cells($i,3).Value=$ret4
		$nowstatus2 = Round($nowstatus*($i-1),2)		
		ProgressSet($nowstatus2, $nowstatus2 & ' percent')
	Next
	ProgressOff()
	.Columns('A:AY').EntireColumn.AutoFit	
    ENDWITH 
EndFunc ;==>_OutExcel()