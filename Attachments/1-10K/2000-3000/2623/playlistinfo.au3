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


Global Const $seconds=1000, $minutes=60000,$TRUE=1
dim $previous_song,$current_song

;main program

$file=FIleOpen(@MyDocumentsDir&"\songplaylist.txt",1)
$previous_song=GetSongInfo()
FileWriteLine($file, $previous_song)
FIleClose($file)
While $TRUE
 sleep(30*$seconds)
 $current_song=GetSongInfo()
 if StringInStr($current_song,$previous_song)=0 then
	$file=FIleOpen(@MyDocumentsDir&"\songplaylist.txt",1)
	FileWriteLine($file, $current_song)
	FIleClose($file)
	$previous_song=$current_song
 endif
wend
;**********************************************************