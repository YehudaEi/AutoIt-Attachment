; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
  ; Filename.......: C:\batch\runact-fk.au3
 ; LOG__________________________________________________________________________________________________________________
  ; Version .......: 0.1.1
  ; Created .......: 2013.03.09.11.06.18
  ; Modified ......: 2013.03.09.20.07.19
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Runner
  ; Subtype .......: Util
  ; Name ..........: runact-fk.au3
  ; CodeName ......: RunActFnKeysIni
  ; Summary .......: Activate or Starts a Program using an Ini File
  ; Description ...: One Parameter F1-F12 is used to determine a window to activate or ask to start program based on
  ;                  settings of an ini file
  ; Remarks .......: This program is a utility and does not have a driver system, but the idea is to use Win+F<x> keys
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: runact-fk.au3 <F1-F12>
  ; Parameters ....: P1             - "F1" any function key
  ; Example .......: Run(@AutoItExe&" C:\scripts\runact-fk.au3 F1","")
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: IniFile must be set up, and placed in same directory, named <thisscriptname>.ini
  ; Postconditions.: A program is started, or a window is activated
  ; Entry Point ...: Main()
  ; LibDependencies: WinAPI,File
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Improvements...: None
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [x] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
  ; Index .........: Identifier                Type     Summary
  ;                :  $logg                     String   Module Logfile Fullpath
  ;                :  $timestamp                String   Module Start Timestamp
  ;                :  $testing                  Bool     Module Testing Flag
  ;                :  $p1                       String   First Parameter, ie KEY <F1-F12>
  ;                :  $f_ini                    String   Module Control Ini Fullpath
  ;                :  $t                        String   Window Title Expression
  ;                :  $mm                       Int      Window Title Match Mode
  ;                :  $only_vis                 Int      Seek Only Visible Windows Flag
  ;                :  $hwnd                     HWnd     HWnd of Window that may still exist
  ;                :  $c                        String   Classname of sought Window
  ;                :  $exe                      String   FilenameExt of sought Window
  ;                :  $exef                     String   Fullpath of Windows Program
  ;                :  $exew                     String   WorkingDir of Windows Program
  ;                :  $exep                     String   Parameters to Start Windows Program
  ;                :  Main                      Command     Main Entry
  ;                :  WinShow                   Command  Show Window when found
  ;                :  WinShowDraw               Command  Draw Attention Rectangles for Window
  ;                :  DrawZoom                  Command  Draw Attention Rectangles for coords
  ;                :  GetGlobals                Property Fill in Global data for Window from Ini using KEY
  ;                :  TryHwnd                   Command  Fast Find of previous found Window
  ;                :  IniVal                    Func     Read Ini for section KEY and given key
  ;                :  IniWriteHwnd              Command  Write Ini into section KEY for given hwnd
  ;                :  matchTitle                Func     Method Matching of Windows Titles
  ;                :  RunApp                    Command  Run Application for Global Window Data
  ;                :  getWins                   Func     Get Window Listing from WinList()
  ;                :  WinClass                  Func     Get Classname of given Hwnd
  ;                :  IsVisible                 Func     Determine Hwnd Visibility
  ;                :  MaybeQuote                Func     Ensure String is Quoted
  ;                :  _Win2Process              Func     Get Process FilenameExt of Window
  ;                :  _ProcessName              Func     Get Process Name from Process ID
  ;                :  _WinAPI_DrawRect          Command  Draw on Screen
  ;                :  SplashError               Command  Show Temporary Error Box
  ;                :  ts                        Func     Get Timestamp
  ;                :  logline                   Command  Log given Line to Module Log File
  ;                :  FilePart                  Func     Parse Specified FullPath Item
  ;                :
 ; STORY________________________________________________________________________________________________________________
  ;  On a Windows 7 platform the Win+<number> keys can be used to start and switch to various 'pinned' applications.
  ;  Making the Pinned Applications to be apps that use more than one window is best, since switching to the app or starting it
  ;  can best be accomplished in other ways. This is especially true for when you have the Windows task bar set to autohide
  ;  because switching to a single app causes the taskbar to show temporarily, making it an annoying means of quickly
  ;  switching to an app.
  ;
  ;  Therefore I have pinned only apps that typically use multiple windows often and I am scripting the activation/running
  ;  of other apps. Also, I have the windows taskbar docked at the right side and using NextStart as a bottom docked
  ;  constantly visible task list. The windows taskbar is also made about 250px wide so I can read a lot of the text on
  ;  the taskbar buttons, but this makes the annoyance worse when jumping to a pinned app because the taskbar will show
  ;  itself in its sloth-like manner.
  ;
  ;  The general goal is to assign hotkeys to Win+<F1-F12> and use that to activate/run apps that use a single window.
  ;  This script is part of the engine of that goal, it is called by another script via hotkeys.
  ;
  ;  There is another associated script I have that will present a top-of-screen hidden dock on the press of scrolllock.
  ;  That dock will show application icons for keys F1-F12 (not globals, but functioning when dock has focus).
  ;  This list of icons will be built dynamically and made to ignore apps that are started via Windows Pinned Apps
  ;  or apps assigned to this script. This will give me access to miscellaneous running apps, which can be quickly
  ;  activated by scrolllock, then F1-F12.
  ;
  ;  Hopefully these techniques will give me the best of all worlds:
  ;    * A constant visual reminder of open apps via NextStarts task list
  ;    * The ability to read the tasks and use Windows Taskbar normally with its Pinned Apps hotkeys
  ;        (in the vertical orientation it can hold a lot of buttons)
  ;    * The ability to quickly activate or run single window apps with the keys Win+<F1-F12>
  ;    * Quick access to all remaining running Apps via ScrollLock, <F1-F12>
  ;
 ; DOCS_________________________________________________________________________________________________________________
  ; Ini Contol File:
  ;  An Ini File must be created and put in the same directory as this script, and must have the same name
  ;  as this script, but with an ini extension.
  ;
  ;  Format___________
  ;   Section names should be F1-F12, or however you want to index it, there are no dependencies on that format,
  ;   only that the first parameter of this script will be used to key in on the proper section.
  ;   Many more sections can be created, but F1-F12 are used as examples of 'hotkeying' in on this script by its driver.
  ;
  ;   Each Section represents a _Window Request/Program Start_, if the window is found it will be given focus,
  ;   else the user will be asked if they would like to start the program that would create such windows.
  ;
  ;   Sections are required to contain the following keys:
  ;    t    - Window Title Expression, where
  ;            "NADA" will cause the program to exit quietly, and represents a disabled section
  ;    mm   - Window Title Match Mode, where:
  ;            0 - match always
  ;            1 - match left
  ;            2 - match anywhere
  ;            3 - match right
  ;            4 - match exact
  ;            5 - match regexp
  ;    only_vis - flag to search only for visible windows, to search for trayyed windows make this flag 0
  ;    c    - Window Class Name, an empty value will match all classes
  ;    exe  - Filename and Ext of Program exe, this is used to determine a window match, which is why it is not extracted
  ;           from 'exef' since exef may be a script that starts the exe
  ;    exef - For starting the program when window is not found
  ;    exew - Working directory of program
  ;    exep - other parameters for starting the program
  ;
  ;   The following key is dynamic and created by this script to help find windows quickly, according to the last found
  ;    hwnd - The Hwnd of the last found window that matches this section, window is also rechecked for qualification
  ;           using the title expression, classname, and exe for the window.
  ;
  ;  Typical Ini Entry with Comments___________
  ;   ;                                                                  section name
  ;   [F4]
  ;   ;                                                                  window title spec
  ;   t=Microsoft Excel -
  ;   ;                                                                  window title match mode
  ;   mm=1
  ;   ;                                                                  search invisible windows too
  ;   only_vis=0
  ;   ;                                                                  window classname
  ;   c=XLMAIN
  ;   ;                                                                  window exe
  ;   exe=EXCEL.EXE
  ;   ;                                                                  program fullpath, NO QUOTES!
  ;   exef=C:\Program Files (x86)\Microsoft Office\Office12\EXCEL.EXE
  ;   ;                                                                  program workdir, NO QUOTES!
  ;   exew=C:\Program Files (x86)\Microsoft Office\Office12
  ;   ;                                                                  program params
  ;   exep=
  ;   ;                                                                  dynamic hwnd, leave out, program will maintain
  ;   hwnd=0x011A1ECA
  ;
  ; Autoit Driver Example:
  ;  Snippet___________________
  ;   global $runact_script="C:\batch\runact-fk.au3"
  ;
  ;   HotKeySet("#F2","key_w_f2"); note #F1 cannot be assigned typically from Autoit due to windows having grabbed it
  ;
  ;   Func key_w_f2()
  ;     Run(@AutoItExe&' "'&$runact_script&'" F2',"")
  ;   EndFunc
  ;  EndSnippet___________________
  ;
  ;  Use Snippet to construct remaining keys, then put a while-sleep loop in there.
  ;
 ; =====================================================================================================================

;#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#NoTrayIcon
; ===================INCLUDES
 #include <WinAPI.au3>
 #include <File.au3>

; ===================STD GLOBALS
 ;______________Log Global UNUSED
 global $logg=@ScriptFullPath&".log.txt";
 ;______________Startup Global UNUSED
 global $timestamp=@YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC
 ;______________Development Global
 global $testing=true
 if $CmdLine[0]<>0 then
   $testing=false
 endif

; ===================PARM GLOBALS
 ;____________Assign here for Development
 global $p1

; ===================PARM CHECK
 if not $testing then
   if $CmdLine[0]<>1 then
     SplashError("Need 1 params - exiting")
     exit
   endif
   ;______________Assign Handy Global
   $p1=$Cmdline[1]
 endif

; ===================APP GLOBALS
 ; Ini Control File
  Global $f_ini=@ScriptDir&"\"&FilePart(@ScriptFullPath,'n')&".ini"
  if not FileExists($f_ini) Then
    SplashError("Ini File Not found:"&$f_ini&". Exiting...");
    exit
  endif

; ===================SETTINGS
 ; Do Focus Rects on Activation
  Global $do_focus_rects=true
 ; Do Window Flash on Activation
  Global $do_window_flash=true
 ; Confirm start program
  Global $do_ask_run=true

; ===================INI READ IN GLOBALS
 ; This data is read to launch the program
 ;--------------------------------------
 ; Title Match String or Expression
  ; The string 'NADA' will cause a quiet bail,
  ; thus you can preserve ini structure
  Global $t;="JIRA Client"
 ; Title Match Mode
  ; 0 any - everything, ignore string
  ; 1 left - left part of title
  ; 2 mid - anywhere in title
  ; 3 right - right part of title
  ; 4 exact - exact title
  ; 5 regexp - regular expression
  Global $mm;=1
 ; Seek Only Visible Apps Flag
  ; anticipating trayed applications here
  Global $only_vis;=1
 ; Hwnd of last successful match
  ; a speed up effort
  Global $hwnd;=1
 ; Class of Window to Match
  ; blank matches all
  Global $c;="SunAwtFrame"
 ; Exe Name of window to Match
  ; not case sensative, blank matches all (but that would be weird to do)
  Global $exe;="jiraclient.exe"
 ; Fullname of EXE
  ; Required, Environment vars not handled
  Global $exef;="C:\Program Files (x86)\JIRA Client\bin\jiraclient.exe"
 ; Working Directory
  ; can be blank
  Global $exew;="C:\Program Files (x86)\JIRA Client\bin"
 ; Launch Params
  ; can be blank
  Global $exep;=""

; ===================GET THE GLOBALS
 ; This call fills in the Launch/Find Globals Above
 GetGlobals()

; ===================PARANOIA
 ; Is everything ok Bob? ...Bob?
 if 0==1 then
   MsgBox(0,@ScriptFullPath,'$t:'&$t);
   MsgBox(0,@ScriptFullPath,'$mm:'&$mm);
   MsgBox(0,@ScriptFullPath,'$only_vis:'&$only_vis);
   MsgBox(0,@ScriptFullPath,'$c:'&$c);
   MsgBox(0,@ScriptFullPath,'$exe:'&$exe);
   MsgBox(0,@ScriptFullPath,'$exef:'&$exef);
   MsgBox(0,@ScriptFullPath,'$exew:'&$exew);
   MsgBox(0,@ScriptFullPath,'$exep:'&$exep);
 endif

; ===================QUIET BAIL
 ; The key is disabled
 if $t=='NADA' Then
   exit
 endif

; ===================SPEEDY TRY
 ; Try Finding a qualifying window using hwnd,
 ; and not dig through the windows list
 if TryHwnd()==1 Then
   ;MsgBox(0,@ScriptFullPath,"HWND")
   exit
 endif

; ===================GET THE WINDOWS LIST
 ; Speedy way failed, battlestations!
 Global $wins=getWins();

; ===================ENTRY POINT
 ; Do it the hard way
 Main();

; ===================EXIT POINT
 ; if you get here you have attempted to Run an app
 ; TODO: need error code
 exit

; ===================APP FUNCTIONS BELOW

; ===================Main
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.11.42.14
  ; Modified ......: 2013.03.09.11.42.17
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Command
  ; Subtype .......: Entry
  ; Name ..........: Main
  ; Summary .......: Find a qualifying window and activate it, otherwise ask to start program
  ; Description ...: Seeks a window that matches the ini data for the script KEY parameter
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: Main()
  ; Parameters ....: None
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: Need error, return value
  ; Status ........: [ ] New
  ;                  [x] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func Main()
   local $I
   for $i=1 to $wins[0][0]
     local $hh=$wins[$I][1]
     local $vv=IsVisible($hh)
     ; filters below qualifiy window
     if $only_vis==1 and not $vv Then
       ContinueLoop
     endif
     ; filter
     local $tt=$wins[$I][0]
     if $tt=="" Then
       ContinueLoop
     endif
     ; filter
     local $cc=WinClass($hh)
     if $cc<>$c and $c<>"" Then
       ContinueLoop
     endif
     ; filter
     if matchTitle($tt,$t,$mm)<>1 Then
       ContinueLoop
     endif
     ; filter
     local $ex=_Win2Process($hh)
     if StringCompare($ex,$exe,2)<>0 Then
       ContinueLoop
     endif
     ; succeed!
     WinShow($hh,$vv)
     exit
   Next
   ; fail, ask to start file
   if $do_ask_run == false or MsgBox(BitOR(0x4,32),@ScriptFullPath,"Start '"&$exe&"'?")== 6 Then ;YESNO. Answered Yes
     RunApp()
   else
     exit
   Endif
 EndFunc

; ===================WinShow
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.12.08.37
  ; Modified ......: 2013.03.09.12.08.40
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Command
  ; Subtype .......: Display
  ; Name ..........: WinShow
  ; Summary .......: Show, Activate, Flash, Record and Draw attention to the Window
  ; Description ...:
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: WinShow($hh,$vv)
  ; Parameters ....: $hh - Hwnd, Window Handle
  ; Parameters ....: $vv - Int, Is Visible
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: Window must exist
  ; Postconditions.: Window presented nicely
  ; Fn Dependencies: _WinAPI_FlashWindowEx, IniWriteHwnd, WinShowDraw
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [x] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......: WinShowDraw
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func WinShow($hh,$vv)
   if not $vv then
     WinSetState($hh,@SW_SHOW)
   endif
   WinActivate($hh)
   if $do_window_flash then
     _WinAPI_FlashWindowEx($hh, BitOr(1,2), 2,100)
   endif
   IniWriteHwnd($hh)
   if $do_focus_rects then
     WinShowDraw($hh)
   endif
 EndFunc

; ===================WinShowDraw
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.12.07.56
  ; Modified ......: 2013.03.09.12.08.00
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Command
  ; Subtype .......: Draw
  ; Name ..........: WinShowDraw
  ; Summary .......: Draws Rects on Window
  ; Description ...:
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: Draw($h)
  ; Parameters ....: $h - Hwnd, Subject
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: Window must exist
  ; Postconditions.: Attention drawing rectangles displayed
  ; Fn Dependencies: DrawZoom
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [x] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func WinShowDraw($h)
   local $p=WinGetPos($h)
   local $xx=$p[0]
   local $yy=$p[1]
   local $ww=$p[2]
   local $hh=$p[3]
   DrawZoom($xx,$yy,$ww,$hh)
   ;_WinAPI_DrawRect($xx, $yy, $ww, $hh, 0x0000FF)
 EndFunc

; ===================DrawZoom
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.12.17.01
  ; Modified ......: 2013.03.09.12.17.03
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Command
  ; Subtype .......: Draw
  ; Name ..........: DrawZoom
  ; Summary .......: Draws multiple rectangles in a zoomy effedt
  ; Description ...:
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: DrawZoom($xx,$yy,$ww,$hh)
  ; Parameters ....: $xx - int, x coord
  ; Parameters ....: $yy - int, y coord
  ; Parameters ....: $ww - int, width
  ; Parameters ....: $hh - int, height
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: _WinAPI_DrawRect
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: Want to to this by inverting pixels
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [x] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func DrawZoom($xx,$yy,$ww,$hh)
   local $d=20
   local $i
   for $i=10 to 1 step -1
     _WinAPI_DrawRect($xx+($i*$d), $yy+($i*$d), $ww-($i*$d*2), $hh-($i*$d*2), 0x0000FF)
   next
 EndFunc

; ===================GetGlobals
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......:
  ; Modified ......:
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Property
  ; Subtype .......: Keyed Data
  ; Name ..........: GetGlobals
  ; Summary .......: Fill in main data from ini based on KEY param
  ; Description ...:
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: GetGlobals()
  ; Parameters ....: None
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: Globals are filled
  ; Fn Dependencies: IniVal
  ; VarDependencies: t,mm,only_vis,c,exe,exef,exew,exep,hwnd
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: Wrap these globals to take them out of scope
  ; Status ........: [ ] New
  ;                  [x] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func GetGlobals()
   $t=IniVal('t','')
   $mm=Int(IniVal('mm','4'))
   $only_vis=Int(IniVal('only_vis','1'))
   $c=IniVal('c','')
   $exe=IniVal('exe','')
   $exef=IniVal('exef','')
   $exew=IniVal('exew','')
   $exep=IniVal('exep','')
   $hwnd=HWnd(IniVal('hwnd','0x0'))
 EndFunc

; ===================TryHwnd
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.12.34.02
  ; Modified ......: 2013.03.09.12.34.03
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Command
  ; Subtype .......: Display
  ; Name ..........: TryHwnd
  ; Summary .......: Display if the hwnd value of Ini is a qualified window
  ; Description ...: This is the fast way
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: 1 on success
  ; Syntax ........: TryHwnd()
  ; Parameters ....: None
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: Global ini data present
  ; Postconditions.: Maybe a displayed winodw
  ; Fn Dependencies: IsVisible,matchTitle,WinClass,_Win2Process,WinShow
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func TryHwnd()
   ; filter
   if $hwnd==0 Then
     return 0;
   endif
   ; filter
   if not WinExists($hwnd) Then
     return 0;
   endif
   ; ok, valid hwnd
   local $hh=$hwnd
   local $vv=IsVisible($hwnd)
   ; filter
   if $only_vis==1 and not $vv Then
     return 0;
   endif
   ; filter
   local $tt=WinGetTitle($hwnd)
   if matchTitle($tt,$t,$mm)<>1 Then
     return 0;
   endif
   ; filter
   local $cc=WinClass($hh)
   if $cc==$c Then
     return 0;
   endif
   ; filter
   local $ex=_Win2Process($hh)
   if StringCompare($ex,$exe,2)<>0 Then
     return 0;
   endif
   ; succeed!
   WinShow($hwnd,$vv)
   return 1;
 EndFunc

; ===================IniVal
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.12.42.24
  ; Modified ......: 2013.03.09.12.42.26
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Property
  ; Subtype .......: Getter
  ; Name ..........: IniVal
  ; Summary .......: Reads value for the KEY section for given key
  ; Description ...: simplifies
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: String value read or default provided
  ; Syntax ........: IniVal($k,$d)
  ; Parameters ....: $k - the key
  ; Parameters ....: $d - the default
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func IniVal($k,$d)
   return IniRead($f_ini,$p1,$k,$d)
 EndFunc

; ===================IniWriteHwnd
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.12.46.03
  ; Modified ......: 2013.03.09.12.46.04
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Property
  ; Subtype .......: Setter
  ; Name ..........: IniWriteHwnd
  ; Summary .......: Writes the given Hwnd to the proper KEY section
  ; Description ...: simplifies
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: IniWriteHwnd($h)
  ; Parameters ....: None
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func IniWriteHwnd($h)
   IniWrite($f_ini,$p1,'hwnd',String($h))
 EndFunc

; ===================matchTitle
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.20.11.35
  ; Modified ......: 2013.03.09.20.11.37
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Function
  ; Subtype .......: Pure
  ; Name ..........: matchTitle
  ; Summary .......: Compare Strings based on given method
  ; Description ...: Methods:
  ;                   0 - Always indicate match is positive
  ;                   1 - Positive if haystack begins with needle
  ;                   2 - Positive if haystack has needle
  ;                   3 - Positive if haystack ends with needle
  ;                   4 - Positive if haystack equals needle
  ;                   5 - Positive if needle regexp in haystack
  ; Remarks .......: Case Sensative!
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: 1 if positive, else 0
  ; Syntax ........: matchTitle($t,$key,$m)
  ; Parameters ....: $t   - the haystack
  ; Parameters ....: $key - the needle
  ; Parameters ....: $m   - the mode to match with
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: Make into a case statement
  ; Status ........: [ ] New
  ;                  [x] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func matchTitle($t,$key,$m)
   ;m 1 left
   ;m 2 mid
   ;m 3 right
   ;m 4 exact
   ;m 5 regexp
   if $m==0 then
       return 1
   endif
   if $m==1 then
     if StringInStr($t,$key,1)==1 then
       return 1
     endif
   endif
   if $m==2 then
     if StringInStr($t,$key,1)>0 then
       return 1
     endif
   endif
   if $m==3 then
     if StringRight($t,StringLen($key))==$key then
       return 1
     endif
   endif
   if $m==4 then
     if $t==$key then
       return 1
     endif
   endif
   if $m==5 then
     if StringRegExp($t,$key,0)==1 Then
       return 1
     endif
   endif
   return 0
 EndFunc

; ===================RunApp
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.20.21.41
  ; Modified ......: 2013.03.09.20.21.43
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Command
  ; Subtype .......: Execute
  ; Name ..........: RunApp
  ; Summary .......: Runs globals
  ; Description ...: Call Run using $exef, $exew, $exep
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: From Run call
  ; Syntax ........: RunApp()
  ; Parameters ....: None
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: MaybeQuote
  ; VarDependencies: exef,exew,exep
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Improvements...: Implement SHOW, ShellExecute and Env Vars
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [x] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func RunApp()
   if $exep=='' then
     return Run(MaybeQuote($exef),$exew)
   else
     return Run(MaybeQuote($exef)&' '&$exep,$exew)
   endif
 EndFunc

; ===================getWins
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.20.28.41
  ; Modified ......: 2013.03.09.20.28.43
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Function
  ; Subtype .......: Pure,Wrapper
  ; Name ..........: getWins
  ; Summary .......: Get array of windows using WinList
  ; Description ...: This is an empty wrapper, was going to do some filters
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: Standard WinList-like array
  ; Syntax ........: getWins()
  ; Parameters ....: None
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Improvements...: Could put filters for know hiddens, but probably not performant
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [x] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func getWins()
   ;$array[0][0] = Number of windows returned
   ;$array[1][0] = 1st window title
   ;$array[1][1] = 1st window handle (HWND)
   local $a=WinList()
   return $a;
 EndFunc

; ===================Wrappers

; ===================WinClass
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.20.33.32
  ; Modified ......: 2013.03.09.20.33.35
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Function
  ; Subtype .......: Pure,Empty,Wrapper
  ; Name ..........: WinClass
  ; Summary .......: Get Window Classname
  ; Description ...: Wraps WinAPI Identifier
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: String, Classname of given HWnd
  ; Syntax ........: WinClass($h)
  ; Parameters ....: $h - HWnd, Window handle. Possible takes string?
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: _WinAPI_GetClassName
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func WinClass($h)
   return _WinAPI_GetClassName($h)
 EndFunc

; ===================IsVisible
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.20.48.56
  ; Modified ......: 2013.03.09.20.48.58
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Function
  ; Subtype .......: Pure, Wrapper
  ; Name ..........: IsVisible
  ; Summary .......: Is Window Visible
  ; Description ...: Use GetWinState to determine Visibility
  ; Remarks .......: Probably replicates something in WinAPI
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: 1 if window is visible, else 0
  ; Syntax ........: IsVisible($h)
  ; Parameters ....: $h - Hwnd, window handle
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func IsVisible($h)
     If BitAND(WinGetState($h), 2) Then
         Return 1
     Else
         Return 0
     EndIf
 EndFunc   ;==>IsVisible

; ===================LIB

; ===================MaybeQuote
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.20.54.09
  ; Modified ......: 2013.03.09.20.54.11
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Function
  ; Subtype .......: Pure, String, Util
  ; Name ..........: MaybeQuote
  ; Summary .......: Wraps Given String in Quotes if it is not already
  ; Description ...:
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: Quoted String
  ; Syntax ........: MaybeQuote($s)
  ; Parameters ....: $s - String that may be unquoted
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func MaybeQuote($s)
   if StringLeft($s,1)<>'"' Then
     $s='"'&$s
   endif
   if StringRight($s,1)<>'"' Then
     $s=$s&'"'
   endif
   return $s
 EndFunc

; ===================_Win2Process
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.21.00.28
  ; Modified ......: 2013.03.09.21.00.30
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Function
  ; Subtype .......: Pure
  ; Name ..........: _Win2Process
  ; Summary .......: Process Name of HWnd
  ; Description ...: Return the Process name for a given HWnd, else return ""
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: Process Name of HWnd, on error return ""
  ; Syntax ........: _Win2Process($h)
  ; Parameters ....: $h - HWnd, Window Handle to Find Process Name for
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: _ProcessName
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func _Win2Process($h)
     local $wproc = WinGetProcess($h)
     if $wproc==-1 Then
       return ""
     endif
     local $pn=_ProcessName($wproc)
     if $pn==-1 Then
       return ""
     Endif
     return $pn
 endfunc

; ===================_ProcessName
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.21.04.15
  ; Modified ......: 2013.03.09.21.04.17
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Function
  ; Subtype .......: Pure
  ; Name ..........: _ProcessName
  ; Summary .......: Process Name of Process ID
  ; Description ...: Return Process Name of Process ID or -1 on error
  ; Remarks .......: Could Optimize
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: Process Name of Process ID or -1 on error
  ; Syntax ........: _ProcessName($pid)
  ; Parameters ....: $pid - String,Int, Process ID
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Improvements...: Add Cousin that takes a process list for optimization
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [x] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func _ProcessName($pid)
     if isstring($pid) then $pid = processexists($pid)
     if not isnumber($pid) then return -1
     $proc = ProcessList()
     for $p = 1 to $proc[0][0]
         if $proc[$p][1] = $pid then return $proc[$p][0]
     Next
     return -1
 EndFunc

; ===================_WinAPI_DrawRect
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.21.10.02
  ; Modified ......: 2013.03.09.21.10.04
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Command
  ; Subtype .......: GDI
  ; Name ..........: _WinAPI_DrawRect
  ; Summary .......: Draw Rect on Screen
  ; Description ...: Draws a single pixel rectangle outline of given color at given coords
  ; Remarks .......: Want a version of this that inverts pixels
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: _WinAPI_DrawRect($start_x, $start_y, $iWidth, $iHeight, $iColor)
  ; Parameters ....: $start_x - int, Left coord
  ; Parameters ....: $start_y - int, Top coord
  ; Parameters ....: $iWidth  - int, Width of Rect, use 1 for dot?
  ; Parameters ....: $iHeight - int, Height of Rect, use 1 for dot?
  ; Parameters ....: $iColor  - int, Color of Rect
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Improvements ..: Want inverted pixel form of this function
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [x] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [ ] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func _WinAPI_DrawRect($start_x, $start_y, $iWidth, $iHeight, $iColor)
   ; ____________________DC of entire screen (desktop)
   Local $hDC = _WinAPI_GetWindowDC(0)
   ; ____________________Make Rect
   Local $tRect = DllStructCreate($tagRECT)
   ; ____________________Fill Rect values
   DllStructSetData($tRect, 1, $start_x)
   DllStructSetData($tRect, 2, $start_y)
   DllStructSetData($tRect, 3, $iWidth+$start_x)
   DllStructSetData($tRect, 4, $iHeight+$start_y)
   ; ____________________Make Brush
   Local $hBrush = _WinAPI_CreateSolidBrush($iColor)
   ; ____________________Draw Rect
   _WinAPI_FrameRect($hDC, DllStructGetPtr($tRect), $hBrush)
   ; ____________________Cleanup
   _WinAPI_DeleteObject($hBrush)
   _WinAPI_ReleaseDC(0, $hDC)
 EndFunc   ;==>_WinAPI_DrawRect


; ===================SplashError
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.22.01.58
  ; Modified ......: 2013.03.09.22.01.59
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Command
  ; Subtype .......: Error, Gui
  ; Name ..........: SplashError
  ; Summary .......: Shows Temporary Error Box
  ; Description ...: Show Box using global title and given error string for 10 secs
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: SplashError($s)
  ; Parameters ....: $s - String, The Error
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies:
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func SplashError($s)
      local $sec=10
      SplashTextOn(@ScriptFullPath,$s, 700, 200, 10, 10, 0, "Arial", 10)
      Sleep($sec*1000)
      SplashOff()
 EndFunc

; ===================ts
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.21.19.15
  ; Modified ......: 2013.03.09.21.19.17
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Function
  ; Subtype .......: Pure,Volitile
  ; Name ..........: ts
  ; Summary .......: Return Timestamp String
  ; Description ...: Return Timestamp of now, like yyyy.mm.dd.hh.nn.ss.iiii
  ; Remarks .......: Unused
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: String, yyyy.mm.dd.hh.nn.ss.iiii
  ; Syntax ........: ts()
  ; Parameters ....: None
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func ts()
   return @YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC
 EndFunc

; ===================logline
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.21.22.12
  ; Modified ......: 2013.03.09.21.22.14
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Command
  ; Subtype .......: File, Util, Log
  ; Name ..........: logline
  ; Summary .......: Append Line to Global Module Log
  ; Description ...: Opens Logfile based on Global name, Appends given Line, Closes Logfile
  ; Remarks .......: Unused in This Module
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: None
  ; Syntax ........: logline($s)
  ; Parameters ....: $s - String, Line to Append
  ; Error values ..: None
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: None
  ; VarDependencies: None
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func logline($line)
  local $fh1=FileOpen($logg,1);
  if $fh1<>-1 then
    FileWriteLine($fh1,$line)
    FileClose($fh1)
  endif
 EndFunc

; ===================FilePart
; ======================================================================================================================
 ; SOURCE_______________________________________________________________________________________________________________
  ; Organization ..: Mark Robbins
  ; Website .......: http://
  ; Author ........: Mark Robbins
 ; LOG__________________________________________________________________________________________________________________
  ; Created .......: 2013.03.09.22.19.00
  ; Modified ......: 2013.03.09.22.19.01
  ; Entries........: yyyy.mm.dd.hh.mm.ss Comments
 ; HEADER_______________________________________________________________________________________________________________
  ; Type ..........: Function
  ; Subtype .......: Pure, File, String
  ; Name ..........: FilePart
  ; Summary .......: Parse Specified FullPath Item
  ; Description ...: Returns drive, path, etc
  ; Remarks .......:
 ; DETAIL_______________________________________________________________________________________________________________
  ; Return values .: String, Requested Part or "" on error
  ; Syntax ........: FilePart($f,$n)
  ; Parameters ....: $f - String, Fullpath subject
  ; Parameters ....: $n - String, Partname, give C:\LOC1\LOC2\FILENAME.EXT of:
  ;                       dl      - drive letter, C
  ;                       d       - drive, C:\
  ;                       drive   - drive, C:\
  ;                       dir     - path part, LOC1\LOC2
  ;                       n       - filename, FILENAME
  ;                       name    - filename, FILENAME
  ;                       e       - extension, EXT
  ;                       ext     - extension, .EXT
  ;                       p       - drive and path, C:\LOC1\LOC2
  ;                       path    - drive and path, C:\LOC1\LOC2
  ;                       dp      - drive and path trailing, C:\LOC1\LOC2\
  ;                       p_      - drive and path trailing, C:\LOC1\LOC2\
  ;                       path_   - drive and path trailing, C:\LOC1\LOC2\
  ;                       ne      - filename and ext, FILENAME.EXT
  ;                       nameext - filename and ext, FILENAME.EXT
  ;                       pn      - path and file, LOC1\LOC2\FILENAME
  ;                       dpn     - drive,path and file, C:\LOC1\LOC2\FILENAME
  ; Error values ..: -1 - invalid request
  ; Dynamic Called : No
  ; Example .......: None
 ; CONTEXT______________________________________________________________________________________________________________
  ; Preconditions .: None
  ; Postconditions.: None
  ; Fn Dependencies: _PathSplit
  ; VarDependencies: None
  ; Includes ......: <File.au3>
 ; DEVELOPMENT__________________________________________________________________________________________________________
  ; Issues ........: None
  ; Status ........: [ ] New
  ;                  [ ] Open
  ;                  [ ] InProgress
  ;                  [ ] Resolved
  ;                  [x] Closed
 ; OTHER________________________________________________________________________________________________________________
  ; Related .......:
  ; Link ..........:
  ; Resources......:
 ; =====================================================================================================================
 Func FilePart($f,$n)
   local $drive, $dir, $fn, $ext
   _PathSplit($f, $drive, $dir, $fn, $ext)
   if $n=='dl' Then Return StringLeft($drive,1)
   if $n=='d' Then Return $drive
   if $n=='drive' Then Return $drive
   if $n=='dir' Then Return $dir
   if $n=='n' Then Return $fn
   if $n=='name' Then Return $fn
   if $n=='e' Then Return StringRight($ext,StringLen($ext)-1)
   if $n=='ext' Then Return $ext
   if $n=='p' Then Return $drive&$path
   if $n=='path' Then Return $drive&$path
   if $n=='dp' Then Return $drive&$path&"\"
   if $n=='p_' Then Return $drive&$path&"\"
   if $n=='path_' Then Return $drive&$path&"\"
   if $n=='ne' Then Return $fn&$ext
   if $n=='nameext' Then Return $fn&$ext
   if $n=='pn' Then Return $path&"\"&$fn
   if $n=='dpn' Then Return $drive&$path&"\"&$fn
   return SetError(-1,0,"")
 EndFunc


