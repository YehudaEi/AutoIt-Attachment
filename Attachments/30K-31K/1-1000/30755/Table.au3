;=================================================================
; Botage Poker Bot
; Copyright © 2009 Brett O'Donnell
;=================================================================
;
; This file is part of Botage Poker Bot.
;
; Botage Poker Bot is free software: you can redistribute it
; and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation,
; either version 3 of the License, or (at your option) any
; later version.
;
; Botage Poker Bot is distributed in the hope that it will
; be useful, but WITHOUT ANY WARRANTY; without even the
; implied warranty of MERCHANTABILITY or FITNESS FOR A
; PARTICULAR PURPOSE.  See the GNU General Public License
; for more details.
;
; You should have received a copy of the GNU General Public
; License along with Botage Poker Bot.  If not, see
; <http://www.gnu.org/licenses/>.
;
; This program is distributed under the terms of the GNU
; General Public License.
;
;=================================================================

;=================================================================
; Table Functions
;=================================================================
#include-once
#Include "Lobby.au3"
#Include "Blind.au3"
#Include "Seat.au3"
#Include "Debug.au3"

Global $iSitStuck = 0
Global $aTop[2]
Global $sTableChecksums = StringSplit(FileRead('..\data\table.txt'),',')
Global $iBlind = 0
Global $tableBuyin=20
Global $bPaused=False


Global $sTableChecksums = StringSplit(FileRead(@ScriptDir & '\data\table.txt'), ',')
Global $TableLastPos
Global Const $cTablePixelColor = 0x364C63

Func _Table()
    local $BlankArray[2]
    $Windowhandle = wingethandle($browserTitle)
    ;first, check if the table has moved since we last checked
    If _TableVerifyChecksum ($TableLastPos) Then
        Return $TableLastPos
    EndIf

    ;default - search screen
    $SearchLeft =0
    $searchRight = @DesktopWidth
    $searchTop = 0
    $searchBottom = @DesktopHeight

    If IsHWnd($WindowHandle) Then
        ;search only in the window's area
        $aWinPos = WinGetPos($WindowHandle)
        If IsArray($aWinPos) Then
            $SearchLeft =$aWinPos[0]
            $searchRight =$aWinPos[0]+$aWinPos[2]
            $searchTop = $aWinPos[1]
            $searchBottom =$aWinPos[1]+$aWinPos[3]
        EndIf
    EndIf

    ;if the window is moved so only part of it is showing...
    If $searchTop < 1 Then $searchTop = 1
    If $SearchLeft < 1 Then $SearchLeft = 1
    If $searchRight > @DesktopWidth Then $searchRight = @DesktopWidth
    If $searchBottom > @DesktopHeight Then $searchBottom = @DesktopHeight

    While $searchTop < $searchBottom
        $aPos = PixelSearch($SearchLeft,$searchTop,$searchRight,$searchBottom, $cTablePixelColor)

        If @error Then
            Return $BlankArray
        Else
            If _TableVerifyChecksum($aPos) Then
                $TableLastPos = $aPos
                Return $TableLastPos
            EndIf
        EndIf
        $searchTop = $aPos[1]+1 ;continue on from the next row
    WEnd

    Return $BlankArray
EndFunc

Func _TableVerifyChecksum ($aPos)
    If Not IsArray ($aPos) Then Return False
    $x = $aPos[0]
    $y = $aPos[1]
    $iChecksum = PixelChecksum($x-1,$y-1,$x,$y)
    For $i = 1 to $sTableChecksums[0]
        If $iChecksum==Int($sTableChecksums[$i]) Then
            Return True
        EndIf
    Next
    Return False
EndFunc

Func _TableStand()
	MouseClick('left',$aTop[0]+710,$aTop[1]+35,1,0) ;changed from 10 to 0 so he stands instantly
	Sleep(1000)
EndFunc

Func _TableStand2()
	$aResult = _FindBMP("SCREEN",$sDataPath & "\bmp\stand_up.bmp")
	If $aResult[1]==True Then
		_Log('_Stand Up')
		MouseClick('left',$aResult[3],$aResult[4],1,0)
		Sleep(1000)
		Return True
	EndIf
EndFunc

Func _TableStanding()
	Local $iChecksum = PixelChecksum($aTop[0]+710,$aTop[1]+35,$aTop[0]+715,$aTop[1]+40)
	If $iChecksum == 3486926225 Or $iChecksum == 3416933765 Then
		Return True
	EndIf
	Return False
EndFunc

Func _TableBank($iSeat=0,$iBuyin=0)
	If $TABLEBUYIN > 180 Then
		$TABLEBUYIN = 180
	EndIf
	$TABLEBUYIN2 = Random($TABLEBUYIN, ($TABLEBUYIN * 1.1), 1)
	If $IBUYIN == 0 Then $IBUYIN = $IBLIND * $TABLEBUYIN2
	_TABLESTAND()
	_TABLESIT($ISEAT, $IBUYIN)
	;If $iBuyin==0 Then $iBuyin = $iBlind * $tableBuyin
	;_TableStand()
	;_TableSit($iSeat,$iBuyin)
EndFunc

Func _TablePause()
	_TableStand()
	$bPaused = True
	_Lobby()
EndFunc

Func _TableSit($iSeat=0,$iBuyin=0)
	If $TABLEBUYIN > 180 Then
		$TABLEBUYIN = 180
	EndIf
	$TABLEBUYIN2 = Random($TABLEBUYIN, ($TABLEBUYIN * 1.1), 1)
	While $bPaused
		Sleep(1000)
	Wend
	If $iSitStuck > 5 Then
		$iSitStuck = 0
		_PopupClose()
		Return False
	ElseIf $aTop[0] Then
		If Not $iSeat Then $iSeat = _SeatAvailable()
		If $iSeat Then
			If Not $iBlind Then $iBlind = _Blind()
			If Not $iBuyin Then $iBuyin = $iBlind * $tableBuyin2
			If Not $iBuyin Then
				_Log('_TableSit: unknown blinds')
				Return False
			Else
				$aSeat = _SeatPosition($iSeat)
				MouseClick('left',$aTop[0]+$aSeat[0],$aTop[1]+$aSeat[1], 1, 0) ; changed to 5
				Sleep(2000)
				Send($iBuyin)
				Send("{ENTER}")
				MouseMove($aTop[0],$aTop[1],0)
				$iCashChange = False
				$just_banked = _totalchips()
				$iSitStuck = $iSitStuck+1
				Return True
			EndIf
		EndIf
	EndIf
EndFunc

Func _TableBuyin($iBuyin=0)
	$aResult = _FindBMP("SCREEN",$sDataPath & "\bmp\table_buyin.bmp")
	;$xBank = 0 ; sets forcebank to false
	;$yBank = 0 ; sets forcebank to false
	;$zBank = 0 ; sets forcebank to false
	;$cWon = False ; we lost 
	$just_banked = _totalchips()
	If $TABLEBUYIN > 180 Then
		$TABLEBUYIN = 180
	EndIf
	$TABLEBUYIN2 = Random($TABLEBUYIN, ($TABLEBUYIN * 1.1), 1)
	If $aResult[1]==True Then
		_Log('_TableBuyin')
		If Not $iBuyin Then $iBuyin = $iBlind * $tableBuyin2
		If Not $iBuyin Then
			MouseClick('left',$aResult[3],$aResult[4],1,0)
			MouseMove($aTop[0],$aTop[1],0)
			Return True
		Else
			$iCashChange = False
			Send($iBuyin)
			Send("{ENTER}")
			MouseMove($aTop[0],$aTop[1],0)
			Return True
		EndIf
	EndIf
EndFunc
