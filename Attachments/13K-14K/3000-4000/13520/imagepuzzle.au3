#include <GUIConstants.au3>
Opt("TrayAutoPause",0)

GUICreate("Image Puzzle",375,20)
$custom=GUICtrlCreateButton("Open image",0,0,80,20)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
$check=GUICtrlCreateButton("Check",260,0,40,20)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
$custx=GUICtrlCreateInput("5",80,0,20,20)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
$custy=GUICtrlCreateInput("5",105,0,20,20)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
GUICtrlCreatelabel("Steps:",130,5)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
$steps=GUICtrlCreatelabel("0",165,5,30)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
GUICtrlCreatelabel("Time:",195,5)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
$timerlabel=GUICtrlCreatelabel("0",225,5,30)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
GUICtrlCreatelabel("Size(%):",305,5)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
$scalelabel=GUICtrlCreateInput("100",345,0,30,20)
GUICtrlSetResizing (-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
GUISetState()

local $lasty=0,$lastx=0,$timesum=0

while 1
	$msg=GUIGetMsg()
	Select
	case ($timesum <> 0) and (TimerDiff($timer) > $timesum*1000) 
		GUICtrlSetData($timerlabel,$timesum)
		$timesum +=1;int(TimerDiff($timer)/1000)-$timesum
	case $msg=$check
		if ($lasty <> 0) and ($lastx <> 0) then
			$wrong=0
			for $i=0 to $lastx-1
				for $j=0 to $lasty-1
					if ($original[$i][$j]<>$image[$i][$j]) and ($original[$i][$j]<>$original[$lastx-1][$lasty-1]) then
						$wrong=1
						exitloop
					endif
				next
			next
			if $wrong then
				msgbox(0,"Wrong","The puzzle is not finished!")
			Else
				msgbox(0,"Success","Congratulations you have finished the puzzle in "&GUICtrlRead($steps)&" steps and in "&GUICtrlRead($timerlabel)&" seconds!")
				$timesum=0
				$timer=0
			endif
		endif
	case $msg=$GUI_EVENT_PRIMARYDOWN
		$mousepos=GUIGetCursorInfo()
		if ($mousepos[1]>25) and ($mousepos[1]<($imagesize[1]*$lasty+25)) and ($mousepos[0]<($imagesize[0]*$lastx)) then
			$replace=0
			if ((int($mousepos[0]/$imagesize[0])+1)<$lastx) then
				if ($image[$spacex][$spacey]=$image[int($mousepos[0]/$imagesize[0])+1][int(($mousepos[1]-25)/$imagesize[1])]) then
					$replace=1
				endif
			endif
			if ((int($mousepos[0]/$imagesize[0])-1)>-1) then
				if ($image[$spacex][$spacey]=$image[int($mousepos[0]/$imagesize[0])-1][int(($mousepos[1]-25)/$imagesize[1])]) then
					$replace=1
				endif
			endif
			if ((int(($mousepos[1]-25)/$imagesize[1])+1)<$lasty) then
				if ($image[$spacex][$spacey]=$image[int($mousepos[0]/$imagesize[0])][int(($mousepos[1]-25)/$imagesize[1])+1]) then
					$replace=1
				endif
			endif
			if ((int(($mousepos[1]-25)/$imagesize[1])-1)>-1) then
				if ($image[$spacex][$spacey]=$image[int($mousepos[0]/$imagesize[0])][int(($mousepos[1]-25)/$imagesize[1])-1]) then
					$replace=1
				endif
			endif
			if $replace Then
				GUICtrlSetPos($image[int($mousepos[0]/$imagesize[0])][int(($mousepos[1]-25)/$imagesize[1])],$spacex*$imagesize[0],$spacey*$imagesize[1]+25)
				$help=$image[$spacex][$spacey]
				$image[$spacex][$spacey]=$image[int($mousepos[0]/$imagesize[0])][int(($mousepos[1]-25)/$imagesize[1])]
				$image[int($mousepos[0]/$imagesize[0])][int(($mousepos[1]-25)/$imagesize[1])]=$help
				$spacex=int($mousepos[0]/$imagesize[0])
				$spacey=int(($mousepos[1]-25)/$imagesize[1])
				GUICtrlSetData($steps,GUICtrlRead($steps)+1)
			endif
		endif
	case $msg=-3
		Exit
	case $msg=$custom
		$file = FileOpenDialog("Choose Image",@MyDocumentsDir,"images (*.jpg)")
		if not @error then
			if ($lasty <> 0) and ($lastx <> 0) then
				for $i=0 to $lastx-1
					for $j=0 to $lasty-1
						GUICtrlDelete($original[$i][$j])
					next
				next
			endif
			Dim $S_DLL
			GUICtrlSetData($steps,0)
			$timesum=1
			$timer=TimerInit()
			$S_DLL = DllOpen("ProSpeed.dll")
			$scale=GUICtrlRead($scalelabel)
			$imagesize=_ImageGetSizeJPG($file)
				$imagesize[0]=int($imagesize[0]*($scale/100))
				$imagesize[1]=int($imagesize[1]*($scale/100))
			$lastx=GUICtrlRead($custx)
			$lasty=GUICtrlRead($custy)
			$cutx=int($imagesize[0]/$lastx)
			$cuty=int($imagesize[1]/$lasty)
			$winpos=WinGetPos("Image Puzzle")
			dim $image[$lastx][$lasty]
			SplashImageOn("",$file,$imagesize[0],$imagesize[1],0,0,1)
			for $i=0 to $lastx-1
				for $j=0 to $lasty-1
					do 
					Screenshot(@ScriptDir&"\"&$i&$j&".jpg",$cutx,$cuty,($cutx*$i)+1,($cuty*$j)+1,1)
					until FileExists(@ScriptDir&"\"&$i&$j&".jpg")
					$imagesize=_ImageGetSizeJPG(@ScriptDir&"\"&$i&$j&".jpg")
					do 
					$image[$i][$j]=GUICtrlCreatePic(@ScriptDir&"\"&$i&$j&".jpg",($imagesize[0]*$i),($imagesize[1]*$j)+25,$imagesize[0],$imagesize[1])
					until $image[$i][$j]<>0
					FileDelete(@ScriptDir&"\"&$i&$j&".jpg")
				Next
			Next
			dim $original=$image
			if (($imagesize[0]*$lastx+10) > 375) and (($imagesize[1]*$lasty+45) > 50) then
				WinMove ("Image Puzzle","", $winpos[0],$winpos[1],$imagesize[0]*$lastx+6,$imagesize[1]*$lasty+50)
			else
				WinMove ("Image Puzzle","", $winpos[0],$winpos[1],381,$imagesize[1]*$lasty+50)
			endif
			SplashOff()
			DllClose($S_DLL)
			GUICtrlDelete($image[$lastx-1][$lasty-1])
			$spacex=$lastx-1
			$spacey=$lasty-1
			for $i=1 to $lastx*$lasty*4
				do
					$randomx1=random(0,$lastx-1,1)
					$randomy1=random(0,$lasty-1,1)
					$randomx2=random(0,$lastx-1,1)
					$randomy2=random(0,$lasty-1,1)
				until (($randomx2<>($lastx-1)) or ($randomy2<>($lasty-1))) and (($randomx1<>($lastx-1)) or ($randomy1<>($lasty-1)))
				GUICtrlSetPos($image[$randomx2][$randomy2],$randomx1*$imagesize[0],$randomy1*$imagesize[1]+25)
				GUICtrlSetPos($image[$randomx1][$randomy1],$randomx2*$imagesize[0],$randomy2*$imagesize[1]+25)
				$help=$image[$randomx2][$randomy2]
				$image[$randomx2][$randomy2]=$image[$randomx1][$randomy1]
				$image[$randomx1][$randomy1]=$help
			next
		endif
	EndSelect
wend

Func Screenshot($S_path, $S_Width, $S_Height, $S_ShotPosX, $S_ShotPosY, $S_Type)
	$RAW_HDC = DllCall("user32.dll","ptr","GetWindowDC","hwnd","")
	$hDC     = "0x" & Hex($RAW_HDC[0])
	$S_Screen = DllCall($S_dll,"long","CreateExtBmp","long",$hDC,"long",$S_Width,"long",$S_Height)	
	DllCall($S_dll,"long","CopyExtBmp","long",$S_Screen[0],"long",0,"long",0,"long",$S_Width,"long",$S_Height,"long",$hDC,"long",$S_ShotPosX,"long",$S_ShotPosY,"long",0)	
	$S_FilePath = $S_path 
	DllCall($S_DLL,"long","SaveExtImage","long",$S_Screen[0],"str",$S_FilePath,"long",$S_Type,"long",10)
EndFunc

Func _ImageGetSizeJPG($sFile)
    Local $anSize[2], $sData, $sSeg, $nFileSize, $nPos = 3
    $nFileSize = FileGetSize($sFile)
    While $nPos < $nFileSize
        $sData = _FileReadAtOffsetHEX ($sFile, $nPos, 4)
        If StringLeft($sData, 2) = "FF" then; Valid segment start
            If StringInStr("C0 C2 CA C1 C3 C5 C6 C7 C9 CB CD CE CF", StringMid($sData, 3, 2)) Then; Segment with size data
               $sSeg = _FileReadAtOffsetHEX ($sFile, $nPos + 5, 4)
               $anSize[1] = Dec(StringLeft($sSeg, 4))
               $anSize[0] = Dec(StringRight($sSeg, 4))
               Return($anSize)
            Else
               $nPos= $nPos + Dec(StringRight($sData, 4)) + 2
            Endif
        Else
            ExitLoop
        Endif
    Wend
    Return("")
EndFunc

Func _FileReadAtOffsetHEX ($sFile, $nOffset, $nBytes)
    Local $hFile = FileOpen($sFile, 0)
    Local $sTempStr = ""
    FileRead($hFile, $nOffset - 1)
    For $i = $nOffset To $nOffset + $nBytes - 1
        $sTempStr = $sTempStr & Hex(Asc(FileRead($hFile, 1)), 2)
    Next
    FileClose($hFile)
    Return ($sTempStr)
Endfunc