#cs
'Pics Converter in Pure AutoIt' made by Cramaboule October 09

Thanks to AdmiralAlkex for his help !

Convert from/to JPG, BMP, GIF, PNG ,...!!!
Enjoy !

- To Do:
- autodetect input type -> Done!!!
- set output file time according to input one -> Done!!!
- for JPG new option for "quality" -> Done!!!
- remove Sleep(10) from FOR/NEXT loop -> Done!!!

V1.0 first realese
V1.1 added new features
V1.2 bugs fixed

#ce
#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#Include <File.au3>
#include <ProgressConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <SliderConstants.au3>

$head = "Pics Conversion V1.2"

Local $Param=0 , $Decoder, $InDecoder[1][10], $ToCombo


_GDIPlus_Startup ()
$testBMP = _ScreenCapture_Capture ("", 0, 0, 1, 1)
$hImage = _GDIPlus_BitmapCreateFromHBITMAP ($testBMP)
$Decoder = _GDIPlus_Decoders()
_GDIPlus_ImageDispose ($hImage)
_WinAPI_DeleteObject ($testBMP)
_GDIPlus_ShutDown ()


For $i = 1 To $Decoder[0][0]
	ReDim $InDecoder[$Decoder[0][0]+1][10]
	$Split = StringSplit($Decoder[$i][6],";")
	For $j = 1 to $Split[0]
		$ToCombo &= StringTrimLeft($Split[$j],2)& "|"
	Next
Next
;ConsoleWrite($ToCombo & @CRLF)

$Conv = GUICreate($head, 400, 210, -1, -1)
$Group1 = GUICtrlCreateGroup("Input", 5, 5, 140, 145)
$InputEncoder = GUICtrlCreateCombo("", 15, 120, 110, 25)
GUICtrlSetData(-1, $ToCombo)
$InputFolder = GUICtrlCreateInput("Input Folder", 15, 30, 120, 21)
$BrowseInput = GUICtrlCreateButton("Browse...", 30, 55, 75, 25, $WS_GROUP)
$Label2 = GUICtrlCreateLabel("Convert from:", 15, 95, 67, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Output", 155, 5, 140, 145)
$OutputEncoder = GUICtrlCreateCombo("JPG", 170, 120, 110, 25)
GUICtrlSetData(-1, "BMP|GIF|PNG")
$OutputFolder = GUICtrlCreateInput("Output Folder", 165, 30, 120, 21)
$BrowseOutput = GUICtrlCreateButton("Browse...", 185, 55, 75, 25, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("Convert to:", 170, 95, 56, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GO = GUICtrlCreateButton("Convert", 100, 160, 200, 40, $WS_GROUP)
$Group3 = GUICtrlCreateGroup(" JPG Quality ", 305, 5, 90, 145)
$Slider = GUICtrlCreateSlider(350, 20, 35, 125, BitOR($TBS_VERT,$TBS_TOP,$TBS_LEFT))
$JPGQlty = GUICtrlCreateInput("100", 315, 75, 30, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

$OldOutEncoder=""
$OldValSlider="0"
$OldJPGQuality="100"

While 1
	$OutEncoder = GUICtrlRead ($OutputEncoder)
	$ValSlider = GUICtrlRead ($Slider)
	$JPGQuality = GUICtrlRead($JPGQlty)
	$nMsg = GUIGetMsg()
	Select
		Case $nMsg=$GUI_EVENT_CLOSE
			Exit
		Case $nMsg= $BrowseInput
			$InFold = FileSelectFolder("Choose a folder", "",7)
			If $InFold <> "" Then
				GUICtrlSetData($InputFolder, $InFold)
				GUICtrlSetData($OutputFolder, $InFold)
			EndIf
		Case $nMsg= $BrowseOutput
			$OutFold = FileSelectFolder("Choose a folder", "",7)
			If $OutFold <> "" Then
				GUICtrlSetData($OutputFolder, $OutFold)
			EndIf
		Case $nMsg= $GO
			$InPath=GUICtrlRead ($InputFolder)
			$OutPath= GUICtrlRead($OutputFolder)
			$InEncoder = GUICtrlRead ($InputEncoder)
			$OutEncoder = GUICtrlRead ($OutputEncoder)
			If StringInStr($InPath,"\")  = 0 Then
				MsgBox (16, "Caution!","Please select a folder!")
			ElseIf $InEncoder = $OutEncoder And $OutEncoder <> "JPG" Or $InEncoder = "" Then
				MsgBox (16, "Caution!","Please choose different encoder/decoder")
			Else
				; do the conversion process...
				; do the progress bar GUI
				$Form1 = GUICreate("", 420, 100,-1, -1,BitOR($WS_POPUP,$WS_BORDER),$WS_EX_TOOLWINDOW)
				$ProgFile = GUICtrlCreateProgress(10, 10, 400, 15, $PBS_SMOOTH)
				$ProgAll = GUICtrlCreateProgress(10, 60, 400, 15, $PBS_SMOOTH)
				$Label1 = GUICtrlCreateLabel("", 10, 80, 400, 17)
				$Label2 = GUICtrlCreateLabel("", 10, 30, 400, 17)
				GUISetState(@SW_SHOW)
				;
				If $OutEncoder ="JPG" Then ; Set JPG quality
					$TParam = _GDIPlus_ParamInit(1)
					$Datas = DllStructCreate("int Quality")
					DllStructSetData($Datas, "Quality", $JPGQuality)
					_GDIPlus_ParamAdd($TParam, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, DllStructGetPtr($Datas))
					$Param = DllStructGetPtr($TParam)
				EndIf
				If IsDllStruct($Param) Then $Param = DllStructGetPtr($TParam)
				;process itself
				$FileList=_FileListToArray($InPath, "*."& $InEncoder, 1)
				If @error <> 0 Then
					MsgBox(16, "Caution!","No files found or invalid path!")
				Else
					_GDIPlus_Startup()
					For $i = 1 To $FileList[0]
						GUICtrlSetData($ProgAll, ($i/$FileList[0])*100)
						GUICtrlSetData($Label2, $InPath&"\"&$FileList[$i])
						GUICtrlSetData($Label1, $i&" / "&$FileList[0])
						$image = _GDIPlus_ImageLoadFromFile($InPath&"\"&$FileList[$i])
						$clsid = _GDIPlus_EncodersGetCLSID($OutEncoder)
						GUICtrlSetData($ProgFile, 25)
						_GDIPlus_ImageSaveToFileEx($image, StringReplace($OutPath&"\"&$FileList[$i],"."&$InEncoder,"."&$OutEncoder), $clsid,$Param)
						GUICtrlSetData($ProgFile, 75)
						FileSetTime ( StringReplace($OutPath&"\"&$FileList[$i],"."&$InEncoder,"."&$OutEncoder), FileGetTime ( $InPath&"\"&$FileList[$i], 0,1), 0 )
						FileSetTime ( StringReplace($OutPath&"\"&$FileList[$i],"."&$InEncoder,"."&$OutEncoder), FileGetTime ( $InPath&"\"&$FileList[$i], 1,1), 1 )
						GUICtrlSetData($ProgFile, 100)
					Next
					_GDIPlus_Shutdown()
					MsgBox(64, "Done!","Done!")
				EndIf
				GUISetState(@SW_HIDE,$Form1)
			EndIf
		Case $OutEncoder <> $OldOutEncoder
			If $OutEncoder <> "JPG" Then
				GUICtrlSetState ($Group3,$GUI_DISABLE)
				GUICtrlSetState ($Slider,$GUI_DISABLE)
				GUICtrlSetState ($JPGQlty,$GUI_DISABLE)
			Else
				GUICtrlSetState ($Group3,$GUI_ENABLE)
				GUICtrlSetState ($Slider,$GUI_ENABLE)
				GUICtrlSetState ($JPGQlty,$GUI_ENABLE)
			EndIf
			$OldOutEncoder = $OutEncoder
		Case $ValSlider <> $OldValSlider
			GUICtrlSetData($JPGQlty,100-$ValSlider)
			$OldValSlider = $ValSlider
		Case $JPGQuality <> $OldJPGQuality
			GUICtrlSetData($Slider, 100-$JPGQuality)
			If $JPGQuality > 100 Then $JPGQuality = 100
			If $JPGQuality < 0 Then $JPGQuality = 0
			GUICtrlSetData($JPGQlty,$JPGQuality)
			$OldJPGQuality = $JPGQuality
	EndSelect
WEnd
