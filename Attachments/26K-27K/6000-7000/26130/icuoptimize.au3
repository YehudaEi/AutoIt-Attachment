#NoTrayIcon
#include-once
#include <WinAPI.au3>
#include <GDIPlus.au3>
#Include <Array.au3>

Global $icufilename
Global Const $__SCREENCAPTURECONSTANT_SRCCOPY = 0x00CC0020
Global $giBMPFormat = $GDIP_PXF24RGB

Global $lfichiers[9999]

Global $icudir = IniRead(@ScriptDir & "\icu.ini", "Param", "folder", "L:\temp\")
Global $icufilename = $icudir & "c"
Global $icunum=0
Global $icuX = IniRead(@ScriptDir & "\icu.ini", "Param", "x",100)
Global $icuY = IniRead(@ScriptDir & "\icu.ini", "Param", "y",20)
Global $icuLarg = IniRead(@ScriptDir & "\icu.ini", "Param", "w",800)
Global $icuHaut = IniRead(@ScriptDir & "\icu.ini", "Param", "h",500)
Global $intervalle = IniRead(@ScriptDir & "\icu.ini", "Param", "intervalle",100)
Global $duree = IniRead(@ScriptDir & "\icu.ini", "Param", "dureeMaxi",60)


Global $icudesktop,$icuDDC,$icuCDC,$icuBMP,$icuCLSID,$icuhImage,$icupGUID, $icutGUID,$icubufferimage,$icubufferimage2
Global $BitmapData0,$BitmapData1,$icuScan0,$icuScan1,$icusize0,$ptr0,$ptr1
Global $postbat

$postbat="CD /D"& $icudir & @CRLF


$f=FileOpen($icudir &"nbfichiers.txt",0)
$icunum=FileRead($f)
FileClose($f)


SplashTextOn("Optimisation","En cours ; veuillez patienter...",260,80)

;----------Partie optimisation 1---------------------------------
_GDIPlus_Startup()
$ibuffer = _GDIPlus_ImageLoadFromFile($icufilename & '10001.bmp')
$numbuffer=1
sleep(12)
$ibuffer2 = _GDIPlus_ImageLoadFromFile($icufilename & '10002.bmp')
$numbuffer2=2
sleep(12)
$batch="CD /D "& $icudir & @CRLF
For $i=3 To $icunum
	$fichier = $icufilename & (10000+$i) &'.bmp'
	$image = _GDIPlus_ImageLoadFromFile($fichier)
	sleep(12)
	$tmp=CompareBitmaps($image, $ibuffer)
	If $tmp Then
		$batch &= "del /Q "& $fichier & @CRLF
		$lfichiers[$i]="-1"
	Else
		$tmp=CompareBitmaps($image, $ibuffer2)
		If $tmp Then
			$batch &= "del /Q "& $fichier & @CRLF
			$lfichiers[$i]="-2"
		Else
			$jpgimage = _GDIPlus_ImageLoadFromFile($fichier)
			$gdiCLSID = _GDIPlus_EncodersGetCLSID("JPG")
			_GDIPlus_ImageSaveToFile($jpgimage, $icufilename & (10000+$i) &'.jpg')
			Sleep(12)
			_GDIPlus_ImageDispose($jpgimage)

			If $numbuffer<$numbuffer2 Then
				$ibuffer = _GDIPlus_ImageLoadFromFile($fichier)
				$numbuffer=$i
				$lfichiers[$i]=1
			Else
				$ibuffer2 = _GDIPlus_ImageLoadFromFile($fichier)
				$numbuffer2=$i
				$lfichiers[$i]=2
			EndIf
		EndIf
	EndIf
Next
_GDIPlus_ImageDispose($image)
_GDIPlus_ImageDispose($ibuffer)
_GDIPlus_ImageDispose($ibuffer2)
_GDIPlus_Shutdown()
$lfichiers[1]=1
$lfichiers[2]=2

;;;$batch &= "exit" & @CRLF
$f=FileOpen($icudir & "deldoublon.bat",2)
FileWrite($f,"CD /D "& $icudir & @CRLF &"tasklist"& @CRLF &"del /Q *.bmp"& @CRLF)
FileClose($f)
sleep(250)
Run($icudir &"deldoublon.bat")
sleep(250)
$f=FileOpen($icudir &"listefichiers.txt",2)
FileWrite($f,_ArrayToString($lfichiers,'|'))
FileClose($f)
SplashOff()
Sleep(250)
Run("cmd /c" & $icudir &"deldoublon.bat",$icudir)
Exit





Func CompareBitmaps($bm1, $bm2)
    $Bm1W = _GDIPlus_ImageGetWidth($bm1)
    $Bm1H = _GDIPlus_ImageGetHeight($bm1)
    $BitmapData1 = _GDIPlus_BitmapLockBits($bm1, 0, 0, $Bm1W, $Bm1H, $GDIP_ILMREAD, $GDIP_PXF32RGB)
    $Stride = DllStructGetData($BitmapData1, "Stride")
    $Scan0 = DllStructGetData($BitmapData1, "Scan0")
    $ptr1 = $Scan0
    $size1 = ($Bm1H - 1) * $Stride + ($Bm1W - 1) * 4

    $Bm2W = _GDIPlus_ImageGetWidth($bm2)
    $Bm2H = _GDIPlus_ImageGetHeight($bm2)
    $BitmapData2 = _GDIPlus_BitmapLockBits($bm2, 0, 0, $Bm2W, $Bm2H, $GDIP_ILMREAD, $GDIP_PXF32RGB)
    $Stride = DllStructGetData($BitmapData2, "Stride")
    $Scan0 = DllStructGetData($BitmapData2, "Scan0")

    $ptr2 = $Scan0
    $size2 = ($Bm2H - 1) * $Stride + ($Bm2W - 1) * 4

    $smallest = $size1
    If $size2 < $smallest Then $smallest = $size2
    $call = DllCall("msvcrt.dll", "int:cdecl", "memcmp", "ptr", $ptr1, "ptr", $ptr2, "int", $smallest)

    _GDIPlus_BitmapUnlockBits($bm1, $BitmapData1)
    _GDIPlus_BitmapUnlockBits($bm2, $BitmapData2)

    Return ($call[0]=0)
EndFunc  ;==>CompareBitmaps
