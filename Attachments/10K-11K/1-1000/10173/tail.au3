; ----------------------------------------------------------------------------
;
; AutoIt Version: Beta v3.1.1.133 
; Author:         Lawrence Scott
; Date:  		  08/02/2006
;
; Script Function:
;	This program is a GUI version of the Unix Tail utility.
;
; ----------------------------------------------------------------------------

;-----------------------------------------------
;			Script Environment settings			|
;-----------------------------------------------
#include <File.au3>
#include <GUIConstants.au3>
#Include <GuiEdit.au3>
Opt("GUIOnEventMode", 1)



;----------------------------------------
;			Script Main body			|
;----------------------------------------


;  			Start GUI Window and Elements creation -->
$W_size_l = 700
$Wsize_h =400
$mainWindow = GUICreate("Tails",$W_size_l,$Wsize_h) 		;Creates main Window
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")				
GUISetState(@SW_SHOW)

GUICtrlCreateLabel("Please select the file you want to tail", 30, 10)  

$fileopenButton = GUICtrlCreateButton("Open File",30, 40)
GUICtrlSetOnEvent($fileopenButton, "FileopenButton")

$TailButton = GUICtrlCreateButton("Tail it",200, 40)
GUICtrlSetOnEvent($TailButton, "Tailit")

																			
$editControl = GUICtrlCreateEdit("",30,120, $W_size_l-60,	($Wsize_h/3)*2,$WS_VSCROLL+ _ 
															 $ES_MULTILINE+$ES_AUTOVSCROLL+$ES_READONLY)
$LabelControl = GUICtrlCreateinput("Chosen file",30,80, 300, 20 )
$linecountcontrol = GUICtrlCreateInput("Lines : ",360,80,150,20,$ES_READONLY)
$loopQAcontrol = GUICtrlCreateInput("Loop : ",360,40,150,20,$ES_READONLY)

;  		<-- End GUI Window and Elements creation 


;			Start Main While loop -->
while 1
sleep(1)
WEnd
;			<-- End Main While loop 

;---------------------------------------------------
; 				Functions Declarations				|
;---------------------------------------------------

;--------------------
;  Function Tailit() |
;----------------------------------------------------------------------------------------------------
;  Main Function that will actually keep checking the target file for any changes
;  via a second While loop
func Tailit()

;			Function Environment settings	-->

	$error =0
	$loopcount = 0
	$file = ControlGetText("Tails","",$LabelControl)
	if not fileexists($file) Then
		$error = -1
		EndIf
	$openfile = FileOpen($file,0)
	
	$count = _FileCountLines($file)
	$scan= filereadline($file, $count)
	
	$file_contents = ""
	for $x =1 to $count
		$file_contents = $file_contents  & filereadline($file, $x)& @CRLF
	next
	GUICtrlSetData($editControl, $file_contents)
	GUICTrlSetData($linecountcontrol, "Lines : " &$count)
	_GUICtrlEditLineScroll ($editControl, 0, $count)
;			<<- Function Environment settings	

;			Start While loop -->
;			This is where are the processing happens.
	while 2
		$loopcount = $loopcount +1
	GUICTrlSetData($loopQAcontrol, "Loop in : " &$loopcount)
		
	$recount = _FileCountLines($file)
	$rescan = filereadline($file, $recount)
 
 ;				Start Select Block -->
	Select
	case $error = -1 
		MsgBox(0,"Error","no valid file specified, please open a file first")
		ExitLoop		
	case $rescan <> $scan
			$file_contents = ""		
			for $x =1 to $count
				$file_contents = $file_contents  & filereadline($file, $x)& @CRLF
			next
			GUICtrlSetData($editControl, $file_contents)
			GUICTrlSetData($linecountcontrol, "Lines : " &$count)
			_GUICtrlEditLineScroll ($editControl, 0, $recount)
			
			$scan = $rescan
			
	case $recount <> $count
			if $recount > $count then
				$file_contents = ""		
				for $x =1 to $recount
					$file_contents = $file_contents  & filereadline($file, $x)& @CRLF
				next
				GUICtrlSetData($editControl, $file_contents)
				GUICTrlSetData($linecountcontrol, "Lines : " &$recount)
				_GUICtrlEditLineScroll ($editControl, 0, $recount)
				
				$count = $recount
			elseif $recount < $count Then
				
				$file_contents = ""
				for $x =1 to $recount
					$file_contents = $file_contents  & filereadline($file, $x)& @CRLF
				next
				GUICtrlSetData($editControl, $file_contents)
				GUICTrlSetData($linecountcontrol, "Lines : " &$recount)
				_GUICtrlEditLineScroll ($editControl, 0, $recount)
				$linecountcontrol = GUICtrlCreateInput("Lines : " &$recount,360,80,150,40,$ES_READONLY)
				$count = $recount
			endif
		
	EndSelect
;				<-- End Select Block
	WEnd
;			<-- End while Loop	
	
	fileclose($openfile)
EndFunc 
;----------------------------------------------------------------------------------------------------
;  End Function Tailit()  |
;-------------------------

;----------------------------
;  Function FileopenButton() |
;----------------------------------------------------------------------------------------------------
;  Creates Open File dialog Box, sets the select as the target file to be Tailed
func FileopenButton()
$selected_file = FileOpenDialog("Open",@ScriptDir,"Text Files (*.*)")
GUICtrlSetData($LabelControl, $selected_file)
EndFunc
;----------------------------------------------------------------------------------------------------
;  End Function FileopenButton() |
;--------------------------------

Func CLOSEClicked()
  Exit
EndFunc
