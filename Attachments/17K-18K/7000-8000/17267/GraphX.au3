#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.8.1
 Author:        WeaponX, Thanks to PSaltyDS for ProcessListProperties

 Script Function:
	Steam style graph generator, this version customized for cpu usage

#ce ----------------------------------------------------------------------------
#include <array.au3>
#include <GUIConstants.au3>
#include "ProcessListProperties.au3"

Dim $points[1][2]

;Poll Frequency in milliseconds
Dim $PollFrequency = 500

;Number of times to execute poll
Dim $PollCount = 60

;Combined CPU usage
Dim $totalCpu = 0

;Combined RAM usage
Dim $totalRam = 0

;Process name
$processName = "prime95.exe"

If NOT ProcessExists($processName) Then
	MsgBox(0,"",$processName & " not running")
	Exit
EndIf

For $X = 1 to $PollCount
	If $X > 1 Then
		Redim $points[$X][2]
	EndIf
	
	$avRET = _ProcessListProperties($processName)
	$totalCpu += $avRET[1][6]
	$totalRam += $avRET[1][7]
	
	;Store seconds elapsed
	$points[$X - 1][0] = $X * ($PollFrequency / 1000)
	
	;Store cpu usage
	$points[$X - 1][1] = $avRET[1][6]
	
	Sleep($PollFrequency)
	
	TrayTip("Monitoring: " & $processName,"Time Elapsed: " & $X * ($PollFrequency / 1000) & " s" & @CRLF & "Time Remaining: " & ($PollCount * ($PollFrequency / 1000)) - ($X * ($PollFrequency / 1000)) & " s", 1)
Next

;_ArrayDisplay($points)
;exit

GraphX($points, ($PollFrequency / 1000) * $PollCount, 100,$processName)
	
;GraphX(2-Dimensional Array [][0] = X  [][1] = Y, X max value, Y max value, Title)

Func GraphX(ByRef $xyArray, $graphMaxX = 60, $graphMaxY = 100, $graphTitle = "")
	;Define colors
	Const $graphBGColor = 0x242529
	Const $graphBorderColor = 0x000000
	Const $graphLabelColor = 0x787878

	Const $graphMinX = 0
	;Const $graphMaxX = 60 ;Note to self: Search array for highest X value
	;Const $graphXisPercent = false

	Const $graphMinY = 0
	;Const $graphMaxY = 100 ;Note to self: Search array for highest Y value
	;Const $graphYisPercent = true
	
	Const $graphWidth = 400
	Const $graphHeight = 100

	Const $graphLineColor1 = 0xc98d35
	Const $graphLineColor2 = 0x686868
	
	Const $graphGridXInterval = 4
	Const $graphGridYInterval = 4
	
	$graphSumX = 0
	$graphSumY = 0
		
	;Create Main window
	GUICreate("Graph X: " & $graphTitle & " cpu usage", 440, 200)
	GUISetBkColor (0x424242)

	;GUISetState (@SW_SHOW) 

	;Create the graphic "sandbox" area
	$graphic = GuiCtrlCreateGraphic(35, 5, $graphWidth,$graphHeight)
	GUICtrlSetBkColor(-1,$graphBGColor)
	GUICtrlSetColor (-1, $graphBorderColor)

	;Draw grid lines at specified interval (skip first and last): Y
	For $X = 1 to $graphGridYInterval - 1
		GUICtrlSetGraphic(-1,$GUI_GR_MOVE, 0,$graphHeight * ($X / $graphGridYInterval))
		GUICtrlSetGraphic(-1,$GUI_GR_LINE,$graphWidth, $graphHeight * ($X / $graphGridYInterval))
	Next
	
	;Draw grid lines at specified interval (skip first and last): X
	For $X = 1 to $graphGridXInterval - 1
		GUICtrlSetGraphic(-1,$GUI_GR_MOVE, $graphWidth * ($X / $graphGridXInterval),0)
		GUICtrlSetGraphic(-1,$GUI_GR_LINE,$graphWidth * ($X / $graphGridXInterval), $graphHeight)
	Next

	;Set line color
	GUICtrlSetGraphic(-1,$GUI_GR_COLOR, $graphLineColor1)

	;Define starting point
	GUICtrlSetGraphic(-1,$GUI_GR_MOVE, 0,$graphMaxY)

	;Draw line
	For $X = 0 to Ubound($xyArray) - 1
		GUICtrlSetGraphic(-1,$GUI_GR_LINE,($graphWidth / $graphMaxX) * $xyArray[$X][0], $graphHeight - (($graphHeight / $graphMaxY) * $xyArray[$X][1]))
		$graphSumX += $xyArray[$X][0]
		$graphSumY += $xyArray[$X][1]
	Next

	;Define Y labels (% cpu usage)
	GUICtrlCreateLabel ("100%",  0, 3, 30)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel ("50%",  8, 50, 25)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel ("0%",  15, 95, 20)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	;Define X labels (elapsed time)
	GUICtrlCreateLabel ($graphMaxX & " s",  410, 107, 30)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel (($graphMaxX + $graphMinX) / 2 & " s",  220, 107, 25)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel ($graphMinX & " s",  35, 107, 20)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	;Draw average cpu usage label
	GUICtrlCreateLabel ("Average CPU Usage:", 10, 160, 170)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,12, 700)


	GUICtrlCreateLabel ($graphSumY / Ubound($xyArray) & "%", 180, 160, 170)
	GUICtrlSetColor ( -1, $graphLineColor1)
	GUICtrlSetFont (-1,12, 700)


	GUISetState (@SW_SHOW)
	 
	Do
		$msg = GUIGetMsg()

	Until $msg = $GUI_EVENT_CLOSE
EndFunc