##include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>

#include <StaticConstants.au3>



FORM1()

Func FORM1()
;MAIN FORM
#Region ### START Koda GUI section ### Form=MAIN FORM
$Form1 = GUICreate("Winnipeg Fireutils Menu", 625, 443, 192, 124)
$form1_button1 = GUICtrlCreateButton("Run EST3 convert", 136, 50, 150, 50, $WS_GROUP)
$form1_button2 = GUICtrlCreateButton("Run EST2 convert", 136, 100, 150, 50, $WS_GROUP)
$form1_button3 = GUICtrlCreateButton("Run QS convert", 136, 150, 150, 50, $WS_GROUP)

;GUICtrlSetOnEvent(-1, "Button1Click")
GUISetState()
#EndRegion ### END Koda GUI section ###

 While 1
        $nMsg = GUIGetMsg()
        Select
            Case $nMsg = $form1_button1
					Run ( "cmd.exe /c C:\fireutils\est32csv.exe *.brc" [, "c:\fireutils" [, @SW_MAXIMIZE]] )
				;ShellExecute ( "C:\fireutils\est32csv.exe" [, "*.brc" [, "c:\fireutils" [, "open" [, @SW_MAXIMIZE]]]])
				


                
            Case $nMsg = $form1_button2
					Run ( "C:\fireutils\est22csv.exe object.txt" [, "c:\fireutils" [, @SW_MAXIMIZE]] )

			Case $nMsg = $form1_button3
					Run ( "C:\fireutils\qs2csv.exe object.txt" [, "c:\fireutils" [, @SW_MAXIMIZE]] )

                	
			Case $nMsg = -5
                Exit
        EndSelect
        WEnd

EndFunc

