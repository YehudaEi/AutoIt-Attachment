#cs


HISTORY:
Date	      	Version	Description
---------------	-------	--------------------------------------------------------------------------------------------
23/Aug/2005		0.0.0	First created

#ce
#include <GuiConstants.au3>
;#include <File.au3>
;#include <Array.au3>
;#include <String.au3>
#include <Date.au3>
;#notrayicon
Dim $ProcID = "ISDN Data"
Dim $Version = " v0.0.0"
;---------------------------------------------------------+---------------------------------------------------------
; PLACE AT TOP OF SCRIPT
$g_szVersion = "ISDN GUI" & $Version
If WinExists($g_szVersion) Then Exit ; It's already running
AutoItWinSetTitle($g_szVersion)
;---------------------------------------------------------+---------------------------------------------------------
; ADDED: Sun 12/June/2005
; HERE WE SET THE DATE VALUE SO WE CAN USE IT FOR NAMING A DIRECTORY.
; OUR DIRECTORY WILL SHOW THE SPECIFIED BACKUP NAME AND WILL ALSO PROVIDE THE CURRENT DATE AND TIME SO WE KNOW WHEN
; IT WAS BACKED UP.
; IN DEFINING THE DATE STRUCTURE WE USE THE "." (PERIOD CHARACTER) TO SEPERATE THE DAY, MONTH AND YEAR.
; THIS IS SO WE DON'T HAVE A RECURSIVE DIRECTORY STRUCTURE WHEN CREATED AND GET OUR DATE AND TIME ON ONE LINE.
; ALSO THIS HAS TO COME FIRST BEFORE WE ASSIGN THE DATE AND TIME VARIABLES TO THE DIRECTORY PATH. 
	Func _today()  ;Return the current date in dd.mm.yyyy form
		return (@MDAY & "." & @MON & "." & @YEAR)
	EndFunc

	Func _time()  ;Return the current time in hh.mm form
		return (@HOUR & "." & @MIN)
	EndFunc
	
	Global $OldSec = @SEC	; Added: 17/June/2005 - Used for clock in GUI
	Global $OldMin = @MIN	; Added: 17/June/2005 - Used for control GUI refresh
;---------------------------------------------------------+---------------------------------------------------------
; PREDEFINED VARIABLES
$sSource = "H:\My Documents\ISDN Guard"
$sBackup_Path = "K:\BACKUP.Zone\ISDN.Guard.Logs_Full"
$s_Time_Stamp = _today() & "_" & _time()
$sBackup = $sBackup_Path & "\_" & $s_Time_Stamp
$ScriptDir = @ScriptDir
$sScript = @ScriptName
$ScriptFull = @ScriptFullPath
Global $LogFile = "ISDN.log"
Global $INIFile = "ISDN.ini"
;---------------------------------------------------------+---------------------------------------------------------
; Little helper to exit the program
HotKeySet("{F3}", "Set_Exit")
;---------------------------------------------------------+---------------------------------------------------------
#cs
	$WS_POPUP				=	Creates a pop-up window. This style cannot be used with the WS_CHILD style.
	$WS_EX_TOPMOST			=	Specifies that a window created with this style should be placed above all non-topmost windows and should stay above them, even when the window is deactivated. 
	$WS_EX_TOOLWINDOW		=	Creates a tool window; that is, a window intended to be used as a floating toolbar.
	$WS_EX_CLIENTEDGE		=	Specifies that a window has a border with a sunken edge.
	$WS_EX_DLGMODALFRAME	=	Creates a window that has a double border; the window can, optionally, be created with a title bar by specifying the WS_CAPTION style in the dwStyle parameter. 
	$WS_EX_ACCEPTFILES		=	Allow an edit or input control within the created GUI window to receive filenames via drag and drop. The control must have also the $GUI_ACCEPTFILES state set by GUICtrlSetState. 
#ce
$GPS_Menu3 = GUICreate("*CoRe Backups Pro* Title", -1, 430, -1, -1, $WS_POPUP, $WS_EX_TOPMOST + $WS_EX_TOOLWINDOW + $WS_EX_CLIENTEDGE + $WS_EX_DLGMODALFRAME)
GUISetBkColor("")

; <!----------------->
; <!-- First Frame -->
; <!----------------->
; Next 2 lines - create the frame and set the background color
GUICtrlCreateLabel("", 0, 0, 400, 38, $SS_SUNKEN, $WS_EX_DLGMODALFRAME)
GUICtrlSetBkColor(-1, "")
; Next 3 lines - create the label and set the font color and size
GUICtrlCreateLabel(" *ISDN Log*   -   Backup/Restore   XP Program " & $Version, 10, 10, 400, 20)
GUICtrlSetFont(-1, 10, 650)
GUICtrlSetColor(-1, 0x00ff00)

; <!------------------>
; <!-- Second Frame -->
; <!------------------>
GUICtrlCreateLabel("", 0, 38, 400, 55, $SS_SUNKEN, $WS_EX_DLGMODALFRAME)
GUICtrlSetBkColor(-1, 0x00ff00)
; Info text
GUICtrlCreateLabel("This is a Backup Pro Series program.", 10, 50, 450, 20)
GUICtrlCreateLabel("You can either Backup or Restore the " & $ProcID & ".", 10, 65, 400, 20)

; Time details
$_StartTimeGlobal = GUICtrlCreateLabel("Time : 00:00:00", 410, 50)

; <!----------------->
; <!-- Third Frame -->
; <!----------------->
GUICtrlCreateLabel("", 0, 93, 400, 190, $SS_SUNKEN, $WS_EX_DLGMODALFRAME) ; vert, hort, wide, high - 190/296
GUICtrlSetBkColor(-1, 0x333333)

; GROUP 1 WITH RADIO BUTTONS
GuiCtrlCreateGroup(" Sys Info:", 15, 110, 370, 155)
GUICtrlSetBkColor(-1, 0x333333) ; grey
GUICtrlSetColor(3,0xffffff) ; white

GUICtrlCreateLabel("Computer Name:", 28, 130, 350, 20)
GUICtrlSetColor(-1, 0xff9900) ; orange
GUICtrlCreateLabel (@ComputerName, 120, 130, 130, 110)
GUICtrlSetColor(-1,0xffffff)
GUICtrlCreateLabel("User Name:", 28, 150, 350, 20)
GUICtrlSetColor(-1, 0xff9900)
GUICtrlCreateLabel (@UserName, 100, 150, 105, 130)
GUICtrlSetColor(-1,0xffffff)

GUICtrlCreateLabel("ISDN Source:", 28, 180, 350, 20)
GUICtrlSetColor(-1, 0xff9900)
GUICtrlCreateLabel ($sSource, 110, 180, 220, 160)
GUICtrlSetColor(-1,0xffffff)
GUICtrlCreateLabel("ISDN Backup:", 28, 200, 350, 20)
GUICtrlSetColor(-1, 0xff9900)
$_sBackupGlobal = GUICtrlCreateLabel ($sBackup, 110, 200, 260,180)
GUICtrlSetColor(-1,0xffffff)
GUICtrlCreateLabel("ISDN Restore:", 28, 220, 350, 20)
GUICtrlSetColor(-1, 0xff9900)
GUICtrlCreateLabel("ISDN Script:", 28, 240, 350, 20)
GUICtrlSetColor(-1, 0xff9900)
GUICtrlCreateLabel ($sScript,100 ,240, 120, 220)
GUICtrlSetColor(-1,0xffffff)

GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group

; GROUP 2 WITH RADIO BUTTONS
GuiCtrlCreateGroup(" Selections:", 15, 271, 370, 105)
GUICtrlSetColor(-1,0xffffff) ; white
GUICtrlSetBkColor(-1, 0x333333) ; grey


; BACKUP CHECKBOX
$radio_0 = GUICtrlCreateRadio ("Backup ISDN Data", 25, 285)
GUICtrlSetColor(-1,0xff0000) ; white
GUICtrlSetBkColor(-1,0x333333) ; grey

GUICtrlSetTip(-1,"Backup Option: Select this and click the RUN button to activate.")

; RESTORE CHECKBOX
$radio_1 = GUICtrlCreateRadio ("Restore ISDN Data", 25, 305)
GUICtrlSetBkColor(-1, 0x333333) ; grey
GUICtrlSetColor(-1,0xffffff) ; white
GUICtrlSetTip(-1,"Restore Option: Select this and click the RUN button to activate.")


GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group



; <!------------------>
; <!-- Fourth Frame -->
; <!------------------>



;$Install_2 = GuiCtrlCreateButton("&Install", 10, 320, 70, 20)
;GUICtrlSetState($Install_2, $GUI_SHOW)




;GUICtrlCreateLabel("", 0, 280, 400, 112, $SS_SUNKEN, $WS_EX_DLGMODALFRAME)
;GUICtrlSetBkColor(-1, 0x333333)


;$Icon_Int1 = GUICtrlCreateIcon("", 0, 60, 295, 30, 30)
;GUICtrlSetImage(-1, "shell32.dll", 129)
;GUICtrlSetCursor(-1, 0)
;GUICtrlSetState(-1, $GUI_SHOW)


; <!----------------->
; <!-- Fifth Frame -->
; <!----------------->

$ARU_Run = GUICtrlCreateLabel("", 320, 395, 20, 20)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, " Run ")

$ARU_Exit = GUICtrlCreateLabel("", 360, 395, 20, 20)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, " Exit ")

; NB: The order in which these following lines are placed is integral to the working function
;     of the Exit and Run processes. This includes the lines above.
;     Ensure they are not moved else the mouse over activation will not work.
GUICtrlCreateLabel("", 0, 390, 400, 40, $SS_SUNKEN, $WS_EX_DLGMODALFRAME)
GUICtrlSetBkColor(-1, "")

$Create = GUICtrlCreateLabel("Click icon to Exit or Run process", 15, 400, 340, 20)
GUICtrlSetFont(-1, 10, 650)
GUICtrlSetColor(-1, 0x00ff00)

$Icon_Run = GUICtrlCreateIcon("", 0, 320, 395, 30, 30)
GUICtrlSetImage(-1, "shell32.dll", 130)
GUICtrlSetCursor(-1, 0)

$Icon_Exit = GUICtrlCreateIcon("", 0, 360, 395, 30, 30)
GUICtrlSetImage(-1, "shell32.dll", 131)
GUICtrlSetCursor(-1, 0)

GUISetState(@SW_HIDE, $GPS_Menu3)

	GUISetState(@SW_SHOW)
	;GUICtrlSetState($Install_1, $GUI_ENABLE)
	;GUICtrlSetState($Install_2, $GUI_ENABLE)
While 1
	$Stop = ""
	ToolTip("")
	$msg = GUIGetMsg()

	Select
		Case $msg = $GUI_EVENT_CLOSE

			Exit

		Case $msg = $ARU_Exit ; User clicked the Exit icon

			Exit

		; Added: 17/June/2005 This is the function for the Clock on the GUI and shows the time in second increments
		Case $OldSec <> @SEC
			GUICtrlSetData($_StartTimeGlobal,StringFormat ( "Time : %2d:%02d:%02d", @HOUR, @MIN, @SEC))
			$OldSec = @SEC

		Case $OldMin <> @MIN
			; This process runs every 1 minute
			; Clear and remove the displayed value of $_VRBackupGlobal within the GUI 
			GUICtrlSetData($_sBackupGlobal,StringFormat ( "", @MIN))
			GUICtrlSetData($_sRestoreGlobal,StringFormat ( "", @MIN))
			; Grab the current date and time
			$TickTock = _today() & "_" & _time()
			; Declare current backup location based on current date and time
			$_AllNew_sBackup = $sBackup_Path & "\_" & $TickTock

	EndSelect

	Sleep(10)
WEnd

Func Set_Exit()
	; GUICtrlSetData($Notice, "System >  Good Bye... ")
	; SoundPlay($Sound_lnk, 1)
	Exit
EndFunc   ;==>Set_Exit


