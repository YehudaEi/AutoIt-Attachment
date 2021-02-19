#include <GraphGDIPlus.au3>
#Include <File.au3>
#Include <Array.au3>
#Include <Date.au3>

Opt("GUIOnEventMode", 1)

$desktopW = @DesktopWidth-20
$desktopH = @DesktopHeight-60

$GUI = GUICreate("",$desktopW,$desktopH, -1, 0)
GUISetBkColor(0x000000)
$MenuItem1 = GUICtrlCreateMenu("File")
$MenuItem3 = GUICtrlCreateMenuItem("Zoom In", $MenuItem1)
GUICtrlSetOnEvent(-1, "_zoomin")
$MenuItem2 = GUICtrlCreateMenuItem("Zoom Out", $MenuItem1)
GUICtrlSetOnEvent(-1, "_zoomout")
$separator1 = GUICtrlCreateMenuItem("", $MenuItem1, 2)
$MenuItem11 = GUICtrlCreateMenuItem("30 Minutes", $MenuItem1)
GUICtrlSetOnEvent(-1, "_30min")
$MenuItem10 = GUICtrlCreateMenuItem("2 Hours", $MenuItem1)
GUICtrlSetOnEvent(-1, "_120min")
$MenuItem4 = GUICtrlCreateMenuItem("12 Hours", $MenuItem1)
GUICtrlSetOnEvent(-1, "_12hrs")
$MenuItem5 = GUICtrlCreateMenuItem("24 Hours", $MenuItem1)
GUICtrlSetOnEvent(-1, "_24hrs")
$MenuItem6 = GUICtrlCreateMenuItem("3 Days", $MenuItem1)
GUICtrlSetOnEvent(-1, "_3days")
$MenuItem7 = GUICtrlCreateMenuItem("1 Week", $MenuItem1)
GUICtrlSetOnEvent(-1, "_1week")
$MenuItem8 = GUICtrlCreateMenuItem("1 Month", $MenuItem1)
GUICtrlSetOnEvent(-1, "_1mnth")
$MenuItem9 = GUICtrlCreateMenuItem("3 Months", $MenuItem1)
GUICtrlSetOnEvent(-1, "_3mnth")
$MenuItem9 = GUICtrlCreateMenuItem("6 Months", $MenuItem1)
GUICtrlSetOnEvent(-1, "_6mnth")

GUISetOnEvent(-3,"_Exit")
GUISetState()

$data_dir = @WorkingDir&"/Data"
$date_now = String(@YEAR&"/"&@MON&"/"&@MDAY&" "&@HOUR&":"&@MIN&":"&@SEC)

;----- Create Graph area -----
Global $hMem = 100000, $xticks = 24, $xlabels = 24, $tick_every = 1, $xtimeframe = 24*60*60

$Graph = _GraphGDIPlus_Create($GUI,60,20,$desktopW*.93,$desktopH*.9,0xFF3F3F3F,0xFF000000)
_GraphGDIPlus_Set_RangeX($Graph,0,$xticks,$xlabels,1,0)
_GraphGDIPlus_Set_RangeY($Graph,0,$hMem,20,1,0)
_GraphGDIPlus_Set_GridX($Graph,1,0xFF3F3F3F)
_GraphGDIPlus_Set_GridY($Graph,$hMem*.10,0xFF3F3F3F)

Func _zoomin()
	_GraphGDIPlus_Delete($GUI,$Graph)
	$hMem = Round($hMem*.5, 0)
	$Graph = _GraphGDIPlus_Create($GUI,60,20,$desktopW*.93,$desktopH*.9,0xFF3F3F3F,0xFF000000)
	_GraphGDIPlus_Set_RangeX($Graph,0,$xticks,$xlabels,1,0)
	_GraphGDIPlus_Set_RangeY($Graph,0,$hMem,20,1,0)
	_GraphGDIPlus_Refresh($Graph)
	_GraphGDIPlus_Set_GridX($Graph,$tick_every,0xFF3F3F3F)
	_GraphGDIPlus_Set_GridY($Graph,$hMem*.10,0xFF3F3F3F)
	_Draw_Graph()
EndFunc

Func _zoomout()
	_GraphGDIPlus_Delete($GUI,$Graph)
	$hMem = Round($hMem*1.5, 0)
	$Graph = _GraphGDIPlus_Create($GUI,60,20,$desktopW*.93,$desktopH*.9,0xFF3F3F3F,0xFF000000)
	_GraphGDIPlus_Set_RangeX($Graph,0,$xticks,$xlabels,1,0)
	_GraphGDIPlus_Set_RangeY($Graph,0,$hMem,20,1,0)
	_GraphGDIPlus_Refresh($Graph)
	_GraphGDIPlus_Set_GridX($Graph,$tick_every,0xFF3F3F3F)
	_GraphGDIPlus_Set_GridY($Graph,$hMem*.10,0xFF3F3F3F)
	_Draw_Graph()
EndFunc

Func _30min()
	$xtimeframe = 60*30
	$xticks = 30
	$xlabels = 30
	$tick_every = 5
	_GraphGDIPlus_Delete($GUI,$Graph)
	$Graph = _GraphGDIPlus_Create($GUI,60,20,$desktopW*.93,$desktopH*.9,0xFF3F3F3F,0xFF000000)
	_GraphGDIPlus_Set_RangeX($Graph,0,$xticks,$xlabels,1,0)
	_GraphGDIPlus_Set_RangeY($Graph,0,$hMem,20,1,0)
	_GraphGDIPlus_Refresh($Graph)
	_GraphGDIPlus_Set_GridX($Graph,$tick_every,0xFF3F3F3F)
	_GraphGDIPlus_Set_GridY($Graph,$hMem*.10,0xFF3F3F3F)
	_Draw_Graph()
EndFunc

Func _120min()
	$xtimeframe = 120*60
	$xticks = 120
	$xlabels = 15
	$tick_every = 4
	_GraphGDIPlus_Delete($GUI,$Graph)
	$Graph = _GraphGDIPlus_Create($GUI,60,20,$desktopW*.93,$desktopH*.9,0xFF3F3F3F,0xFF000000)
	_GraphGDIPlus_Set_RangeX($Graph,0,$xticks,$xlabels,1,0)
	_GraphGDIPlus_Set_RangeY($Graph,0,$hMem,20,1,0)
	_GraphGDIPlus_Refresh($Graph)
	_GraphGDIPlus_Set_GridX($Graph,$tick_every,0xFF3F3F3F)
	_GraphGDIPlus_Set_GridY($Graph,$hMem*.10,0xFF3F3F3F)
	_Draw_Graph()
EndFunc

Func _12hrs()
	$xtimeframe = 12*60*60
	$xticks = 12
	$xlabels = 12
	$tick_every = 1
	_GraphGDIPlus_Delete($GUI,$Graph)
	$Graph = _GraphGDIPlus_Create($GUI,60,20,$desktopW*.93,$desktopH*.9,0xFF3F3F3F,0xFF000000)
	_GraphGDIPlus_Set_RangeX($Graph,0,$xticks,$xlabels,1,0)
	_GraphGDIPlus_Set_RangeY($Graph,0,$hMem,20,1,0)
	_GraphGDIPlus_Refresh($Graph)
	_GraphGDIPlus_Set_GridX($Graph,$tick_every,0xFF3F3F3F)
	_GraphGDIPlus_Set_GridY($Graph,$hMem*.10,0xFF3F3F3F)
	_Draw_Graph()
EndFunc

Func _24hrs()
	$xtimeframe = 24*60*60
	$xticks = 24
	$xlabels = 24
	$tick_every = 1
	_GraphGDIPlus_Delete($GUI,$Graph)
	$Graph = _GraphGDIPlus_Create($GUI,60,20,$desktopW*.93,$desktopH*.9,0xFF3F3F3F,0xFF000000)
	_GraphGDIPlus_Set_RangeX($Graph,0,$xticks,$xlabels,1,0)
	_GraphGDIPlus_Set_RangeY($Graph,0,$hMem,20,1,0)
	_GraphGDIPlus_Refresh($Graph)
	_GraphGDIPlus_Set_GridX($Graph,$tick_every,0xFF3F3F3F)
	_GraphGDIPlus_Set_GridY($Graph,$hMem*.10,0xFF3F3F3F)
	_Draw_Graph()
EndFunc

Func _3days()
	$xtimeframe = 36*60*60
	$xticks = 36
	$xlabels = 12
	$tick_every = 1
	_GraphGDIPlus_Delete($GUI,$Graph)
	$Graph = _GraphGDIPlus_Create($GUI,60,20,$desktopW*.93,$desktopH*.9,0xFF3F3F3F,0xFF000000)
	_GraphGDIPlus_Set_RangeX($Graph,0,$xticks,$xlabels,1,0)
	_GraphGDIPlus_Set_RangeY($Graph,0,$hMem,20,1,0)
	_GraphGDIPlus_Refresh($Graph)
	_GraphGDIPlus_Set_GridX($Graph,$tick_every,0xFF3F3F3F)
	_GraphGDIPlus_Set_GridY($Graph,$hMem*.10,0xFF3F3F3F)
	_Draw_Graph()
EndFunc

Func _1week()
	$xtimeframe = 168*60*60
	$xticks = 168
	$xlabels = 12
	$tick_every = 4
	_GraphGDIPlus_Delete($GUI,$Graph)
	$Graph = _GraphGDIPlus_Create($GUI,60,20,$desktopW*.93,$desktopH*.9,0xFF3F3F3F,0xFF000000)
	_GraphGDIPlus_Set_RangeX($Graph,0,$xticks ,$xlabels,1,0)
	_GraphGDIPlus_Set_RangeY($Graph,0,$hMem,20,1,0)
	_GraphGDIPlus_Refresh($Graph)
	_GraphGDIPlus_Set_GridX($Graph,$tick_every,0xFF3F3F3F)
	_GraphGDIPlus_Set_GridY($Graph,$hMem*.10,0xFF3F3F3F)
	_Draw_Graph()
EndFunc

Func _1mnth()
EndFunc
Func _3mnth()
EndFunc
Func _6mnth()
EndFunc

;----- Draw the graph -----
_Draw_Graph()

While 1
    Sleep(100)
WEnd

Func _Draw_Graph()

	$filelist_ar = _FileListToArray($data_dir, "*.log", 1)

	Dim $fileinfo_ar[$filelist_ar[0]][4] 	;processname, color, max_memory_index, max memory index time

	$i = 1
	Do
		$fileinfo_ar[$i][1] = _RandClr()
		$process_file = FileOpen($data_dir&"/"&$filelist_ar[$i], 0)
		$n = _FileCountLines($data_dir&"/"&$filelist_ar[$i])

		_GraphGDIPlus_Set_PenColor($Graph, $fileinfo_ar[$i][1])
		_GraphGDIPlus_Set_PenSize($Graph,2)

		$lineread = FileReadLine($process_file)
		$div1 = StringInStr($lineread, "<>", 0, 1)
		$fileinfo_ar[$i][0] = StringLeft($lineread, $div1-1)
		$div2 = StringInStr($lineread, "<>", 0, 2)
		$memory_point = StringMid($lineread, $div1+2, $div2-$div1-2) ;memory
		$timestamp = StringRight($lineread, StringLen($lineread)-$div2-1) ;timestamp
		$date_diff = _DateDiff("s", $timestamp, $date_now)
		$fileinfo_ar[$i][3] = 0
		_GraphGDIPlus_Plot_Start($Graph,(($xtimeframe-$date_diff)/$xtimeframe)*$xticks,$memory_point)
		$j = 2
		Do
			$lineread = FileReadLine($process_file)
			$div1 = StringInStr($lineread, "<>", 0, 1)
			$div2 = StringInStr($lineread, "<>", 0, 2)
			$memory_point = StringMid($lineread, $div1+2, $div2-$div1-2) ;memory
			$timestamp = StringRight($lineread, StringLen($lineread)-$div2-1) ;timestamp
			$date_diff = _DateDiff("s", $timestamp, $date_now)

			;FileSetPos ($process_file, -StringLen($lineread)*2, 1)

			If $memory_point <> 0 Then
				If $memory_point < $hMem Then
					If $date_diff < $xtimeframe Then
						If $memory_point > $fileinfo_ar[$i][2] Then
							$fileinfo_ar[$i][2] = $memory_point
							$fileinfo_ar[$i][3] = $date_diff
						EndIf

						If $n = 1 Then
							_GraphGDIPlus_Plot_Dot($Graph,(($xtimeframe-$date_diff)/$xtimeframe)*$xticks,$memory_point)
						Else
							$timestamp2 = StringRight(FileReadLine($process_file), StringLen($lineread)-$div2-1) ;timestamp
							$internal_dif = _DateDiff("s", $timestamp, $timestamp2)
							If $internal_dif <= 63 Then
								_GraphGDIPlus_Plot_Line($Graph,(($xtimeframe-$date_diff)/$xtimeframe)*$xticks,$memory_point)
							Else
								_GraphGDIPlus_Plot_Start($Graph,(($xtimeframe-$date_diff+$internal_dif)/$xtimeframe)*$xticks,$memory_point)
							EndIf
						EndIf
					Else
						_GraphGDIPlus_Plot_Start($Graph,(($xtimeframe-$date_diff)/$xtimeframe)*$xticks,$memory_point)
					EndIf
				Else
					_GraphGDIPlus_Plot_Start($Graph,(($xtimeframe-$date_diff)/$xtimeframe)*$xticks,$memory_point)
				EndIf
			EndIf

			$j = $j + 1
		Until $j >= $n
		FileClose($process_file)
		_GraphGDIPlus_Refresh($Graph)
		IF $fileinfo_ar[$i][3] = 0 Then
			$fileinfo_ar[$i][3] = Random(0, $xtimeframe-20, 1)
		EndIf

		$i = $i + 1
	Until $i = $filelist_ar[0]

	$i = 1
	Do
		If $fileinfo_ar[$i][2] < $hMem And $fileinfo_ar[$i][3] <> 0 And $fileinfo_ar[$i][2] <> 0 Then
			If ($xtimeframe-$fileinfo_ar[$i][3])/$xtimeframe*$xticks < 5 Then
				_GraphGIDPlus_Plot_Text($Graph, Random(5, 10, 1), $fileinfo_ar[$i][2], $fileinfo_ar[$i][0], $fileinfo_ar[$i][1], 8, "Arial") ;$aGraphArray, $iX, $iY, $iText, $iColor)
			Else
				_GraphGIDPlus_Plot_Text($Graph, (($xtimeframe-$fileinfo_ar[$i][3])/$xtimeframe)*$xticks, $fileinfo_ar[$i][2], $fileinfo_ar[$i][0], $fileinfo_ar[$i][1], 8, "Arial") ;$aGraphArray, $iX, $iY, $iText, $iColor)
			EndIf
			;MsgBox(0, "($xtimeframe-$fileinfo_ar[$i][3])/$xtimeframe)*$xticks", ($xtimeframe-$fileinfo_ar[$i][3])/$xtimeframe*$xticks)
		EndIf
		$i = $i + 1
	Until $i = $filelist_ar[0]
EndFunc

Func _RandClr()
    Return "0xFF" & Hex(Random(0, 16777215, 1), 6)
EndFunc

Func _Exit()
    ;----- close down GDI+ and clear graphic -----
    _GraphGDIPlus_Delete($GUI,$Graph)
    Exit
EndFunc