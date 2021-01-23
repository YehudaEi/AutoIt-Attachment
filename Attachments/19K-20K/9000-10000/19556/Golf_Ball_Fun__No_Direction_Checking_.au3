#NoTrayIcon

#include <GUIConstants.au3>

Global $ScreenWidth = @DesktopWidth
Global $ScreenHeight = @DesktopHeight

Global $Window_List = -1
Dim $Window_List_Sizes[1][5]

RefreshWinList()

$Xslope = Random(-20, 20, 1)
$Yslope = Random(-20, 20, 1)

$Ball_Size = Random(10, 100, 1)

$Main_GUI = GuiCreate("", $Ball_Size, $Ball_Size, -1, -1, $WS_POPUP, $WS_EX_LAYERED + $WS_EX_TOOLWINDOW)

$Soccer_Ball = GUICtrlCreatePic ("Golf Ball.gif", 0, 0, $Ball_Size, $Ball_Size)

GUISetState()

WinSetOnTop($Main_GUI, "", 1)

Global $Ball_Pos = WinGetPos($Main_GUI)

$Timer = TimerInit()
$Win_Refresh_Timer = TimerInit()

While 1
    $Msg = GUIGetMsg()
    Select
        Case $Msg = $GUI_EVENT_CLOSE
            Exit
    EndSelect
    
    If TimerDiff($Timer) >= 1 Then
        If $Ball_Pos[0] = 0 Or ($Ball_Pos[0] + $Ball_Size) = $ScreenWidth Then
            $Xslope = $Xslope * -1
        ElseIf $Ball_Pos[1] = 0 Or ($Ball_Pos[1] + $Ball_Size) = $ScreenHeight Then
            $Yslope = $Yslope * -1
		Else
			For $i = 1 To $Window_List_Sizes[0][0] Step 1
				If BitAnd(WinGetState($Window_List_Sizes[$i][0], ""), 16) = 0 Then
					If ($Ball_Pos[0] + $Ball_Size) > $Window_List_Sizes[$i][1] And $Ball_Pos[0] < ($Window_List_Sizes[$i][1] + StringReplace($Xslope, "-", "")) And $Ball_Pos[1] > $Window_List_Sizes[$i][2] And $Ball_Pos[1] < ($Window_List_Sizes[$i][2] + $Window_List_Sizes[$i][4]) Then
						$Xslope = $Xslope * -1
					ElseIf $Ball_Pos[0] < ($Window_List_Sizes[$i][1] + $Window_List_Sizes[$i][3]) And $Ball_Pos[0] >= (($Window_List_Sizes[$i][1] + $Window_List_Sizes[$i][3]) - StringReplace($Xslope, "-", "")) And $Ball_Pos[1] > $Window_List_Sizes[$i][2] And $Ball_Pos[1] < ($Window_List_Sizes[$i][2] + $Window_List_Sizes[$i][4]) And StringInStr($Xslope, "-") Then
						$Xslope = $Xslope * -1
					ElseIf ($Ball_Pos[1] + $Ball_Size) > $Window_List_Sizes[$i][2] And $Ball_Pos[1] < ($Window_List_Sizes[$i][2] + StringReplace($Yslope, "-", "")) And $Ball_Pos[0] > $Window_List_Sizes[$i][1] And $Ball_Pos[0] < ($Window_List_Sizes[$i][1] + $Window_List_Sizes[$i][3]) Then
						$Yslope = $Yslope * -1
					ElseIf $Ball_Pos[1] < ($Window_List_Sizes[$i][2] + $Window_List_Sizes[$i][4]) And $Ball_Pos[1] >= (($Window_List_Sizes[$i][2] + $Window_List_Sizes[$i][4]) - StringReplace($Yslope, "-", "")) And $Ball_Pos[0] > $Window_List_Sizes[$i][1] And $Ball_Pos[0] < ($Window_List_Sizes[$i][1] + $Window_List_Sizes[$i][3]) And StringInStr($Yslope, "-") Then
						$Yslope = $Yslope * -1
					EndIf
				EndIf
			Next
        EndIf

        $Ball_Pos[0] += $Xslope
        $Ball_Pos[1] += $Yslope

        If $Ball_Pos[0] < 0 Then
			$Ball_Pos[0] = 0
		ElseIf $Ball_Pos[0] > ($ScreenWidth - $Ball_Size) Then
			$Ball_Pos[0] = $ScreenWidth - $Ball_Size
		ElseIf $Ball_Pos[1] < 0 Then
			$Ball_Pos[1] = 0
        ElseIf $Ball_Pos[1] > ($ScreenHeight - $Ball_Size) Then
            $Ball_Pos[1] = $ScreenHeight - $Ball_Size
        EndIf

        WinMove($Main_GUI, "", $Ball_Pos[0], $Ball_Pos[1], $Ball_Size, $Ball_Size)

		$Ball_Pos = WinGetPos($Main_GUI)
        $Timer = TimerInit()
    EndIf
	
	If TimerDiff($Win_Refresh_Timer) > 10 Then
		RefreshWinList()
		$Win_Refresh_Timer = TimerInit()
	EndIf
Wend

Func RefreshWinList()
    ReDim $Window_List_Sizes[1][5]
    $Window_List_Sizes[0][0] = 0

    $Window_List = WinList()

    For $i = 1 To $Window_List[0][0] Step 1
        If IsVisible($Window_List[$i][1]) Then
            $Window_List_Sizes[0][0] += 1
            Redim $Window_List_Sizes[$Window_List_Sizes[0][0] + 1][5]
            $Window_List_Sizes[$Window_List_Sizes[0][0]][0] = $Window_List[$i][1]
            $Temp_Size = WinGetPos($Window_List[$i][1])
            $Window_List_Sizes[$Window_List_Sizes[0][0]][1] = $Temp_Size[0]
			$Window_List_Sizes[$Window_List_Sizes[0][0]][2] = $Temp_Size[1]
			$Window_List_Sizes[$Window_List_Sizes[0][0]][3] = $Temp_Size[2]
			$Window_List_Sizes[$Window_List_Sizes[0][0]][4] = $Temp_Size[3]
        EndIf
    Next

EndFunc

Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc