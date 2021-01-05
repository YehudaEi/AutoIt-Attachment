#include <GUIConstants.au3>
#Include <Constants.au3>
#NoTrayIcon

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.
Global Const $seconds=1000, $minutes=60000,$TRUE=1,$FALSE=0


Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc


Func GetSongInfo()
dim $position
$var = WinList()

For $i = 1 to $var[0][0]
  ; Only display visble windows that have a title
  ; with Winamp and that IS visible..there is a hidden
  ;winamp window with just winamp library..we DON't want that!!
  If $var[$i][0] <> "" AND IsVisible($var[$i][1]) then
	$position=StringInStr($var[$i][0],"winamp")
	if $position>0 then
	 ;we found the winamp window
	 ;so get the title from here after stripping winamp from it.
	 ;along with the extraneous space and '-'
	 $songinfo=StringTrimRight($var[$i][0],9)
	 $songinfo=StringTrimLeft($songinfo,2)
	 $songinfo=StringStripWS($songinfo,3)
	 return $songinfo 
        endif   
  EndIf
Next
EndFunc


;***********************************************************
;Problem: Ever been listening to the radio on Winamp
;         and the next day trying to remember the name of 
;	  that great song you were listening to?
;Solution: This Program! It logs the currently playing file
;          from Winamp. It checks every 30 secs so it 
;          should be fine with regular songs and not REALLY
;          short snippets.
;File Location: playlistinfo.txt saved in your My Documents
;               folder
;HAVE FUN!
;
;**created by closeupman, contact: closeupman AT aol dot com
;**put autoit as subject line
dim $previous_song,$current_song
dim $logsongsflag

$logsongsitem = TrayCreateItem("Log Songs")
TrayCreateItem("")
$aboutitme = TrayCreateItem("About")
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")

TraySetState()

$file=FileOpen(@MyDocumentsDir&"\songplaylist.txt",1)
$previous_song=""
While $TRUE
    ;sleep(30*$seconds)
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
        Case $msg = $logsongsitem
	msgbox(4096,"", TrayItemGetState($logsongsitem))
	    ; if $logsongs isn't checked that means the user is checking 
	    ; it now, so that means the user wants to log songs
            if TrayItemGetState($logsongsitem)=68 then
	      TrayItemSetState($logsongsitem,$TRAY_CHECKED)
msgbox(4096,"", TrayItemGetState($logsongsitem))
	      ;$logsongsflag=$TRUE
	    else
		
	      ; if $logsongs is checked that means the user is UNchecking 
	      ; it now, so that means the user wants to stop logging songs
	      TrayItemSetState($logsongsitem,68)
	      $logsongsflag=$FALSE

            endif
	Case $msg = $exititem
            Exitloop
    EndSelect


    ;if the $Logsongsflag is TRUE that means we need to log songs
    ;If $logsongsflag=$TRUE then
	;$current_song=GetSongInfo()
 	;if StringInStr($current_song,$previous_song)=0 then
	 ; $file=FIleOpen(@MyDocumentsDir&"\songplaylist.txt",1)
	  ;FileWriteLine($file, $current_song)
	  ;FIleClose($file)
	  ;$previous_song=$current_song
        ;endif
    ;endif

WEnd

FIleClose($file)
Exit