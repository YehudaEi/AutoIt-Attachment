#include <GuiConstants.au3>

dim    $a_AniSliderCtrlHandles[10]
global $h_AniSliderGuiHandle

global $i_AniSliderControlWidth = 250
global $i_AniSliderTop = 15 
global $i_AniSliderWidth = 60
global $i_AniSliderHeight = 20
global $i_AniSliderStep = 15

global $i_AniSliderMaxLeft = 10
global $i_AniSliderMaxRight= $i_AniSliderControlWidth - $i_AniSliderWidth + $i_AniSliderMaxLeft

global $i_AniSliderPos = $i_AniSliderMaxLeft


global $i_AniSliderMousePosStart
global $i_AniSliderMousePosCurr
global $i_AniSliderGuiPos
global $i_AniSliderMouseKlicked


global $i_AniSliderCurrentProgressState


;===============================================================================
;
; Function Name:    _AniSliderCreateGui()
;
; Description:      Creates the AniSlider GUI.
; Parameter(s):     $s_Title      - The "window title"
;                   $s_StatusLine - Status line text
;                   $s_CloseFunc  - Which function mto call when the GUI gets closed.
; Requirement(s):   None
; Return Value(s):  None
;
; Author(s):        /dev/null aka KurtK
;
;===============================================================================
;
func _AniSliderCreateGui($s_Title = "Animated Slider", $s_StatusLine = "Status line...", $s_CloseFunc = "_AniSliderExit")
	
	local $i_Counter

	AutoItSetOption("GUIOnEventMode",1)    ; 0 = (default) disable. - 1 = enable
	

	for $i_Counter = 0 to Ubound($a_AniSliderCtrlHandles)-1
		$a_AniSliderCtrlHandles[$i_Counter] = -999999999
	next

	
	$h_AniSliderGuiHandle = GuiCreate($s_Title, 280, 60,@DesktopWidth-280,0, BitOR($WS_POPUP,$WS_DLGFRAME),$WS_EX_TOPMOST)
	GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_AniSliderMoveGui")
	GUISetOnEvent($GUI_EVENT_PRIMARYUP, "_AniSliderMoveGui")
	GUISetOnEvent($GUI_EVENT_MOUSEMOVE, "_AniSliderMoveGui")
	GUISetOnEvent($GUI_EVENT_CLOSE, $s_CloseFunc)
	
	$i_AniSliderGuiPos = WinGetPos($h_AniSliderGuiHandle)
	
	$a_AniSliderCtrlHandles[0] = GUICtrlCreateLabel($s_Title,10,0,250)
	GUICtrlSetFont($a_AniSliderCtrlHandles[0],9,600,0,"Arial Bold")
	GUICtrlSetOnEvent($a_AniSliderCtrlHandles[0], "_AniSliderMoveGui")
	
	$a_AniSliderCtrlHandles[1] = GUICtrlCreateLabel($s_StatusLine,10,40,250)
	GUICtrlSetFont($a_AniSliderCtrlHandles[1],8,500,0,"Arial Bold")
	GUICtrlSetOnEvent($a_AniSliderCtrlHandles[1], "_AniSliderMoveGui")
	
	$a_AniSliderCtrlHandles[2] = GuiCtrlCreateLabel("", $i_AniSliderMaxLeft, $i_AniSliderTop, $i_AniSliderControlWidth, $i_AniSliderHeight, $ss_center)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetOnEvent($a_AniSliderCtrlHandles[2], "_AniSliderMoveGui")

	$a_AniSliderCtrlHandles[3] = GuiCtrlCreateLabel("", $i_AniSliderMaxLeft, $i_AniSliderTop, $i_AniSliderWidth, $i_AniSliderHeight)
	GUICtrlSetBkColor(-1, 0x00ff00)
	GUICtrlSetOnEvent($a_AniSliderCtrlHandles[3], "_AniSliderMoveGui")

	GuiSetState()
	
	_AniSliderSetProgressState($s_StatusLine)
	
	AdlibEnable("_AniSliderAnimateProgressBar",250)

endfunc

;===============================================================================
;
; Function Name:    _AniSliderMoveGui()
;
; Description:      Drag-n-Drop with mouse. This functions moves the whole GUI, 
;		    no matter where the user clicked.
;
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  None
;                   
; Author(s):        /dev/null aka KurtK
;
;===============================================================================
;
func _AniSliderMoveGui()
  local $i_ControlHandleFound = 0, $i_ControlIdFound = 0, $i_Counter
  
   for $i_Counter = 0 to Ubound($a_AniSliderCtrlHandles)-1
       if $a_AniSliderCtrlHandles[$i_Counter] = @GUI_CTRLHANDLE then $i_ControlHandleFound = 1
       if $a_AniSliderCtrlHandles[$i_Counter] = @GUI_CTRLID then $i_ControlIdFound = 1
   next

   if (@GUI_WINHANDLE = $h_AniSliderGuiHandle) OR ($i_ControlHandleFound = 1) then
     select
       case (@GUI_CTRLID = $GUI_EVENT_PRIMARYDOWN) OR ($i_ControlIdFound = 1)
           $i_AniSliderMousePosStart= MouseGetPos()
           $i_AniSliderMouseKlicked  = 1
          
          
       case @GUI_CTRLID = $GUI_EVENT_PRIMARYUP
           $i_AniSliderMouseKlicked = 0
           $i_AniSliderMousePosCurr= MouseGetPos()
           $delta_x = $i_AniSliderMousePosCurr[0] - $i_AniSliderMousePosStart[0]
           $delta_y = $i_AniSliderMousePosCurr[1] - $i_AniSliderMousePosStart[1]
           WinMove($h_AniSliderGuiHandle,"", $i_AniSliderGuiPos[0]+$delta_x, $i_AniSliderGuiPos[1]+$delta_y)
           $i_AniSliderGuiPos = WinGetPos($h_AniSliderGuiHandle)        
          
       case @GUI_CTRLID = $GUI_EVENT_MOUSEMOVE
           if $i_AniSliderMouseKlicked = 1 then
              $i_AniSliderMousePosCurr= MouseGetPos()
           $delta_x = $i_AniSliderMousePosCurr[0] - $i_AniSliderMousePosStart[0]
           $delta_y = $i_AniSliderMousePosCurr[1] - $i_AniSliderMousePosStart[1]
           WinMove($h_AniSliderGuiHandle,"", $i_AniSliderGuiPos[0]+$delta_x, $i_AniSliderGuiPos[1]+$delta_y)
        
           endif
     endselect
   endif       	
endfunc


;===============================================================================
;
; Function Name:    _AniSliderAnimateProgressBar()
;
; Description:      Animates the progress bar. This function gets called by
;		    AdlibEnable()
;
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  None
;                   
; Author(s):        /dev/null aka KurtK
;
;===============================================================================
;
func _AniSliderAnimateProgressBar()
    
    $i_AniSliderPos = $i_AniSliderPos + $i_AniSliderStep

    if $i_AniSliderPos > $i_AniSliderMaxRight then
       $i_AniSliderPos = $i_AniSliderMaxRight
       $i_AniSliderStep = $i_AniSliderStep * -1
    elseif $i_AniSliderPos < $i_AniSliderMaxLeft then 
       $i_AniSliderPos = $i_AniSliderMaxLeft
       $i_AniSliderStep = $i_AniSliderStep * -1
    endif
	
    GUICtrlSetData($a_AniSliderCtrlHandles[1],$i_AniSliderCurrentProgressState)
    GUICtrlSetPos($a_AniSliderCtrlHandles[3], $i_AniSliderPos, $i_AniSliderTop, $i_AniSliderWidth, $i_AniSliderHeight)
	
endfunc


;===============================================================================
;
; Function Name:    _AniSliderSetProgressState()
;
; Description:      Sets the current progress state in a global variable. 
;		    _AniSliderAnimateProgressBar() reads this variable
;
; Parameter(s):     $s_State      - Current progress status
;                   
; Requirement(s):   None
; Return Value(s):  None
;                   
; Author(s):        /dev/null aka KurtK
;
;===============================================================================
;
func _AniSliderSetProgressState($s_State="")
	 $i_AniSliderCurrentProgressState = $s_State
endfunc


;===============================================================================
;
; Function Name:    _AniSliderExit()
;
; Description:      Exit function, which is called when the GUI gets closed
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  None
;                   
; Author(s):        /dev/null aka KurtK
;
;===============================================================================
;
func _AniSliderExit()
	GUIDelete($h_AniSliderGuiHandle)
	exit
endfunc


