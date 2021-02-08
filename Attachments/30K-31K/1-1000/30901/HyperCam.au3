#include-once
#Region Header
#cs
	Title:   		HyperCam UDF Library for AutoIt3
	Filename:  		HyperCam.au3
	Description: 	Automate the HyperCam screen recorder
	Author:   		seangriffin
	Version:  		V0.1
	Last Update: 	18/06/10
	Requirements: 	AutoIt3 3.2 or higher
					HyperCam is installed & registered (see below)
	Changelog:		
					---------18/06/10---------- v0.1
					Initial release.
					
#ce
#EndRegion Header
#Region Global Variables and Constants
Global $_HyperCam_obj
#EndRegion Global Variables and Constants
#Region Core functions
; #FUNCTION# ;===============================================================================
;
; Name...........:	_HyperCam_StartRec()
; Description ...:	Starts a screen recording.
; Syntax.........:	_HyperCam_StartRec($filename, $start_x = 0, $start_y = 0, $width = @DesktopWidth, $height = @DesktopHeight, $compressor = "MSVC", $comp_quality = 85, $frame_rate = 10, $key_frames = 100, $record_sound = 0, $playback_rate = 10, $flash_rect = -1)
; Parameters ....:	$filename			- the AVI filename and path to store the recording
;					$start_x			- the horizontal top left corner of the screen area to be recorded (in pixels)
;					$start_y			- the vertical top left corner of the screen area to be recorded (in pixels)
;					$width				- the width of the screen area to be recorded (in pixels)
;					$height				- the height of the screen area to be recorded (in pixels)
;					$compressor			- the codec (compressor/decompressor) that HyperCam will use to compress frames written to the AVI file
;					$comp_quality		- the compression quality factor (as a percentage)
;					$frame_rate			- the current recording frame rate (in frames per second)
;					$key_frames			- the key frame value of the recorded AVI file
;					$record_sound		- If true, sound will be recorded, otherwise not
;					$playback_rate		- Allows a playback rate that is different from the actual recording frame rate
;					$flash_rect			- If set to True, a flashing rectangle is shown around the recording area
; Return values .: 	On Success			- Returns True and screen recording commenses. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	HyperCam must already be installed, and registered as an automation server.
;					To register HyperCam as an automation server, follow the instructions
;					provided in HyperCam's Help file in the page titled "Automation".
;					For instance, run HyperCam from the command line with the following argument:
;					“C:\Program Files\HyCam2\HyCam2.exe” –regonly
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _HyperCam_StartRec($filename, $start_x = 0, $start_y = 0, $width = @DesktopWidth, $height = @DesktopHeight, $compressor = "MSVC", $comp_quality = 85, $frame_rate = 10, $key_frames = 100, $record_sound = 0, $playback_rate = 10, $flash_rect = -1)

	if IsObj($_HyperCam_obj) = False Then $_HyperCam_obj = ObjCreate("HyCam2.Application")

	if IsObj($_HyperCam_obj) = False Then Return False

	; AVI File Tab
	$_HyperCam_obj.Compressor = $compressor
	$_HyperCam_obj.CompQuality = $comp_quality
	$_HyperCam_obj.FileName = $filename
	$_HyperCam_obj.FrameRate = $frame_rate
	$_HyperCam_obj.KeyFrames = $key_frames
	$_HyperCam_obj.RecordSound = $record_sound
	$_HyperCam_obj.PlaybackRate = $playback_rate

	; Screen Area Tab
	$_HyperCam_obj.FlashRect = $flash_rect
	$_HyperCam_obj.Height = $height
	$_HyperCam_obj.StartX = $start_x
	$_HyperCam_obj.StartY = $start_y
	$_HyperCam_obj.Width = $width

	; Hot Keys Tab
	$_HyperCam_obj.DisableHotKeys()

	; General
	$_HyperCam_obj.StartRec

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_HyperCam_StopRec()
; Description ...:	Stops a screen recording (previously started with "_HyperCam_StartRec").
; Syntax.........:	_HyperCam_StopRec()
; Parameters ....:	
; Return values .: 	On Success			- Returns True and screen recording stops. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	HyperCam will automatically stop recording if a script exits
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _HyperCam_StopRec()

	$_HyperCam_obj.StopRec

	Return True
EndFunc