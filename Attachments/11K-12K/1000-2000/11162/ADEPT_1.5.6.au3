;;Auto Data Entry and Processing Tool v1.5.6
;A GUI to read send()able and execute()able strings from an Excel
;Spreadsheet (and maybe other places too) and then send them
;to a nominated window.
;
;

#include <Array.au3>
#include <GUIConstants.au3>
#Include <GuiListView.au3>

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1); Change to OnEvent mode 

HotKeySet("!g","GoMacro")

Dim $Running = "N"
Dim $WindowRefreshTimer; Timer for refreshing window list periodically
Dim $CurrentApp      ;Window currently being actioned
Dim $CurrentInValue  ;Field number of current row in source
Dim $CurrentValues[1]  ;Strings for sending or executing
Dim $NumColumns      ;User specified spreadsheet width
Global $OldWindowList  ;List of windows
Dim $guiADE              ;Main GUI window
Dim $guiHelp              ;Help GUI WIndow
Dim $Label1              ;GUI Label
Dim $Label2              ;GUI Label
Dim $Label3              ;GUI Label
Dim $Label4              ;GUI Label
Dim $Label6              ;GUI Label
Dim $Label7              ;GUI Label
Dim $Label8              ;GUI Label
Dim $Label9              ;GUI Label
Dim $lblStatus          ;Label on GUI for displaying text status of application
Dim $lblRowsProcessed  ;Label on GUI for displaying progress
Dim $cboSource          ;combo box on GUI for source window
Dim $cboDestination  ;combo box on GUI for destination window
Dim $inpNumColumns  ;input box on GUI for number of columns to be read on source window    
Dim $inpSkipRows      ;input box on GUI for number of rows to skip at start of source window read
Dim $btnGo              ;button on gui for initiating macro run
Dim $btnStop          ;button on gui for stopping macro run
Dim $btnHelp          ;button on gui for providing sytax and run help
Dim $btnCopyToClip      ;button on gui for copying selected help list view item to clipboard
Dim $Group1              ;Group on GUI for grouping radio buttons
Dim $rdoTop              ;radio button on gui for selecting start at top of source
Dim $rdoCursor          ;radio button on gui for selecting start at cursor line in source window
Dim $picRunning          ;picture on GUI for graphically displaying running status
Dim $picStopped      ;picture on GUI for graphically displaying stopped status
Dim $msg              ;GUI message for event based programming
Dim $CurrentInValue  ;Counter and status flag for progress through a record in input phase
Dim $CurrentOutValue  ;Counter and status flag for progress through a record in output phase
Dim $Source              ;Contents of $cboSource
Dim $Destination      ;Contetns of $cboDestination
Dim $SkipRows          ;Contents of $inpSkipRows
Dim $CountRowsProcessed;Counter for user feedback of progress
Dim $Helptext          ;temp variable for displaying help text in messagebox
Dim $lvHelp              ;list view control in Help GUI
Dim $lviHelp[4][40]      ;[0][x] is control id of listview item. [1][x] is column1, [2][x] is column2, [3][x] is column3.
Dim $lvHelpItem1      ;item in $lvHelp
Dim $lvHelpItem2      ;item in $lvHelp
Dim $lvHelpItem3      ;item in $lvHelp
Dim $lvHelpItem4      ;item in $lvHelp
Dim $lvHelpItem5      ;item in $lvHelp
Dim $lvHelpItem6      ;item in $lvHelp
Dim $lvHelpItem7      ;item in $lvHelp
Dim $lvHelpItem8      ;item in $lvHelp
Dim $lvHelpItem9      ;item in $lvHelp
Dim $lvHelpItem10      ;item in $lvHelp
Dim $lvHelpItem11      ;item in $lvHelp
Dim $lvHelpItem12      ;item in $lvHelp
Dim $lvHelpItem13      ;item in $lvHelp
Dim $lvHelpItem14      ;item in $lvHelp
Dim $lvHelpItem15      ;item in $lvHelp
Dim $lvHelpItem16      ;item in $lvHelp
Dim $lvHelpItem17      ;item in $lvHelp
Dim $lvHelpItem18      ;item in $lvHelp
Dim $lvHelpItem19      ;item in $lvHelp
Dim $lvHelpItem20      ;item in $lvHelp
Dim $lvHelpItem21      ;item in $lvHelp
Dim $lvHelpItem22      ;item in $lvHelp
Dim $lvHelpItem23      ;item in $lvHelp
Dim $lvHelpItem24      ;item in $lvHelp
Dim $lvHelpItem25      ;item in $lvHelp
Dim $lvHelpItem26      ;item in $lvHelp
Dim $lvHelpItem27      ;item in $lvHelp
Dim $lvHelpItem28      ;item in $lvHelp
Dim $lvHelpItem29      ;item in $lvHelp
Dim $lvHelpItem30      ;item in $lvHelp
Dim $ExpandedMode = "N";tracks whether gui is in expanded mode (for help) or not

;GUI
   $guiADE = GUICreate("ADEPT - Auto Data Entry Processing Tool v1.5.6", 504, 153, @DesktopWidth-514, 5)
   GUISetOnEvent($GUI_EVENT_CLOSE, "Event_GUI_EVENT_CLOSE")

;LABELS
   $Label1 = GUICtrlCreateLabel("Source Excel Window (must be open)", 8, 12,182, 20)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $Label2 = GUICtrlCreateLabel("Destination Window (must be open)", 8, 36,172, 20)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $Label3 = GUICtrlCreateLabel("Skip the First x Rows", 8, 84, 112, 17)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $label7 = GUICtrlCreateLabel("Number of columns to process",8, 60, 172, 20)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $Label6 = GUICtrlCreateLabel("Status", 280, 111, 34, 17)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $lblStatus = GUICtrlCreateLabel("Stopped", 280, 127, 100, 20, $WS_BORDER,$WS_EX_CLIENTEDGE)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $Label4 = GUICtrlCreateLabel("Rows Processed", 390, 111, 84, 17)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $lblRowsprocessed = GUICtrlCreateLabel("0", 390, 127, 100, 20, -1, $WS_EX_CLIENTEDGE)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $Label8 = GUICtrlCreateLabel("Keystrokes may be sequenced in a cell.   Commands (starting with '\') must have their own cell.", 10, 155, 450, 20)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $Label9 = GUICtrlCreateLabel("For more detailed information on functions and sendkeys refer to AutoIt3 help", 10, 170, 450, 20)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)

;COMBOS
   $OldWindowList = GetWindowList()
   $cboSource = GUICtrlCreateCombo("", 192, 8, 305, 220)
   GUICtrlSetData($cboSource,_ArrayToString($OldWindowList,"|"))
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
  ;GUICtrlSetOnEvent ( $cboSource, "RefreshWindowList" )
   $cboDestination = GUICtrlCreateCombo("", 192, 32, 305, 220)
   GUICtrlSetData($cboDestination,_ArrayToString($OldWindowList,"|"))
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
  ;GUICtrlSetOnEvent ( $cboDestination, "RefreshWindowList" )
   ReFreshWindowList();$OldWindowList)
   
;INPUT BOXES
   $inpNumColumns = GUICtrlCreateInput("",192, 56, 100, 21, -1, $WS_EX_CLIENTEDGE)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $inpSkipRows = GUICtrlCreateInput("0", 192, 80, 100, 21, -1,$WS_EX_CLIENTEDGE)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   
;BUTTONS
   $btnGo = GUICtrlCreateButton("Go (Alt-G)", 8, 117, 75, 30)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   GUICtrlSetOnEvent ( $btnGo, "GoMacro" )

   $btnStop = GUICtrlCreateButton("Stop (Esc)", 84, 117, 75, 30)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   GUICtrlSetOnEvent ( $btnStop, "StopMacro" )

   $btnHelp = GUICtrlCreateButton("Help>>",160, 117, 75, 30)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   GUICtrlSetOnEvent($btnhelp, "Event_btnHelp")
   
   $btnCopyToClip = GUICtrlCreateButton("Copy Usage to Clipboard",10, 550, 140, 30)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   GUICtrlSetOnEvent($btnCopyToClip, "Event_btnCopyToClip")

;RADIO BUTTONS
   $Group1 = GUICtrlCreateGroup("Start at:", 338, 61, 154, 40)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $rdoTop = GUICtrlCreateRadio("Top", 346, 77, 50, 17)
   GUICtrlSetState(-1, $GUI_CHECKED)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $rdoCursor = GUICtrlCreateRadio("Cursor", 406, 77, 50, 17)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   GUICtrlSetOnEvent($rdoCursor,"Event_rdoCursor")
   GUICtrlCreateGroup("", -99, -99, 1, 1)

;PICTURES
   FileDelete ( @TempDir & "\Recycling.ico" )
   FileDelete ( @TempDir & "\Stop.ico" )
   FileInstall("Recycling.ico", @TempDir & "\Recycling.ico")
   FileInstall("Stop.ico", @TempDir & "\Stop.ico")
   $picRunning = GUICtrlCreateIcon(@TempDir & "\Recycling.ico", -1, 245, 115)
   GUICtrlSetState($picRunning, $GUI_HIDE)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $picStopped = GUICtrlCreateIcon(@TempDir & "\Stop.ico", -1, 245, 115)
   GUICtrlSetState($picStopped, $GUI_SHOW)
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   GUISetState(@SW_SHOW)
   
;LIST VIEW
   $lvHelp = GUICtrlCreateListView("Key or Command|          Typical Use          |          Usage          ",10,185,480,360, -1, BitOr($LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
   GUICtrlSetResizing(-1,$GUI_DOCKALL)
   $lviHelp[1][1] = "a-z, A-Z and 0-9"
   $lviHelp[2][1] = "Names, numbers etc.."
   $lviHelp[3][1] = "Just type!"
   
   $lviHelp[1][2] = "TAB"
   $lviHelp[2][2] = "Navigate to next control (field, button, checkbox, etc)"
   $lviHelp[3][2] = "{TAB}"

   $lviHelp[1][3] = "SHIFT-TAB"
   $lviHelp[2][3] = "Navigate to previous control"
   $lviHelp[3][3] = "+{TAB}"

   $lviHelp[1][4] = "ENTER/RETURN"
   $lviHelp[2][4] = ""
   $lviHelp[3][4] = "{ENTER}"

   $lviHelp[1][5] = "SPACE"
   $lviHelp[2][5] = "Can be used to toggle a checkbox or click a button."
   $lviHelp[3][5] = "{SPACE}"

   $lviHelp[1][6] = "PAGE UP"
   $lviHelp[2][6] = ""
   $lviHelp[3][6] = "{PGUP}"
   
   $lviHelp[1][7] = "PAGE DOWN"
   $lviHelp[2][7] = ""
   $lviHelp[3][7] = "{PGDN}"

   $lviHelp[1][8] = "F1"
   $lviHelp[2][8] = "Help"
   $lviHelp[3][8] = "{F1}"

   $lviHelp[1][9] = "F13"
   $lviHelp[2][9]   = ""
   $lviHelp[3][9] = "+{F1}"

   $lviHelp[1][10] = "NUMBER PAD +"
   $lviHelp[2][10]   = "AS400 Field Exit"
   $lviHelp[3][10] = "{NUMPADADD}"

   $lviHelp[1][11] = "RIGHT CONTROL"
   $lviHelp[2][11]   = "AS400 Field Exit"
   $lviHelp[3][11] = "{RCTRL}"

   $lviHelp[1][12] = "LEFT CONTROL"
   $lviHelp[2][12]   = "AS400 Clear Error"
   $lviHelp[3][12] = "{LCTRL}"

   $lviHelp[1][13] = "CONTROL-P"
   $lviHelp[2][13]   = "Print"
   $lviHelp[3][13] = "^p"

   $lviHelp[1][14] = "ALT-f"
   $lviHelp[2][14]   = "Alt+f, usually the access key for file menu. Try other letters!"
   $lviHelp[3][14] = "!f"
   
   $lviHelp[1][15] = "UP ARROW"
   $lviHelp[2][15]   = "Move up a menu.  Previous Oracle record."
   $lviHelp[3][15] = "{UP}"
   
   $lviHelp[1][16] = "DOWN ARROW"
   $lviHelp[2][16]   = "Move down a menu.  Next Oracle record."
   $lviHelp[3][16] = "{DOWN}"

   $lviHelp[1][17] = "LEFT ARROW"
   $lviHelp[2][17]   = "Move leftward to new menu or collapse a submenu (amongst other uses)."
   $lviHelp[3][17] = "{LEFT}"

   $lviHelp[1][18] = "RIGHT ARROW"
   $lviHelp[2][18]   = "Move rightward to new menu or expand a submenu (amongst other uses)."
   $lviHelp[3][18] = "{RIGHT}"

   $lviHelp[1][19] = "^"
   $lviHelp[2][19]   = ""
   $lviHelp[3][19] = "{^}"

   $lviHelp[1][20] = "\"
   $lviHelp[2][20]   = ""
   $lviHelp[3][20] = "{\}"

   $lviHelp[1][21] = "+"
   $lviHelp[2][21]   = "Usually checks a checkbox (if it's a 'real' checkbox.)"
   $lviHelp[3][21] = "{+}"

   $lviHelp[1][22] = "-"
   $lviHelp[2][22]   = "Usually unchecks a checkbox."
   $lviHelp[3][22] = "{-}"

   $lviHelp[1][23] = "!"
   $lviHelp[2][23]   = ""
   $lviHelp[3][23] = "{!}"

   $lviHelp[1][24] = "Wait 1.5 Seconds"
   $lviHelp[2][24]   = "Pause for application to think"
   $lviHelp[3][24] = "\sleep(1500)"

   $lviHelp[1][25] = "Wait For Oracle"
   $lviHelp[2][25]   = "Pause for Oracle to think"
   $lviHelp[3][25] = "\OracleSleep"

   $lviHelp[1][26] = "Beep"
   $lviHelp[2][26]   = "Get User's attention"
   $lviHelp[3][26] = "\Beep(500,1000)"

   $lviHelp[1][27] = "Left mousclick at 0,500"
   $lviHelp[2][27]   = "Click a button or field"
   $lviHelp[3][27] = "\MouseClick(""left"", 0, 500, 1)"

   $lviHelp[1][28] = "Activate a window"
   $lviHelp[2][28]   = "Swapping Windows for entering Data into multiple applications"
   $lviHelp[3][28] = "\WinActivate(""Notepad.exe"")"

   $lviHelp[1][29] = "Wait for a window to become active"
   $lviHelp[2][29]   = "Swapping Windows for entering Data into multiple applications"
   $lviHelp[3][29] = "\WinWaitActive(""Notepad.exe"")"

   $lviHelp[1][30] = "Stop Macro"
   $lviHelp[2][30]   = "End of data.  Line containing command not executed."
   $lviHelp[3][30] = "\Finished Sheet"

   $lviHelp[1][31] = "End Row (early)"
   $lviHelp[2][31]   = "Finish row here.  Subsequent rows return to chosen number or columns."
   $lviHelp[3][31] = "\Finished Row"

   For $Count = 1 to ubound($lviHelp,2)-1
     $lviHelp[0][$Count] = GUICtrlCreateListViewItem($lviHelp[1][$Count] & "|" & $lviHelp[2][$Count] & "|" & $lviHelp[3][$Count], $lvHelp)
   Next
   _GUICtrlListViewSetColumnWidth($lvHelp, 1, 203)
   _GUICtrlListViewSetColumnWidth($lvHelp, 2, 151)

;Put as help about?
#comments-start
   $HelpText = "Welcome to the Auto Data Entry Tool!" & @CRLF & @CRLF
   $HelpText = $HelpText & "The purpose of this tool is to automate transfer of information from one application to another, where that data transfer would typically be done by a person.  The tool is designed for the source application to be Excel, although it MAY work with other applications.   Each row in the spreadsheet is intended to be on cycle of the data entry.  Each cell may contain either keystrokes or commands." & @CRLF & @CRLF
   $HelpText = $HelpText & "Keystrokes will either be simple text (eg 123) or special keys.  Special keys are those that are on the keyboard but do not have a letter corresponding to them (eg the TAB key).   Special keys are enclosed in curly braces (eg {TAB}).   Some normal characters have been reserved for special keys and therefore the normal key should be enclosed in curly braces.  For example, the character '!' us used to represent a 'Alt Key' press so if you wanted to send Alt-C, then you would have '!c'.   If you wanted to send 'exclamation mark-C' you would represent it as {!}c.   Full details of these are provided below." & @CRLF & @CRLF
   $HelpText = $HelpText & "Commands are instructions to the program to do something.   In general these are advanced options, however a few simple ones are listed below.   Example commands are an instruction to do nothing for 2 seconds, which would be represented as '\sleep(2000)'   Commands always start with a backslash character '\'." & @CRLF & @CRLF
   $HelpText = $HelpText & "KEYSTROKES" & @CRLF & @CRLF
   $HelpText = $HelpText & "Special Key Instruction" & @TAB & "Resulting Simulated Keypress" & @CRLF 
   $HelpText = $HelpText & "------------------------" & @TAB & "-------------------------------"& @CRLF & @CRLF
#comments-end


   $WindowRefreshTimer = TimerInit()
   While 1
     sleep(10)
     If TimerDiff($WindowRefreshTimer) > 4000 Then 
        $WindowRefreshTimer = TimerInit();Update list of available windows every 4 seconds
        RefreshWindowList()
     Endif
     If $Running = "Y" Then
        If $CurrentInValue <= $NumColumns Then GetNextAction($Source, $SkipRows, $CurrentInValue, $CurrentOutValue, $NumColumns, $CurrentValues)
        If $CurrentOutValue <= $CurrentValues[0] Then SendNextAction($Destination, $CurrentInValue, $CurrentOutValue, $NumColumns, $CurrentValues, $CountRowsProcessed)
        If $CurrentInValue > $NumColumns and $CurrentOutValue > $CurrentValues[0] then 
		  msgbox(0,"foo","")
		  StopMacro()
	    Endif
        GUICtrlSetData($lblRowsprocessed,$CountRowsProcessed)
     Endif
   WEnd
Exit
;---------------------------------------------------------------------------------------------------------------------
Func GetNextAction($CurrentApp, $SkipRows, ByRef $CurrentInValue, ByRef $CurrentOutValue, $NumColumns, ByRef $CurrentValues)
;This function retrieves 1 value at a time from the source window.   Possible improvement is to select
;entire row in one go.

Dim $Temp = ""

   WinActivate($CurrentApp,"")
   sleep(100)
   If WinActive($CurrentApp,"") Then
     If $CurrentInValue = -3 Then;First Row, at top
        send("^{HOME}")
        If $SkipRows > 0 then send("{DOWN " & $SkipRows & "}")
        $CurrentInValue = 1
     ElseIf $CurrentInValue = -2 Then; First Row, at cursor
        send("{HOME}")
        If $SkipRows > 0 then send("{DOWN " & $SkipRows & "}")
        $CurrentInValue = 1
     ElseIf $CurrentInValue = -1 Then; New Row
        send("{HOME}")
        Send("{DOWN}")
        $CurrentInValue = 1
        $CurrentValues[0] = $NumColumns
     Endif
     Send("^{INS}")
	sleep(50)
     $Temp = ClipGet()
  ;msgbox(0,"error",@error)
     $CurrentValues[$CurrentInValue] = TrimCRLF($Temp)
     If StringUpper($CurrentValues[$CurrentInValue]) = "\FINISHED ROW" Then
        $CurrentValues[0] = $CurrentInValue - 1
        $CurrentInValue = $NumColumns                                      ;Prematurely end row by artificially indicating rows complete
     Endif
     If StringUpper($CurrentValues[$CurrentInValue]) = "\FINISHED SHEET" Then
        StopMacro()
     Endif
     send("{RIGHT}")
     $CurrentInValue = $CurrentInValue + 1
     If $CurrentInValue > $NumColumns Then $CurrentOutValue = 1
   Endif
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func SendNextAction($CurrentApp, ByRef $CurrentInValue, ByRef $CurrentOutValue, $NumColumns, $CurentValues, ByRef $CountRowsProcessed)
;This function sends one action at a time.   Was originally done one at a time so that user could interrupt when before I switched to
;using OnEventMode.  Possible improvement is to do a whole row of commands at a time.

Dim $AllEmpty;Confirm not an empty row

   $AllEmpty = "Y"
   For $Count = 1 to $NumColumns
     If $CurrentValues[$Count] <> "" Then $AllEmpty = "N"
   Next
   If $AllEmpty = "N" then
     WinActivate($CurrentApp,"")
     sleep(200)
     If WinActive($CurrentApp,"") Then
        If StringLeft($CurrentValues[$CurrentOutValue],1) = "\" Then
          If StringUpper($CurrentValues[$CurrentOutValue]) = "\ORACLESLEEP" Then
            OracleSleep($CurrentApp)
          Else
            Execute(StringTrimLeft($CurrentValues[$CurrentOutValue],1))
          Endif
      Else
          Send($CurrentValues[$CurrentOutValue])
        Endif
        $CurrentOutValue = $CurrentOutValue + 1

        If $CurrentOutValue > $CurrentValues[0] Then 
          $CurrentInValue = -1
          $CurrentOutValue = $Numcolumns + 1
          $CountRowsProcessed = $CountRowsProcessed + 1
        Endif
     Endif
   Else
     $CurrentOutValue = $NumColumns + 1
   Endif
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func TrimCRLF($Value)
;Strip unwanted characters from end of clipboard

   While stringRight($Value,1) = @CR or StringRight($Value,1) = @LF
     $Value = StringTrimRight($Value,1)
   Wend
   Return $Value
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func ConfirmGUIOK()
;Validate user selections before starting

   Select
     Case GUICtrlRead($cboSource) = "" 
        msgbox(0,"Error","Please select a source window!")
        Return "N"
     Case GUICtrlRead($cboDestination) = ""
        msgbox(0,"Error","Please select a destination window!")
        Return "N"
     Case StringIsDigit(GUICtrlRead($inpNumColumns)) = 0 or GUICtrlRead($inpNumColumns) = "" or GUICtrlRead($inpNumColumns) = "0"
        msgbox(0,"Error","Please put a non-zero numeric value in the 'Number of columns to process' box")
        Return "N"
     Case StringIsDigit(GUICtrlRead($inpSkipRows)) = 0 and GUICtrlRead($inpSkipRows) <> ""
        msgbox(0,"Error","Please put a numeric value in the 'Skip the First x Rows' box")
        Return "N"
     Case Else
        return "Y"
   EndSelect
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then
    Return 1
  Else
    Return 0
  EndIf
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func ArrayPush(ByRef $Array, $Value)
;Had some problems with the dimensioning of _ArrayAdd, so I used this instead.

         If UBound($Array) > 1 or $Array[0] <> "0" Then ReDim $Array[UBound($Array)+1]
         $Array[UBound($Array)-1] = $Value
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func StopMacro()
;Update UI and status when stopping 'run'
HotKeySet("!g","GoMacro")
HotKeySet("{ESC}")

   $Running = "N"
   GUICtrlSetData($lblStatus,"Stopped")
   WinSetOnTop($guiADE,"",0)
   GUICtrlSetState($picRunning, $GUI_HIDE)
   GUICtrlSetState($picStopped, $GUI_SHOW)

EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func GoMacro()
;Update UI and status when starting 'run'
HotKeySet("!g")
HotKeySet("{ESC}","StopMacro")

   If $Running = "N" Then 
     If ConfirmGUIOK() = "Y" then 
        $Running = "Y"
        GUICtrlSetData($lblStatus,"Running")
        WinSetOnTop($guiADE,"",1)
        $NumColumns = GUICtrlRead($inpNumColumns)
        $CurrentValues[0] = $NumColumns
        ReDim $CurrentValues[$NumColumns+1]
        If GUICtrlRead($rdoTop) = $GUI_CHECKED Then 
          $CurrentInValue = -3; First row, at top
        Else 
          $CurrentInValue = -2; First row, at cursor
        Endif
        $CurrentOutValue = $NumColumns + 1; Not doing data entry at the moment
        $Source = GUICtrlRead($cboSource)
        $Destination = GUICtrlRead($cboDestination)
        $SkipRows = GUICtrlRead($inpSkipRows)
        If $SkipRows = "" Then $SkipRows = 0
        $CountRowsProcessed = 0
        GUICtrlSetState($picRunning, $GUI_SHOW)
        GUICtrlSetState($picStopped, $GUI_HIDE)
     Endif
   Endif
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func ADE_Expand()
;Show Help stuff

Local $WindowSize[4]
   $WindowSize = WinGetPos("ADEPT")
   GUICtrlSetData($btnHelp,"Help<<")
   WinMove("ADEPT","", $WindowSize[0],$WindowSize[1], $WindowSize[2], 620)
;GUISetState(@SW_SHOW)
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func ADE_Collapse()
;Hide Help stuff

Local $WindowSize[4]
   $WindowSize = WinGetPos("ADEPT")
   GUICtrlSetData($btnHelp,"Help>>")
   WinMove("ADEPT","", $WindowSize[0],$WindowSize[1], $WindowSize[2], 185)
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func OracleSleep($OracleName)
;This function waits until Oracle Applications is ready by checking the cursor status.

Local $StartWait
Local $EndWait
Local $WaitInterval
Local $WaitIterations

Dim $Count
   ;msgbox(0,"oraclewait","")
   $StartWait = 500
   $EndWait = 750
   $WaitInterval = 100
   $WaitIterations = 15

   $Count = 0
   AutoItSetOption("MouseCoordMode",0)


   WinWait($OracleName,"")
   If Not WinActive($OracleName,"") Then WinActivate($OracleName,"")
   WinWaitActive($OracleName,"")

   sleep($StartWait)
   while $Count <= $WaitIterations

     sleep($WaitInterval)
     MouseMove("220","165","0")
     if MouseGetCursor()<>14 then
        $Count = $Count + 1
     Else
        $Count = 0
     EndIf
   Wend
   Sleep($EndWait)
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func ReFreshWindowList()
;Get a fresh list of valid windows for selection

   Dim $TempSource
   Dim $TempDestination
   Dim $NewWindowList
   
   $NewWindowList = GetWindowList()
   If _ArrayToString($NewWindowList,"|") <> _ArrayToString($OldWindowList,"|") Then
	 $OldWindowList = $NewWindowList
	 $TempSource = GUICtrlRead($cboSource)
	 $TempDestination = GUICtrlRead($cboDestination)
	 GUICtrlSetData($cboSource,_ArrayToString($NewWindowList,"|"))
	 If $TempSource <> "" and StringInStr(_ArrayToString($NewWindowList,"|"), $TempSource) Then GUICtrlSetData($cboSource, $TempSource)
	 GUICtrlSetData($cboDestination,_ArrayToString($OldWindowList,"|"))
	 If $TempDestination <> "" and StringInStr(_ArrayToString($NewWindowList,"|"), $TempDestination) Then GUICtrlSetData($cboDestination,$TempDestination)
   Endif
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func GetWindowList()
;Get a list of valid windows for selection

Local $InitialWindowList;As returned by built-in Autoit function
Local $FinalWindowList[1];To be returned by this function

   $InitialWindowList = WinList()
   For $i = 1 to $InitialWindowList[0][0]
; Only display visble windows that have a title
     If $InitialWindowList[$i][0] <> "" AND $InitialWindowList[$i][0] <> "Program Manager" and IsVisible($InitialWindowList[$i][1]) Then
        ArrayPush($FinalWindowList,$InitialWindowList[$i][0])
     EndIf
   Next
   _ArraySort($FinalWindowList)
   Return $FinalWindowList
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func Event_GUI_EVENT_CLOSE()

   Exit
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func Event_btnHelp()

   If $ExpandedMode = "N" Then 
     ADE_Expand()
     $ExpandedMode = "Y"
   Else
     ADE_Collapse()
     $ExpandedMode = "N"
   Endif
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func Event_btnCopyToClip()

   For $Count = 0 to Ubound($lviHelp,2)-1
     If $lviHelp[0][$Count] = GUICtrlRead($lvHelp) Then 
        ClipPut($lviHelp[3][$Count])
     Endif
   Next
EndFunc

;---------------------------------------------------------------------------------------------------------------------
Func Event_rdoCursor()

   If StringIsDigit(GUICtrlRead($inpSkipRows)) and GUICtrlRead($inpSkipRows) <> 0 and GUICtrlRead($inpSkipRows) <> "" then 
        msgbox(0,"Warning","The first " & GUICtrlRead($inpSkipRows) & " rows from the cursors row will be skipped!  Update this to 0 if you wish no rows to be skipped")
   Endif
EndFunc