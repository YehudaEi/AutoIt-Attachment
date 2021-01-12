; ------ ALL to MP3 Converter
;
; works only with NON DRM files !
;
; tags are taken and converted in MP3 Tags (if mediainfo finds them ...)
;
; some files seem to have troubles (possible filename) to be played in mplayer
;
;	requires
;			mplayer.exe by  http://www.mplayerhq.hu
;
;			lame.exe  	LAME 32bits version 3.97 (beta 2, Jan  8 2006) (                      )
;
;			Mediainfo.DLL 		                                 
;
;
; based on ::
;
;	Mp3 <-> Ogg Vorbis Converter Autoit 	by 	"The Kandy Man"
;	Drag and Drop into	Listviews  			by 	"Lazycat"
;
; Author Nobbe
;
; last change: 	16 Jan 2007
;

#include <GUIConstants.au3>
#include <Array.au3>
#include <Process.au3>
#include <Constants.au3>

#include <GuiListView.au3>
#include <GUIStatusBar.au3>
#include <File.au3>


;  ---- my udf for TAG info
#include "_media_tag_info.au3";

;  ---- my udf for TAG info
#include "_debug.au3"; udf for debugging into output window

Global $WM_DROPFILES = 0x233
Global $gaDropFiles[1], $str = ""

GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC")

Global $version = "0.1"

#NoTrayIcon

Opt("GUIOnEventMode", 1)
Opt("RunErrorsFatal", 0)

; -------------------------------------------- 

Global $main
Global $splitpath[5]
Global $tempwavefile
Global $mp3qualitycombo
Global $mp3qualitylabel
Global $mp3bitratecombo
Global $mp3samplingratecombo
Global $readmp3bitratecombo
Global $inilocation = @ScriptDir & "\settings.ini"
Global $encodingcancelled = False
Global $overwritecheckbox

Global $mp3_artist ; for MP3 tags ..
Global $mp3_title
Global $mp3_album
Global $mp3_year
Global $mp3_drm


; ########### KODA include --

$main = GUICreate("ALL -> MP3 Converter", 764, 578, 250, 206, $GUI_SS_DEFAULT_GUI, $WS_EX_ACCEPTFILES)

$progresslabel = GUICtrlCreateLabel("prog", 10, 450, 400, 17)
$fileprogresslabel = GUICtrlCreateLabel("Progress", 10, 470, 400, 17)

$group_settings = GUICtrlCreateGroup("MP3 Settings", 0, 0, 310, 135)

$mp3qualityradio = GUICtrlCreateRadio("Quality", 5, 15, 50, 18)
$mp3bitrateradio = GUICtrlCreateRadio("Bitrate", 135, 15, 50, 18)
$lbl_quality = GUICtrlCreateLabel("Quality:", 10, 50, 80, 20)

$mp3qualitycombo = GUICtrlCreateCombo("", 50, 45, 80, 20, $CBS_DROPDOWNLIST)

$mp3qualitylabel = GUICtrlCreateLabel("Approx. Bitrate 132 kbps", 10, 70, 118, 20)
$lbl_vbr = GUICtrlCreateLabel("Variable Bitrate Mode:", 10, 90, 120, 20)
$mp3vbrmodecombo = GUICtrlCreateCombo("", 10, 105, 120, 20, $CBS_DROPDOWNLIST)

$mp3bitratecombo = GUICtrlCreateCombo("", 215, 45, 50, 20, $CBS_DROPDOWNLIST + $WS_VSCROLL)
$lbl_target_bitrate = GUICtrlCreateLabel("Target Bitrate:", 140, 50)
$lbl_kbps = GUICtrlCreateLabel("kbps", 270, 50, 25)
$lameconstantbitratecheck = GUICtrlCreateCheckbox("Constant Bitrate (CBR)", 140, 70, 160, 18)

$lamemonoencodingcheck = GUICtrlCreateCheckbox("Mono Encoding", 140, 95, 100, 15)
$lbl_samplingrate = GUICtrlCreateLabel("Sampling Rate:", 140, 115, 75, 18)
$lbl_khz = GUICtrlCreateLabel("kHz", 275, 115, -1, 18)
$mp3samplingratecombo = GUICtrlCreateCombo("", 220, 110, 50, 1, $CBS_DROPDOWNLIST)

$stopbutton = GUICtrlCreateButton("Stop Encoding", 318, 43, 80, 20, 0)
$overwritecheckbox = GUICtrlCreateCheckbox("Overwrite files", 318, 9, 85, 18)


$listctrl = GUICtrlCreateListView("Filename|Artist|Title|Album|Year|DRM", 8, 144, 745, 289)
$progress_bar_one_file = GUICtrlCreateProgress(10, 500, 740, 15)
$progress_bar_all_files = GUICtrlCreateProgress(10, 525, 740, 15)


; ######### setting with koda

;  $searchlistViewF = _GuiCtrlCreateListViewIndexed ($sTempHeader, 0, 16, 790, 530, BitOR($LVS_SHOWSELALWAYS, $LVS_EDITLABELS), BitOR($LVS_EX_GRIDLINES, $LVS_EX_HEADERDRAGDROP, $LVS_EX_FULLROWSELECT, $LVS_EX_REGIONAL))


GUICtrlSetState($listctrl, $GUI_DROPACCEPTED)

;$s = $tempfile & "|" & $loc_mp3_artist & "|" & $loc_mp3_title & "|" & $loc_mp3_album & "|" & $loc_mp3_year & "|" & $loc_mp3_drm ; all values later...
GUICtrlCreateListViewItem("drop files here", $listctrl)


;; statusbar
Global $aStatusParts[2] = [420, -1]
Global $aTempStatus[2] = ["", ""]
$StatusBar = _GUICtrlStatusBarCreate($main, $aStatusParts, $aTempStatus, $SBARS_SIZEGRIP)
_GUICtrlStatusBarSetMinHeight($StatusBar, 20)
_GUICtrlStatusBarSetText($StatusBar, "....");

GUICtrlSetOnEvent($mp3qualitycombo, "MP3QualityCombo")
GUICtrlSetOnEvent($lameconstantbitratecheck, "Checkvalidsampletobitrate")

GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_DROPPED, "GetDroppedItemListBox") ;; now with list box


GUICtrlSetData($mp3qualitycombo, "10|20|30|40|50|60|70|80|90|100")
GUICtrlSetData($mp3qualitycombo, "80")

GUICtrlSetData($mp3vbrmodecombo, "New Method|Old Method(faster?)")
GUICtrlSetData($mp3vbrmodecombo, "New Method")

GUICtrlSetData($progresslabel, "Ready")
GUICtrlSetData($mp3samplingratecombo, "8|11.025|12|16|22.05|24|32|44.1|48")
GUICtrlSetData($mp3samplingratecombo, "44.1")

GUICtrlSetData($mp3bitratecombo, "112|128|160|192|224|256|320") ; pro only , no messing with little vals.. ..
GUICtrlSetData($mp3bitratecombo, "192")

GUICtrlSetState($stopbutton, $GUI_HIDE)
GUICtrlSetState($mp3qualityradio, $GUI_CHECKED)

GUICtrlSendMsg($listctrl, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)

_GUICtrlListViewSetColumnWidth($listctrl, 0, 350)
_GUICtrlListViewSetColumnWidth($listctrl, 1, 150)
_GUICtrlListViewSetColumnWidth($listctrl, 2, 150)
_GUICtrlListViewSetColumnWidth($listctrl, 3, 150)
_GUICtrlListViewSetColumnWidth($listctrl, 3, 150)

GUISetState(@SW_SHOW)

INIReadSettings()


While 1
	Sleep(10)
WEnd

;
;
;
; better now to put all files into list view box to see what we got..
;
;
Func GetDroppedItemListBox()
	Local $nbrFiles
	Local $i
	

	#cs
		local $str = ""
		local $nbrFiles= UBound($gaDropFiles) - 1;
		
		For $i = 0 To $nbrFiles
		$filenames[$i+1] = $gaDropFiles[$i]
		$str &=  $gaDropFiles[$i] & "|"
		Next
		;            GUICtrlSetData($hList, $str)
		$filenames[0] = $nbrFiles;
	#ce

	 ChangeControls("DISABLE")

	$encodingcancelled = False
	
	GUICtrlSetState($overwritecheckbox, $GUI_HIDE)
	GUICtrlSetState($stopbutton, $GUI_SHOW)

	FillListCtrl($listctrl, $gaDropFiles) 	;

	$nbrFiles = UBound($gaDropFiles) - 1;

	Opt("GUIOnEventMode", 0)

	; do all files 
	For $i = 0 To $nbrFiles
		
		If FileExists($gaDropFiles[$i]) Then

			Dim $szDrive, $szDir, $szFName, $szExt ; ??
			$splitpath = _PathSplit($gaDropFiles[$i], $szDrive, $szDir, $szFName, $szExt)

			$s1 = "encoding (" & $i + 1 & ") of (" & $nbrFiles + 1 & ")";
			_GUICtrlStatusBarSetText($StatusBar, $s1);
			_GUICtrlStatusBarSetText($StatusBar, $splitpath[3], 1);

			$tempwavefile = @TempDir & '\' & $splitpath[3] & '.wav'
			If VerifyOverwrite($splitpath[1] & $splitpath[2] & $splitpath[3] & ".wav") = True Then
				decode_file($gaDropFiles[$i])
				
				; with wave filename
				Convert_to_mp3($splitpath[3] & ".wav", $splitpath[1] & $splitpath[2] & $splitpath[3], $splitpath[4])

				FileDelete($splitpath[3] & ".wav")
				
				If $encodingcancelled = False Then
					FileMove($tempwavefile, $splitpath[1] & $splitpath[2] & $splitpath[3] & ".wav")
				Else
					FileDelete($tempwavefile)
				EndIf
			EndIf

			; set bar to ..
			GUICtrlSetData($progress_bar_all_files, ($i * 100) / $nbrFiles)

		EndIf ; file Exist..

	Next ; all files to encode ..

	;reset status bar 
	_GUICtrlStatusBarSetText($StatusBar, "");
	_GUICtrlStatusBarSetText($StatusBar, "", 1);

	Opt("GUIOnEventMode", 1)
	GUICtrlSetState($overwritecheckbox, $GUI_SHOW)
	GUICtrlSetState($stopbutton, $GUI_HIDE)
	GUICtrlSetData($progresslabel, "Ready")
	GUICtrlSetData($progress_bar_one_file, 0)
	GUICtrlSetData($progress_bar_all_files, 0)
	ChangeControls("ENABLE") 
	
EndFunc   ;==>GetDroppedItemListBox




;
; decodes file into local wav file ..
;
;
; input : full pathname to file
;

Func decode_file($my_infile)

	; global
	$mp3_title = "";
	$mp3_artist = "";
	$mp3_album = "";
	$mp3_year = "";
	$mp3_drm = "";

	GUICtrlSetData($progress_bar_one_file, 0)
	
	$ret = "";
	$ret = _media_tag_from_file ($my_infile)
	_DebugPrint ($ret);

	$val = "";
	$val = StringSplit($ret, "|")

	$mp3_artist = StringStripWS($val[1], 7) ; all WS
	$mp3_title = StringStripWS($val[2], 7) ; all WS
	$mp3_album = StringStripWS($val[3], 7) ; all WS
	$mp3_year = StringStripWS($val[4], 7) ; all WS
	$mp3_drm = StringStripWS($val[5], 7) ; all WS

	GUICtrlSetData($fileprogresslabel, "Decoding: " & $splitpath[3])
	GUICtrlSetData($progresslabel, "Decoding...")
	
	$mplayerpid = Run('mplayer.exe "' & $my_infile & '" -ao pcm:file="' & '.\' & $splitpath[3] & '.wav"', @ScriptDir, @SW_HIDE, $STDIN_CHILD)
	ProcessSetPriority($mplayerpid, 0) ;; lowest

	; ##  output doesnt work ??
	; output is
	; A: 147.2 (02:27.1) of 254.0 (04:14.0)  0.3%

	While ProcessExists($mplayerpid)

		$msg = GUIGetMsg()
		Select
			Case $msg = $stopbutton
				$encodingcancelled = True
				ProcessClose($mplayerpid)
				FileDelete($tempwavefile)
			Case $msg = $GUI_EVENT_CLOSE
				$encodingcancelled = True
				ProcessClose($mplayerpid)
				FileDelete($tempwavefile)
				Terminate()
		EndSelect
	WEnd

	WinSetTitle($main, "", "")
	GUICtrlSetData($progresslabel, 100 & "% done.")
	GUICtrlSetData($progress_bar_one_file, 100)
	GUICtrlSetData($fileprogresslabel, "")
	GUICtrlSetData($progresslabel, "Ready")
	GUICtrlSetData($progress_bar_one_file, 0)

EndFunc   ;==>decode_file



;
; 
;
Func SpecialEvents()
	Select
		Case @GUI_CtrlId = $GUI_EVENT_CLOSE
			WriteINISettings()
			Exit
		Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE
;~             MsgBox(0, "Window Minimized", "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE)
		Case @GUI_CtrlId = $GUI_EVENT_RESTORE
;~             MsgBox(0, "Window Restored", "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE)

			#cs
				Case $GUI_EVENT_DROPPED ; my files are dropped
				$str = ""
				For $i = 0 To UBound($gaDropFiles) - 1
				$str &= "|" & $gaDropFiles[$i]
				Next
				;            GUICtrlSetData($hList, $str)
				MsgBox(0, "Dropped ", $str)
			#ce
			
	EndSelect
EndFunc   ;==>SpecialEvents




Func Convert_to_mp3($filein, $fileout, $origextension)
;~ 	GUICTrlSetData($progresslabel, "Encoding MP3...")
	#cs
		CBR (constant bitrate, the default) options:
		-b <bitrate>    set the bitrate in kbps, default 128 kbps
		--cbr           enforce use of constant bitrate
		ABR options:
		--abr <bitrate> specify average bitrate desired (instead of quality)
		VBR options:
		-v              use variable bitrate (VBR) (--vbr-old)
		--vbr-old       use old variable bitrate (VBR) routine
		--vbr-new       use new variable bitrate (VBR) routine
		-V n            quality setting for VBR.  default n=4
		0=high quality,bigger files. 9=smaller files
		-b <bitrate>    specify minimum allowed bitrate, default  32 kbps
		-B <bitrate>    specify maximum allowed bitrate, default 320 kbps
		-F              strictly enforce the -b option, for use with players that
		do not support low bitrate mp3
		-t              disable writing LAME Tag
		-T              enable and force writing LAME Tag
	#ce

	_DebugPrint ("startmp3 encode");

	If $encodingcancelled = True Then Return 0
	If GUICtrlRead($mp3qualityradio) = $GUI_CHECKED Then
		$readqualitycombo = GUICtrlRead($mp3qualitycombo)
		Select
			Case $readqualitycombo = 10
				$quality = "-V 9"
			Case $readqualitycombo = 20
				$quality = "-V 8"
			Case $readqualitycombo = 30
				$quality = "-V 7"
			Case $readqualitycombo = 40
				$quality = "-V 6"
			Case $readqualitycombo = 50
				$quality = "-V 5"
			Case $readqualitycombo = 60
				$quality = "-V 4"
			Case $readqualitycombo = 70
				$quality = "-V 3"
			Case $readqualitycombo = 80
				$quality = "-V 2"
			Case $readqualitycombo = 90
				$quality = "-V 1"
			Case $readqualitycombo = 100
				$quality = "-V 0"
		EndSelect
		$readmp3vbrmodecombo = GUICtrlRead($mp3vbrmodecombo)
		Select
			Case $readmp3vbrmodecombo = "New Method"
				$qualitymode = "--vbr-new "
			Case $readmp3vbrmodecombo = "Old Method(faster?)"
				$qualitymode = "--vbr-old "
		EndSelect
		$mp3readsamplereate = GUICtrlRead($mp3samplingratecombo)
		$mp3encodingparameters = "--resample " & $mp3readsamplereate & " " & $qualitymode & $quality
	Else
		$readmp3bitrateinput = GUICtrlRead($mp3bitratecombo)
		If GUICtrlRead($lameconstantbitratecheck) = $GUI_CHECKED Then
			$mp3bitrate = "--preset cbr " & Number($readmp3bitrateinput)
		Else
			$mp3bitrate = "--cbr " & Number($readmp3bitrateinput)
		EndIf
		$mp3readsamplereate = GUICtrlRead($mp3samplingratecombo)
		$mp3encodingparameters = "--resample " & $mp3readsamplereate & " " & $mp3bitrate
	EndIf

	If GUICtrlRead($lamemonoencodingcheck) = $GUI_CHECKED Then
		$mp3encodingparameters &= " -a"
	EndIf

	If VerifyOverwrite($fileout & '.mp3') = True Then
		If FileExists($filein) Then
			Local $szDrive, $szDir, $szFName, $szExt
			_PathSplit($filein, $szDrive, $szDir, $szFName, $szExt)
			GUICtrlSetData($fileprogresslabel, "Encoding: " & $szFName & ".mp3");
			
			; now lame with all ID3 tags also ...
			$lame_cmd = 'lame.exe ' & $mp3encodingparameters & " --ta " & '"' & $mp3_artist & '"' & " --tt " & '"' & $mp3_title & '"' ;
			$lame_cmd = $lame_cmd & " --tl " & '"' & $mp3_album & '"' & ' "' & $filein & '" "' & $fileout & '.mp3"'  ; 		& " --ty " & $mp3_year &

			_DebugPrint ($lame_cmd);

			$lameencpid = Run($lame_cmd, @ScriptDir, @SW_HIDE, $STDERR_CHILD)

			ProcessSetPriority($lameencpid, 0) ;; lowest

			$streamcounter = 0
			
			While ProcessExists($lameencpid)
				If 1 <= $streamcounter Then
					$readstream = StderrRead($lameencpid);,0,true)
					$position = StringInStr($readstream, "%)")
					$firsttrim = StringLeft($readstream, $position - 1)
					$position2 = StringInStr($firsttrim, " (")
					$percentdone = StringTrimLeft($firsttrim, $position2 + 1)

					If Not StringInStr($percentdone, ":") And Not StringInStr($percentdone, "  ") And Not $percentdone = "" Then

						; progress bar ..
						GUICtrlSetData($progress_bar_one_file, $percentdone)
						GUICtrlSetData($progresslabel, $percentdone & "% done encoding MP3...")
						WinSetTitle($main, "", $percentdone & "% done encoding MP3")
					EndIf
					$streamcounter = 0
				EndIf


				$msg = GUIGetMsg()
				Select
					Case $msg = $stopbutton
						$encodingcancelled = True
						ProcessClose($lameencpid)
						FileDelete($tempwavefile)
					Case $msg = $GUI_EVENT_CLOSE
						$encodingcancelled = True
						ProcessClose($lameencpid)
						FileDelete($tempwavefile)
						Terminate()
				EndSelect
				$streamcounter = $streamcounter + 1

			WEnd
		Else


		EndIf
	EndIf
	GUICtrlSetData($fileprogresslabel, "")
	GUICtrlSetData($progresslabel, "")
EndFunc   ;==>Convert_to_mp3


;
;
;
Func MP3QualityCombo()
;~ 	Msgbox(0,"","It has registered the press.")
	$readmp3combo = GUICtrlRead($mp3qualitycombo)
	Select
		Case $readmp3combo = 10
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 60 kbps")
		Case $readmp3combo = 20
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 84 kbps")
		Case $readmp3combo = 30
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 100 kbps")
		Case $readmp3combo = 40
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 118 kbps")
		Case $readmp3combo = 50
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 132 kbps")
		Case $readmp3combo = 60
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 152 kbps")
		Case $readmp3combo = 70
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 166 kbps")
		Case $readmp3combo = 80
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 190 kbps")
		Case $readmp3combo = 90
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 220 kbps")
		Case $readmp3combo = 100
			GUICtrlSetData($mp3qualitylabel, "Approx. Bitrate 240 kbps")
	EndSelect
	#cs
		CBR (constant bitrate, the default) options:
		-b <bitrate>    set the bitrate in kbps, default 128 kbps
		--cbr           enforce use of constant bitrate
		ABR options:
		--abr <bitrate> specify average bitrate desired (instead of quality)
		VBR options:
		-v              use variable bitrate (VBR) (--vbr-old)
		--vbr-old       use old variable bitrate (VBR) routine
		--vbr-new       use new variable bitrate (VBR) routine
		-V n            quality setting for VBR.  default n=4
		0=high quality,bigger files. 9=smaller files
		-b <bitrate>    specify minimum allowed bitrate, default  32 kbps
		-B <bitrate>    specify maximum allowed bitrate, default 320 kbps
		-F              strictly enforce the -b option, for use with players that
		do not support low bitrate mp3
		-t              disable writing LAME Tag
		-T              enable and force writing LAME Tag
	#ce
EndFunc   ;==>MP3QualityCombo


Func Checkforvalidbitrate()
	$readinput = GUICtrlRead($mp3bitratecombo)
	If $readinput > 320 Then GUICtrlSetData($mp3bitratecombo, 320)
EndFunc   ;==>Checkforvalidbitrate






Func Checkvalidsampletobitrate()
	$readmp3sameplecombo = GUICtrlRead($mp3samplingratecombo)
	If GUICtrlRead($lameconstantbitratecheck) = $GUI_CHECKED Then
		$readmp3bitratecombo = GUICtrlRead($mp3bitratecombo)
		Select
			Case $readmp3sameplecombo = 8
				GUICtrlSetData($mp3bitratecombo, "")
				GUICtrlSetData($mp3bitratecombo, "8|16|24|32|40|48|56|64|80|96|112|128|144|160")
				GUICtrlSetData($mp3bitratecombo, Mpeg2and2point5ComboCheck())
			Case $readmp3sameplecombo = 11.025
				GUICtrlSetData($mp3bitratecombo, "")
				GUICtrlSetData($mp3bitratecombo, "8|16|24|32|40|48|56|64|80|96|112|128|144|160")
				GUICtrlSetData($mp3bitratecombo, Mpeg2and2point5ComboCheck())
			Case $readmp3sameplecombo = 12
				GUICtrlSetData($mp3bitratecombo, "")
				GUICtrlSetData($mp3bitratecombo, "8|16|24|32|40|48|56|64|80|96|112|128|144|160")
				GUICtrlSetData($mp3bitratecombo, Mpeg2and2point5ComboCheck())
			Case $readmp3sameplecombo = 16
				GUICtrlSetData($mp3bitratecombo, "")
				GUICtrlSetData($mp3bitratecombo, "8|16|24|32|40|48|56|64|80|96|112|128|144|160")
				GUICtrlSetData($mp3bitratecombo, Mpeg2and2point5ComboCheck())
			Case $readmp3sameplecombo = 22.05
				GUICtrlSetData($mp3bitratecombo, "")
				GUICtrlSetData($mp3bitratecombo, "8|16|24|32|40|48|56|64|80|96|112|128|144|160")
				GUICtrlSetData($mp3bitratecombo, Mpeg2and2point5ComboCheck())
			Case $readmp3sameplecombo = 24
				GUICtrlSetData($mp3bitratecombo, "")
				GUICtrlSetData($mp3bitratecombo, "8|16|24|32|40|48|56|64|80|96|112|128|144|160")
				GUICtrlSetData($mp3bitratecombo, Mpeg2and2point5ComboCheck())
			Case $readmp3sameplecombo = 32
				GUICtrlSetData($mp3bitratecombo, "")
				GUICtrlSetData($mp3bitratecombo, "32|40|48|56|64|80|96|112|128|160|192|224|256|320")
				GUICtrlSetData($mp3bitratecombo, Mpeg1ComboCheck())
			Case $readmp3sameplecombo = 44.1
				GUICtrlSetData($mp3bitratecombo, "")
				GUICtrlSetData($mp3bitratecombo, "32|40|48|56|64|80|96|112|128|160|192|224|256|320")
				GUICtrlSetData($mp3bitratecombo, Mpeg1ComboCheck())
			Case $readmp3sameplecombo = 48
				GUICtrlSetData($mp3bitratecombo, "")
				GUICtrlSetData($mp3bitratecombo, "32|40|48|56|64|80|96|112|128|160|192|224|256|320")
				GUICtrlSetData($mp3bitratecombo, Mpeg1ComboCheck())
		EndSelect

		;Else
		;		$readmp3bitratecombo = GUICtrlRead($mp3bitratecombo)
		;		GUICtrlSetData($mp3bitratecombo, "")
		;		$combostring = 0
		;		For $counter = 1 To 320
		;			$combostring &= "|" & $counter
		;		Next
		;		GUICtrlSetData($mp3bitratecombo, $combostring)
		;		GUICtrlSetData($mp3bitratecombo, $readmp3bitratecombo)


	EndIf
EndFunc   ;==>Checkvalidsampletobitrate


Func Mpeg2and2point5ComboCheck()
	Select
		Case $readmp3bitratecombo <= 8
			Return 8
		Case $readmp3bitratecombo <= 16
			Return 16
		Case $readmp3bitratecombo <= 24
			Return 24
		Case $readmp3bitratecombo <= 32
			Return 32
		Case $readmp3bitratecombo <= 40
			Return 40
		Case $readmp3bitratecombo <= 48
			Return 48
		Case $readmp3bitratecombo <= 56
			Return 56
		Case $readmp3bitratecombo <= 64
			Return 64
		Case $readmp3bitratecombo <= 80
			Return 80
		Case $readmp3bitratecombo <= 96
			Return 96
		Case $readmp3bitratecombo <= 112
			Return 112
		Case $readmp3bitratecombo <= 128
			Return 128
		Case $readmp3bitratecombo <= 144
			Return 144
		Case $readmp3bitratecombo <= 160
			Return 160
		Case $readmp3bitratecombo > 160
			Return 160
	EndSelect
EndFunc   ;==>Mpeg2and2point5ComboCheck



Func Mpeg1ComboCheck()
	Select
		Case $readmp3bitratecombo <= 32
			Return 32
		Case $readmp3bitratecombo <= 40
			Return 40
		Case $readmp3bitratecombo <= 48
			Return 48
		Case $readmp3bitratecombo <= 56
			Return 56
		Case $readmp3bitratecombo <= 64
			Return 64
		Case $readmp3bitratecombo <= 80
			Return 80
		Case $readmp3bitratecombo <= 96
			Return 96
		Case $readmp3bitratecombo <= 112
			Return 112
		Case $readmp3bitratecombo <= 128
			Return 128
		Case $readmp3bitratecombo <= 160
			Return 160
		Case $readmp3bitratecombo <= 192
			Return 192
		Case $readmp3bitratecombo <= 224
			Return 224
		Case $readmp3bitratecombo <= 256
			Return 256
		Case $readmp3bitratecombo <= 320
			Return 320
		Case $readmp3bitratecombo > 320
			Return 320
	EndSelect
EndFunc   ;==>Mpeg1ComboCheck




Func WriteINISettings()
	Checkvalidsampletobitrate()
	;	CalculateNominalBitrate()
	If GUICtrlRead($mp3qualityradio) = $GUI_CHECKED Then
		IniWrite($inilocation, "Settings", "MP3Radio", "Quality")
	Else
		IniWrite($inilocation, "Settings", "MP3Radio", "Bitrate")
	EndIf
	IniWrite($inilocation, "Settings", "QualitySetting", GUICtrlRead($mp3qualitycombo))
	IniWrite($inilocation, "Settings", "VBRMode", GUICtrlRead($mp3vbrmodecombo))
	IniWrite($inilocation, "Settings", "TargetBitrate", GUICtrlRead($mp3bitratecombo))
;~ 	If GUICtrlRead($lameconstantbitratecheck) = $GUI_CHECKED Then
;~ 		IniWrite($inilocation, "Settings", "CBR", $GUI_CHECKED)
	IniWrite($inilocation, "Settings", "CBR", GUICtrlRead($lameconstantbitratecheck))
;~ 	Else
;~ 		IniWrite($inilocation, "Settings", "CBR", $GUI_UNCHECKED)
;~ 	EndIf
;~ 	If GUICtrlRead($lamemonoencodingcheck) = $GUI_CHECKED Then
;~ 		IniWrite($inilocation, "Settings", "Mono", $GUI_CHECKED)
	IniWrite($inilocation, "Settings", "Mono", GUICtrlRead($lamemonoencodingcheck))
;~ 	Else
;~ 		IniWrite($inilocation, "Settings", "Mono", $GUI_UNCHECKED)
;~ 	EndIf
	IniWrite($inilocation, "Settings", "SamplingRate", GUICtrlRead($mp3samplingratecombo))

	IniWrite($inilocation, "Settings", "Overwritefiles", GUICtrlRead($overwritecheckbox))
EndFunc   ;==>WriteINISettings



Func INIReadSettings()
	;using a variable and then setting the state equal to the variable because it is easier to read
	$read = IniRead($inilocation, "Settings", "MP3Radio", "Quality")
	If $read = "Quality" Then
		GUICtrlSetState($mp3qualityradio, $GUI_CHECKED)
	Else
		GUICtrlSetState($mp3bitrateradio, $GUI_CHECKED)
	EndIf
	$read = IniRead($inilocation, "Settings", "QualitySetting", "50")
	GUICtrlSetData($mp3qualitycombo, $read)
	$read = IniRead($inilocation, "Settings", "VBRMode", "New Method")
	GUICtrlSetData($mp3vbrmodecombo, $read)
	$read = IniRead($inilocation, "Settings", "TargetBitrate", "128")
	GUICtrlSetData($mp3bitratecombo, $read)
	$read = IniRead($inilocation, "Settings", "CBR", $GUI_UNCHECKED)
	GUICtrlSetState($lameconstantbitratecheck, $read)
	$read = IniRead($inilocation, "Settings", "Mono", $GUI_UNCHECKED)
	GUICtrlSetState($lamemonoencodingcheck, $read)
	$read = IniRead($inilocation, "Settings", "SamplingRate", "44.1")
	GUICtrlSetData($mp3samplingratecombo, $read)
	;	CalculateNominalBitrate()
	$read = IniRead($inilocation, "Settings", "Overwritefiles", $GUI_UNCHECKED)
	GUICtrlSetState($overwritecheckbox, $read)

	$read = 0
EndFunc   ;==>INIReadSettings

;
;
;
Func Terminate()
	WriteINISettings()
	Exit
EndFunc   ;==>Terminate

;
;
;
Func VerifyOverwrite($path)
	If FileExists($path) Then
		If GUICtrlRead($overwritecheckbox) = $GUI_CHECKED Then
			Return True
		Else
			;MsgBox(48, "Error", 'The file "' & $path & '" already exists!', 10)
			Return False
		EndIf
	Else
		Return True
	EndIf
EndFunc   ;==>VerifyOverwrite


;
; instead of 2 functions now only one 
;
; ChangeControls("ENABLE") 
; ChangeControls("DISABLE")
;

Func ChangeControls($state)
	Local $new_state
	
	If $state == "ENABLE" Then
		$new_state = $GUI_ENABLE
	Else
		$new_state = $GUI_DISABLE
	EndIf

	GUICtrlSetState($mp3bitratecombo, $new_state)
	GUICtrlSetState($mp3qualityradio, $new_state)
	GUICtrlSetState($mp3bitrateradio, $new_state)
	GUICtrlSetState($mp3qualitycombo, $new_state)
	GUICtrlSetState($mp3vbrmodecombo, $new_state)
	GUICtrlSetState($mp3bitratecombo, $new_state)
	GUICtrlSetState($lameconstantbitratecheck, $new_state)
	GUICtrlSetState($lamemonoencodingcheck, $new_state)
	GUICtrlSetState($mp3samplingratecombo, $new_state)
	GUICtrlSetState($overwritecheckbox, $new_state)
EndFunc   ;==>ChangeControls



;
; all my values into list view ..
;
Func FillListCtrl($myList, $myArray)
	Local $iRun, $ilisttem, $s, $s1
	Local $szD, $szP, $szFN, $szE
	Local $splitpath1
	Local $tempfile
	Local $ile
	Local $nr = 0;

	Local $loc_mp3_title = "";
	Local $loc_mp3_artist = "";
	Local $loc_mp3_album = "";
	Local $loc_mp3_year = "";
	Local $loc_mp3_drm = "";

	_GUICtrlListViewDeleteAllItems($myList)

	Local $nbrFiles = UBound($myArray) - 1;# size of array

	For $iRun = 0 To $nbrFiles ;

		$splitpath1 = _PathSplit($myArray[$iRun], $szD, $szP, $szFN, $szE)
		$tempfile = $splitpath1[3] ;

		$s = $tempfile & "|" & $loc_mp3_artist & "|" & $loc_mp3_title & "|" & $loc_mp3_album & "|" & $loc_mp3_year & "|" & $loc_mp3_drm ; all values later...

		GUICtrlCreateListViewItem($s, $myList) ; in list box

		$s1 = "loading file (" & $iRun + 1 & ") of (" & $nbrFiles + 1 & ")"; ## 0 based --
		_GUICtrlStatusBarSetText($StatusBar, $s1); $s1,1 == first bar right
	Next

	_GUICtrlListViewSetColumnWidth($myList, 1, $LVSCW_AUTOSIZE)
	_GUICtrlListViewSetColumnWidth($myList, 2, $LVSCW_AUTOSIZE)
	_GUICtrlListViewSetColumnWidth($myList, 3, $LVSCW_AUTOSIZE)
	_GUICtrlListViewSetColumnWidth($myList, 4, $LVSCW_AUTOSIZE)
	_GUICtrlListViewSetColumnWidth($myList, 5, $LVSCW_AUTOSIZE)

	_GUICtrlStatusBarSetText($StatusBar, "");
	_GUICtrlStatusBarSetText($StatusBar, "", 1);
	
EndFunc   ;==>FillListCtrl



;
; drop my files here in listview
;
Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $gaDropFiles[$i + 1]
		$gaDropFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
EndFunc   ;==>WM_DROPFILES_FUNC