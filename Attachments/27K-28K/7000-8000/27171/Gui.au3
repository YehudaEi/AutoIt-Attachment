#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiButton.au3>

#Region ### START Koda GUI section ### Form=C:\Documents and Settings\Administrator\Desktop\koda_1.7.2.0\Forms\Bot.kxf
$mobstersBot = GUICreate("Mobsters Bot", 570, 242, 192, 124)
$nameLabel = GUICtrlCreateLabel("Player Name:", 16, 16, 79, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$namei = GUICtrlCreateInput("Name", 96, 16, 75, 21)
$healthLabel = GUICtrlCreateLabel("Health:", 16, 40, 45, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$staminaLabel = GUICtrlCreateLabel("Stamina:", 16, 64, 53, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$energyLabel = GUICtrlCreateLabel("Energy:", 16, 88, 47, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$healthi = GUICtrlCreateInput("Health", 96, 40, 75, 21)
$staminai = GUICtrlCreateInput("Stamina", 96, 64, 75, 21)
$energyi = GUICtrlCreateInput("Energy", 96, 88, 75, 21)
$cashflowLabel = GUICtrlCreateLabel("Cash Flow:", 16, 112, 66, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$cashflowi = GUICtrlCreateInput("Cash Flow", 96, 112, 75, 21)
$startButton = GUICtrlCreateButton("Start", 16, 160, 81, 25, $WS_GROUP)
$stopButton = GUICtrlCreateButton("Stop", 112, 160, 81, 25, $WS_GROUP)
GUISetState(@SW_SHOW)
Dim $Form1_AccelTable[2][2] = [["^s", $startButton],["^q", $stopButton]]
GUISetAccelerators($Form1_AccelTable)
#EndRegion ### END Koda GUI section ###


Dim $hWnd = WinGetHandle('Mobsters Bot')
Dim $hStop = ControlGetHandle($hWnd, 'Stop', 2)
Dim $hStart = ControlGetHandle($hWnd, 'Start', 1)

While 1
    If _GUICtrlButton_GetState($hStop) = 620 Then
        _GUICtrlButton_Click($hStop)
        bstop( )
        ExitLoop
    EndIf
    
    If _GUICtrlButton_GetState($hStart) = 620 Then
        _GUICtrlButton_Click($hStart)
        bstart( )
        ExitLoop
    EndIf
    
    Sleep(20)
WEnd
    
Func bstop( )
    Exit
EndFunc

Func bstart( )
    start( )
EndFunc
Exit