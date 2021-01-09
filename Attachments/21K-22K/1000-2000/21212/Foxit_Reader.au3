
#include<GUIConstantsEx.au3>
#include<WindowsConstants.au3>

Dim $objApp
$PDFViewer = ObjCreate("Foxit.FoxitReaderSDKCtrl.1") 

If Not IsObj($PDFViewer) Then 
	$PDFViewer = ObjCreate("Foxit.FoxitReaderSDKCtrl.2") 
	If Not IsObj($PDFViewer) Then 
	Exit
	EndIf
EndIf	

; Create GUI 
$Gui = GUICreate ( "Foxit PDF Reader", 830, 580,(@DesktopWidth-830)/2, (@DesktopHeight-580)/2 , _
								Bitor($WS_OVERLAPPEDWINDOW ,$WS_VISIBLE , $WS_CLIPSIBLINGS))

;Creates an ActiveX control in the GUI.
$GUIActiveX = GUICtrlCreateObj ( $PDFViewer, -1, -1, @DesktopWidth, @DesktopHeight)
GUICtrlSetResizing ( $GUIActiveX, $GUI_DOCKAUTO)

; Show GUI
GUISetState () 


While 1
    $msg = GUIGetMsg()
    
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend
	
GUIDelete()



