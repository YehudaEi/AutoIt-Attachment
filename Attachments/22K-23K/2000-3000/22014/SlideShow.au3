#cs ----------------------------------------------------------------------------

 A Slideshow application similar to the Vista widget (Stays on top of all windows)
 you can specifiy (via an ini file). 
 
 The
 Size and position of the show, as well as the frequencey images are editable.
 The image is scaled to fit and then centred verticall & horizontally in the 
    viewport defined by the widh and height 
 There is also the ability to hide the image if it gets in the way Or
    work sequentially through a list of images in a text File (the app
    allows you to create a list by trawling through a directory and all 
    sub-directories to create a list of jpg files)
 For the paranoind you can even encrypt the slideshowfile
 
 left clicking on an image hides it for you (if set on in the ini file)
 
 When in slideshow mode
	Right clicking on the middle third of an image fits it to full-screen and copies it to the clipboard when it is closeed
	Right clicking on the right third of an image moves to the next image
	Right clicking on the left third of an image shows the previous image
 
 When in Full-screen mode
	Right clicking on the right third of an image moves to the next image
	left clicking on an image hides it for you
	
 A Taskbar menu allows you to
    Toggle the Viewstate of the show
    Select a diferent Show
    Create a new show
    Edit & save the settings
    Exit the applicatiopn

  
 Then file "_GDIClip.au3" is a direct copy of some UDF's created by Progandy
  !!! Some really fantastic work !!! see 
	http://www.autoitscript.com/forum/index.php?showtopic=70237
 (There are 2 constants replaced by values)

#ce ----------------------------------------------------------------------------
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
#Include <Array.au3>
#Include <GDIPlus.au3>
#Include <String.au3>
#Include <Misc.au3>
#Include <Clipboard.au3>
#Include "_GDIClip.au3"

$mykey = "{87981060-4374-4680-9BEF-85FEEAF1A491}"
$thisisme = "{C597E81E-F52F-4C0F-9C1D-CE3684C60493}"

_Singleton($thisisme, 0)

Opt("GUIOnEventMode", 1)

Opt("TrayOnEventMode",1)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)

Opt("MouseCoordMode",0)

Global $ShowRunning = 1
GLOBAL $Settings


Init()
ToggleViewState()
ReadShow()
CreateTrayItems()

While 1
	If $Timer = $picDelay Then
		If $ShowRunning = 1 Then
			ChangeImage()
		EndIf
	EndIf
	
	Sleep(100)
	UpdateTimer()
WEnd

Func Init()
	
	Global $picRandom = IniRead("slideshow.ini","Defaults","Random","1")
	Global $picDelay = IniRead("slideshow.ini","Defaults","Delay","300") * 10
	Global $Timer = $picDelay
	Global $Encrypted_Showfile = IniRead("slideshow.ini","Defaults","Encrypted","0")
	Global $HideonClick = IniRead("slideshow.ini","Defaults","HideOnClick","0")
	Global $MaxWidth = IniRead("slideshow.ini","Defaults","Width",@DesktopWidth) 	; image Size
	Global $MaxHeight = IniRead("slideshow.ini","Defaults","Height",@DesktopHeight) 	; image Size

	Global $Fit_Width_Height = $MaxWidth / $MaxHeight	; 1 = Square 	<1 = portrait	>1 =Landscape

	Global $Top_of_Widget = IniRead("slideshow.ini","Defaults","Top","0")	; top of widget 
	Global $right = IniRead("slideshow.ini","Defaults","Right","0")

	Global $Background =   IniRead("slideshow.ini","Defaults","Background","0xFF006B9F")	; Background colour ; XP default
	Global $hBrush1 = 0

	Global $maximages = 0 ; the number if images in the show
	Global $Thisimage = 0 ; the current image
	Global $ImageFileName = ""
	Global $PrevImage = ""
	Global $bigarray[1]
	
	$Showstring = IniRead("slideshow.ini","Defaults","FileName","show.txt")
	Global $Show_file = FileOpen($Showstring,0)	
	If $Show_file = -1 Then
		MsgBox(0, "File Open Error", "Unable to open slideshow file - " & $Showstring)
		IF Not FileExists($Showstring) Then
			FileWriteLine($Showstring,"")
			Global $Show_file = FileOpen($Showstring,0)	
		Else
			Exit
		EndIf
	EndIf

	_GDIPlus_Startup()
	$hBrush1 = _GDIPlus_BrushCreateSolid ($Background)
	
	#Region ### START Koda GUI section ### Form=
	Global $Form1 = GUICreate($thisisme, $MaxWidth, $MaxHeight, @DesktopWidth - $MaxWidth - $right, $Top_of_Widget, BitOR($WS_SYSMENU,$WS_POPUP,$WS_CLIPSIBLINGS), $WS_EX_TOPMOST + $WS_EX_TOOLWINDOW)
	GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "LeftMousetEvent",$Form1)
	GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "RightMousetEvent",$Form1)
	
	Global $Form2 = GUICreate($thisisme, @DesktopWidth , @DesktopHeight , 0, 0, BitOR($WS_SYSMENU,$WS_POPUP,$WS_CLIPSIBLINGS), $WS_EX_TOPMOST + $WS_EX_TOOLWINDOW)
	GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "KillBigOne",$Form2)
	GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "BigNextEvent",$Form2)
	#EndRegion ### END Koda GUI section ###
	
EndFunc

Func ReadShow()
	$maximages = 0
	While 1		; as easy as _FileReadToArray and check index[0] but faster 
		$line = FileReadLine($Show_file)
		If @error = -1 Then ExitLoop
		$maximages += 1
	Wend

EndFunc

Func ChangeImage($ActionFlag=0)
	If $ActionFlag = 1 Then
		$ImageFileName = $PrevImage			;show the previous image
	ElseIf $ActionFlag = 2 Then
		; do Nothing
	Else
		$PrevImage = $ImageFileName
		If $Encrypted_Showfile = 1 Then
			$ImageFileName = _StringEncrypt(0,ReadShowFile(),$mykey)
		Else
			$ImageFileName = ReadShowFile()
		EndIf
		
	EndIf
	
	$OriginalImage = _GDIPlus_BitmapCreateFromFile ($ImageFileName)
	$Image_Width = _GDIPlus_ImageGetWidth ($OriginalImage)
    $Image_Height = _GDIPlus_ImageGetHeight ($OriginalImage)
	
	$Image_Width_Height = $Image_Width / $Image_Height	

	If $Fit_Width_Height = 1 Then		; Square
		If $Image_Width > $Image_Height  Then; landscape
			$Image_Width = $MaxWidth
			$Image_Height = Int($Image_Width / $Image_Width_Height)
		Else
			$Image_Height = $MaxHeight
			$Image_Width = Int($Image_Height * $Image_Width_Height)
		EndIf
	Else
		If $Fit_Width_Height > 1 Then		; landscape
			If $Fit_Width_Height < $Image_Width_Height Then
				If $Image_Width > $Image_Height  Then; landscape
					$Image_Width = $MaxWidth
					$Image_Height = Int($Image_Width / $Image_Width_Height)
				Else
					$Image_Height = $MaxHeight
					$Image_Width = Int($Image_Height * $Image_Width_Height)
				EndIf
			Else
				$Image_Height = $MaxHeight
				$Image_Width = Int($Image_Height * $Image_Width_Height)
			EndIf
		Else	;portrait
			If $Fit_Width_Height < $Image_Width_Height Then
				$Image_Width = $MaxWidth
				$Image_Height = Int($Image_Width / $Image_Width_Height)
			Else
				$Image_Height = $MaxHeight
				$Image_Width = Int($Image_Height * $Image_Width_Height)
			EndIf
		EndIf
	EndIf
	
	$graphics = _GDIPlus_GraphicsCreateFromHWND($Form1)

; draw a filled rectangle to erase the imagerectangle
	_GDIPlus_GraphicsFillRect($graphics, 0, 0, $MaxWidth, $MaxHeight,$hBrush1)
	
; Centre the image on the filled rectangle	
	_GDIPlus_GraphicsDrawImageRect($graphics, $OriginalImage, ($MaxWidth - $Image_Width)/2, ($MaxHeight - $Image_Height) / 2, $Image_Width, $Image_Height)
	_GDIPlus_GraphicsDispose($graphics)
	_GDIPlus_ImageDispose ($OriginalImage)
    _WinAPI_DeleteObject ($OriginalImage)

EndFunc

Func ReadShowFile()
	If $picRandom = 0 Then	
		$Thisimage +=1
		If $Thisimage > $maximages Then $Thisimage = 1	; yes I know we can simply read and test for EOF, but this is easier
		Return FileReadLine($Show_file,$Thisimage)
	Else
		Return FileReadLine($Show_file,Int(Random(1,$maximages,1)))
	EndIf
EndFunc

Func CreateTrayItems()


	$tv = TrayCreateItem ("Toggle Viewstate")
	TrayItemSetOnEvent(-1,"ToggleViewState")
	TrayCreateItem ("")
	$ts = TrayCreateItem ("Select new Show")
	TrayItemSetOnEvent(-1,"NewShow")
	$tc = TrayCreateItem ("Create new Show")
	TrayItemSetOnEvent(-1,"CreateShow")
	TrayCreateItem ("")
	$tt = TrayCreateItem ("Edit Settings")
	TrayItemSetOnEvent(-1,"EditSettings")
	TrayCreateItem ("")
	$te = TrayCreateItem ("Exit")
	TrayItemSetOnEvent(-1,"AppExit")
 
EndFunc

Func LeftMousetEvent()
	If $HideonClick = 1 Then
		ToggleViewState()
	EndIf
	sleep(100)
EndFunc

Func ToggleViewState()
	If bitand(WinGetState ( $thisisme),2) then ;= 2 Then ; visible
		$ShowRunning = 0
		GUISetState(@SW_HIDE,$Form1)
	Else
		$ShowRunning = 1
		GUISetState(@SW_SHOW,$Form1)
		ChangeImage(1)
	EndIf
	
EndFunc

Func NewShow()
	$ShowRunning = 0
	
	$Show_filestring = FileOpenDialog("New Showfile",@scriptdir,"Slideshow Text File (*.txt)")
	$Show_file = FileOpen($Show_filestring,0)	
	If $Show_file = -1 Then
		MsgBox(0, "File Open Error", "Unable to open slideshow file, using default.")
		$Show_file = FileOpen(IniRead("slideshow.ini","Defaults","FileName","show.txt"),0)	
	EndIf
	ReadShow()
	ChangeImage()
	$Timer = $picDelay
	
	$ShowRunning = 1
EndFunc

Func RightMousetEvent()
	If MouseGetPos(0) > $MaxWidth / 3 * 2 Then		; right hand 3rd of the image so go get next image
		ChangeImage()
		$Timer = $picDelay
	ElseIf MouseGetPos(0) < $MaxWidth / 3  Then 	; left hand 3rd of the image go back to previous image
		ChangeImage(1)
		$Timer = $picDelay
	Else										; Center 3rd of the image so show a BIG one
		$ShowRunning = 0
		ShowBigOne()
	EndIf
	sleep(100)
EndFunc	

Func ShowBigOne()
	
Local $Fit_Width_Height = @DesktopWidth / @DesktopHeight	; 1 = Square 	<1 = portrait	>1 =Landscape	

	GUISetState(@SW_SHOW,$Form2)
	
	Local $OriginalImage = _GDIPlus_BitmapCreateFromFile ($ImageFileName)
	local $Image_Width = _GDIPlus_ImageGetWidth ($OriginalImage)
    local $Image_Height = _GDIPlus_ImageGetHeight ($OriginalImage)
	
	local $Image_Width_Height = $Image_Width / $Image_Height	
	
	If $Fit_Width_Height = 1 Then		; Square
		If $Image_Width > $Image_Height  Then; landscape
			$Image_Width = @DesktopWidth
			$Image_Height = Int($Image_Width / $Image_Width_Height)
		Else
			$Image_Height = @DesktopHeight
			$Image_Width = Int($Image_Height * $Image_Width_Height)
		EndIf
	Else
		If $Fit_Width_Height > 1 Then		; landscape
			If $Fit_Width_Height < $Image_Width_Height Then
				If $Image_Width > $Image_Height  Then; landscape
					$Image_Width = @DesktopWidth
					$Image_Height = Int($Image_Width / $Image_Width_Height)
				Else
					$Image_Height = @DesktopHeight
					$Image_Width = Int($Image_Height * $Image_Width_Height)
				EndIf
			Else
				$Image_Height = @DesktopHeight
				$Image_Width = Int($Image_Height * $Image_Width_Height)
			EndIf
		Else	;portrait
			If $Fit_Width_Height < $Image_Width_Height Then
				$Image_Width = @DesktopWidth
				$Image_Height = Int($Image_Width / $Image_Width_Height)
			Else
				$Image_Height = @DesktopHeight
				$Image_Width = Int($Image_Height * $Image_Width_Height)
			EndIf
		EndIf
	EndIf
			
	local $graphics2 = _GDIPlus_GraphicsCreateFromHWND($Form2)

; draw a filled rectangle to erase the imagerectangle
	_GDIPlus_GraphicsFillRect($graphics2, 0, 0, @DesktopWidth, @DesktopHeight, $hBrush1)
	
; Centre the image on the filled rectangle	
	$thingy = _GDIPlus_GraphicsDrawImageRect($graphics2, $OriginalImage, (@DesktopWidth - $Image_Width)/2, (@DesktopHeight - $Image_Height) / 2, $Image_Width, $Image_Height)

	_GDIPlus_GraphicsDispose($graphics2)
	_GDIPlus_ImageDispose ($OriginalImage)
    _WinAPI_DeleteObject ($OriginalImage)
EndFunc

Func KillBigOne()
	_ImageToClip($ImageFileName)
	GUISetState(@SW_HIDE,$Form2)
	GUISetState(@SW_SHOW,$Form1)
	$Timer = $picDelay
	$ShowRunning = 1
	ChangeImage()
EndFunc

Func BigNextEvent ()
	
	If MouseGetPos(0) > @DesktopWidth / 3 * 2 Then		; right hand 3rd of the image so go get next image
		ChangeImage()
		ShowBigOne()
		$ShowRunning = 0
	EndIf
	Sleep(100)
EndFunc

Func CreateShow()
	$ShowRunning = 0
	Global $base = FileSelectFolder("Choose a folder.","87981060-4374-4680-9BEF-85FEEAF1A491")
	If @Error=1 Then
		MsgBox (0,"","No Files\Folders Found.")
		$ShowRunning = 1
		Return
	EndIf

	dim $root[3]
	dim $bigarray[1]	; array of directories
	$bigarray[0] = 0
	CreateFolderList()
	CreateFileList()
	MsgBox(0,"Done","Slideshow Created")
	ReDim $bigarray[1]
	$ShowRunning = 1
	
EndFunc

Func CreateFolderList()
	$inilist = _FileListToArray($base,"*.",2)
	$l2 = 0
	If isarray($inilist) Then
		While $l2 < $inilist[0]
			$l2 +=1
			_ArrayAdd($bigarray, $base & "\" & $inilist[$l2])
			$bigarray[0] += 1
		WEnd
	EndIf
	
	$loop = 0
	while $loop < $bigarray[0]
		$loop +=1
		FindDirs($bigarray[$loop]) 
	WEnd

EndFunc

Func FindDirs($fromhere) 
	local  $dirlist
	$dirlist = _FileListToArray($fromhere,"*.",2)
	If IsArray($dirlist) Then
		For $l3 = 1 to $dirlist[0]
			_ArrayAdd($bigarray,$fromhere & "\" & $dirlist[$l3])
			$bigarray[0] += 1
		Next
	EndIf
EndFunc

Func CreateFileList()
	
	$of = FileOpen(InputBox("Get show filename", "Show filename" & @CRLF & "(Created in current Directory)","show.txt"),2)
	; The root directory
	$FL = _FileListToArray($base & "\","*.jpg",1)
	If IsArray($FL) Then
		For $l2 = 1 To $FL[0]
			If $Encrypted_Showfile = 1 Then
				FileWriteLine($of,_StringEncrypt(1,$base & "\"  & $FL[$l2],$mykey))
			Else
				FileWriteLine($of,$base & "\" & $FL[$l2])
			EndIf
		Next
	EndIf
	
	For $l1 = 1 to $bigarray[0]
		$FL = _FileListToArray($bigarray[$l1],"*.jpg",1)
		If IsArray($FL) Then
			For $l2 = 1 To $FL[0]
				If $Encrypted_Showfile = 1 Then
					FileWriteLine($of,_StringEncrypt(1,$bigarray[$l1] & "\" & $FL[$l2],$mykey))
				Else
					FileWriteLine($of,$bigarray[$l1] & "\" & $FL[$l2])
				EndIf
			Next
		EndIf
	Next
	FileClose ($of)
EndFunc

Func EditSettings()

	$ShowRunning = 0
	$Settings = GUICreate("Settings",420,280)
	
	GUICtrlCreateLabel("Slideshow File",18,5)
	Global $S1 = GUICtrlCreateInput("",90,0,300)
	GUICtrlSetData(-1,IniRead("slideshow.ini","Defaults","FileName","show.txt"))
	GUICtrlCreateButton("...",390,1,20,20)
	GUICtrlSetOnEvent(-1,"ShowBrowse")
	
	GUICtrlCreateLabel("Width",58,30)
	Global $S2 = GUICtrlCreateInput("",90,25,50)
	GUICtrlSetData(-1,$MaxWidth)
	GUICtrlCreateUpdown($S2)
	
	GUICtrlCreateLabel("Height",55,55)
	Global $S3 = GUICtrlCreateInput("",90,50,50)
	GUICtrlSetData(-1,$MaxHeight)
	GUICtrlCreateUpdown($S3)
	
	GUICtrlCreateLabel("Top Margin",32,80)
	Global $S4 = GUICtrlCreateInput("",90,75,50)
	GUICtrlSetData(-1,$Top_of_Widget)
	GUICtrlCreateUpdown($S4)
	
	GUICtrlCreateLabel("Right Margin",26,105)
	Global $S5 = GUICtrlCreateInput("",90,100,50)
	GUICtrlSetData(-1,$right)
	GUICtrlCreateUpdown($S5)
	
	GUICtrlCreateLabel("Delay (Seconds)",8,130)
	Global $S6 = GUICtrlCreateInput("",90,125,50)
	GUICtrlSetData(-1,$picDelay/10)
	GUICtrlCreateUpdown($S6)
	
	GUICtrlCreateLabel("Random Image",13,152)
	Global $S7 = GUICtrlCreateCheckbox("",90,145,100)
	If $picRandom = 1 Then
		GUICtrlSetState(-1,$GUI_CHECKED)
	EndIf
	
	GUICtrlCreateLabel("Encrypted Show",8,173)
	Global $S8 = GUICtrlCreateCheckbox("",90,165,100)
	If $Encrypted_Showfile = 1 Then
		GUICtrlSetState(-1,$GUI_CHECKED)
	EndIf
	
	GUICtrlCreateLabel("Hide on Click",22,193)
	Global $S10 = GUICtrlCreateCheckbox("",90,185,100)
	if $HideonClick = 1 Then
		GUICtrlSetState(-1,$GUI_CHECKED)
	EndIf
	
	GUICtrlCreateLabel("Background",27,220)
	Global $S9 = GUICtrlCreateInput("",90,215,100)
	GUICtrlSetData(-1,$Background)
	
	GUICtrlCreateButton("Save Settings",90,250)
	GUICtrlSetOnEvent(-1, "SaveSettings")
	
	GUISetState(@SW_SHOW,$Settings)
EndFunc

Func ShowBrowse()
	GUICtrlSetData($S1,FileOpenDialog("New Showfile",@scriptdir,"Slideshow Text File (*.txt)"),"Show.txt")
EndFunc

Func SaveSettings()
	IniWrite("slideshow.ini","Defaults","FileName",GUICtrlRead($S1))
	IniWrite("slideshow.ini","Defaults","Width",GUICtrlRead($S2))
	IniWrite("slideshow.ini","Defaults","Height",GUICtrlRead($S3))
	IniWrite("slideshow.ini","Defaults","Top",GUICtrlRead($S4))
	IniWrite("slideshow.ini","Defaults","Right",GUICtrlRead($S5))
	IniWrite("slideshow.ini","Defaults","Delay",GUICtrlRead($S6))
	If GUICtrlRead($S7) = $GUI_CHECKED Then
		IniWrite("slideshow.ini","Defaults","Random","1")
	Else
		IniWrite("slideshow.ini","Defaults","Random","0")
	EndIf
	
	If GUICtrlRead($S8) = $GUI_CHECKED Then
		IniWrite("slideshow.ini","Defaults","Encrypted","1")
	Else
		IniWrite("slideshow.ini","Defaults","Encrypted","0")
	EndIf
	
	If GUICtrlRead($S10) = $GUI_CHECKED Then
		IniWrite("slideshow.ini","Defaults","HideOnClick","1")
	Else
		IniWrite("slideshow.ini","Defaults","HideOnClick","0")
	EndIf

	IniWrite("slideshow.ini","Defaults","Background",GUICtrlRead($S9))

	GUIDelete ($Form1)
	GUIDelete ($Form2)
	GUIDelete($Settings)
	Init()
	ReadShow()
	$Timer = $picDelay
	ToggleViewState()
	ChangeImage()
	$ShowRunning = 1
EndFunc

Func UpdateTimer()
	If $ShowRunning = 1 Then
		$Timer += 1
		If $Timer > $picDelay Then
			$Timer = 0
		EndIf
	EndIf
EndFunc

Func AppExit()
	_GDIPlus_BrushDispose ($hBrush1)
	_GDIPlus_ShutDown ()
	GUIDelete($Form1)
	Exit
EndFunc