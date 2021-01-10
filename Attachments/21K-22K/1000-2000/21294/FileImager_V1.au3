	#include <GuiConstantsEx.au3>
	#include <GDIPlus.au3>
	#include <ScreenCapture.au3>
	#Include <String.au3>
;

	
	Local $hGUI, $hWnd, $hGraphic, $hPen, $x1, $y1





	$x1 = -1
	$y1 = 0
	; Create GUI
	$hGUI = GUICreate("File Encoder", 400, 440, 193, 125)
	$hWnd = WinGetHandle("File Encoder")
	$Progress1 = GUICtrlCreateProgress(2, 405, 205, 28)
	GUICtrlSetLimit($Progress1, 399, 0)
	$Button1 = GUICtrlCreateButton("Read", 214, 404, 89, 30, 0)
	$Button2 = GUICtrlCreateButton("Create", 307, 404, 89, 30, 0)
	GUISetState(@SW_SHOW)
	
	

func _CreateFileImage()
	; Draw dots
	$x1 = -1
	$y1 = 0
	_GDIPlus_Startup ()
	
	
	$hGraphic2 = _GDIPlus_GraphicsCreateFromHWND ($hWnd)
   	_GDIPlus_GraphicsFillRect($hGraphic2, 0,0,400,400)
   	$hImage = _GDIPlus_BitmapCreateFromGraphics(400,400, $hGraphic2)
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)
	$hPen = _GDIPlus_PenCreate(0xFF00FF00)



	
	$FoD = FileOpenDialog("Open", @DesktopDir, "All (*.*)", 1)
	if @error <> 1 then
	$loop = 0
	$open = FileOpen($FoD, 16)
	
	; First dot is the files extension
	$fileext = Binary(StringRight($FoD, 3))
	$fileext_chars = StringInStr($fileext, "2E") 
	if $fileext_chars = 0 then
		$fileext = StringTrimLeft($fileext, 2)
		$x1 += 1
	_GDIPlus_PenSetColor($hPen,"0xFF" & $fileext) 
	_GDIPlus_GraphicsDrawLine ($hGraphic, $x1, $y1, $x1 + 1, $y1, $hPen)
	
	Else
	
	$fileext = StringTrimLeft($fileext, $fileext_chars + 1) 
	$fileext_len = StringLen($fileext)
	
	for $fileext_len = $fileext_len to 6 Step + 1
		$fileext = $fileext & "0"
		$fileext_len = StringLen($fileext)
	Next
	
	_GDIPlus_PenSetColor($hPen,"0xFF" & $fileext)
	_GDIPlus_GraphicsDrawLine ($hGraphic, $x1, $y1, $x1 + 1, $y1, $hPen)
	
	endif
	; ---------------------------------
	
	while $loop = 0
	$read = FileRead($open, 2)
	if @error <> -1 Then
		
		$x1 += 1
			
		
		
		if $x1 > 399 Then
			$y1 += 1
			$x1 = 0
			endif
		
		

		$read_final = StringTrimLeft($read, 2)
		
		if StringLen($read_final) = 4 Then
			$rnd = String(Random(0, 9, 1)) & "0"
			
			$read_final = "0xFF" & $read_final & $rnd
			
			
			
		elseif StringLen($read_final) = 2 then
			$read_final = "0xFF" & $read_final & "FFFF"
			$loop = 1
			
			
			endif
		
	_GDIPlus_PenSetColor($hPen, $read_final)
	_GDIPlus_GraphicsDrawLine ($hGraphic, $x1, $y1, $x1 + 1, $y1, $hPen)
	


	elseif @error = -1 then
		_GDIPlus_PenSetColor($hPen,"0xFFFFFFFF")
		_GDIPlus_GraphicsDrawLine ($hGraphic, $x1 + 1, $y1, $x1 + 2, $y1, $hPen)
			; MsgBox(0, "", "File finished")
		$loop = 1
	
	endif




wend

	
	$saveloc = FileSaveDialog("Save image", @DesktopDir, "Bitmap (*.bmp)")
	
	if @error <> 1 then
		
	$Savecheck = StringRight($saveloc, 3)
	if $Savecheck <> "bmp" Then
	
		$saveloc = $saveloc & ".bmp"
	
	endif
		
	_GDIPlus_ImageSaveToFile($hImage, $saveloc)
	
	$hImagefinal = _GDIPlus_ImageLoadFromFile($saveloc)
	
	_GDIPlus_GraphicsDrawImage($hGraphic2, $hImagefinal, 0, 0)

	_GDIPlus_PenDispose($hPen)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()
	endif

endif
	
	
	EndFunc
	
Func _ReadFileImage()
	
	opt("PixelCoordMode", 0)
	Opt("MouseCoordMode", 0 )
	$x1 = 0
	$y1 = 0
	$filecontent = ""
	$value = ""

	
	
	$FoD = FileOpenDialog("Open", @DesktopDir, "bitmaps (*.bmp)")
	if @error <> 1 then
	_GDIPlus_Startup()
	$hGraphic2 = _GDIPlus_GraphicsCreateFromHWND ($hWnd)	
	$hImagefinal = _GDIPlus_ImageLoadFromFile($FoD)
	_GDIPlus_GraphicsDrawImage($hGraphic2, $hImagefinal, 0, 0)
	MsgBox(0, "", "Please do not move the file encoder window until it is done." )
	sleep(1000)
	$readloop = 0
	$ImageFile_ext = StringTrimLeft(Hex(PixelGetColor($x1 + 3, $y1 + 23, $hWnd)), 2)
	$x1 += 1
	$ImageFile_ext = _HexToString($ImageFile_ext)
	while $readloop = 0
		
	$value = StringTrimLeft(Hex(PixelGetColor($x1 + 3, $y1 + 23, $hWnd)), 2)
	$x1 += 1
	
	if $x1 > 399 Then
		$y1 += 1
		$x1 = 0
		GUICtrlSetData($Progress1, 0)
	endif
	
	
	
	if $value = "FFFFFF" Then
	$readloop = 1
	
	elseif StringRight($value, 1) = "F" Then

		$filecontent = $filecontent & StringLeft($value, 2)
		if $x1 > 60 Then
		endif
		$readloop = 1

	Else
		
		$filecontent = $filecontent & StringLeft($value, 4)
		
	endif

		GUICtrlSetData($Progress1, $x1)
	
	
wend


;filesave
$saveloc = FileSaveDialog("Save file", @DesktopDir, "file (*." & $ImageFile_ext & ")" , 16, "" & $ImageFile_ext)
if @error <> 1 then

$zipcheck = StringRight($saveloc, 3)
	
	if $zipcheck <> $ImageFile_ext Then
	
		$saveloc = $saveloc & "." & $ImageFile_ext
	
	endif
$filecontent = Binary("0x" & $filecontent)
FileWrite($saveloc, $filecontent)
GUICtrlSetData($Progress1, 100)
;GUISetState(@SW_SHOW, $Form1)
;ClipPut($filecontent)
endif


endif

endfunc
	
	
	
While 1
		Switch GUIGetMsg()
			
			Case $GUI_EVENT_CLOSE
				
					
					
					exit
					
					
			Case $Button2
					
					_CreateFileImage()
					
					
			Case $Button1
					
					_ReadFileImage()
					
		
		
		EndSwitch

wend

