;******************************
; by Jason Dubar 11/06
;
; A lot of help came from the AutoIt forums also!
; http://www.autoitscript.com/forum/index.php?showtopic=36935
;******************************
#Include <File.au3>
#Include <GUIConstants.au3>
#Include <GuiStatusBar.au3>
#Include <GuiListView.au3>
#Include <_ZipFunctions.au3>

Opt("TrayIconHide", 1)

Global $WM_DROPFILES = 0x233
Global $gaDropFiles[1]
Global $installbat = @TempDir&"\Install.bat"
Global $installtxt = @TempDir&"\Install.txt"
Global $installreg = @TempDir&"\Install.reg"
Global $installvbs = @TempDir&"\Install.vbs"
Global $zipfile = @ScriptDir&"\"&@MON&"-"&@MDAY&"-"&@YEAR&".zip"

Global $count = "0"

Global $a_PartsRightEdge[1] = [-1]
Global $a_PartsText[1] = [$count&" items"]

;Check the PC for the requirements before running
Call("SystemCheck")

;---------MAIN GUI-------------
$main =     GUICreate("Bundle Process", 400, 300, -1, -1, -1, $WS_EX_ACCEPTFILES)
$hList =    GUICtrlCreateListView(" # |Filename|Switch", 5, 5, 390, 190)
_GUICtrlListViewSetColumnWidth ($hList, 1, 301)
GUICtrlSetState (-1, $GUI_DROPACCEPTED)
$hLabel =   GUICtrlCreateLabel("To add files, drag && drop them into the list box", -1, 205, 400, -1, $SS_CENTER)
GUICtrlSetFont(-1, 9, 600)
$StatusBar = _GUICtrlStatusBarCreate($main, $a_PartsRightEdge, $a_PartsText)
$hStart =   GUICtrlCreateButton("&Start", 72, 230, 50)
$hAdd =     GuiCtrlCreateButton("A&dd", 122, 230, 50)
$hRemove =  GUICtrlCreateButton("&Remove", 172, 230, 50)
$hAbout =   GUICtrlCreateButton("&About", 222, 230, 50)
$hExit =    GUICtrlCreateButton("E&xit", 272, 230, 50)
$hUp =      GUICtrlCreateButton("&Up", 10, 220, 20, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
$hDown =    GUICtrlCreateButton("&Dn", 10, 240, 20, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetState(@SW_SHOW)
;-----------------------------

;---------ABOUT GUI-----------
$about =    GUICreate("About", 150, 136)
GUICtrlCreateIcon(@AutoItExe, 0, 57, 30)
GUICtrlCreateLabel("Created by", 47, 65)
GUICtrlCreateLabel("Jason Dubar 2006", 30, 80)
$aboutokbutton = GUICtrlCreateButton("&OK", 45, 100, 60, -1)
;-----------------------------

;-----------Progress GUI------
$progress = GUICreate("Compressing...", 300, 40)
$progbar =  GUICtrlCreateProgress(10,10,280,20,$PBS_SMOOTH)
GUISetState(@SW_HIDE)
;-----------------------------

;-----------Context Menu------
$listcontext   = GUICtrlCreateContextMenu($hList)
$listitem1     = GUICtrlCreateMenuItem("Move Up", $listcontext)
$listitem2     = GUICtrlCreateMenuItem("Move Down", $listcontext)
                 GUICtrlCreateMenuItem ("", $listcontext); separator
$listitem3     = GUICtrlCreateMenuItem("Remove", $listcontext)
$listitem4     = GUICtrlCreateMenuItem("Edit Switch", $listcontext)
;-----------------------------

GUIRegisterMsg ($WM_DROPFILES, "WM_DROPFILES_FUNC")

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $hExit
            Exit
        Case $hStart
            Call("CheckList")
        Case $hUp
            MoveUp(_GUICtrlListViewGetCurSel($hList))
        Case $listitem1
            MoveUp(_GUICtrlListViewGetCurSel($hList))
        Case $hDown
            MoveDown(_GUICtrlListViewGetCurSel($hList))
        Case $listitem2
            MoveDown(_GUICtrlListViewGetCurSel($hList))
        Case $hAdd
            Call("Add")
            Call("Count")
        Case $hAbout
            Call("About")
        Case $hRemove
            Remove(_GUICtrlListViewGetCurSel($hList))
            Call("Count")
        Case $listitem3
            Remove(_GUICtrlListViewGetCurSel($hList))
            Call("Count")
        Case $listitem4
            EditSwitch(_GUICtrlListViewGetCurSel($hList))
        Case $GUI_EVENT_DROPPED
            For $i = 0 To UBound($gaDropFiles) - 1
               ;Check if item dropped is a folder
               $fileList = _FileListToArray($gaDropFiles[$i])
               If @Error = 4 Then ; 4 = No Folder Found
                  $answer = MsgBox(262144+4+32, "Switches", "Any switches required for"&@CRLF&@CRLF&$gaDropFiles[$i]&"?")
                  If $answer = 6 Then
                     $switches = InputBox("Switches", "Enter the switches below:", "", "", -1, 80)
                     $nItem = GUICtrlCreateListViewItem($count+1&"|"&$gaDropFiles[$i]&"|"&$switches, $hList)
                  Else
                     $nItem = GUICtrlCreateListViewItem($count+1&"|"&$gaDropFiles[$i], $hList)
                  EndIf
                  Call("Count")
               Else
                  For $q = 1 To $fileList[0]
                     $answer = MsgBox(262144+4+32, "Switches", "Any switches required for"&@CRLF&@CRLF&$gaDropFiles[$i]&"\"&$fileList[$q]&"?")
                     If $answer = 6 Then
                        $switches = InputBox("Switches", "Enter the switches below:", "", "", -1, 80)
                        $nItem = GUICtrlCreateListViewItem($count+1&"|"&$gaDropFiles[$i]&"\"&$fileList[$q]&"|"&$switches, $hList)
                     Else
                        $nItem = GUICtrlCreateListViewItem($count+1&"|"&$gaDropFiles[$i]&"\"&$fileList[$q], $hList)
                     EndIf
                     Call("Count")  
                  Next
               EndIf
            Next
    EndSwitch
WEnd

Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
    Local $nSize, $pFileName
    Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
    For $i = 0 To $nAmt[0] - 1
        $nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
        $nSize = $nSize[0] + 1
        $pFileName = DllStructCreate("char[" & $nSize & "]")
        DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
        ReDim $gaDropFiles[$i+1]
        $gaDropFiles[$i] = DllStructGetData($pFileName, 1)
        $pFileName = 0
    Next
EndFunc

;The about winow's function which is accessed on the main GUI by pressing the About button or Alt+A
Func About()
   GUISetState(@SW_SHOW, $about)
   GUISetState(@SW_DISABLE, $main)
   While 1
      $msg = GUIGetMsg()
      If $msg = $aboutokbutton Then
         GUISetState(@SW_HIDE, $about)
         WinActivate($main, "")
         GUISetState(@SW_ENABLE, $main)
         ExitLoop
      EndIf
   Wend
EndFunc

;The function to remove a selected item from the list - if nothing has been selected, a message will appear and nothing will be done
Func Remove($selected)
   $selected = _GUICtrlListViewGetItemText($hList, $selected, 1)
   If $selected = "" Then
      MsgBox(262144+64, "Oops", "Nothing Selected.")
   Else
      $answer = MsgBox(262144+4+32, "Verify Removal", "Remove "&$selected&"?")
      If $answer = 6 Then
         $selectedindex = _GUICtrlListViewGetCurSel($hList)
         _GUICtrlListViewDeleteItem($hList, $selectedindex)
         ;Reorganize the numbers
         $amount = _GUICtrlListViewGetItemCount($hList)
         For $z = 1 To $amount
            _GUICtrlListViewSetItemText($hList, $z-1, 0, $z)
         Next
      EndIf
   EndIf
EndFunc

Func Add()
   $var = FileOpenDialog("Hold down Ctrl or Shift to choose multiple files", @DesktopDir, "All (*.*)", 1 + 4)
   If @error Then
      MsgBox(262144+64,"Oops","No File(s) chosen")
   Else
      $vars = StringSplit($var, "|")
      If @error = 1 Then
         $answer = MsgBox(262144+4+32, "Switches", "Any switches required for"&@CRLF&@CRLF&$var&"?")
         If $answer = 6 Then
            $switches = InputBox("Switches", "Enter the switches below:", "", "", -1, 80)
            $nItem = GUICtrlCreateListViewItem($count+1&"|"&$var&"|"&$switches, $hList)
         Else
            $nItem = GUICtrlCreateListViewItem($count+1&"|"&$var, $hList)
         EndIf
         Call("Count")
      Else
         For $u = 2 To $vars[0]
            $answer = MsgBox(262144+4+32, "Switches", "Any switches required for"&@CRLF&@CRLF&$vars[1]&$vars[$u]&"?")
            If $answer = 6 Then
               $switches = InputBox("Switches", "Enter the switches below:", "", "", -1, 80)
               $nItem = GUICtrlCreateListViewItem($count+1&"|"&$vars[1]&$vars[$u]&"|"&$switches, $hList)
            Else
               $nItem = GUICtrlCreateListViewItem($count+1&"|"&$vars[1]&$vars[$u], $hList)
            EndIf
            Call("Count")
         Next
      EndIf
   EndIf
EndFunc

;A simple running count of the items in the list
Func Count()
    $count = _GUICtrlListViewGetItemCount($hList)
    If $count = "1" Then
      $text = " item"
    Else
      $text = " items"
    EndIf
    Global $a_PartsText[1] = [$count&$text]
    $StatusBar = _GUICtrlStatusBarCreate($main, $a_PartsRightEdge, $a_PartsText)
    If $count > "1" Then
      GUICtrlSetState($hUp, $GUI_ENABLE)
      GUICtrlSetState($hDown, $GUI_ENABLE)
    Else
      GUICtrlSetState($hUp, $GUI_DISABLE)
      GUICtrlSetState($hDown, $GUI_DISABLE)
    EndIf
EndFunc

;Main Process
Func Start()
   GUICtrlSetState($hStart, $GUI_DISABLE)
   GUICtrlSetState($hAdd, $GUI_DISABLE)
   GUICtrlSetState($hRemove, $GUI_DISABLE)
   GUICtrlSetState($hAbout, $GUI_DISABLE)
   GUICtrlSetState($hExit, $GUI_DISABLE)
   If FileExists($installbat) Then FileDelete($installbat)
   If FileExists($installtxt) Then FileDelete($installtxt)
   If FileExists($installreg) Then FileDelete($installreg)
   $filebat = FileOpen($installbat, 1)
   $filetxt = FileOpen($installtxt, 1)
   $filereg = FileOpen($installreg, 1)
   FileWrite($filetxt, "These Updates will be installed in this release of "&@MON&"-"&@MDAY&"-"&@YEAR&".exe"&@CRLF&@CRLF)
   FileWrite($filebat, "START """" NOTEPAD.exe C:\Temp\Install.txt"&@CRLF)
   FileWrite($filebat, "CD C:\Temp"&@CRLF)
   FileWrite($filebat, "MD UserPrograms"&@CRLF)
   FileWrite($filebat, "CD "&'"%HOMEPATH%\"'&@CRLF)
   FileWrite($filebat, "XCOPY "&'"Start Menu" '&'"C:\Temp\UserPrograms" /E /Y'&@CRLF)
   FileWrite($filebat, "CD C:\Temp"&@CRLF)
   FileWrite($filebat, "MD AllUserPrograms"&@CRLF)
   FileWrite($filebat, "CD "&'"%ALLUSERSPROFILE%\"'&@CRLF)
   FileWrite($filebat, "XCOPY "&'"Start Menu" '&'"C:\Temp\AllUserPrograms" /E /Y'&@CRLF)
   FileWrite($filebat, "REGEDIT.exe /E C:\Temp\lmrun.reg "&'"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"'&@CRLF)
   FileWrite($filebat, "REGEDIT.exe /E C:\Temp\curun.reg "&'"HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"'&@CRLF)
   $total = _GUICtrlListViewGetItemCount($hList)
   _ZipCreate($zipfile)
   ;$item =                The exact line in the list
   ;$ItemNoSwitch =        The exact line in the list minus the switch
   ;$FileNameWithSwitch =  The file name and switch; no path
   ;$FileName =            The file name only
   ;$FileSwitch =          The File's switch only
   For $i = 0 To $total
      $item = _GUICtrlListViewGetItemText($hList, $i, 1)
      $pos = StringInStr($item, ".")
      $ItemNoSwitch = StringTrimRight($item, StringLen($item) - ($pos + 4))
      $pos = StringInStr($item, "\", 0, -1)
      $FileNameWithSwitch = StringMid($item, $pos + 1)
      $pos = StringInStr($FileNameWithSwitch, ".")
      $FileName = StringTrimRight($FileNameWithSwitch, StringLen($FileNameWithSwitch) - ($pos + 3))
      $FileSwitch = _GUICtrlListViewGetItemText($hList, $i, 2)
      If Not $FileName = "" Then
         If $FileSwitch = "" Then
            FileWrite($filebat, "START /WAIT "&'C:\Temp\'&$FileName&@CRLF&"PAUSE"&@CRLF)
         Else
            FileWrite($filebat, "START /WAIT "&'C:\Temp\'&$FileName&' '&$FileSwitch&@CRLF&"PAUSE"&@CRLF)
         EndIf
      EndIf
      FileWrite($filetxt, $FileName&@CRLF&@CRLF)
      _ZipAdd ($zipfile, $ItemNoSwitch)
      GUISetState(@SW_SHOW, $progress)
      GUISetState(@SW_DISABLE, $main)
      GUICtrlSetData($progbar,(($i+1)/$total)*100)
      ;When the progress bar goes to 101, this will bring it back to 100%
      ;It just bugged me, that's all...
      $progstat = GUICtrlRead($progbar)
      If $progstat >= 100 Then GUICtrlSetData($progbar, 99)
   Next
   FileWrite($filetxt, @CRLF&@CRLF&"Be sure NOT to close the command prompt window, otherwise the process will terminate!!"&@CRLF)
   FileWrite($filetxt, "This text file will automatically close after the update process has completely finished."&@CRLF)
   FileWrite($filebat, "CD "&'"%HOMEPATH%\"'&@CRLF)
   FileWrite($filebat, "DEL /Q /F *.*"&@CRLF)
   FileWrite($filebat, "CD "&'"%ALLUSERSPROFILE%\"'&@CRLF)
   FileWrite($filebat, "DEL /Q /F *.*"&@CRLF)
   FileWrite($filebat, "RD /S /Q "&'"%HOMEPATH%\Start Menu\Programs"'&@CRLF)
   FileWrite($filebat, "CD "&'"%HOMEPATH%\Start Menu\"'&@CRLF)
   FileWrite($filebat, "DEL /Q /F *.*"&@CRLF)
   FileWrite($filebat, "CD "&'"C:\Temp\"'&@CRLF)
   FileWrite($filebat, "XCOPY "&'"UserPrograms" '&'"%HOMEPATH%\Start Menu\"'&" /A /E /I /Q /R /K /Y"&@CRLF)
   FileWrite($filebat, "RD /S /Q "&'"%ALLUSERSPROFILE%\Start Menu\Programs"'&@CRLF)
   FileWrite($filebat, "CD "&'"%ALLUSERSPROFILE%\Start Menu\"'&@CRLF)
   FileWrite($filebat, "DEL /Q /F *.*"&@CRLF)
   FileWrite($filebat, "CD "&'"C:\Temp\"'&@CRLF)
   FileWrite($filebat, "XCOPY "&'"AllUserPrograms" '&'"%ALLUSERSPROFILE%\Start Menu\"'&" /A /E /I /Q /R /K /Y"&@CRLF)
   FileWrite($filereg, "Windows Registry Editor Version 5.00"&@CRLF)
   FileWrite($filereg, "[-HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run]"&@CRLF)
   FileWrite($filereg, "[-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run]"&@CRLF)
   FileWrite($filebat, "REGEDIT.exe /S Install.reg"&@CRLF)
   FileWrite($filebat, "REGEDIT.exe /S C:\Temp\lmrun.reg"&@CRLF)
   FileWrite($filebat, "REGEDIT.exe /S C:\Temp\curun.reg"&@CRLF)
   FileWrite($filebat, "ECHO. >> C:\Patches\PatchLog.log"&@CRLF)
   FileWrite($filebat, "ECHO Patch "&@MON&"-"&@MDAY&"-"&@YEAR&" has been run: %DATE% >> C:\Patches\PatchLog.log"&@CRLF)
   FileWrite($filebat, "CD\"&@CRLF)
   FileWrite($filebat, "C:\Temp\Install.vbs"&@CRLF)
   FileWrite($filebat, "RD /S /Q C:\Temp"&@CRLF)
   FileClose($filebat)
   FileClose($filetxt)
   FileClose($filereg)
   Call("MakeVBS")
   Call("ZipItUp")
   FileDelete($zipfile)
   Sleep(500)
   GUISetState(@SW_HIDE, $progress)
   GUISetState(@SW_ENABLE, $main)
   $answer = MsgBox(262144+64+4, "All Done", "Operation is complete!"&@CRLF&@CRLF&"Do you want to make another?")
   If $answer = 7 Then Exit;No
   GUICtrlSetState($hStart, $GUI_ENABLE)
   GUICtrlSetState($hAdd, $GUI_ENABLE)
   GUICtrlSetState($hRemove, $GUI_ENABLE)
   GUICtrlSetState($hAbout, $GUI_ENABLE)
   GUICtrlSetState($hExit, $GUI_ENABLE)
   ; ==> END
EndFunc

Func CheckList()
   $total = _GUICtrlListViewGetItemCount($hList)
   If $total = "0" Then
      MsgBox(262144+64, "Oops", "The list is empty...")
   Else
      Call("Start")
   EndIf
EndFunc

Func MakeVBS()
   If FileExists($installvbs) Then FileDelete($installvbs)
   $filevbs = FileOpen($installvbs, 1)
   FileWrite($filevbs, "strComputer = "&'"'&'."'&@CRLF)
   FileWrite($filevbs, "Set objWMIService = GetObject("&'"winmgmts:"'&' _'&@CRLF)
   FileWrite($filevbs, "    & "&'"{impersonationLevel=impersonate}!\\"'&' & strComputer & "'&'\root\cimv2")'&@CRLF&@CRLF)
   FileWrite($filevbs, "Set colProcessList = objWMIService.ExecQuery _"&@CRLF)
   FileWrite($filevbs, "    ("&'"Select * from Win32_Process Where Name ='&" 'Notepad.exe'"&'")'&@CRLF&@CRLF)
   FileWrite($filevbs, "For Each objProcess in colProcessList"&@CRLF)
   FileWrite($filevbs, "    objProcess.Terminate()"&@CRLF)
   FileWrite($filevbs, "Next")
   FileClose($filevbs)
EndFunc

Func ZipItUp()
   _ZipAdd ($zipfile, $installvbs)
   _ZipAdd ($zipfile, $installtxt)
   _ZipAdd ($zipfile, $installbat)
   _ZipAdd ($zipfile, $installreg)
   RunWait('"C:\Program Files\WinZip Self-Extractor\WZIPSE32.exe"'&' "'&$zipfile&'" -y -d C:\Temp -le -overwrite -auto -c .\Install.bat')
EndFunc

Func SystemCheck()
   ;OS Check - This script can only be run on Windows XP!
   If Not @OSVersion = "WIN_XP" Then
      MsgBox(262144+48, "OS Conflict", "This script can only be run on Windows XP")
      Exit
   EndIf
   ;PC *MUST* also have Winzip Self-Extractor installed as well!!
   $winzipse = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinZip Self-Extractor", "UninstallString")
   If @error Then
      MsgBox(262144+48, "Uh-Oh!", "Winzip Self-Extractor is required to use this application.")
      Exit
   EndIf
EndFunc

Func MoveUp($selected)
   If $selected = 0 Or $selected = -1 Then
      Sleep(10)
   Else
      $selectedindex =        _GUICtrlListViewGetItemText($hList, $selected, 0)
      $selectedname =         _GUICtrlListViewGetItemText($hList, $selected, 1)
      $selectedswitch =       _GUICtrlListViewGetItemText($hList, $selected, 2)
   
      $aboveselectedindex =   _GUICtrlListViewGetItemText($hList, $selected - 1, 0)
      $aboveselectedname =    _GUICtrlListViewGetItemText($hList, $selected - 1, 1)
      $aboveselectedswitch =  _GUICtrlListViewGetItemText($hList, $selected - 1, 2)
      
      _GUICtrlListViewSetItemText($hList, $selected, 0, $selectedindex)
      _GUICtrlListViewSetItemText($hList, $selected, 1, $aboveselectedname)
      _GUICtrlListViewSetItemText($hList, $selected, 2, $aboveselectedswitch)
      
      _GUICtrlListViewSetItemText($hList, $selected - 1, 0, $aboveselectedindex)
      _GUICtrlListViewSetItemText($hList, $selected - 1, 1, $selectedname)
      _GUICtrlListViewSetItemText($hList, $selected - 1, 2, $selectedswitch)
      _GUICtrlListViewSetItemSelState($hList, $selected - 1, 1, 1)
   EndIf
EndFunc

Func MoveDown($selected)
   $end =                     _GUICtrlListViewGetItemCount($hList)
   If $selected = $end - 1 Or $selected = -1 Then
      Sleep(10)
   Else  
      $selectedindex =        _GUICtrlListViewGetItemText($hList, $selected, 0)
      $selectedname =         _GUICtrlListViewGetItemText($hList, $selected, 1)
      $selectedswitch =       _GUICtrlListViewGetItemText($hList, $selected, 2)
   
      $belowselectedindex =   _GUICtrlListViewGetItemText($hList, $selected + 1, 0)
      $belowselectedname =    _GUICtrlListViewGetItemText($hList, $selected + 1, 1)
      $belowselectedswitch =  _GUICtrlListViewGetItemText($hList, $selected + 1, 2)
      
      _GUICtrlListViewSetItemText($hList, $selected, 0, $selectedindex)
      _GUICtrlListViewSetItemText($hList, $selected, 1, $belowselectedname)
      _GUICtrlListViewSetItemText($hList, $selected, 2, $belowselectedswitch)
      
      _GUICtrlListViewSetItemText($hList, $selected + 1, 0, $belowselectedindex)
      _GUICtrlListViewSetItemText($hList, $selected + 1, 1, $selectedname)
      _GUICtrlListViewSetItemText($hList, $selected + 1, 2, $selectedswitch)
      _GUICtrlListViewSetItemSelState($hList, $selected + 1, 1, 1)
   EndIf
EndFunc

Func EditSwitch($selected)
   If $selected = -1 Then
      Sleep(10)
   Else
      $selectedswitch =       _GUICtrlListViewGetItemText($hList, $selected, 2)
      $newswitch =            InputBox("Switches", "Enter the switches below:", $selectedswitch, "", -1, 80)
      _GUICtrlListViewSetItemText($hList, $selected, 2, $newswitch)
   EndIf
EndFunc
