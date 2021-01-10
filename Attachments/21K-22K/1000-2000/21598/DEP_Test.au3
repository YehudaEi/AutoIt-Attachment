#include <WindowsConstants.au3>

$Viewer = ObjCreate ("ELPhotoX.PhotoX")     ;Instantiate viewer
If @error Then
   MsgBox (0, "GUICtrlCreateObj Test", "Unable to instantiate first instance of ELPhotoX")
   Exit
EndIf
$Viewer.BackColor1 = 0x00000000             ;Set BackColor1 property
$Viewer.ShowBorder = 0                      ;Set the ShowBorder property
$Viewer.ScrollWindowvisible = 0             ;Do not show zoom window when zooming
$Viewer.AutoResize = 1

$Preview = ObjCreate ("ELPhotoX.PhotoX")    ;Instantiate preview
If @error Then
   MsgBox (0, "GUICtrlCreateObj Test", "Unable to instantiate second instance of ELPhotoX")
   Exit
EndIf
$Preview.BackColor1 = 0x00000000            ;Set BackColor1 property
$Preview.ShowBorder = 0                     ;Set the ShowBorder property

;                                           ;Create slide show window (initially hidden)
$Slide_Show_Window = GUICreate ("Slide Show", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP)
GUISetBkColor (0x00000000)
;                                           ;Embed Viewer object in slide show window (create ActiveX control)
$Embedded_Viewer_Control = GUICtrlCreateObj ($Viewer, 0, 0, @DesktopWidth, @DesktopHeight)

;                                           ;Create preview window (initially hidden)
$PreView_Window = GUICreate ("Slide Show", 238, 178, @DesktopWidth-238-50, @DesktopHeight-178-50, $WS_POPUP)
GUISetBkColor (0x00000000)
;                                           ;Embed Viewer object in preview window (create ActiveX control)
$Embedded_Preview_Control = GUICtrlCreateObj ($Preview, 0, 0, 238, 178)

MsgBox (0, "GUICtrlCreateObj Test", "All controls successfully embedded")
