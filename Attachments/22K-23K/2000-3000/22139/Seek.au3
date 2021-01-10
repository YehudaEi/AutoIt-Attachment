#include <File.au3>
#include <Misc.au3>
Opt('WinTitleMatchMode', 1)
Tooltip('Try to find the file named: FindMe.txt in one of the directories on your desktop, if you found it double click on it..', 0, 0)
sleep(5000)
global $say[6]=['', 'This one', 'Pick me', 'the file is in me', 'dont pick me', 'im empty']
global $say1[6]=['', 'maybe in me', 'no not in me', 'yep the file is in me', 'look somewere else', 'COME HERE']
global $say2[3]=['', 'This is the one', 'no wrong directory']
$number1 = Random(1, 5, 1)
$number2 = Random(1, 5, 1)
$number3 = Random(1, 2, 1)
Tooltip('creating directorys and files', 0, 0)
DirCreate(@DesktopDir&'\start')
For $i = 1 to 5
	DirCreate(@DesktopDir&'\start\'&$say[$i])
	For $1 = 1 to 5
		DirCreate(@DesktopDir&'\start\'&$say[$i]&'\'&$say1[$1])
		For $2 = 1 to 2
			DirCreate(@DesktopDir&'\start\'&$say[$i]&'\'&$say1[$1]&'\'&$say2[$2])
			if $number1 = $i and $number2 = $1 and $number3 = $2 Then
				$goodfile = @DesktopDir&'\start\'&$say[$number1]&'\'&$say1[$number2]&'\'&$say2[$number3]&'\FindMe.txt'
				_FileCreate($goodfile)
				_FileWriteToLine($goodfile, 1, 'you found me')
			Else
				$toobadfile = @DesktopDir&'\start\'&$say[$i]&'\'&$say1[$1]&'\'&$say2[$2]&'\too bad.txt'
				_FileCreate($toobadfile)
				_FileWriteToLine($toobadfile, 1, 'awww too bad')
			EndIf
		Next
	Next
Next
For $i = 3 to 0 step -1
	Tooltip($i, 0, 0)
	sleep(1000)
Next
Tooltip('Gooooo!!', 0, 0)
$timer = TimerInit()
sleep(1000)
$secs = 0
$clicks = 0
While 1
	If _IsPressed(01) then $clicks +=1
	Sleep(1000)
	$secs += 1
	Tooltip('you are searching for '&$secs&' seconds and you clicked '&$clicks&' times', 0, 0)
	if WinExists('FindMe') then
		msgbox(32, 'Stop the time!', 'you got it in '&$secs&' seconds and '&$clicks&' clicks..'&@CRLF&'Make sure you closed all the directorys and files before clicking ok!'&@CRLF&'The game results are pasted into your clipboard')
		ClipPut('Game results seek:'&@CRLF&'seconds		= '&$secs&@CRLF&'click		= '&$clicks)
		DirRemove(@DesktopDir&'\start', 1)
		Exit
	EndIf
WEnd