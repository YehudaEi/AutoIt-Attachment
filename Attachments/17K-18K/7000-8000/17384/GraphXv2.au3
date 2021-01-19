#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.8.1
 Author:        WeaponX, Thanks to PSaltyDS for ProcessListProperties

 Script Function:
	Steam style graph generator, this version customized for cpu usage

#ce ----------------------------------------------------------------------------
#include <array.au3>
#include <GUIConstants.au3>
#include "ProcessListProperties.au3"

$processName = "explorer.exe"

;Uncomment next line to retrieve real data
$theArray = processStatsToArray($processName)

;Uncomment next line to generate random data
;$theArray = randomStatsToArray()

GraphX($theArray, $processName)

;Return 2D Array of CPU / RAM usage per process
;[0] = Elapsed time in ms
;[1] = CPU usage as %
;[2] = RAM usage in kb
Func processStatsToArray($processName)
	Local $points[1][3]

	;Poll Frequency in milliseconds
	Local $PollFrequency = 1000

	;Number of times to execute poll
	Local $PollCount = 12

	If NOT ProcessExists($processName) Then
		MsgBox(0,"",$processName & " not running")
		Exit
	EndIf

	;[0] = Elapsed time in ms
	;[1] = CPU usage as %
	;[2] = RAM usage in kb
	For $X = 1 to $PollCount
		If $X > 1 Then
			Redim $points[$X][3]
		EndIf
		
		$avRET = _ProcessListProperties($processName)
		
		;Store seconds elapsed
		$points[$X - 1][0] = $X * ($PollFrequency / 1000)
		
		;Store cpu usage (0-100)
		$points[$X - 1][1] = $avRET[1][6]
		
		;Store ram usage (in Kb)
		$points[$X - 1][2] = $avRET[1][7]
		
		Sleep($PollFrequency)
		
		TrayTip("Monitoring: " & $processName,"Time Elapsed: " & StringFormat("%.2f", $X * ($PollFrequency / 1000)) & " s" & @CRLF & "Time Remaining: " & StringFormat("%.2f", ($PollCount * ($PollFrequency / 1000)) - ($X * ($PollFrequency / 1000))) & " s", 1)
	Next
	
	;Clear traytip
	TrayTip("","", 0)
	
	Return $points
EndFunc

Func randomStatsToArray()
	Local $points[1][3]

	;Poll Frequency in milliseconds
	Local $PollFrequency = 100

	;Number of times to execute poll
	Local $PollCount = 100

	;[0] = Elapsed time in ms
	;[1] = CPU usage as %
	;[2] = RAM usage in kb
	For $X = 1 to $PollCount
		If $X > 1 Then
			Redim $points[$X][3]
		EndIf
		
		;Store seconds elapsed
		$points[$X - 1][0] = $X * ($PollFrequency / 1000)
		
		;Store cpu usage (0-100)
		$points[$X - 1][1] = Random(0,100, 1)
		
		;Store ram usage (in Kb)
		$points[$X - 1][2] = Random(0,500000000, 1)
		
		;Sleep($PollFrequency)
		
		;TrayTip("Monitoring: " & $processName,"Time Elapsed: " & $X * ($PollFrequency / 1000) & " s" & @CRLF & "Time Remaining: " & ($PollCount * ($PollFrequency / 1000)) - ($X * ($PollFrequency / 1000)) & " s", 1)
	Next
	
	;Clear traytip
	;TrayTip("","", 0)
	
	Return $points
EndFunc
	
;GraphX
Func GraphX(ByRef $xyArray, $graphTitle = "")
	;Define colors
	Local $graphBGColor = 0x242529
	Local $graphBorderColor = 0x000000
	Local $graphLabelColor = 0x787878

	Const $graphMinX = 0
	Local $graphMaxX = 0
	
	For $X = 0 to Ubound($xyArray) - 1
		If $xyArray[$X][0] > $graphMaxX Then
			$graphMaxX = $xyArray[$X][0]
		EndIf
			
	Next

	Local $graphMinY = 0
	Local $graphMaxY = 100
	#CS
	For $X = 0 to Ubound($xyArray) - 1
		If $xyArray[$X][0] > $graphMaxY Then
			$graphMaxY = $xyArray[$X][0]
		EndIf
			
	Next
	#CE
	
	Const $graphWidth = 400
	Const $graphHeight = 100

	Const $graphLineColor1 = 0xc98d35
	Const $graphLineColor2 = 0x686868
	
	Const $graphGridXInterval = 4
	Const $graphGridYInterval = 4
	
	$graphSumCPU = 0
	$graphSumRAM = 0
		
	;Create Main window
	GUICreate("Graph X: " & $graphTitle & " cpu usage", 500, 200, -1)
	GUISetBkColor (0x424242)

	;GUISetState (@SW_SHOW) 

	;Create the graphic "sandbox" area
	$graphic = GuiCtrlCreateGraphic(50, 5, $graphWidth,$graphHeight)
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

	;Draw line 1
	For $X = 0 to Ubound($xyArray) - 1
		;Convert input value (relative %) into absolute pixel value
		$tempX = ($graphWidth / $graphMaxX) * $xyArray[$X][0]
		
		;Reflect Y value
		$tempY = $graphHeight - (($graphHeight / $graphMaxY) * $xyArray[$X][1])
		
		GUICtrlSetGraphic(-1,$GUI_GR_LINE,$tempX,$tempY)
		$graphSumCPU += $xyArray[$X][1]
	Next

	;Set line color
	GUICtrlSetGraphic(-1,$GUI_GR_COLOR, $graphLineColor2)

	;Define starting point
	GUICtrlSetGraphic(-1,$GUI_GR_MOVE, 0,$graphMaxY)
	
	;Draw line 2
	;Find highest amoutn of ram used
	$maxRamUsage = 0
	For $X = 0 to Ubound($xyArray) - 1
		If $xyArray[$X][2] > $maxRamUsage Then
			$maxRamUsage = $xyArray[$X][2]
		EndIf
	Next
		
	For $X = 0 to Ubound($xyArray) - 1
		$ramAsPercent = ($xyArray[$X][2] / $maxRamUsage) * 100
		
		;Convert input value (relative %) into absolute pixel value
		$tempX = ($graphWidth / $graphMaxX) * $xyArray[$X][0]
		
		;Reflect Y value
		$tempY = $graphHeight - (($graphHeight / $graphMaxY) * $ramAsPercent)
		
		GUICtrlSetGraphic(-1,$GUI_GR_LINE,$tempX,$tempY)
		$graphSumRAM += $xyArray[$X][2]
	Next
	
	;Define Y labels (% cpu usage)
	GUICtrlCreateLabel ("100%",  10, 3, 30)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel ("50%",18, 50, 25)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel ("0%",  25, 95, 20)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)
	
	;Define Y labels (% RAM usage)
	GUICtrlCreateLabel (Int($maxRamUsage / 1000000) & "mb",  455, 3, 45)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel (Int(($maxRamUsage / 1000000) / 2) & "mb",455, 50, 45)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel ("0mb",  455, 95, 45)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	;Define X labels (elapsed time)
	GUICtrlCreateLabel ($graphMinX & " s",  50, 107, 20)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel (($graphMaxX + $graphMinX) / 2 & " s",  240, 107, 30)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)

	GUICtrlCreateLabel ($graphMaxX & " s",  440, 107, 30)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,8, 600)
	
	;Draw average cpu usage label
	GUICtrlCreateLabel ("Average CPU Usage:", 10, 160, 170)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,12, 700)

	GUICtrlCreateLabel (StringFormat("%.2f", $graphSumCPU / Ubound($xyArray)) & "%", 180, 160, 170)
	GUICtrlSetColor ( -1, $graphLineColor1)
	GUICtrlSetFont (-1,12, 700)
	
	;Draw average ram usage label
	GUICtrlCreateLabel ("Average RAM Usage:", 10, 140, 170)
	GUICtrlSetColor ( -1, $graphLabelColor)
	GUICtrlSetFont (-1,12, 700)

	GUICtrlCreateLabel (StringFormat("%.2f", ($graphSumRAM / Ubound($xyArray)) / 1000000) & "mb", 180, 140, 170)
	GUICtrlSetColor ( -1, $graphLineColor1)
	GUICtrlSetFont (-1,12, 700)

	GUISetState (@SW_SHOW)
	 
	Do
		$msg = GUIGetMsg()
	Until $msg = $GUI_EVENT_CLOSE
EndFunc