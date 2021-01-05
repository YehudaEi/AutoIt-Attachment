;*************************************************************
;**
;** (c) 2005 by /dev/null
;**
;** Version 1.0.1 Use it if you like it....
;**
;** This script needs Lazycat's screen capture DLL captdll.dll. See
;** the following link for this.
;**
;**                         
;**
;*************************************************************
#include <math.au3>
#include <File.au3>
#include <GUIConstants.au3>


Opt ("wintitlematchmode", 4)

global const $GUI_EVENT_MOUSE_DOWN = 3
global const $GUI_EVENT_MOUSE_UP = -8

global const $ERR_INVALID_FILE_RECTFILE = 10
global const $ERR_INVALID_FILE_COORD = 11
global const $ERR_INVALID_FILE_SIZE = 12
global const $ERR_INVALID_FILE_FORMAT = 13
global const $ERR_FILE_OPEN_ERROR = 20
global const $ERR_FILE_READ_ERROR = 21
global const $ERR_FILE_WRITE_ERROR = 22

global const $SCALING_FACTOR = 0.95

global $coord_start
global $coord_stop

global $scale_x = @DesktopWidth * $SCALING_FACTOR
global $scale_y = @DesktopHeight * $SCALING_FACTOR

global $main_window

global $rect_handle
global $mouse_down = 0
global $rounds = 0
global $first_time = 1

global $tmpfile

;***********************************************************************
;** Make a screenshot and save it to a file
;***********************************************************************
$tmpfile = _TempFile()
capture_screen_to_bmp($tmpfile)

;***********************************************************************
;** Create the GUI
;***********************************************************************

$main_window = GUICreate ("Screenshot", $scale_x, $scale_y, -1, -1)
$picture_control = GuiCtrlCreatePic ($tmpfile,0,0, $scale_x,$scale_y)
GUIsetstate ()

$msg = "Mark an area with the mouse on the screenshot"

msgbox(4096,"Info", $msg)

;***********************************************************************
;** Main message loop
;***********************************************************************

While 1
  $msg = GUIGetMsg()

  Select
    Case $msg = 0 

    Case $msg = -7

    Case $msg = $GUI_EVENT_MOUSEMOVE
         show_mouse_position()
         show_selection_rectangle()
    
    Case $msg = $GUI_EVENT_MOUSE_DOWN
         mark_start()

    Case $msg = $GUI_EVENT_MOUSE_UP
         mark_stop()
     
    Case $msg = $GUI_EVENT_CLOSE
         cleanup()
         exit

    Case Else
      MsgBox(0, "GUI Event", "Message: " & $msg)

  EndSelect
WEnd

;***********************************************************************
;** Func: show_mouse_position
;** Param: NONE
;** Descr: show a tooltip window with the mouse positions
;**
;** Return: NONE
;***********************************************************************
func show_mouse_position()

     if ($mouse_down = 1) then
        $coord_client = GUIGetCursorInfo($main_window)
        $coord_abs = MouseGetPos() 
        ToolTip("")
        if ($coord_client[0] > 0 AND $coord_client[1] > 0) then
           $tipmsg = "x= " & $coord_client[0] & " y=" & $coord_client[1] & @CRLF
           $tipmsg = $tipmsg & "dx= " & $coord_client[0] - $coord_start[0] & " dy=" & $coord_client[1] - $coord_start[1] 
           ToolTip($tipmsg, $coord_abs[0]+15, $coord_abs[1]+15) 
        endif 
     else
        ToolTip("")
     endif
endfunc 

;***********************************************************************
;** Func: show_selection_rectangle
;** Param: NONE
;** Descr: show a "selection rectangle"
;**
;** Return: $handle
;***********************************************************************
func show_selection_rectangle()
     
     local $dx, $dy

     if ($first_time = 1) then
        $rect_handle = GUICtrlCreateLabel("select_rectangle", -1, -1, 1, 1,0x107)
        $first_time = 0
     endif 

     if ($mouse_down = 1) then
        $coord_client = GUIGetCursorInfo($main_window)

        $dx = $coord_client[0] - $coord_start[0]
        $dy = $coord_client[1] - $coord_start[1]

        GuiCtrlSetPos($rect_handle, $coord_start[0], $coord_start[1], $dx, $dy)

;        $handle=GuiCtrlCreateGraphic($coord_start[0], $coord_start[1], $dx, $dy)
;        GuiCtrlSetStyle($handle,$WS_DISABLED, $WS_EX_TRANSPARENT )
;        GuiCtrlSetState($handle,$GUI_HIDE)
;        GUICtrlSetGraphic($handle,$GUI_GR_COLOR, 0xff00)
;        GUICtrlSetGraphic($handle,$GUI_GR_RECT,$coord_start[0], $coord_start[1], $dx, $dy) 
        
     endif
endfunc 

;***********************************************************************
;** Func: delete_selection_rectangle
;** Param: NONE
;** Descr: delete a "selection rectangle"
;**
;** Return: NONE
;***********************************************************************
func delete_selection_rectangle($handle)
     GUICtrlDelete($handle)
     $first_time = 1
endfunc 

;***********************************************************************
;** Func: capture_screen
;** Param: NONE
;** Descr: Get a screenshot of the whole screen and write it to a file
;**
;** Return: NONE
;***********************************************************************
func capture_screen_to_bmp($file)
    DllCall("captdll.dll", "int", "CaptureScreen", "str", $file, "int", -1)

     ;******************************************************************
     ;** Check for any errors of DllCall
     ;******************************************************************
     if @error <> 0 then
        error_dllcall("captdll.dll")
     endif
endfunc 

;***********************************************************************
;** Func: capture_rect_to_bmp
;** Param: NONE
;** Descr: Get a screenshot of the whole screen and write it to a file
;**
;** Return: NONE
;***********************************************************************
func capture_rect_to_bmp($nLeft, $nTop, $nHeight, $nWidth, $file)

     $nLeft = _Ceil($nLeft / $SCALING_FACTOR)
     $nTop = _Ceil($nTop / $SCALING_FACTOR)
     $nHeight = _Ceil($nHeight / $SCALING_FACTOR)
     $nWidth = _Ceil($nWidth / $SCALING_FACTOR)

     DllCall("captdll.dll", "int", "CaptureRegion", "str", $file, "int", $nLeft, "int", $nTop, "int", $nHeight, "int", $nWidth, "int", -1)
     ;******************************************************************
     ;** Check for any errors of DllCall
     ;******************************************************************
     if @error <> 0 then
        error_dllcall("captdll.dll")
     endif
endfunc 

;***********************************************************************
;** Func: mark_start
;** Param: NONE
;** Descr: Start the "marking" process, by retrieving the mouse coordinates
;**        on left mouse click.
;**
;** Return: NONE
;***********************************************************************
func mark_start()
     $coord_start=GUIGetCursorInfo($main_window)
     if ($coord_start[4] = $picture_control) then
        $mouse_down = 1
        ToolTip("")
        show_mouse_position()
  
        show_selection_rectangle()
     endif
endfunc


;***********************************************************************
;** Func: mark_stop
;** Param: NONE
;** Descr: Stop the "marking" process, by retrieving the mouse coordinates
;**        on left mouse click RELEASE. Hide the application an do get 
;**        the pixels from the "selected" area
;**
;** Return: NONE
;***********************************************************************
func mark_stop()
     local $coord_stop = GUIGetCursorInfo($main_window)
     
     local $delta_x
     local $delta_y
     local $myrect

     if $mouse_down=0 then
        return
     endif

     $delta_x = $coord_stop[0] - $coord_start[0]
     $delta_y = $coord_stop[1] - $coord_start[1]

     $mouse_down = 0
     ToolTip("")

     delete_selection_rectangle($rect_handle)

     ;*****************************************************************
     ;** If the mouse movement was too small, we asume a double click
     ;*****************************************************************
     if ($delta_x < 4 OR $delta_y < 4) then 
        return
     endif

     ;*****************************************************************
     ;** if the value is negativ (selection in opposite direction), do
     ;** some math to get positive values.
     ;*****************************************************************
     if $delta_x < 0 then
        $coord_start[0] = $coord_start[0] + $delta_x
        $delta_x = $delta_x * -1
     endif

     if $delta_y < 0 then
        $coord_start[1] = $coord_start[1] + $delta_y
        $delta_y = -$delta_y
     endif

     ;*****************************************************************
     ;** Ask for a file to save the pixels 
     ;*****************************************************************
     $filename = FileSaveDialog( "Choose a name to save Rectangle", @WorkingDir, "Rectangles (*.rect)", 3)
     if @error = 1 then
        msgbox(4096, "Error", "No file was chosen!")
        return
     endif


     ;*****************************************************************
     ;** Now hide the full screenshot to get the real pixels from screen
     ;*****************************************************************
     msgbox(4096, "Info", "Will now hide my windows and get the pixels." & @CRLF & "May take a few seconds... Hold on")

     GuiSetState(@SW_HIDE, $main_window)

     $myrect = GetRectFromScreen($coord_start[0],$coord_start[1], $delta_x, $delta_y)

     capture_rect_to_bmp($coord_start[0],$coord_start[1], $delta_x, $delta_y, "partial_capture.bmp")

     GuiSetState(@SW_SHOW, $main_window)

     ;*****************************************************************
     ;** Write the pixels
     ;*****************************************************************
     $return=WriteRectToFile($filename,$myrect)


endfunc


;***********************************************************************
;** Func: GetRectFromScreen
;** Param: $coord_x, $coord_y ==> The upper left corner of the rectangle
;**        $size_x, $size_y ==> The size of the rectangle
;** Descr: Get the requested pixels from screen. Take $SCALING_FACTOR into
;**        account, as we have selected the rectangle from a downscaled 
;**        screenshot
;**
;** Return: $rect ==> an array with the pixels
;***********************************************************************

func GetRectFromScreen($coord_x, $coord_y, $size_x, $size_y)
     local $dx, $dy

     $coord_x = _Ceil($coord_x / $SCALING_FACTOR)
     $coord_y = _Ceil($coord_y / $SCALING_FACTOR)

     $size_x = _Ceil($size_x / $SCALING_FACTOR)
     $size_y = _Ceil($size_y / $SCALING_FACTOR)

     local $rect[$size_x][$size_y+1]

     $rect[0][0] = $coord_x
     $rect[1][0] = $coord_y
     $rect[2][0] = $size_x
     $rect[3][0] = $size_y
     
     for $dy = 1 to $size_y step 1
         for $dx = 0 to $size_x-1 step 1
             $rect[$dx][$dy] = PixelGetColor($coord_x + $dx, $coord_y + $dy) 
         next
     next
     return $rect
endfunc


;***********************************************************************
;** Func: WriteRectToFile
;** Param: $filename ==> The file to write
;**        $rect ==> the pixels in an array
;** Descr: Write an array of pixels to a file
;**
;** Return: NONE
;***********************************************************************

func WriteRectToFile($filename,$rect)

     local $coord_x = $rect[0][0] 
     local $coord_y = $rect[1][0] 
     local $size_x = $rect[2][0] 
     local $size_y = $rect[3][0]
     local $line = ""
     local $file
     local $dx, $dy

     ;**********************************************************
     ;** Open the wile for reading
     ;**********************************************************

     $file = FileOpen($filename, 2)
     if $file = -1 then
        SetError($ERR_FILE_OPEN_ERROR)
	return
     endif     

     ;**********************************************************
     ;** Write the header of our file
     ;** Format of the file is:
     ;** Rectfile: V1.0
     ;** Coord: x,y 
     ;** Size: dx,dy
     ;** v,v,v,v,v,v,v,v,v
     ;** v,v,v,v,v,v,v,v,v
     ;**********************************************************
     $line = $line & "Rectfile: V1.0" & @CRLF
     $line = $line & "Coord: " & $coord_x & "," & $coord_y & @CRLF
     $line = $line & "Size: " & $size_x & "," & $size_y & @CRLF

     FileWriteLine($file, $line)

     if @error = 1 then
        FileClose($file)
        SetError($ERR_FILE_WRITE_ERROR)
	return
     endif

     ;****************************************************************
     ;** Start writing the values to the file
     ;****************************************************************
     for $dy = 1 to $size_y step 1
         $line = ""
         $msg=""
         for $dx = 0 to ($size_x-2) step 1
             $line = $line & $rect[$dx][$dy] & ","
         next

	 ;****************************************************************
         ;** VERY STRANGE dx gets incremented after the loop was left !??!
         ;** Thus we have to use $rect[$dx][$dy] INSTEAD of $rect[$dx+1][$dy]
	 ;****************************************************************
         $line = $line & $rect[$dx][$dy] & @CRLF  ; last line without "," 

	 FileWriteLine($file, $line)

         if @error = 1 then
            FileClose($file)
            SetError($ERR_FILE_WRITE_ERROR)
	    return
         endif

     next
     FileClose($file)
     SetError(0)
     return 0
endfunc


;***********************************************************************
;** Func: ReadRectFromFile
;** Param: $filename ==> The file to read
;** Descr: Read an array of pixels from a file
;**
;** Return: $rect ==> an array with the pixels from the file
;***********************************************************************

func ReadRectFromFile($filename)

     local $coord_x, $coord_y 
     local $size_x, $size_y
     local $line = ""
     local $file
     local $values, $tokens

     ;**********************************************************
     ;** Open the wile for reading
     ;**********************************************************

     $file = FileOpen($filename, 0)
     if $file = -1 then
        SetError($ERR_FILE_OPEN_ERROR)
	return
     endif     

     ;**********************************************************
     ;** Read the first line, our signatue. 
     ;** Format of the file is:
     ;** Rectfile: V1.0
     ;** Coord: x,y 
     ;** Size: dx,dy
     ;** v,v,v,v,v,v,v,v,v
     ;** v,v,v,v,v,v,v,v,v
     ;**********************************************************
     $line = FileReadLine($file)
     if @error = 1 then
        FileClose($file)
        SetError($ERR_FILE_READ_ERROR)
	return
     endif

     $tokens = StringSplit($line, ":")
     if $tokens[1] <> "Rectfile" then
        FileClose($file)
        SetError($ERR_INVALID_FILE_RECTFILE)
	return
     endif

     ;**********************************************************
     ;** Read the second line, the coordinates of the upper left
     ;** corner of our rectangle
     ;** Coord: 200,300
     ;**********************************************************
     $line = FileReadLine($file)
     if @error = 1 then
        FileClose($file)
        SetError($ERR_FILE_READ_ERROR)
	return
     endif

     $tokens = StringSplit($line, ":")
     if $tokens[1] <> "Coord" then
        FileClose($file)
        SetError($ERR_INVALID_FILE_COORD)
	return
     endif

     ;**********************************************************
     ;** Get the coordinate values
     ;**********************************************************
     $values = StringSplit($tokens[2], ",")
     $coord_x = $values[1]
     $coord_y = $values[2]
  
     if $coord_x < 0 OR $coord_x > @DesktopWidth then
        FileClose($file)
        SetError($ERR_INVALID_FILE_COORD)
	return
     endif

     if $coord_y < 0 OR $coord_y > @DesktopHeight then
        FileClose($file)
        SetError($ERR_INVALID_FILE_COORD)
	return
     endif

     ;**********************************************************
     ;** Read the third line, the size of our rectangle
     ;** Size: 100,120
     ;**********************************************************
     $line = FileReadLine($file)
     if @error = 1 then
        FileClose($file)
        SetError($ERR_FILE_READ_ERROR)
	return
     endif

     $tokens = StringSplit($line, ":")
     if $tokens[1] <> "Size" then
        FileClose($file)
        SetError($ERR_INVALID_FILE_SIZE)
	return
     endif

     ;**********************************************************
     ;** Get the size values
     ;**********************************************************
     $values = StringSplit($tokens[2], ",")
     $size_x = $values[1]
     $size_y = $values[2]
  
     if ($size_x < 0) OR ($coord_x + $size_x >  @DesktopWidth) then
        FileClose($file)
        SetError($ERR_INVALID_FILE_SIZE)
	return
     endif

     if ($size_y < 0) OR ($coord_y + $size_y >  @DesktopHeight) then
        FileClose($file)
        SetError($ERR_INVALID_FILE_SIZE)
	return
     endif

     ;**********************************************************
     ;** Init the rectangle array
     ;**********************************************************
     if ($size_x < 4) then 
        local $rect[4][$size_y+1]  ; need at least 4 columnns for coord. + size
     else 
        local $rect[$size_x][$size_y+1]  ; need one extra for the coordinates + size
     endif

     $rect[0][0] = $coord_x
     $rect[1][0] = $coord_y
     $rect[2][0] = $size_x
     $rect[3][0] = $size_y


     ;**********************************************************
     ;** Read all values from the file
     ;**********************************************************
     for $dy = 1 to $size_y step 1

         $line = FileReadLine($file)
         if @error = 1 then
            FileClose($file)
            SetError($ERR_FILE_READ_ERROR)
            return
         endif

         $values = StringSplit($line, ",")

         if ($values[0] <> $size_x) then
            FileClose($file)
            SetError($ERR_INVALID_FILE_FORMAT)
            return
         endif 

         $n = 1
         for $dx = 0 to $size_x-1 step 1
             $rect[$dx][$dy] = $values[$n]
             ;msgbox(4096, "", $dy & " " & $dx & " " & $rect[$dx][$dy])
             $n = $n +1
         next

     next

     FileClose($file)
     
     SetError(0)
     return $rect
endfunc

;***********************************************************************
;** Func: cleanup
;** Param: NONE
;** Descr: Clean up things befor exit
;**
;** Return: NONE
;***********************************************************************

func cleanup()
   FileDelete($tmpfile)
endfunc

;***********************************************************************
;** Func: error_dllcall
;** Param: NONE
;** Descr: print an error message and terminate
;**
;** Return: NONE
;***********************************************************************

func error_dllcall($dllfile)
     local $msg
     cleanup()
     $msg = "Error calling DLL <<" & $dllfile & ">>. Probably the DLL was not found" 
     $msg = $msg & @CRLF & @CRLF & "Will terminate now ...."
     msgbox(4096, "Error", $msg) 
     exit
endfunc

