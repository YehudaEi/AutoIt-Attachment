; Latest Working Model

;#=#INDEX#==================================================================#
;#  Title .........: _Error Handler.au3  v 2.1.2                            #
;#  Description....: AutoIt3 Error Handler & Debugger                       #
;#  Date ..........: 7.9.08                                                 #
;#  Authors .......: jennico (jennicoattminusonlinedotde)                   #
;#                   @MrCreatoR                                             #
;#                   MadExcept (GUI inspiration by mrRevoked)               #
;#==========================================================================#

#include-once

Dim $s_msg,$s_icn[5],$s_lb1[5],$s_lb2[5],$s_old=1, $s_edt, $bool_ShowError

_OnAutoItError()

;#=#Function#===============================================================#
;#  Name ..........: _OnAutoItError ( )                                     #
;#  Description....: AutoIt3 Error Handler & Debugger GUI                   #
;#  Parameters.....: (None)                                                 #
;#  Date ..........: 4.4.09                                                 #
;#  Authors .......: jennico (jennicoattminusonlinedotde)                   #
;#                   @MrCreatoR                                             #
;#                   MadExcept (GUI inspiration by mrRevoked)               #
;#                   Rajesh V R (rajeshwithsoftware@gmail.com)              #
;#==========================================================================#
; v 2.1.1 was based on original release of _Error Handler
; v 2.1.2 is based on _ErrorHandler v 1.2 from jenico.
;   this function is made to be customized !

Func _OnAutoItError()
    If StringInStr($CmdLineRaw,"/AutoIt3ExecuteScript") Then Return
    Opt("TrayIconHide",1)   ;  run a second instance
    
	opt("GUIResizeMode",802)   ;~ 	$GUI_DOCKALL
		
	$iPID=Run(@AutoItExe&' /ErrorStdOut /AutoIt3ExecuteScript "'&@ScriptFullPath&'"',@ScriptDir,0,6)
    ProcessWait($iPID)
	
    Dim $sErrorMsg,$GUI=GUICreate(@ScriptName,385,225,Default,Default,-2134376448)
	
        GUISetBkColor(0xE0DFE2) ;BitOR($WS_CAPTION,$WS_POPUP,$WS_SYSMENU)
        GUICtrlCreateIcon("user32.dll",103,11,11,32,32)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",1,1,383,1),0x41689E)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",1,88,383,1),0x41689E)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",1,1,1,88),0x41689E)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",383,1,1,88),0x41689E)
        GUICtrlSetBkColor(GUICtrlCreateLabel("An error occurred in the application.",52,21,175,15),-2)
        $s_lb1[0]=GUICtrlCreateLabel("",10,60,110,22)
            GUICtrlSetBkColor(-1,0xEFEEF2)
            GUICtrlSetState(-1,128)
        $s_lb2[0]=GUICtrlCreateLabel("   send bug report",28,64,92,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $s_icn[0]=GUICtrlCreateIcon("explorer.exe",254,13,63,16,16)
            GUICtrlSetCursor(-1,0)
        $s_lb1[1]=GUICtrlCreateLabel("",126,60,114,22)
            GUICtrlSetBkColor(-1,0x706E63)
            GUICtrlSetState(-1,128)
        $s_lb2[1]=GUICtrlCreateLabel("    De-Bug Script",145,64,95,15)
            If @Compiled Then GUICtrlSetData(-1,"   show bug report")
            GUICtrlSetColor(-1,0xFFFFFF)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $s_icn[1]=GUICtrlCreateIcon("shell32.dll",-81,129,63,16,16)
            If @Compiled Then GUICtrlSetImage(-1,"shell32.dll",23)
            GUICtrlSetCursor(-1,0)
        $s_lb1[2]=GUICtrlCreateLabel("",246,8,131,22)
            GUICtrlSetBkColor(-1,0xEFEEF2)
            GUICtrlSetState(-1,128)
        $s_lb2[2]=GUICtrlCreateLabel("   continue application",265,12,115,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $s_icn[2]=GUICtrlCreateIcon("shell32.dll",290,249,11,16,16)
            GUICtrlSetCursor(-1,0)
        $s_lb1[3]=GUICtrlCreateLabel("",246,34,131,22)
            GUICtrlSetBkColor(-1,0xEFEEF2)
            GUICtrlSetState(-1,128)
        $s_lb2[3]=GUICtrlCreateLabel("    restart application",265,38,115,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $s_icn[3]=GUICtrlCreateIcon("shell32.dll",255,249,37,16,16)
            GUICtrlSetCursor(-1,0)
        $s_lb1[4]=GUICtrlCreateLabel("",246,60,131,22)
            GUICtrlSetBkColor(-1,0xEFEEF2)
            GUICtrlSetState(-1,128)
        $s_lb2[4]=GUICtrlCreateLabel("     close application",265,64,115,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $s_icn[4]=GUICtrlCreateIcon("shell32.dll",240,249,63,16,16)
            GUICtrlSetCursor(-1,0)
        $s_edt=GUICtrlCreateEdit($sErrorMsg& @CRLF ,8,95,370,120,BitOR(0x00200000,0x00100000 ,0x0004,0x0040,0x0080,0x0800)) 
		; $WS_VSCROLL 0x00200000 $ES_MULTILINE 0x0004 $ES_AUTOVSCROLL 0x0040 $ES_AUTOHSCROLL 0x0080 $ES_READONLY 0x0800 $WS_HSCROLL 0x00100000 
		    GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
    ProcessWait($iPID)
    
	While 1 ;    trap the error message
        $sErrorMsg&=StdoutRead($iPID)
        If @error Then ExitLoop
        Sleep(1)
    WEnd
    
	If $sErrorMsg="" Then Exit
    
    If NOT $bool_ShowError Then WinMove ( @ScriptName, "", Default , Default , 391,125) ; hiding the error message detail at startup 
	
	GUISetState()
    WinSetOnTop(@ScriptName,"",1)
    SoundPlay(@WindowsDir&"\Media\chord.wav")
    
    Opt("TrayIconHide",0)
    Opt("TrayAutoPause",0)
    
    TraySetToolTip(@ScriptName&@CRLF&"An error occurred in the application.")
	
    Do  ; choose action to be taken
        Dim $s_msg=GUIGetMsg(),$mse=GUIGetCursorInfo($GUI)
        If @error=0 Then
            For $i=0 To 4
                If $i<>$s_old And ($mse[4]=$s_lb1[$i] Or $mse[4]=$s_lb2[$i] Or _
                    $mse[4]=$s_icn[$i]) Then __Select($i)
            Next
        EndIf
        If WinActive($GUI) And $s_msg=0 Then
            HotKeySet("{ENTER}","__Hotkey")
            HotKeySet("{RIGHT}","__Hotkey")
            HotKeySet("{LEFT}","__Hotkey")
            HotKeySet("{DOWN}","__Hotkey")
            HotKeySet("{TAB}","__Hotkey")
            HotKeySet("{UP}","__Hotkey")
        Else
            HotKeySet("{ENTER}")
            HotKeySet("{RIGHT}")
            HotKeySet("{LEFT}")
            HotKeySet("{DOWN}")
            HotKeySet("{TAB}")
            HotKeySet("{UP}")
        EndIf
        If $s_msg=$s_lb2[2] Or $s_msg=$s_icn[2] Then MsgBox(270400,"Continue Application", _
            "Not possible with AutoIt !     "&@CRLF&@CRLF& _
            "( No GoTo command )      :-( ")
        If $s_msg=$s_lb2[0] Or $s_msg=$s_icn[0] Then MsgBox(270400,"Send Bug Report", _
            "Feature Not Implemented Yet !     ")
            ;#include <INet.au3>    ;   use email
            ;_INetSmtpMail ( $s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress [,$s_Subject&_
            ;[,$as_Body [,$s_helo, [,$s_first [,$b_trace]]]]])
        If $s_msg=$s_lb2[1] Or $s_msg=$s_icn[1] Then
            If @Compiled=0 Then __Debug($sErrorMsg)
            If @Compiled Then 
            	$bool_ShowError  = NOT($bool_ShowError)
				
            	If $bool_ShowError Then
               		MsgBox(270400,"Show Bug Report",$sErrorMsg & "    ")
        			WinMove (@ScriptName , "",Default,Default,391,257) ;something causes original GUI to be created 391 and not 385
        			GUICtrlSetData($s_lb2[1],"   hide bug report")
					GUICtrlSetData($s_edt,$sErrorMsg & @CRLF )
        		Else
        			WinMove (@ScriptName, "", Default , Default , 391,125)
					GUICtrlSetData($s_lb2[1],"   show bug report")
				EndIf
				
			EndIf
        EndIf
    Until $s_msg=-3 Or $s_msg=$s_lb2[3] Or $s_msg=$s_icn[3] Or $s_msg=$s_lb2[4] Or $s_msg=$s_icn[4]
    If $s_msg=$s_lb2[3] Or $s_msg=$s_icn[3] Then Run(@AutoItExe&' "'&@ScriptFullPath& _
        '"',@ScriptDir,0,6)
    SoundPlay(@WindowsDir&"\Media\start.wav")
    Exit
EndFunc


;#=#Function#===============================================================#
;#  Name ..........: __Debug ( $txt )                                       #
;#  Description....: Debug Function for _ErrorHandler.au3                   #
;#  Parameters.....: $txt = Error Message Text from StdoutRead              #
;#  Date ..........: 7.9.08                                                 #
;#  Authors .......: jennico (jennicoattminusonlinedotde)                   #
;#==========================================================================#

Func __Debug($txt)
    WinSetState(@ScriptName,"",@SW_HIDE)
    $a=StringSplit($txt,@CRLF,1)
	$scitePath=RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SciTE.exe","")
    Dim $b=StringSplit($a[1],") : ==> ",1),$number=StringMid($b[1],StringInStr($b[1],"(")+1)
    Dim $code="Error Code: "&@TAB&StringTrimRight($b[2],2),$line="Line: "&@TAB&$number&" => "&$a[3]
    Dim $file="File: "&@TAB&StringReplace($b[1]," ("&$number,""),$count=StringLen($code),$height=180
    If StringLen($file)>$count Then $count=StringLen($file)
    If StringLen($line)>$count Then $count=StringLen($line)
    If StringLen($a[2])>$count Then $count=StringLen($a[2])
    If $count*6>@DesktopWidth-50 Then Dim $count=(@DesktopWidth-50)/6,$height=240
    Run($scitepath&' "'&@ScriptFullPath&'" /goto:'&$number&","&StringLen($a[2])-1)
    $x=InputBox(" Please Correct this line:",$code&@CRLF&@CRLF&$file&@CRLF&@CRLF& _
        $line,StringTrimRight($a[2],1),"",$count*6,$height)
    WinSetState(@ScriptName,"",@SW_SHOW)
    If $x="" Or $x=StringTrimRight($a[2],1) Then Return
    $t=StringSplit(FileRead(@ScriptFullPath),@CRLF,1)
    $t[$number]=StringReplace($t[$number],StringTrimRight($a[2],1),$x)
    $open=FileOpen(@ScriptFullPath,2)
    For $i=1 to $t[0]
        FileWriteLine($open,$t[$i])
    Next
    FileClose($open)
    ControlSend(@ScriptDir,"","ToolbarWindow32","^R")
EndFunc

;#=#Function#===============================================================#
;#  Name ..........: __Select ( $i )                                        #
;#  Description....: Select Function for _ErrorHandler.au3                  #
;#  Parameters.....: $i = Element from Mouse Hover ID                       #
;#  Date ..........: 7.9.08                                                 #
;#  Authors .......: jennico (jennicoattminusonlinedotde)                   #
;#==========================================================================#

Func __Select($i)
    GUICtrlSetBkColor($s_lb1[$i],0x706E63)
    GUICtrlSetColor($s_lb2[$i],0xFFFFFF)
    GUICtrlSetBkColor($s_lb1[$s_old],0xEFEEF2)
    GUICtrlSetColor($s_lb2[$s_old],0)
    $s_old=$i
EndFunc

;#=#Function#===============================================================#
;#  Name ..........: __Hotkey ( )                                           #
;#  Description....: Hotkey Functions for _ErrorHandler.au3                 #
;#  Parameters.....: None                                                   #
;#  Date ..........: 7.9.08                                                 #
;#  Authors .......: jennico (jennicoattminusonlinedotde)                   #
;#==========================================================================#

Func __Hotkey()
    If @HotKeyPressed="{DOWN}" And $s_old>1 And $s_old<4 Then __Select($s_old+1)
    If @HotKeyPressed="{RIGHT}" And $s_old<2 Then __Select(1+3*($s_old=1))
    If @HotKeyPressed="{TAB}" Then __Select(($s_old+1)*($s_old<4))
    If @HotKeyPressed="{LEFT}" And $s_old Then __Select($s_old>1)
    If @HotKeyPressed="{UP}" And $s_old>2 Then __Select($s_old-1)
    If @HotKeyPressed="{ENTER}" Then $s_msg=$s_icn[$s_old]
EndFunc