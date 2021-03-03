#cs
	RoboRealm available for download from http://www.RoboRealm.com
	30-day trial is free, $49 to continue use after that.

	Don't forget to regsvr32 RR_COM_API.dll before first use!

	The com object doesn't support events or properties, but contains
	32 methods: Connect, Disconnect, GetDimension, GetImage, SetImage,
	GetVariable, SetVariable, DeleteVariable, Execute, LoadProgram,
	LoadImage, SaveImage, SetCamera, Run, WaitVariable, WaitImage,
	LoadPPM, SavePPM, Open, Close, GetVariables, SetVariables, SetParameter,
	GetParameter, MinimizeWindow, MaximizeWindow, MoveWindow, ResizeWindow,
	PositionWindow, SaveProgram, Pause, Resume

#ce

Opt("MustDeclareVars", 1)
Opt("WinDetectHiddenText", 1) ;0=don't detect, 1=do detect
Opt("WinSearchChildren", 1) ;0=no, 1=search children also
Opt("WinTextMatchMode", 1) ;1=complete, 2=quick
Opt("WinTitleMatchMode", 1) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

Global $RR_Ver, $oCatchErr, $oRR, $Width_Img, $Height_Img, $CameraName, $FPS, $Handle

$RR_Ver = "RoboRealm 2.44.24" ; Change this if it isn't your version of RoboRealm
$Handle = 0

; Prepare to trap any COM errors
$oCatchErr = ObjEvent("AutoIt.Error", "ErrHandler")

; Get RoboRealm COM object
$oRR = ObjCreate("RoboRealm.API.1")
If (@error <> 0) Then
	MsgBox(16, "Error creating COM object", "Unable to create RoboRealm.API.1")
	Exit
EndIf

; Run RoboRealm if not already running
$oRR.Open("C:\Program Files\RoboRealm\RoboRealm.exe", 6060)

; Get a handle to the RoboRealm window
$Handle = WinWait($RR_Ver, 15)
If ($Handle = 0) Then
	MsgBox(16, "Window Error", "Unable find RoboRealm window")
	Exit
EndIf

; Attempt connection to RoboRealm
If ($oRR.connect("localhost") = 0) Then
	MsgBox(16, "Connection Error", "Unable to connect to server")
	Exit
EndIf

; --- If we make it this far RoboRealm is all good

; Wait for camera to wake up since it was just activated a few microseconds ago
Sleep(5000)

ResetRoboRealm() ; Restore original default state in case we did something earlier

; Read a few RoboRealm variables
$CameraName = $oRR.GetVariable("CAMERA_NAME")
$Height_Img = $oRR.GetVariable("IMAGE_HEIGHT")
$Width_Img = $oRR.GetVariable("IMAGE_WIDTH")
$FPS = $oRR.GetVariable("FPS") ; Frames per second

; Save image
$oRR.SaveImage("", @DesktopDir & "\Img1.jpg") ; Unmodified image

; Set and configure an RGB filter
$oRR.Execute("<head><version>1.50</version></head><RGB_Filter><min_value>40</min_value><channel>3</channel></RGB_Filter>")

$oRR.WaitImage ; Wait for image to update
$oRR.SaveImage("", @DesktopDir & "\Img2.jpg") ; Image via RGB filter

; Load a RoboRealm program
$oRR.LoadProgram("C:\Program Files\RoboRealm\Examples\Sobel Edges.robo")

$oRR.WaitImage ; Wait for image to update
$oRR.SaveImage("", @DesktopDir & "\Img3.jpg") ; Image processed for Sorbel Edges

; If you want to save changes to RoboRealm in a program file you can do this,
; by default RoboRealm will remember its state on exit and reload on restart.
; Obviously you can do a $oRR.loadProgram to load one instead.
$oRR.SaveProgram(@DesktopDir & "\test.robo")

ResetRoboRealm()

; Disconnect from server
$oRR.Disconnect ; Could do $oRR.Close instead to terminate RoboRealm program

Func ErrHandler()
	Local $HexNumber
	$HexNumber = Hex($oCatchErr.number, 8)
	MsgBox(16, "COM Error", "Number is: " & $HexNumber & @CRLF & _
			"Windescription is: " & $oCatchErr.windescription)
EndFunc   ;==>ErrHandler

Func ResetRoboRealm()
	If (WinActive($Handle) = 0) Then
		WinActivate($Handle)
		If (WinWaitActive($Handle, "", 5) = 0) Then
			MsgBox(16, "Load Error", "Unable to activate RoboRealm window.")
			Exit
		EndIf
		Sleep(25)
	EndIf
	ControlClick($Handle, "", "[CLASS:Button; TEXT:&New]") ; Restore original state
	Sleep(25)
EndFunc   ;==>ResetRoboRealm
