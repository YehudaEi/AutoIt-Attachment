;written 18, June 2007 - ronriel
;updated 28, June 2007 - ronriel
;updated 30, June 2007 - ronriel
#NoTrayIcon
#include <Sound.au3>
#include <GuiList.au3>
#include <file.au3>
#include <Array.au3>
#include <IE.au3>
#Include <Date.au3>
#Include <String.au3>
Opt ("GUIOnEventMode", 1)
Opt ("WinTitleMatchMode", 4)

Dim $fod, $m, $SDir, $r, $c, $ar, $pos, $sL, $s, $fsf, $k, $clkMe,$hour,$min,$sec,$hourR,$minR,$secR,$path,$oArt,$oIE,$oTit
Dim $var1 = 1, $var2 = 1, $var3 = 0,$cont = 0, $lst = @ScriptDir & "\rr.lst", $P = "r4r", $msg = "               Audio Player by: ronriel               ", $sp = StringSplit($msg,"")

HotKeySet("^f", "catchguikey")
HotKeySet("{ENTER}", "catchguikey")

$gui1 = GUICreate ($P, 360, 200, 510, 186)
$H1 = WinGetHandle ("[title:" & $P & ";class:AutoIt v3 GUI]")
$Ld = GUICtrlCreateList ("", 5, 5, 350, 145,0xA00003)
$Spos = GUICtrlCreateSlider(188, 183, 135, 17,0x0010)
GUICtrlSetTip (-1, "Current Position")
$vs = GUICtrlCreateSlider (255, 161, 100, 17,0x0010)
GUICtrlSetData (-1, 100)
SoundSetWaveVolume (100)
GUICtrlSetTip (-1, "Volume = 100")
$B1 = GUICtrlCreateButton ("<", 5, 144, 20, 13,0x8000)
GUICtrlSetTip (-1, "Display Lyrics Window")
GUICtrlSetFont (-1, 7)
$B2 = GUICtrlCreateButton ("|<<", 5, 178, 35, 20)
GUICtrlSetColor (-1, 0x255FDC)
GUICtrlSetBkColor(-1,0xffffff)
GUICtrlSetTip (-1, "Previous Track")
$B3 = GUICtrlCreateButton ("> | |", 41, 178, 35, 20)
GUICtrlSetColor (-1, 0x47AC47)
GUICtrlSetBkColor(-1,0xffffff)
GUICtrlSetTip (-1, "Play/Pause")
$B4 = GUICtrlCreateButton ("[ ]", 77, 178, 35, 20)
GUICtrlSetColor (-1, 0xC30604)
GUICtrlSetBkColor(-1,0xffffff)
GUICtrlSetTip (-1, "Stop")
$B5 = GUICtrlCreateButton (">>|", 113, 178, 35, 20)
GUICtrlSetColor (-1, 0x255FDC)
GUICtrlSetBkColor(-1,0xffffff)
GUICtrlSetTip (-1, "Next Track")
$B6 = GUICtrlCreateButton ("dir", 5,160,30,15)
GUICtrlSetTip (-1, "Add Folder(s)")
GUICtrlSetFont (-1, 8)
$B7 = GUICtrlCreateButton ("file", 36,160,30,15)
GUICtrlSetTip (-1, "Add File(s)")
GUICtrlSetFont (-1, 8)
$B8 = GUICtrlCreateButton ("Impt", 67,160,30,15)
GUICtrlSetTip (-1, "Import Playlist")
GUICtrlSetFont (-1, 8)
$B9 = GUICtrlCreateButton ("del", 98,160,30,15)
GUICtrlSetTip (-1, "Remove from List")
GUICtrlSetFont (-1, 8)
$B10 = GUICtrlCreateButton ("clr", 129,160,30,15)
GUICtrlSetTip (-1, "Clear Playlist")
GUICtrlSetFont (-1, 8)
$B11 = GUICtrlCreateButton ("find", 160,160,30,15)
GUICtrlSetTip (-1, "Find Tracks")
GUICtrlSetFont (-1, 8)
$CB1 = GUICtrlCreateCheckbox ("Rand", 191,160 , 30, 15,0x1000)
GUICtrlSetState (-1, $GUI_CHECKED)
GUICtrlSetTip (-1, "Random Play")
GUICtrlSetFont (-1, 7)
$CB2 = GUICtrlCreateCheckbox ("Loop",  222,160, 30, 15,0x1000)
GUICtrlSetTip (-1, "Loop Track")
GUICtrlSetFont (-1, 7)
$L1 = GUICtrlCreateLabel ("Item(s)", 300, 145, 55, 12,BitOR(0x1000,0x01))
GUICtrlSetFont (-1, 7)
GUICtrlSetBkColor(-1,0xffffff)
$L2 = GUICtrlCreateLabel ("    >", 159, 183, 35, 15)
GUICtrlSetFont (-1, 7)
$L3 = GUICtrlCreateLabel (">", 325, 183, 35, 15)
GUICtrlSetFont (-1, 7)
$L4 = GUICtrlCreateLabel ("", 25, 145, 275, 12,BitOR(0x1000,0x01))
GUICtrlSetFont (-1, 7)
GUICtrlSetBkColor(-1,0xffffff)
GUISetOnEvent ($GUI_EVENT_CLOSE, "Ex")

$winpos = WinGetPos ($gui1, "")
$gui2 = GUICreate ("Lyrics", 300, 223, $winpos[0] - 310, $winpos[1]+1, $WS_SIZEBOX, $WS_EX_TOOLWINDOW, $gui1)
$H2 = WinGetHandle ("[title:Lyrics;class:AutoIt v3 GUI]")
$Lwin = GUICtrlCreateEdit ("", 10, 10, 280, 150, BitOR (0x1000, $WS_VSCROLL))
$B21 = GUICtrlCreateButton ("Save", 10, 183, 140, 15)
GUICtrlSetTip (-1, "Save changes made to the lyrics")
$B22 = GUICtrlCreateButton ("Delete", 150, 183, 140, 15)
GUICtrlSetTip (-1, "Delete Lyrics")
$CR1 = GUICtrlCreateRadio ("absolutelyrics.com",150,165,110,15)
$CR2 = GUICtrlCreateRadio ("azlyrics.com",30,165,110,15)
GUICtrlSetState (-1, $GUI_CHECKED)
GUISetOnEvent ($GUI_EVENT_CLOSE, "CLW")

GUICtrlSetOnEvent ($B1, "OLW")
GUICtrlSetOnEvent ($B2, "Prevs")
GUICtrlSetOnEvent ($B3, "Play")
GUICtrlSetOnEvent ($B4, "Stop")
GUICtrlSetOnEvent ($B5, "Nxt")
GUICtrlSetOnEvent ($B6, "dir")
GUICtrlSetOnEvent ($B7, "file")
GUICtrlSetOnEvent ($B8, "impt")
GUICtrlSetOnEvent ($B9, "del")
GUICtrlSetOnEvent ($B10, "clr")
GUICtrlSetOnEvent ($B11,"find")
GUICtrlSetOnEvent ($vs, "volume")
GUICtrlSetOnEvent ($Spos, "Pos")
GUICtrlSetOnEvent ($Ld,"click")
GUICtrlSetOnEvent ($B21, "save")
GUICtrlSetOnEvent ($B22, "delete")
prep()
GUISetState (@SW_SHOW, $gui1)
;=========================
;My FUNCTIONS

Func prep()
	$c = _FileCountLines ($lst)
	If $c = 0 Then Return
	_FileReadToArray ($lst, $ar)
	For $i = 1 To $c
		$ss = StringSplit ($ar[$i], "\")
		_GUICtrlListAddItem ($Ld,_StringProper(StringTrimRight ($ss[$ss[0]], 4)))
	Next
	GUICtrlSetData($L1, $c&" Items")
	_GUICtrlListSelectIndex ($Ld,0)
EndFunc

Func dir()
	$AudF = _SubDirFileListToArray("*.wav;*.mp3","Add Folder(s)")
	If IsArray($AudF) Then
	For $i = 1 To $AudF[0]
		$ss = StringSplit ($AudF[$i], "\")
		_GUICtrlListAddItem ($Ld,_StringProper(StringTrimRight ($ss[$ss[0]], 4)))
	Next
	$str1 = _ArrayToString ($AudF, @CRLF, 1)
	$str2 = _StringInsert($str1,@CRLF,StringLen($str1))
	$o = FileOpen ($lst, 1)
	FileWrite ($o, $str2)
	FileClose ($o)
	GUICtrlSetData ($L1, _FileCountLines ($lst) & " Files")
	_GUICtrlListSelectIndex ($Ld, 0)
EndIf
EndFunc
Func _SubDirFileListToArray($filter = "*.*",$dtext = "",$rootdir = "",$flag = "",$initialdir ="");=== now supports multiple filters "*.xyz;*.abc"
	Dim	$list[1]=[0]
	$fsf = FileSelectFolder ($dtext,$rootdir,$flag,$initialdir)
	If @error = 1 Then Return
	$sFilter = StringSplit($filter,";")
	If @error = 1 Then
	$sFilter[0]= 1
	$sFilter[1]=$filter
	EndIf
	For $y =  1 To $sFilter[0]
	$fla1 = _FileListToArray ($fsf, $sFilter[$y], 1)
	If @error = 2 Then Return 0
	If IsArray ($fla1) Then
		For $i = 1 To $fla1[0]
		_ArrayAdd ($list, $fsf&"\"&$fla1[$i])
		Next
	EndIf
	$DLTA = _DirListToArray($fsf)
	 If IsArray ($DLTA) Then
		For $i = 1 To $DLTA[0]
		$fla = _FileListToArray ($DLTA[$i],$sFilter[$y], 1)
			If IsArray ($fla) Then
				For $x = 1 To $fla[0]
					_ArrayAdd ($list,  $DLTA[$i]&"\"&$fla[$x])
				Next
			EndIf
		Next
	EndIf
	Next
		$list [0] = UBound ($list) - 1
		Return $list
	EndFunc

Func file()
	$fod = FileOpenDialog ("Add File(s).", "", "Music (*.mp3;*.wav)", 4)
	If @error = 1 Then Return
	$ss = StringSplit ($fod, "\")
	$Mss = StringSplit ($fod, "|")
	If @error = 1 Then
		_GUICtrlListAddItem ($Ld,_StringProper(StringTrimRight ($ss[$ss[0]], 4)))
		$o = FileOpen ($lst, 1)
		FileWrite ($o, $fod & @CRLF)
		FileClose ($o)
	Else
		$o = FileOpen ($lst, 1)
		$SDir = $Mss[1] & "\"
		For $i = 2 To $Mss[0]
			_GUICtrlListAddItem ($Ld,_StringProper(StringTrimRight ($Mss[$i], 4)))
			FileWrite ($o, $Mss[1] & "\" & $Mss[$i] & @CRLF)
		Next
		FileClose ($o)
	EndIf
	GUICtrlSetData ($L1, _FileCountLines ($lst) & " Files")
	_GUICtrlListSelectIndex ($Ld, 0)
EndFunc

Func del()
	$r1 = GUICtrlRead($Ld)
	$si = _GUICtrlListSelectedIndex ($Ld)
	_GUICtrlListDeleteItem ($Ld, $si)
	_GUICtrlListSelectIndex ($Ld, $si - 1)
	_FileReadToArray ($lst, $ar)
	$s = _ArraySearch ($ar, $r1, 1, 0, 0, True)
	_FileWriteToLine ($lst, $s, "", 1)
	GUICtrlSetData ($L1, _FileCountLines ($lst) & " Files")
EndFunc

Func clr()
	_GUICtrlListClear ($Ld)
	FileDelete ($lst)
	GUICtrlSetData ($L1, "0 File")
EndFunc

Func impt()
	$fod = FileOpenDialog ("Add Playlist.", @ProgramFilesDir, "(*.pls;*.m3u)")
	If @error = 1 Then Return
	If StringInStr ($fod, ".pls", 2) Then
		_FileReadToArray ($fod, $ar)
		$str = StringAddCR (StringStripWS (StringRegExpReplace (StringRegExpReplace (StringRegExpReplace ( _ArrayToString ($ar, @LF, 3), "((?i)(?:Title)[0-9]{1,4})(?:=).{1,}", ""), "((?i)(?:Length)[0-9]{1,4})(?:=).{1,}", ""), "((?i)(?:File)[0-9]{1,4})(?:=)", ""), 4))
		$o = FileOpen ($lst, 1)
		FileWrite ($o, $str)
		FileClose ($o)
	ElseIf StringInStr ($fod, ".m3u", 2) Then
		_FileReadToArray ($fod, $ar)
		$str = StringAddCR (StringStripWS (StringRegExpReplace (_ArrayToString ($ar, @LF, 3), "((?i)(?:#EXTINF)).{1,}", ""), 4))
		$o = FileOpen ($lst, 1)
		FileWrite ($o, $str)
		FileClose ($o)
	EndIf
	prep()
	GUICtrlSetData ($L1, _FileCountLines ($lst) & " Files")
EndFunc


Func find()
	$find = InputBox("Find","Enter search string.","","",100,30)
	If @error = 1 Then Return
	_FileReadToArray($lst,$ar)
	If IsArray($ar) Then
	$str = StringSplit(StringRegExpReplace (StringRegExpReplace (StringRegExpReplace (_ArrayToString($ar,@LF,1),"\w:\\", ""),"(\w+ +\w+)+\\", ""),"\w+\\", ""),@LF)
	_ArrayDelete($str,0)
	_ArraySort($str)
	$s = _ArraySearch ($str, $find, 0, 0, 0, True)
	If @error = 6 Then MsgBox(0,"Info","Not Found!",3)
	_GUICtrlListSelectIndex ($ld,$s-1)
	EndIf
EndFunc

Func click()
	GUICtrlSetOnEvent ($Ld,"click2")
	$clkMe = _GUICtrlListSelectedIndex($Ld)
EndFunc
Func click2()
	If $clkMe = _GUICtrlListSelectedIndex($Ld) Then
	play()
	GUICtrlSetOnEvent ($Ld,"click")
	Else
	GUICtrlSetOnEvent ($Ld,"click")
	EndIf
EndFunc

Func OLW()
	GUISetState (@SW_SHOW, $gui2)
	GUICtrlSetOnEvent ($B1, "CLW")
	GUICtrlSetTip ($B1, "Hide Lyrics Window")
	GUICtrlSetData ($B1, ">")
EndFunc   ;==>OLW

Func CLW()
	GUISetState (@SW_HIDE, $gui2)
	GUICtrlSetOnEvent ($B1, "OLW")
	GUICtrlSetTip ($B1, "Display Lyrics Window")
	GUICtrlSetData ($B1, "<")
EndFunc   ;==>CLW

Func Lyrics()
	WinSetTitle ($H2, "", $r)
	$LFS = FileOpen (@ScriptDir & "\Lyrics\" & $r & ".mp3.txt", 0)
	If $LFS = -1 Then
		$ss = StringSplit($path,"\")
			If @error<>1 Then
				FileClose ($LFS)
				GUICtrlSetData ($Lwin, "Searching...")
				RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main", "Display Inline Images", "REG_SZ", "no")
				$Shell = ObjCreate ("shell.application")
				$Dir = $Shell.NameSpace (StringReplace($path,$ss[$ss[0]],""))
				$File = $Dir.Parsename ($ss[$ss[0]])
				$oTit = $Dir.GetDetailsOf ($File, 10)
				$oArt = $Dir.GetDetailsOf ($File, 16)
					If GUICtrlRead($CR1)= $GUI_CHECKED Then
						$Stit = StringReplace (StringLower ($oTit), " ", "_")
						$Art = StringReplace (StringLower ($oArt), " ", "_")
						$oIE = _IECreate ("                                          " & $Art & "/" & $Stit, 0,0,0)
						$var3 = 0
						$cont = 1
						Return
					Else
						$Stit = StringReplace (StringLower ($oTit), " ", "")
						$Art = StringReplace (StringLower ($oArt), " ", "")
						$oIE = _IECreate ("http://www.azlyrics.com/lyrics/"&$Art&"/"&$Stit&".html", 0,0,0)
						$var3 = 0
						$cont = 2
						Return
					EndIf
				Else
				Return
			EndIf
	EndIf
	$lyrics = FileRead ($LFS)
	FileClose ($LFS)
	GUICtrlSetData ($Lwin, $r & @CRLF & @CRLF & $lyrics)
EndFunc   ;==>Lyrics

Func cont1()
	_IELoadWait($oIE,0,1000)
	If @error = 0 Then
		If StringInStr (_IEPropertyGet ($oIE, "title"),$oArt, 2) = 0 Then
			GUICtrlSetData ($Lwin, "Lyrics Not Found...")
			RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main", "Display Inline Images", "REG_SZ", "yes")
			_IEQuit($oIE)
			Return
		EndIf
	$oDiv = _IEGetObjById ($oIE, "realText")
	$lyrics = _IEPropertyGet($oDiv, "innertext")
	$o = FileOpen (@ScriptDir & "\Lyrics\" & $r & ".mp3.txt", 10)
	FileWrite ($o, $lyrics)
	FileClose ($o)
	GUICtrlSetData ($Lwin, $r & @CRLF & @CRLF & $lyrics)
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main", "Display Inline Images", "REG_SZ", "yes")
	_IEQuit($oIE)
	Else
	GUICtrlSetData ($Lwin, "Lyrics Not Found...")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main", "Display Inline Images", "REG_SZ", "yes")
	_IEQuit($oIE)
	Return
	EndIf
EndFunc
Func cont2()
	_IELoadWait($oIE,0,1000)
	If @error = 0 Then
		If StringInStr (_IEPropertyGet ($oIE, "title"),$oArt, 2) = 0 Then
			GUICtrlSetData ($Lwin, "Lyrics Not Found...")
			RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main", "Display Inline Images", "REG_SZ", "yes")
			_IEQuit($oIE)
			Return
		EndIf
	$lyrics = StringTrimRight (StringTrimLeft (_IEBodyReadText ($oIE), StringLen ($r) + 14), 23)
	$o = FileOpen (@ScriptDir & "\Lyrics\" & $r & ".mp3.txt", 10)
	FileWrite ($o, $lyrics)
	FileClose ($o)
	GUICtrlSetData ($Lwin, $r & @CRLF & @CRLF & $lyrics)
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main", "Display Inline Images", "REG_SZ", "yes")
	_IEQuit($oIE)
	Else
	GUICtrlSetData ($Lwin, "Lyrics Not Found...")
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main", "Display Inline Images", "REG_SZ", "yes")
	_IEQuit($oIE)
	Return
	EndIf
EndFunc



Func save()
	$Tit = WinGetTitle ($H2)
	$lyrics = StringReplace (GUICtrlRead ($Lwin), $Tit & @CRLF & @CRLF, "")
	$o = FileOpen (@ScriptDir & "\Lyrics\" & $Tit & ".mp3.txt", 10)
	FileWrite ($o, $lyrics)
	FileClose ($o)
	Lyrics()
EndFunc   ;==>save

Func Delete()
	$Tit = WinGetTitle ($H2)
	FileDelete(@ScriptDir & "\Lyrics\" & $Tit & ".mp3.txt")
	GUICtrlSetData($Lwin,"")
EndFunc

Func play()
	If $var1 = 1 Then
	$r = GUICtrlRead ($Ld)
	If $r = "" Then Return
		_SoundClose ($m)
		_FileReadToArray ($lst, $ar)
		$s = _ArraySearch ($ar, $r, 1, 0, 0, True)
		$path = FileReadLine ($lst, $s)
		$m = _SoundOpen ($path)
			If @error = 2 Then
				MsgBox(0,"Info","File not Found")
				Return
			EndIf
		$msg = $r&"          - "&_SoundLength ($m, 1)&" -          "
		$sp = StringSplit($msg,"")
		$var2 = 1
		$cont = 0
		$sL = _SoundLength ($m, 2)
		$k = _GUICtrlListSelectedIndex ($Ld)
		If GUICtrlRead($B1) = ">" Then Lyrics()
	EndIf
		_SoundPlay ($m)
		WinSetTitle ($H1, "", $r & "     " & $P)
		GUICtrlSetOnEvent ($B3, "pause")
EndFunc

Func pause()
	_SoundPause ($m)
	$var1 = 0
	WinSetTitle ($H1, "", "Paused" & "     " & $P)
	GUICtrlSetOnEvent ($B3, "play")
EndFunc

Func stop()
	_SoundStop ($m)
	_SoundClose ($m)
	$var1 = 1
	WinSetTitle ($H1, "", "Stopped" & "     " & $P)
	GUICtrlSetData ($Spos, 0)
	GUICtrlSetOnEvent ($B3, "play")
EndFunc

Func Nxt()
	$si = _GUICtrlListSelectedIndex ($Ld)
	$cnt = _GUICtrlListCount ($Ld)
	$var1 = 1
	If GUICtrlRead ($CB1) = $GUI_CHECKED Then
		_GUICtrlListSelectIndex ($Ld, Random (1, $cnt))
		play()
		Return
	EndIf
	If $cnt = $si+1 Then
		_GUICtrlListSelectIndex ($Ld, 0)
		play()
		Return
	EndIf
	_GUICtrlListSelectIndex ($Ld, $si + 1)
	play()
EndFunc

Func prevs()
	$si = _GUICtrlListSelectedIndex ($Ld)
	$cnt = _GUICtrlListCount ($Ld)
	$var1 = 1
	If GUICtrlRead ($CB1) = $GUI_CHECKED Then
		_GUICtrlListSelectIndex ($Ld, Random (1, $cnt))
		play()
		Return
	EndIf
	If $si = 0 Then
		_GUICtrlListSelectIndex ($Ld, $cnt-1)
		play()
		Return
	EndIf
	_GUICtrlListSelectIndex ($Ld, $si - 1)
	play()
EndFunc

Func Volume()
    SoundSetWaveVolume (GuiCtrlRead ($vs))
	GUICtrlSetTip ($vs, "Volume = "&GuiCtrlRead ($vs))
EndFunc

Func Pos()
	$newpos = GUICtrlRead($Spos)
	$pos = ($newpos/100)*$sL
	_TicksToTime($pos,$hour,$min,$sec)
	_SoundSeek($m,$hour,$min,$sec)
	_SoundPlay($m)
EndFunc

Func Ex()
	Exit
EndFunc

Func OnAutoItExit ()
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main", "Display Inline Images", "REG_SZ", "yes")
		_IEQuit($oIE)
EndFunc

;==================================================
Func catchguikey(); =====function from FAQ
    If WinGetHandle("active") = $H1 Then
        If @HotKeyPressed = "^f" Then
		find()
		ElseIf @HotKeyPressed = "{ENTER}" Then
		play()
        EndIf
    Else
        HotKeySet(@HotKeyPressed)
        Send(@HotKeyPressed)
        HotKeySet(@HotKeyPressed, "catchguikey")
    EndIf
EndFunc

Func _DirListToArray($sPath);======= By: MsCreatoR
    Local $i, $j, $rlist[1]=[0], $blist, $alist=_FileListToArray ($sPath, '*', 2)
    If IsArray ($alist) Then
        For $i=1 To $alist [0]
            _ArrayAdd ($rlist, $sPath & "\" & $alist [$i])
            $blist = _DirListToArray ($sPath & "\" & $alist [$i])
            If $blist[0]>0 Then
                For $j=1 To $blist [0]
                    _ArrayAdd ($rlist, $blist [$j])
                Next
            EndIf
        Next
    EndIf
    $rlist [0] = UBound ($rlist) - 1
    Return $rlist
EndFunc
;===================================


While 1
	Sleep (1000)
	$scrl= _StringInsert(StringTrimLeft($msg,1),$sp[$var2],StringLen($msg)-1) ;scroll
	$msg = $scrl
	GUICtrlSetData($L4,$scrl)
	$var2 = $var2+1
	If $var2 = StringLen($msg) Then $var2 = 1

	$pos = _SoundPos ($m, 2)
	$pcnt = ($pos / $sL) * 100
	_TicksToTime($pos,$hour,$min,$sec)
	_TicksToTime($sL-$pos,$hourR,$minR,$secR)
	GUICtrlSetData ($Spos, $pcnt)
	GUICtrlSetData ($L2, $hourR&$minR&":"&$secR&" >")
	GUICtrlSetData ($L3, "> "&$hour&$min&":"&$sec)

	$var3 = $var3+1
	If $var3 = 15 Then
		If $cont = 1 Then Cont1()
		If $cont = 2 Then Cont2()
		If $cont = 0 Then $var3 = 0
	EndIf

	If $pcnt = 100 Then
		$si = _GUICtrlListSelectedIndex ($Ld)
		$cnt = _GUICtrlListCount ($Ld)
		$var1 = 1
		If GUICtrlRead ($CB2) = $GUI_CHECKED Then
			_GUICtrlListSelectIndex ($Ld, $k)
			play()
		ElseIf GUICtrlRead ($CB1) = $GUI_CHECKED Then
			_GUICtrlListSelectIndex ($Ld, Random (1, $cnt))
			play()
		ElseIf $cnt = $si + 1 Then
			_GUICtrlListSelectIndex ($Ld, 1)
			play()
		Else
			_GUICtrlListSelectIndex ($Ld, $si + 1)
			play()
		EndIf
	EndIf
WEnd