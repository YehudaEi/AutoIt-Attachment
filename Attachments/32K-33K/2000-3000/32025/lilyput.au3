#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=lilyput.ico
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=Lilyput
#AutoIt3Wrapper_Res_Description=MIDI Input for Lilypond
#AutoIt3Wrapper_Res_Fileversion=2.0.0.5
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Uwe Lahni
#AutoIt3Wrapper_Res_Language=1031
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <midiudf.au3>
HotKeySet("{Esc}", "Escape")
global $outfile
global $send
Global $key[100]
global $zero[100]
global $nlg=16
global $lilyout=""
for $i=0 to 99
	$Zero[$i]=0
Next	
$notelo=number(get_config("NoteLo"))
$notehi=number(get_config("NoteHi"))
$midiinport=number(get_config("MIDIInPort"))
$midioutport=number(get_config("MIDIOutPort"))
$outfile=get_config("Outfile")
$send=number(get_config("Send"))

;~ consolewrite($notelo& " " &$notehi & @CRLF)

$cb = DLLCallbackRegister ("MIDIInProc", "long", "ptr;int;ptr;ptr;ptr")     
global $notename[12]

for $i=0 to 11
	$notename[$i]=get_notenames($i)
Next
Global $octn[11]=["?","?",",,,",",,",",","","'","''","'''"]
$midi_in = _midiInOpen ($midiinport,DllCallbackGetPtr($cb),0,$callback_function)
;$midi_out = _midiOutOpen ($midioutport)
;msgbox(0,"Ports",_MidiInGetID ($midi_in) & @CRLF ,500) ;& _MidiOutGetID($midi_out),500)
_midiinreset($midi_in)

$a=""
$dot=False
$noff=""
$non=""
$pos=0
$allnoff=False
_midiinstart($midi_in)

While true
	while not($allnoff)
		_midiinstart($midi_in)
		sleep(400)
		_midiinstop($midi_in)
		for $i=36 to $notehi
			If $key[$i]=-1 then $allnoff=True
			if $key[$i]=1 then 
;				consolewrite ($i)
				$allnoff=False
				ExitLoop
			EndIf	
		Next
	WEnd
	$allnoff=False
	for $i=36 to $notelo-1
		if $key[$i]<0 Then 
			$action= get_config("Key"&$i)
			if $action = "." then $dot=not($dot)
			if stringleft($action,1)="L" then $nlg= StringRight($action, stringlen($action)-1) 	
			if stringleft($action,1)="K" then send( StringRight($action, stringlen($action)-1)) 	
			if stringleft($action,1)="R" then 
				$lilyout="r"& $nlg
				$pos=$pos+16/$nlg
				if $dot then 
					$lilyout=$lilyout & "."
					$pos=$pos+8/$nlg
					$nlg=$nlg*2
					$dot=false
				endif	
				lilyout($lilyout)
			EndIf
			if stringleft($action,1)="S" then
				$lilyout="s"& $nlg
				$pos=$pos+16/$nlg
				if $dot then 
					$lilyout=$lilyout & "."
					$pos=$pos+8/$nlg
				endif	
				lilyout($lilyout)
			EndIf
			if stringleft($action,1)="B" then
				lilyout( " | {ENTER}")
				$pos=0
			EndIf
			
			$key[$i]=0
		EndIf
	Next
	$ncnt=0
	$noff=""
	for $i=$notehi to $notelo Step -1
		if $key[$i]<0 then 
			$ncnt=$ncnt+1
			$note=$notename[mod($i,12)]
			$oct=Int($i/12)
			$noff=$noff & " " & $note &  $octn[$oct]
			$key[$i]=0
		EndIf
	Next
	$lilyout=$noff
	if $noff >"" Then
		if $ncnt>1 then $lilyout="<" & $noff & ">" 
		$lilyout=$lilyout & $nlg
		$pos=$pos+16/$nlg
		if $dot then 
			$lilyout=$lilyout & "."
			$pos=$pos+8/$nlg
		endif
		lilyout($lilyout)
		$key=$zero
	endif	
WEnd

Func MidiInProc($midi, $msg,$instance,$Param1,$Param2)
	
	if $param1>255 then 
		$mm=$Param1
		$n=BitAND($mm,0x00ff00)/256
		$on=BitAND($mm,0x000090)/16
;		beep(999,99)
;		consolewrite($n & " " &$on & @CRLF)
 		if $on=9 then
			$key[$n]=1
 		endif
		if $on=8 Then
			$key[$n]=-1
		EndIf
	EndIf
EndFunc

func Escape()
	_midiinstop($midi_in)
	sleep(100)
	_midiinclose($midi_in)
	sleep(100)
	DllCallbackFree($cb)

EndFunc
;~ func play()
;~ 			_MidiOutShortMsg ($midi_out, 0x99 + (42 * 256) + (64 * 0x10000))
;~ 		if $t=1 then _MidiOutShortMsg ($midi_out, 0x99 + (36 * 256) + (127 * 0x10000))
;~ 		if mod ($t,4)=1 then _MidiOutShortMsg ($midi_out, 0x99 + (38 * 256) + (40 * 0x10000))
;~ ;		sleep(400)
;~ EndFunc

func lilyout($t)
;	consolewrite($t & @crlf)
	$lastlen=stringlen($t)
	if $send<>0 Then
		for $i=1 to $lastlen
			send(stringmid($t, $i,1))
		Next
	EndIf
	send(" ")
	$pos=mod($pos,16)
	if $pos=0 then send(" |{ENTER}")	
	if $outfile>"" Then
		filewrite($outfile,$t)
	EndIf
	$lilyout=""
EndFunc	

Func get_config($s)
	$g=IniRead("lilyput.ini", "Setup", $s, "x")
	If @error Then 
		MsgBox(4096, "", "INI File Error")
	EndIf
	Return $g
EndFunc
Func get_notenames($s)
	$g=IniRead("lilyput.ini", "NoteNames", $s, "x")
	If @error Then 
		MsgBox(4096, "", "INI File Error")
	EndIf
	Return $g
EndFunc