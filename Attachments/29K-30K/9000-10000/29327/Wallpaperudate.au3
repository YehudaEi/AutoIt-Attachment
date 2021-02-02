#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\_Icons\Painting.ico
#AutoIt3Wrapper_Res_Fileversion=0.0.0.11
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
	yes I know there are a load of wallpaper rotators out there, but
	I wanted one where I would specify a folder of wallpapers as well as a folder of overlays
	(I use holiday photos as the wallpaper an the kids as an overlay)
	
	The program reads a list of wallpaper files into an array and randomises it. 
	The same is done with the list of overlays. I when walk through the wallpapers and overlays
	and create a wallpaper/overlay combinaton for display on the desktop
	
	what this does is create a new image with a second image overlaying the first.
	this code scales the second image to a percentage of the desktop height and places it 
	at the bottom of the screen and with a right margin sucked out of the ini file
	(two lines commented out and another two uncommented will centre the overlay in the wallpaper.)
	
	I run this on a Windows 7 PC (the best windows OS ever!) and I have fairly elevated rights,
	so if you are having problems, check folder rights or use other folders. It also handles 
	high quality jpgs as background images which I really like.
	
	I have jpg files as the backround and png's as the overlay (transparency support is why I use then)
	but you can use just about anything 
	
	There is a tray menu that allows you to 
		Turn overlays on/off
		skip to the next Overlay
		skip to the next wallpaper
		Skip to the next Wallpaper/Overlay Set
		Exit the application (clear overlay automatically.)
	
	Remember the trailing '\' on file paths in the ini file
	
everything between the pairs of ############## are the contents of an example ini file
THIS SHOULD BE CREATED BERFORE RUNNING THE PROGRAM
##############
;	Interval - Minutes between changes
;	Scale - % of desktop HEIGHT
;	WallType - filetype to use as wallpapers
;	OverlayType -filetype to use as overlays
;	FileType - Output filetype for the combined wallpper & Overlay 
; 	Margin - Right Margin
; 	Bottom - Bottom Margin
;	WithOverlay - do we want overlays (1=Yes) anything else is no.
;	ClearOnExit - clear the overlay on exit.
; 	OverlayPath - path to overlays
;	WallpaperSourcePath - Path to wallpapers to use
;	WallpaperPath - where we put the resultant compound image

[Defaults]
Interval=5
Scale=60
WallType=JPG
OverlayType=PNG
FileType=JPG
Margin=1
Bottom=0
WithOverlay=1
ClearOnExit=1
OverlayPath=C:\Users\paul\Pictures\overlay\overlay\
WallpaperSourcePath=C:\Users\paul\Pictures\Backgrounds\
WallpaperPath=C:\Users\paul\AppData\Roaming\Microsoft\Windows\Themes\
##############
	
	
TODO
Better error handling when files do not exist etc.
	
	
#ce

#Include <Misc.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#Include <Constants.au3>
#Include <File.au3>
#Include <Array.au3>
#include <GUIConstantsEx.au3>


Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 
opt("TrayIconDebug",1)

Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1); 
Opt('MustDeclareVars', 1)

Global $g_szVersion = "WallpaperUpdate 1.2"
If _Singleton($g_szVersion,1) = 0 Then
	Msgbox(0,"Warning","An occurence of " & $g_szVersion & " is already running",2)
	Exit
EndIf
	
Global $iniFile = "wallpaperupdate.ini"	

;  Bad practice I know, but anyway
Global $sCLSID=""
Global $sWallType=""
Global $sOverlayType=""
Global $sFileType = ""
Global $bWithOverlay=0	; 1 yes we want overlays, anything else, we dont
Global $hWithOverlay 
Global $hNoOverlay 
Global $iWallpaperDisplayTime = 0
Global $iOverlayDisplayTime = 0
Global $WallpaperInterval = 20
Global $OverlayInterval = 20
Global $iScale = 80
Global $iMargin = 80
Global $iBottom = 0
Global $sOverlayPath = ""
Global $sWallpaperSourcePath = ""
Global $sWallpaperPath = ""
Global $aWallpapers [1] [1]
Global $aOverlays [1] [1]
Global $iThisWallpaper = 0
Global $iThisOverlay = 0
Global $iClearOnExit = 0
Global $bO
Global $bW

Global $Settings
Global $S2
Global $S3
Global $S4
Global $S5
Global $S6
Global $S7
Global $S8
Global $S9
Global $S10
Global $S11
Global $S12
Global $S13
Global $S14


_Init()
_SetupTray()
_Main()

Func _Main()

Local $iSleeptime = 100

	While 1
		; effectively using a manual timer here to make sure that both the overlay and wallpaper change at the same time 
		; and not milliseconds betrween each other.
		Sleep($iSleeptime)
		
		$bO = 0
		$bW = 0
		
		If $bWithOverlay=1 Then
			If $OverlayInterval <= $iOverlayDisplayTime  Then ; time for a new overlay
				$bO = 1
			EndIf		
			$iOverlayDisplayTime += $iSleeptime 
		EndIf
	
		If $WallpaperInterval <= $iWallpaperDisplayTime Then	; time for a new wallpaper
			$bW = 1
		EndIf
		$iWallpaperDisplayTime += $iSleeptime 
		
		If $bO  = 1 Or $bW  = 1 Then
			_BuildNewWallpaper($bO,$bW)
		EndIf
	WEnd
	
EndFunc

Func _Init()

	local $aTemp, $iLooper
	
	$WallpaperInterval = IniRead($iniFile,"Defaults","WallpaperInterval","20")	; 20 Minutes between wallpaper changes.
	$WallpaperInterval = $WallpaperInterval *  1000 * 60
	$OverlayInterval = IniRead($iniFile,"Defaults","OverlayInterval","20")	; 20 Minutes between overlay changes.
	$OverlayInterval = $OverlayInterval * 1000 * 60
	$bWithOverlay = IniRead($iniFile,"Defaults","WithOverlay","0")	; No overlay
	$iScale = IniRead($iniFile,"Defaults","Scale","80")	; 80% of desktop height
	$sFileType = IniRead($iniFile,"Defaults","FileType","BMP")	; output wallpaper filetype
	$sWallType = IniRead($iniFile,"Defaults","WallType","BMP")	; output wallpaper filetype
	$sOverlayType = IniRead($iniFile,"Defaults","OverlayType","BMP")	; output wallpaper filetype
	$iMargin = IniRead($iniFile,"Defaults","Margin","80")	;	 right margin in px
	$iBottom = IniRead($iniFile,"Defaults","Bottom","0")	;	 right margin in px
	$sOverlayPath = IniRead($iniFile,"Defaults","OverlayPath","C:\Users\paull\Pictures\overlay\overlay\")
	$sWallpaperSourcePath = IniRead($iniFile,"Defaults","WallpaperSourcePath","C:\Users\paull\AppData\Roaming\Microsoft\Windows\Themes\")
	$sWallpaperPath = IniRead($iniFile,"Defaults","WallpaperPath",@ScriptDir & "\")
	$iClearOnExit = IniRead($iniFile,"Defaults","ClearOnExit","1")
	
	; this is ok for me, but if you have a large number of wallpapers it could be a little expensive.
	; ***Edit***
	$aTemp = _FileListToArray($sWallpaperSourcePath, "*." & $sWallType,1)
	If IsArray($aTemp) Then
		ReDim $aWallpapers[$aTemp[0]+1][2]
		; Randomize the Wallpaler but make sure that we cycle through them all before starting at the begining again.
		For $iLooper = 1 To $aTemp[0] 
			$aWallpapers[$iLooper][0] = $aTemp[$iLooper]
			$aWallpapers[$iLooper][1] = Random(1,$aTemp[0],1)
		Next
		; the actual randomising
		_ArraySort($aWallpapers,0,0,0,1)
	EndIf

	; this is ok for me, but if you have a large number of overlays it could be a little expensive.
	; I use png's here because they support transparency, but it could be just about Anything,
	; ***Edit***
	$aTemp = _FileListToArray($sOverlayPath, "*." & $sOverlayType,1)
	If IsArray($aTemp) Then
		ReDim $aOverlays[$aTemp[0]+1][2]
		; Randomize the overlays but make sure that we cycle through them all before starting at the begining again.
		For $iLooper = 1 To $aTemp[0]
			$aOverlays[$iLooper][0] = $aTemp[$iLooper]
			$aOverlays[$iLooper][1] = Random(1,$aTemp[0],1)
		Next
		$aTemp = 0	; a little tidying
		; the actual randomising
		_ArraySort($aOverlays,0,0,0,1)
	EndIf
	; Get encoder CLSID for wallpaper filetype 
	; this feels a hang of a waste just to get an encoder class Id but i don;t want to do it each time I create a new wallpaper
	_GDIPlus_Startup()
	$sCLSID = _GDIPlus_EncodersGetCLSID ($sFileType)
	_GDIPlus_Shutdown()
	
	; set the initial wallpaper
	_BuildNewWallpaper(1,1)

EndFunc
Func _SetupTray()
		;  set up a tray menu
	$hNoOverlay = TrayCreateItem("No Overlay",-1,-1,1)
	TrayItemSetOnEvent(-1,"_NoOverlay")
	If $bWithOverlay <> 1 Then
		TrayItemSetState ( -1, $TRAY_CHECKED )
	EndIf
	$hWithOverlay  = TrayCreateItem("With Overlay",-1,-1,1)
	TrayItemSetOnEvent(-1,"_WithOverlay")
	If $bWithOverlay = 1 Then
		TrayItemSetState ( -1, $TRAY_CHECKED )
	EndIf
	TrayCreateItem("")
	TrayCreateItem("Next Overlay")
	TrayItemSetOnEvent(-1,"_Next_Overlay")
	TrayCreateItem("Previous Overlay")
	TrayItemSetOnEvent(-1,"_Prev_Overlay")
	TrayCreateItem("")
	TrayCreateItem("Next Wallpaper")
	TrayItemSetOnEvent(-1,"_Next_Wallpaper")
	TrayCreateItem("Previous Wallpaper")
	TrayItemSetOnEvent(-1,"_Prev_Wallpaper")
	TrayCreateItem("Next Pair")
	TrayItemSetOnEvent(-1,"_Next_Pair")
	TrayCreateItem("")
	TrayCreateItem("Edit Settings")
	TrayItemSetOnEvent(-1,"_EditSettings")
	TrayCreateItem("")
	TrayCreateItem("Exit")
	TrayItemSetOnEvent(-1,"_ExitEvent")

	TraySetState()
	TraySetToolTip($g_szVersion)
EndFunc

Func _Next_Wallpaper() ; but keep same overlay
	$iWallpaperDisplayTime = 0
	_BuildNewWallpaper(0,1)
EndFunc
Func _Prev_Wallpaper() ; but keep same overlay
	$iWallpaperDisplayTime = 0
	_BuildNewWallpaper(0,-1)
EndFunc
Func _Next_Overlay() ; but keep same wallpaper
	$iOverlayDisplayTime = 0
	_BuildNewWallpaper(1,0)
EndFunc
Func _Prev_Overlay()	; but keep same wallpaper
	$iOverlayDisplayTime = 0
	_BuildNewWallpaper(-1,0)
EndFunc
Func _Next_Pair () ; change both wallpaper and overlay.
	$iWallpaperDisplayTime = 0
	$iOverlayDisplayTime = 0
	_BuildNewWallpaper(1,1)
EndFunc

Func _NoOverlay()	; remove overlays without changing the wallpaper
	$bWithOverlay = 0
	_BuildNewWallpaper(0,0)
EndFunc
Func _WithOverlay() ; re-instate overlays without changing the wallpaper or the overlay
	$iOverlayDisplayTime = 0
	$bWithOverlay = 1
	_BuildNewWallpaper(0,0)
EndFunc

Func _BuildNewWallpaper($iNextOverlay,$iNextwallpaper) 
	Local $hImage1, $hImage2, $hGraphic, $width, $height, $sFileName, $sNewFileName, $sOverlay, $Scaling, $top, $left

	; Initialize GDI+ library
	_GDIPlus_Startup()
	
	; pick a new overlay  and wallpaper
;~ 	$sOverlay = _PickOverlay($iNextOverlay) 
	$sFileName = _PickWallpaper($iNextwallpaper) 
	
	; ***Edit***
	$sNewFilename = $sWallpaperPath & "TranscodedWallpaper1." & $sFileType
	
	;Load the wallpaper
	$hImage1 = _GDIPlus_ImageLoadFromFile($sFileName)
	
	; add the overlay if we need to 
	If $bWithOverlay = 1 Then
		$sOverlay = _PickOverlay($iNextOverlay) 
		$hImage2 = _GDIPlus_ImageLoadFromFile($sOverlay)

		; calculate  the scaling to make sure that the overlay is the correct % of the background image 
		; (assuming that the background will be 100 % of desktop height)
		; This makes for large overlays if they have no height.
		
		If _GDIPlus_ImageGetHeight($hImage2) > @DesktopHeight * $iScale / 100 Then
			;scale image down if needed
			$Scaling = _GDIPlus_ImageGetHeight($hImage1) * $iScale / _GDIPlus_ImageGetHeight($hImage2) / 100
		Else
			;scale image up to the required percentage
			$Scaling =  _GDIPlus_ImageGetHeight($hImage1) * $iScale / 100 / _GDIPlus_ImageGetHeight($hImage2)
		EndIf
		$width = _GDIPlus_ImageGetWidth($hImage2) * $Scaling
		$height = _GDIPlus_ImageGetHeight($hImage2) * $Scaling

		; center the image vertically
		; ***Edit***
;~ 	 	$top = (_GDIPlus_ImageGetHeight($hImage1) - $height) / 2
		; or have it at the bottom of the screen
		$top = _GDIPlus_ImageGetHeight($hImage1) - $height - $iBottom
		
		; center the image horizontally
		; ***Edit***
;~ 		$left = (_GDIPlus_ImageGetWidth($hImage1) - $width) / 2
		; or with the left margin from the ini file
		$left = _GDIPlus_ImageGetWidth($hImage1) - $width - $iMargin
		
		; Draw one image in another
		$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)
		_GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage2, $left, $top, $width, $height )
		
		; Clean up resources
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_ImageDispose($hImage2)
		
		If $iNextOverlay = 1 Then $iOverlayDisplayTime = 0
		
	EndIf
	
	; Save resultant compound image
;~ 	_GDIPlus_ImageSaveToFile($hImage1, $sNewFileName) 
	_GDIPlus_ImageSaveToFileEx($hImage1, $sNewFileName,$sCLSID) 
	
	Sleep(100)	; this seems to stop the next call from hanging around and eating up the CPU
	; Set the new image as the wallpaper.  as it happens all the rest is fluff. This does all the work.
	DllCall("user32", "int", "SystemParametersInfo", "int", 20, "int", 0, "str", $sNewFileName, "int", 0)

	; Clean up resources
	_GDIPlus_ImageDispose($hImage1)
	
	; Shut down GDI+ library
	_GDIPlus_Shutdown()

	If $iNextwallpaper = 1 Then $iWallpaperDisplayTime = 0
	
EndFunc  

Func _PickWallpaper($iStep)
	; Continuously cycle through the list of randomised wallpapers  if we keep feeding a 1 
	; previous = -1 same one = 0
	$iThisWallpaper += $iStep
	If $iThisWallpaper = UBound($aWallpapers,1) Then
		$iThisWallpaper =1
	EndIf
	If $iThisWallpaper < 1 Then
		$iThisWallpaper = UBound($aWallpapers,1) - 1
	EndIf
	Local $sFileName
	$sFileName = $sWallpaperSourcePath & $aWallpapers[$iThisWallpaper] [0]
	Return $sFileName
EndFunc

Func _PickOverlay($iStep)
	; Continuously cycle through the list of randomised overlays if we keep feeding a 1 
	; -1 will obviously take us to the previous one and 0 stay in the same place.
	$iThisOverlay += $iStep
	If $iThisOverlay = UBound($aOverlays,1) Then
		$iThisOverlay =1
	EndIf
	If $iThisOverlay < 1 Then 
		$iThisOverlay = UBound($aOverlays,1) - 1
	EndIf
	local $sOverlay 
	$sOverlay = $sOverlayPath & $aOverlays[$iThisOverlay] [0]
	Return $sOverlay 
	
EndFunc

Func _CreateSettingsGui()
	
	$Settings = GUICreate("Settings",620,300)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_AbandonSettings")
	
	GUICtrlCreateLabel("Wallpaper Interval",10,30)
	$S2 = GUICtrlCreateInput("",120,25,40)
	GUICtrlSetData(-1,$WallpaperInterval / 1000 / 60)
	GUICtrlCreateUpdown($S2)
	
	GUICtrlCreateLabel("Overlay Interval",10,55)
	$S3 = GUICtrlCreateInput("",120,50,40)
	GUICtrlSetData(-1,$OverlayInterval / 1000 / 60)
	GUICtrlCreateUpdown($S3)
	
	GUICtrlCreateLabel("Scale",10,80)
	$S4 = GUICtrlCreateInput("",120,75,40)
	GUICtrlSetData(-1,$iScale)
	GUICtrlCreateUpdown($S4)
	
	GUICtrlCreateLabel("Right Margin",10,105)
	$S5 = GUICtrlCreateInput("",120,100,40)
	GUICtrlSetData(-1,$iMargin)
	GUICtrlCreateUpdown($S5)
	
	GUICtrlCreateLabel("Bottom Margin",180,105)
	$S6 = GUICtrlCreateInput("",260,100,40)
	GUICtrlSetData(-1,$iBottom)
	GUICtrlCreateUpdown($S6)
	
	GUICtrlCreateLabel("With Overlay",10,130)
	$S7 = GUICtrlCreateCheckbox("",120,125,20,20)
	If $bWithOverlay = 1 Then
		GUICtrlSetState(-1,$GUI_CHECKED)
	EndIf
	
	GUICtrlCreateLabel("Clear Overlay on Exit",10,155)
	$S8 = GUICtrlCreateCheckbox("",120,150,20,20)
	If $iClearOnExit = 1 Then
		GUICtrlSetState(-1,$GUI_CHECKED)
	EndIf
	
	GUICtrlCreateLabel("Wallpaper Source",10,180)
	$S10 = GUICtrlCreateInput("",120,175,400)
	GUICtrlSetData(-1,$sWallpaperSourcePath)
	GUICtrlCreateButton("...",520,175,20,20)
	GUICtrlSetOnEvent(-1,"_BrowseSource")
	
	$S13 = GUICtrlCreateCombo("",540,175,60)
	GUICtrlSetData(-1, "JPG|BMP|PNG|*",$sWallType) 
	
	GUICtrlCreateLabel("Overlay Source",10,205)
	$S11 = GUICtrlCreateInput("",120,200,400)
	GUICtrlSetData(-1,$sOverlayPath)	
	GUICtrlCreateButton("...",520,200,20,20)
	GUICtrlSetOnEvent(-1,"_BrowseOverlay")
	
	$S14 = GUICtrlCreateCombo("",540,200,60)
	GUICtrlSetData(-1, "JPG|BMP|PNG|*",$sOverlayType) 
	
	GUICtrlCreateLabel("Output Folder",10,230)
	$S12 = GUICtrlCreateInput("",120,225,400)
	GUICtrlSetData(-1,$sWallpaperPath)
	GUICtrlCreateButton("...",520,225,20,20)
	GUICtrlSetOnEvent(-1,"_BrowseOutput")
	
	$S9 = GUICtrlCreateCombo("",540,225,60)
	GUICtrlSetData(-1, "JPG|BMP|PNG",$sFileType) 

	GUICtrlCreateButton("Save Changes",120,260)
	GUICtrlSetOnEvent(-1, "_SaveSettings")
	
	GUICtrlCreateButton("Abandon Changes",230,260)
	GUICtrlSetOnEvent(-1, "_AbandonSettings")
		
EndFunc

Func _EditSettings()
	_CreateSettingsGui()
	GUISetState(@SW_SHOW,$Settings)
EndFunc

Func _BrowseSource()
	GUICtrlSetData($S10,FileSelectFolder ( "Wallpaper Source", "" ,-1, @ScriptDir ) & "\")
	If GUICtrlRead($S10) = "" Then
		GUICtrlSetData($S10,$sWallpaperSourcePath)
	EndIf
EndFunc

Func _BrowseOverlay()
	GUICtrlSetData($S11,FileSelectFolder ( "Overlay Source", "" ,-1, @ScriptDir ) & "\")
	If GUICtrlRead($S11) = "" Then
		GUICtrlSetData($S11,$sOverlayPath)
	EndIf

EndFunc

Func _BrowseOutput()
	GUICtrlSetData($S12,FileSelectFolder ( "Output Folder" ,-1, @ScriptDir ) & "\")
	If GUICtrlRead($S12) = "" Then
		GUICtrlSetData($S12,$sWallpaperPath)
	EndIf

EndFunc

Func _AbandonSettings()
	GUIDelete($Settings)
EndFunc

Func _SaveSettings()
	local $Search
	
	IniWrite($iniFile,"Defaults","WallpaperInterval",GUICtrlRead($S2))
	IniWrite($iniFile,"Defaults","OverlayInterval",GUICtrlRead($S3))
	IniWrite($iniFile,"Defaults","Scale",GUICtrlRead($S4))
	IniWrite($iniFile,"Defaults","Margin",GUICtrlRead($S5))
	IniWrite($iniFile,"Defaults","Bottom",GUICtrlRead($S6))
	If GUICtrlRead($S7) = $GUI_CHECKED Then
		IniWrite($iniFile,"Defaults","WithOverlay","1")
		$bWithOverlay = 1
		TrayItemSetState ($hNoOverlay, $TRAY_UNCHECKED )
		TrayItemSetState ($hWithOverlay, $TRAY_CHECKED )
	Else
		IniWrite($iniFile,"Defaults","WithOverlay","0")
		$bWithOverlay = 0
		TrayItemSetState ($hWithOverlay, $TRAY_UNCHECKED )
		TrayItemSetState ($hNoOverlay, $TRAY_CHECKED )
	EndIf
	
	If GUICtrlRead($S8) = $GUI_CHECKED Then
		IniWrite($iniFile,"Defaults","ClearOnExit","1")
	Else
		IniWrite($iniFile,"Defaults","ClearOnExit","0")
	EndIf
	
	IniWrite($iniFile,"Defaults","FileType",GUICtrlRead($S9))
	
	; check that there are in fact files  to use as wallpaper
	$Search = FileFindFirstFile(GUICtrlRead($S10) & "*." & GUICtrlRead($S13))  
	If $search = -1 Then
		MsgBox(0, "Error", "No available wallpaper files available.")
		Return
	Else
		IniWrite($iniFile,"Defaults","WallpaperSourcePath",GUICtrlRead($S10))
		IniWrite($iniFile,"Defaults","WallType",GUICtrlRead($S13))
	EndIf
	; check that there are in fact files  to use as overlays
	$Search = FileFindFirstFile(GUICtrlRead($S11) & "*." & GUICtrlRead($S14))  
	If $search = -1 Then
		MsgBox(0, "Error", "No available wallpaper files available.")
		Return
	Else
		IniWrite($iniFile,"Defaults","OverlayPath",GUICtrlRead($S11))
		IniWrite($iniFile,"Defaults","OverlayType",GUICtrlRead($S14))
	EndIf	
	
	IniWrite($iniFile,"Defaults","WallpaperPath",GUICtrlRead($S12))

	GUIDelete($Settings)
	
	_Init()

EndFunc

Func _ExitEvent()
	; remove the overlay
	If  $iClearOnExit = 1  Then; Default is clear overlay on exit
		_NoOverlay()
	EndIf
	Exit
EndFunc

