#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <WinAPI.au3>
#include <IE.au3>
#include <Misc.au3>

_IEErrorHandlerRegister()

Local $oIE = _IECreateEmbedded()

Global $thisfile="C:\batch\borg\TestCreeper.au3"
Global $logg="C:\$data\logs\TestCreeper-log.txt";
Global $timestamp=@YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC

; switch to false to demand command line params
Global $testing=True

If $CmdLine[0]<>0 Then
  $testing=False
EndIf

;Where registry entries are read from
Global $reg_p='HKEY_CURRENT_USER\Creeper\'

Global $p1='2013.07.28.14.37.12.722'
; make the program run with example parameters if no params are given
$p1=''


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Creeper v0.1.1
;
; PROGRAM OVERVIEW
;  Creeper accepts many params from command line or registry, optionally combines them
;  with an ini style file to produce an html based notification window that appears
;  at the bottom of screen and moves upward, eventually fading out at the top where it
;  is destroyed. The html of the notification is optionally logged.
;
;  This notification window is transparent to clicks.
;  Pressing left and right Ctrl keys will remove all notifications from the screen.
;
;  Features
;   * accepts any html for content
;   * full styling control over components
;   * optionally logs the produced html notification to specified file
;   * supports html templating
;
;  Display Components
;   * wrapper div
;    + backgroundcolor,bordercolor,borderwidth,borderstyle,font,fontsize,color,padding
;   * Title <H3> element
;    + titlefont,titlecolor
;   * Image
;    + width,height
;
;  Extenal Components
;   * registry key (hardcoded)
;   * ini files (user specified)
;   * html output files (user specified)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; COMMAND LINE PARAMETERS
; Information is read either from the registry, or the command line depending on form
; of the first parameter
;
; If the first parameter has the following form it is assumed to be a registry entry,
; no other params are required:
;  2013.07.28.14.37.12.722
; Note: this date stamp has no temporal significance, it is used as a guid that represents
;       a reg key below HKEY_CURRENT_USER\Creeper\
;
; If the first parameter is not in that form, it is assumed to be a comma seperated list of
; parameter names whose values will follow. The syntax is:
;  "name1,name2[,name3]..." "<name1 value>" "<name2 value>" ...
;
; This is list of parameters, these are case sensitive. Parameters are valid
; both on the command line and as registry values:
; ================= ================= ===== ==================================================
; NAME              DEFAULT VALUE     TYPE  MEANING
; ================= ================= ===== ==================================================
;  width             500              style  the width of the displayed div
;  backgroundcolor   #000000          style  div background color
;  bordercolor       #AA00AA          style  div
;  borderwidth       1                style  div
;  borderstyle       solid            style  div
;  padding           2                style  div
;  title             ''               text   text to appear inside <H3> Tag
;  titlefont         ''               style  font family for H3, otherwise inherits div font
;  titlecolor        #FFFFFF          style  H3
;  font              Tahoma           style  div
;  fontsize          12               style  div
;  image             ''               url    to appear floated left of html
;  imagewidth        ''               attrib img
;  imageheight       ''               attrib img
;  html              ''               html   your html, see #TEMPLATING
;  color             #CCCCCC          style  div
;  zdot              ''               ignor  this is special to creator of this app, ignore it
;  fmtini            ''               file   fullpath to ini for formatting, see #FMTINI
;  fmtname           ''               name   section name in fmtini file to use
;  outhtml           ''               file   fullpath to log html msgs to, see #LOGGING
;  autodel           ''               ctrl   registry param only, delete entry if 1
;
; Additional html TEMPLATING parameters can be added to this list. A templating parameters name must start with
; a dollar sign ($name), and in the template itself the expansion occurs at %(name)
;
;---------------------------------
;#FMTINI
; STYLE FORMATTING INI
;  The section of the format ini file is referenced by the 'fmtname' parameter
;  Every value in the referenced section whose key matches a parameter name
;  will be used where the parameter is not given on the command line
;  If the ini parameter value is missing or '' then the program default is used
;
; The following parameters are accepted in an Ini Section:
;  width,backgroundcolor,bordercolor,borderwidth,borderstyle,padding,title,titlefont,titlecolor,image,
;  imagewidth,imageheight,html,font,fontsize,color,outhtml
;
; So basically everything except fmtini, fmtname and autodel (of course).
;
;---------------------------------
;#TEMPLATING
; HTML TEMPLATING
; The 'html' value in an ini file can be a template. Templates are regular html that include injection points
; that have the form:
;  %(name)
; The value of $name will be injected. $name is declared either on the command line, or in the registry key.
;
;---------------------------------
;#DEFAULTS
; PARAMETER DEFAULTS
; The Command Line Parameter list shows the internal program defaults.
; Params specified as '' are considered unspecified.
; Whether using Registry or Command Line Params, params are filled as follows:
;  1) clear all params
;  2) apply params specified by commandline or registry.
;  3) if an fmtini param and a fmtname param exists, apply the params found in the ini to remaining unspecified params.
;  4) apply internam program defaults to all unspecified params
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; EXAMPLE COMMAND LINE PARAMS
;
; CmdLine Basic
; "title,html" "The Title" "some <b>bolded html msg</b>"
;
; CmdLine Basic with styling change - red border
; "title,html,bordercolor" "The Title" "some <b>bolded html msg</b>" "#FF0000"
;
; CmdLine Basic - with logging
; "title,html,outhtml" "The Title" "some <b>bolded html msg</b>" "C:\creeper.html"
;
; Registry Basic
; "2013.07.28.14.37.12.722"
;
; CmdLine Templating - creepersectionname should have a 'html' value like:  some text %(texta) some other text %(textb)
; "title,fmtini,fmtname,$texta,$textb" "The Title" "C:\creeper.ini" "creepersectionname" "This is text A" "This is text B"
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#LOGGING
; LOGGING NOTIFICATIONS
;  When the 'outhtml' parameter is given, an html file will be created and the notification html
;  will be prepended at the insertion point, see #HTMLTEMPLATE
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; EXTERNAL SCRIPTS
;  External AutoIt Scripts can use the functions 'makeReg' to create a registry entry,
;  be sure to define $reg_p when using this function. Also include 'makeRegWrite' in your script.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; KNOWN ISSUES
;  * For my platform, with IE 10 installed, the 'border-radius' property does not work. This is just as well though,
;    since the form is square and is not a region form.
;  * There seems to be some form and IE sizing issues, I have twiddled with these, but could not achieve consistency.
;  * There is no regulator, running this program in rapid succession will result in overlapping, unreadable messages.
;  * On occasion, the IE embedded object does not display properly, all that is seen is a grey box and one border.
;    I thought this was a timing problem, but I don't know.
;  * There is no way I know of to make the messages move faster up the screen and maintain smoothness.
;  * Need a better PrevHwnd implementation
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; IMPROVEMENTS, TODO
;  * Make a regulator, so messages are backlogged and not displayed immediately, but in a fashion where they do not overlap.
;  * Make a mechanism to flag parameters as persistant, so multiple calls can be easily made using persistant params.
;  * Allow for different display styles other than the current 'move up screen'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Get first Param
If Not $testing Then
  If $CmdLine[0]<1 Then
    MsgBox(0,$thisfile,"Need 1 params - exiting")
    Exit
  EndIf
  $p1=$CmdLine[1]
EndIf

Global $ph=PrevHwnd()
Local $ss=_WinAPI_GetClassName($ph)&WinGetTitle($ph)
;ToolTip($ss)
;WinActivate($ph)

; Form Vars
Global $y_s
Global $ff_x
Global $ff_y
Global $ff_w
Global $ff_h
Global $hgui


; Program Default Parms
Global $d_autodel=''
Global $d_fmtini=''
Global $d_fmtname=''

Global $d_zdot=''
Global $d_outhtml=''

Global $d_title=''
Global $d_titlefont=''
Global $d_titlecolor='#ffffff'
Global $d_html=''
Global $d_bordercolor='#AA00AA'
Global $d_color='#CCCCCC'
Global $d_backgroundcolor='#000000'
Global $d_width='500'
Global $d_borderwidth='1'
Global $d_borderstyle='solid'
Global $d_padding='2'
Global $d_font='Tahoma'
Global $d_fontsize='12'
Global $d_image=''
Global $d_imagewidth=''
Global $d_imageheight=''

;#HTMLTEMPLATE
; Output File template
Global $d_filehtml=''
$d_filehtml&='<HTML>'&@CRLF
$d_filehtml&='<HEAD>'&@CRLF
$d_filehtml&='<STYLE type="text/css">'&@CRLF
$d_filehtml&='body {background-color:black;margin: 0; padding: 0;}'&@CRLF
$d_filehtml&='</STYLE>'&@CRLF
$d_filehtml&='</HEAD>'&@CRLF
$d_filehtml&='<BODY BGCOLOR="#000000" border="0" marginheight="0" topmargin="0" vspace="0" marginwidth="0" leftmargin="0" hspace="0">'&@CRLF
$d_filehtml&='<!-- INSERT -->'&@CRLF
$d_filehtml&='</BODY>'&@CRLF
$d_filehtml&='</HTML>'&@CRLF
$d_filehtml&=''&@CRLF



Global $c_names='title,titlefont,titlecolor,html,bordercolor,color,backgroundcolor,width,borderwidth,borderstyle,padding,font,fontsize,image,imagewidth,imageheight'
$c_names&=',outhtml,fmtini,fmtname,zdot,autodel'

; These are filled with example data so the file with no params will run with these
Global $p_zdot='87544160001980301'
Global $p_title='Title Text'
Global $p_titlefont=''
Global $p_titlecolor='#cccccc'

Global $p_html='This is the notification <b>body</b>, referred to as the "html" parameter'
Global $p_bordercolor='#FF0000'
Global $p_color='#CCCCCC'
Global $p_backgroundcolor='#000000'
Global $p_width='500'
Global $p_borderwidth='1'
Global $p_borderstyle='solid'
Global $p_padding='4'
Global $p_font='Tahoma'
Global $p_fontsize='12'
Global $p_image='                                                                 '
Global $p_imagewidth='32'
Global $p_imageheight='32'


Global $p_outhtml='C:\batch\borg\TestCreeper.html'
Global $p_fmtini='C:\batch\borg\TestCreeper.ini'
Global $p_fmtname='basic'
Global $p_autodel=''; auto delete registry entry if 1

If False Then
makeReg( _
  $p_title, _
  $p_html, _
  $p_zdot, _
  $p_outhtml, _
  $p_fmtini, _
  $p_fmtname, _
  $p_width, _
  $p_backgroundcolor, _
  $p_bordercolor, _
  $p_titlecolor, _
  $p_color, _
  $p_titlefont, _
  $p_font, _
  $p_fontsize, _
  $p_borderwidth, _
  $p_borderstyle, _
  $p_image, _
  $p_imagewidth, _
  $p_imageheight, _
  $p_padding, _
  $p_autodel _
  )
EndIf

; BEGIN MAIN
If IsRegStamp($p1) Then
  cleanP()
  regReadKey($p1)
  readFmtIni(True)
  regFixupHtml($p1)
  If $p_autodel=='1' Then
    ;MsgBox(0,'autodel',$p_autodel)
    regDel($p1)
  EndIf
  ;xamP()
  DoForm()
  Exit
Else
  If $p1=='' Then
    ;MsgBox(0,'','')
    ;cleanP()
    ;assignDefs(True)
    DoForm()
    Exit
  Else
    cleanP()
    paramCsvToParams()
    readFmtIni(True)
    assignDefs(True)
    paramCsvFixupHtml()
    ;xamP()
    DoForm()
    Exit
  EndIf
EndIf
Exit

; Examine the $p_* params
Func xamP()
  Local $s=''
  Local $n=$c_names
  Local $a=StringSplit($n,',',3)
  Local $x,$end=UBound($a)-1,$i
  For $x=0 To $end
    $i=$a[$x]
    If $s=='' Then
      $s='$p_'&$i&':"'&Eval('p_'&$i)&'"'
    Else
      $s&=@CRLF&'$p_'&$i&':"'&Eval('p_'&$i)&'"'
    EndIf
  Next
  MsgBox(0,'xamP',$s)
EndFunc

;Utility Function to create a registry key parameter set
; Returns name of key
Func makeReg( _
  $title_='', _
  $html_='', _
  $zdot_='', _
  $outhtml_='', _
  $fmtini_='', _
  $fmtname_='', _
  $width_='', _
  $backgroundcolor_='', _
  $bordercolor_='', _
  $titlecolor_='', _
  $color_='', _
  $titlefont_='', _
  $font_='', _
  $fontsize_='', _
  $borderwidth_='', _
  $borderstyle_='', _
  $image_='', _
  $imagewidth_='', _
  $imageheight_='', _
  $padding_='', _
  $autodel_='' _
  )
  Local $ts=@YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC
  Local $p=$reg_p &$ts
  makeRegWrite($p,'title',$title_)
  makeRegWrite($p,'html',$html_)
  makeRegWrite($p,'zdot',$zdot_)
  makeRegWrite($p,'outhtml',$outhtml_)
  makeRegWrite($p,'fmtini',$fmtini_)
  makeRegWrite($p,'fmtname',$fmtname_)
  makeRegWrite($p,'width',$width_)
  makeRegWrite($p,'backgroundcolor',$backgroundcolor_)
  makeRegWrite($p,'bordercolor',$bordercolor_)
  makeRegWrite($p,'titlecolor',$titlecolor_)
  makeRegWrite($p,'color',$color_)
  makeRegWrite($p,'titlefont',$titlefont_)
  makeRegWrite($p,'font',$font_)
  makeRegWrite($p,'fontsize',$fontsize_)
  makeRegWrite($p,'borderwidth',$borderwidth_)
  makeRegWrite($p,'borderstyle',$borderstyle_)
  makeRegWrite($p,'image',$image_)
  makeRegWrite($p,'imagewidth',$imagewidth_)
  makeRegWrite($p,'imageheight',$imageheight_)
  makeRegWrite($p,'padding',$padding_)
  makeRegWrite($p,'autodel',$autodel_)
  Return $ts
EndFunc

; Helper function for makeReg
Func makeRegWrite($p,$k,$v)
  If $v=='' Then
    Return
  EndIf
  RegWrite($p,$k,"REG_SZ",$v)
EndFunc

; Read the Values at Registry key into $p_* vars
Func regReadKey($k)
  Local $p=$reg_p &$k
  Local $n='title,html,zdot,outhtml,fmtini,fmtname,width,backgroundcolor,bordercolor,titlecolor,color,titlefont,font,fontsize,borderwidth,borderstyle,image,imagewidth,imageheight,padding,autodel'
  Local $a=StringSplit($n,',',3)
  Local $x,$end=UBound($a)-1,$i,$v
  For $x=0 To $end
    $i=$a[$x]
    $v=RegRead($p,$i)
    If $v=='' Then
      If @error==0 Then
        Assign('p_'&$i,$v,4);fail if not exist
      EndIf
    Else
      Assign('p_'&$i,$v,4);fail if not exist
    EndIf
  Next
EndFunc

;Does string resemble a timestamp
Func IsRegStamp($s)
 ;                           yyyy      mm    dd    hh    nn   ss    ii
  ;MsgBox(0,'IsRegStamp',$s)
  Local $v=StringRegExp($s,'\d\d\d\d\.\d\d\.\d\d\.\d\d\.\d\d\.\d\d\.\d\d\d',0);
  Return $v
EndFunc

; Delete Registry key
Func regDel($k)
  Local $p=$reg_p &$k
  RegDelete($p)
EndFunc

; Assign internal defaults to $p_* vars
Func assignDefs($assign_only_blank=False)
  Local $a=StringSplit($c_names,',',3)
  Local $x,$end=UBound($a)-1
  Local $i,$v,$e
  For $x=0 To $end
    $i=$a[$x]
    If $assign_only_blank Then
      If Eval('p_'&$i)=='' Then
        $e=Assign("p_"&$i, Eval('d_'&$i), 4 );fail if not exists
      EndIf
    Else
      $e=Assign("p_"&$i, Eval('d_'&$i), 4 );fail if not exists
    EndIf
  Next
EndFunc


; Assign '' to $p_* vars
Func cleanP()
  Local $a=StringSplit($c_names,',',3)
  Local $x,$end=UBound($a)-1
  Local $i,$v,$e
  For $x=0 To $end
    $i=$a[$x]
    $e=Assign("p_"&$i, '', 4 );fail if not exists
  Next
EndFunc

; Do html Templating for Registry values starting with $
Func regFixupHtml($k)
  Local $p=$reg_p&$k
  Local $v,$i=1
  Local $vv
  While True
    $v = RegEnumVal($p, $i)
    If @error <> 0 Then ExitLoop
    $i=$i+1
    If StringMid($v,1,1)=='$' Then
      $vv=RegRead($p,$v)
      If @error==0 Then
        $v=StringMid($v,2)
        $p_html=StringReplace($p_html,'%('&$v&')',$vv)
      EndIf
    EndIf
    ;MsgBox(4096, "Value Name  #" & $i & " under in AutoIt3 key", $v)
  WEnd

EndFunc

; Do html Templating for Command Line values starting with $
Func paramCsvFixupHtml()
  Local $a=StringSplit($p1,',',3)
  Local $x,$end=UBound($a)-1
  Local $i,$v,$e
  Local $start_parm=2
  For $x=0 To $end
    $i=$a[$x]
    If StringMid($i,1,1)=='$' Then
      $v=$CmdLine[$start_parm+$x]
      $i=StringMid($i,2)
      $p_html=StringReplace($p_html,'%('&$i&')',$v)
    EndIf
  Next
EndFunc

; Assign $p_* values from csv of $p1
Func paramCsvToParams()
  Local $a=StringSplit($p1,',',3)
  Local $x,$end=UBound($a)-1
  Local $i,$v,$e
  Local $start_parm=2
  For $x=0 To $end
    $i=$a[$x]
    ;Assign ( "varname", "data" [, flag] )
    If StringMid($i,1,1)<>'$' And IsDeclared("p_"&$i) Then
      $v=$CmdLine[$start_parm+$x]
      $e=Assign("p_"&$i, $v, 4 );fail if not exists
    EndIf
  Next
EndFunc

; Assign $p_* values from fmtini section fmtname if exists
Func readFmtIni($assign_only_blank=False)
  If $p_fmtini=='' Then
    Return
  EndIf
  If Not FileExists($p_fmtini) Then
    Return
  EndIf
  If $p_fmtname=='' Then
    Return
  EndIf
  Local $n='width,backgroundcolor,bordercolor,borderwidth,borderstyle,padding,title,titlefont,titlecolor,image,imagewidth,imageheight,html,font,fontsize,color,zdot,outhtml'
  Local $a=StringSplit($n,',',3)
  Local $x,$end=UBound($a)-1,$i
  For $x=0 To $end
    $i=$a[$x]
    If $assign_only_blank Then
      If Eval('p_'&$i)=='' Then
        Assign('p_'&$i,IniRead($p_fmtini,$p_fmtname,$i,Eval('d_'&$i)))
      EndIf
    Else
      Assign('p_'&$i,IniRead($p_fmtini,$p_fmtname,$i,Eval('d_'&$i)))
    EndIf
  Next
EndFunc

; Output the html to $p_outhtml, creating if necc.
Func WriteHtmlEntry($s_html)
  If $p_outhtml=='' Then
    Return
  EndIf
  If Not FileExists($p_outhtml) Then
    WriteNewHtml()
  EndIf
  Local $tmp=$p_outhtml&'.tmp'
  Local $wh=FileOpen($tmp,2)
  If $wh = -1 Then
      MsgBox(0, "Error", "Unable to open output file:"&$tmp)
      Exit
  EndIf
  Local $rh=FileOpen($p_outhtml,0)
  If $rh = -1 Then
      MsgBox(0, "Error", "Unable to open input file:"&$p_outhtml)
      Exit
  EndIf
  Local $line
  ;MsgBox(0,$thisfile,'write')
  While 1
      $line = FileReadLine($rh)
      If @error = -1 Then ExitLoop
      FileWriteLine($wh,$line)
      If $line=='<!-- INSERT -->' Then
        FileWriteLine($wh,$s_html)
      EndIf
  WEnd
  FileClose($wh)
  FileClose($rh)
  ;FileDelete($p_outhtml)
  FileMove ($tmp, $p_outhtml, 1);overwrite
  FileDelete($tmp)
EndFunc

; Helper for WriteHtmlEntry, use on file not exists
Func WriteNewHtml()
  Local $wh=FileOpen($p_outhtml,2+10); will create dirs
  FileClose($wh)
  FileWriteLine( $p_outhtml, $d_filehtml)
EndFunc



; Main form create and display, does not return until form is done moving
Func DoForm()
  Local $f_w=1000;$div.offsetWidth+100
  Local $f_h=400
  $hgui=GUICreate("Creeper", $f_w, $f_h, _
          0,-1000, _
          $WS_POPUP,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST+$WS_EX_TRANSPARENT)
  Local $cIe=GUICtrlCreateObj($oIE, -2, -2, $f_w+30, $f_h+8-100)
  GUICtrlSetBkColor ( $cIe, 0 )
  GUISetBkColor(0x000044)
  WinSetTrans($hgui,"",0)
  GUISetState() ;Show GUI
  If IsHWnd($ph) Then
    WinActivate($ph)
  EndIf
  _IENavigate($oIE, "about:blank")
  Local $html=getHtml($p_html)
  Local $r=_IEPropertySet($oIE,'innerhtml',$html)
  Local $div=_IEGetObjByName($oIE,'div1')
  Local $ow=$div.offsetWidth
  Local $oh=$div.offsetHeight
  ;GUICtrlSetPos($cie,-2, -4, $ow+26,$oh+4)
  GUICtrlSetPos($cie,-2, -4, $ow+30,$oh+4); Issues here
  $y_s=1; keep this at 1 else jittery
  $ff_x=(@DesktopWidth - $ow) / 2
  $ff_y=(@DesktopHeight - $oh)
  $ff_w=$ow-2
  $ff_h=$oh
  WinSetTrans($hgui,"",10)
  WinMove( $hGui, '',$ff_x, $ff_y , $ff_w+4, $ff_h+2); Issues here
  Sleep(1100); trying to make 'grey box' issue go away
  DoMove()
  GUIDelete(); program should exit after this return
EndFunc

; Helper for DoForm(), moves the window until it is gone through top of monitor
Func DoMove()
  Local $ctmx=100
  Local $ct=0
  Local $y1
  While True
   $ct=$ct+1
   If ShouldAbort() Then
     Return
   EndIf
   If $ct>$ctmx Then
     $ff_y=$ff_y-$y_s
   Else
     WinSetTrans($hgui,"",$ct*2)
   EndIf
   If $ff_y<=-$ff_h Then
     Return
   EndIf
   ;WinMove( $hGui, '',$ff_x, $ff_y , $ff_w+2, $ff_h+2)
   WinMove( $hGui, '',$ff_x, $ff_y)
   If $ff_y<200 Then
     If $ff_y>=0 Then
       WinSetTrans($hgui,"",$ff_y)
     EndIf
   EndIf
   ;Sleep(8-Int(((@DesktopHeight-$ff_y)/@DesktopHeight)*6))
   ;$y1=(@DesktopHeight-$ff_y)/@DesktopHeight
   ;$y1=Int($y1*6)
   ;ToolTip($y1)
   Sleep(10)
   ;Sleep(8-$y1)
   ;ToolTip(Int(((@DesktopHeight-$ff_y)/@DesktopHeight)*6))
  WEnd
EndFunc

;
Func getHtml($p_html)
  Local $bst='body {background-color:black;margin: 0; padding: 0; } '
  Local $br='border-radius:8px 8px 8px 8px;'
  ; create div style
  Local $st=''
  $st&='border:'&$p_borderwidth&'px '&$p_borderstyle&' '&$p_bordercolor&';'
  $st&='background-color:'&$p_backgroundcolor&';'
  $st&='padding:'&$p_padding&'px;'
  $st&='color:'&$p_color&';'
  $st&='font-family:'&$p_font&';'
  $st&='font-size:'&$p_fontsize&';'
  ;
  Local $st1=$st; st1 is for logging
  $st&='position:absolute;'&$br
  $st&='left:0px;'
  $st&='top:0px;'
  ;
  $st1&=$br
  $st1&='margin-bottom:4px;'
  If $p_width<>'' Then
    $st&='width:'&$p_width&'px;'
  EndIf
  ; create image if specified
  Local $im=''
  If $p_image<>'' Then
    $im='<img src="'&$p_image&'"';
    If $p_imagewidth<>'' Then
      $im&=' width="'&$p_imagewidth&'"'
    EndIf
    If $p_imageheight<>'' Then
      $im&=' height="'&$p_imageheight&'"'
    EndIf
    $im&=' style="float:left">'
  EndIf
  ; create title if specified
  Local $ti=''
  If $p_title<>'' Then
    $ti='<h3 style="margin-top:0px;margin-bottom:0px;';
    If $p_titlefont<>'' Then
      $ti&='font-family:'&$p_titlefont&';'
    EndIf
    If $p_titlecolor<>'' Then
      $ti&='color:'&$p_titlecolor&';'
    EndIf
    $ti&='">';
    $ti&=$p_title
    $ti&='</h3>';
    ;$ti&='<HR>';
  EndIf
  ; html for IE
  Local $t='<div id="div1" style="'&$st&'">'&$ti&$im&$p_html&'</div>'
  ; more html for log
  Local $stamp2=@YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC
  Local $stamp=StringReplace($stamp2,'.','')
  Local $stam='<SMALL><SMALL>'&$stamp2&'</SMALL></SMALL><BR>'
  Local $zlink=''
  If $p_zdot<>'' Then
    $zlink='<SMALL><a style="color:#8888AA;text-decoration:none;" href="sled://z/z.'&$p_zdot&'">z.'&$p_zdot&'</a></SMALL><BR>'
  EndIf
  ; create html for log
  Local $s_html='<div id="div'&$stamp&'" style="'&$st1&'">'&$ti&$stam&$zlink&$im&$p_html&'</div>'
  ; write the log if desired
  WriteHtmlEntry($s_html)
  Local $body_tags='BGCOLOR="#000000" border="0" marginheight="0" topmargin="0" vspace="0" marginwidth="0" leftmargin="0" hspace="0" '
  Local $html='<HTML><HEAD><STYLE type="text/css">'&$bst&'</STYLE></HEAD><BODY '&$body_tags&'>'&$t&'</BODY></HTML>'
  ;return html for IE
  Return $html
EndFunc

Func PrevHwnd()
  ;$array[0][0] = Number of windows returned
  ;$array[1][0] = 1st window title
  ;$array[1][1] = 1st window handle (HWND)
  Local $a=WinList()
  Local $x
  Local $t,$h,$v,$c,$y,$z
  For $x=1 To $a[0][0]
    $t=$a[$x][0]
    $h=$a[$x][1]
    If $t=='' Or $t=='Start' Then
      ContinueLoop
    EndIf
    $v=BitAND(WinGetState($h), 2)
    If Not $v Then
      ContinueLoop
    EndIf
    $c=_WinAPI_GetClassName($h)
    $y=_WinAPI_GetWindowLong($h,$GWL_STYLE)
    $z=_WinAPI_GetWindowLong($h,$GWL_EXSTYLE)
    If BitAND($z,$WS_EX_TOPMOST) Then
      ContinueLoop
    EndIf
    ;$ss=$y
    ;If Not BitAND($y,$WS_BORDER) Or $y.Caption==False Or $y.ThickFrame==False Then
    ;  ContinueLoop
    ;EndIf
    return $h
    ;$y=WinStyle(
    ;logline('$c:'&$c&' st:'&$y.AsString()&' $t:'&$t)
  Next
EndFunc

Func ShouldAbort()
  ;_IsPressed($sHexKey [, $vDLL = 'user32.dll'])
  If _IsPressed('A2') And _IsPressed('A3') Then
    Return True
  EndIf
  Return False
EndFunc

;;;;;;functions
Func ts()
  Return @YEAR&"."&@MON&"."&@MDAY&"."&@HOUR&"."&@MIN&"."&@SEC&"."&@MSEC
EndFunc
Func logline($line)
  Local $fh1=FileOpen($logg,1);
  If $fh1<>-1 Then
    FileWriteLine($fh1,$line)
    FileClose($fh1)
  EndIf
EndFunc

