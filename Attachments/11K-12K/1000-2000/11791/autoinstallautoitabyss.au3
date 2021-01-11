


#include <GUIConstants.au3>
#include <File.au3>


if not fileexists("C:\program files\Abyss Web Server\abyss.conf") then

if MsgBox(36,"Web-Based AutoIt Easy Installer",'Abyss Web Server was not found in the directory "C:\program files\Abyss Web Server". Do you have Abyss Web Server Installed?') = 6 then
global $path = _ask("Please type in the directory to your Abyss Webserver installation...", "C:\Program Files\Abyss Web Server")

if not fileexists($path) then 
MsgBox(16,"Web-Based AutoIt Easy Installer","Could not find the directory specified.")
exit
endif

if not fileexists($path & "\abyss.conf") then
MsgBox(16,"Web-Based AutoIt Easy Installer","Could not find the Abyss Config file.")
exit
endif
global $path = $path & "\abyss.conf"
else

if MsgBox(68,"Web-Based AutoIt Easy Installer","Since Abyss Webserver is not installed, would you like me to download it for you?") = 6 then
download_abyss()
else
MsgBox(16,"Web-Based AutoIt Easy Installer","Abyss Webserver must be installed for this installer to continue.")
exit
endif
endif
else
$path = "C:\program files\Abyss Web Server\abyss.conf"
endif

if MsgBox(36,"Web-Based AutoIt Easy Installer","Welcome to the Web-Based AutoIt Easy Installer!" & @CRLF & "" & @CRLF & "This installer will help you get web-based autoit running on your machine." & @CRLF & "" & @CRLF & "Would you like to continue?") = 7 then exit

MsgBox(32,"Web-Based AutoIt Easy Installer","OK, you will now be asked a series of quesions. " & @CRLF & "" & @CRLF & 'If at any time you would like to cancel the easy installer, but push "Cancel".')

if regread("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "betaInstallDir") = "" then
$def = regread("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir") & "\AutoIt3.exe"
else
$def = regread("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "betaInstallDir") & "\AutoIt3.exe"
endif

$autoit_exe = _ask("Please enter the path to the AutoIt executable that should be the interpreter for AutoIt scripts...", $def)

do
$ext = _ask("Please enter the extentions that should be ran as AutoIt scripts when in a web-enviroment (For more then 1, seperate them by commas (,))", "aux,ahp")
until stringlen($ext) > 0

$exe_ext = ''
$ext = stringreplace($ext, ".", "")
$ext = stringsplit($ext, ",")
if isarray($ext) then
for $i = 1 to $ext[0]
$exe_ext &= @crlf & "							" & $ext[$i]
next
$ext = $exe_ext
$exe_ext = ''
else
$ext = @crlf & $ext
endif

if MsgBox(33,"Web-Based AutoIt Easy Installer","OK, we are now ready to apply new settings to Abyss Webserver to make it execute AutoIt script." & @CRLF & "" & @CRLF & "Push OK below to continue, or Cancel to exit...") = 2 then exit
$data = fileread($path)
if stringinstr($data, $autoit_exe) then
if MsgBox(33,"Web-Based AutoIt Easy Installer","Um, it appears that you might have already applyed the settings that will allow Abyss Webserver to run AutoIt scripts." & @CRLF & "" & @CRLF & "Push OK below to continue installing, or Cancel to exit...") = 2 then exit
endif


$lines = _FileCountLines($path)
for $i = 1 to $lines
$data = filereadline($path, $i)
if stringinstr($data, "</interpreters>") then
exitloop
endif
next



$data = ''
$data &='					<interpreter>' & @crlf
$data &='						<ext>' & @crlf
$data &= $ext & @crlf
$data &='						</ext>' & @crlf
$data &='						<interface>' & @crlf
$data &='							0' & @crlf
$data &='						</interface>' & @crlf
$data &='						<file>' & @crlf
$data &='							' & $autoit_exe & @crlf
$data &='						</file>' & @crlf
$data &='						<checkexists>' & @crlf
$data &='							yes' & @crlf
$data &='						</checkexists>' & @crlf
$data &='						<type>' & @crlf
$data &='							0' & @crlf
$data &='						</type>' & @crlf
$data &='						<updatepaths>' & @crlf
$data &='							yes' & @crlf
$data &='						</updatepaths>' & @crlf
$data &='					</interpreter>' & @crlf
$data &='				</interpreters>' & @crlf

_FileWriteToLine($path, $i, $data, 1)
MsgBox(64,"Web-Based AutoIt Easy Installer","The new settings have been applyed." & @CRLF & "" & @CRLF & "I will now restart Abyss Web Server...")
ProcessClose ("abyssws.exe")
$run_path = stringreplace($path, "\abyss.conf", '') & "\abyssws.exe"
$run = run('"' & $run_path & '"')

while processexists($run) = 0
wend

MsgBox(64,"Web-Based AutoIt Easy Installer","Abyss Web Server has been restarted." & @CRLF & "" & @CRLF & "Please check that all the settings have taken effect." & @CRLF & "" & @CRLF & "Enjoy!")


exit
func _Ask($question, $default = '')
$asked = GUICreate("Question", 324, 106, 193, 115)
$Label1 = GUICtrlCreateLabel($question, 12, 4, 298, 45)
$input = GUICtrlCreateInput($default, 12, 52, 297, 21)
$ok = GUICtrlCreateButton("&OK", 158, 76, 75, 25, 0)
$cancel = GUICtrlCreateButton("&Cancel", 236, 76, 75, 25, 0)
GUISetState(@SW_SHOW)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cancel
			Exit
		Case $ok
			exitloop
	EndSwitch
WEnd
$data = guictrlread($input)
guidelete($asked)
return $data
endfunc

func download_abyss()
$dload_url = '                                       '

$dload = GUICreate("Downloading Abyss Web Server... ", 392, 103, 299, 235)
$progress = GUICtrlCreateProgress(12, 26, 370, 28, $PBS_SMOOTH)
GUICtrlSetData(-1, 0)
$Label1 = GUICtrlCreateLabel("Please wait while I download Abyss Webserver...", 14, 4, 235, 17)
$status = GUICtrlCreateLabel("Status: (Please Wait)", 14, 58, 368, 17, $SS_CENTER)
$cancel = GUICtrlCreateButton("Cancel", 308, 76, 75, 25, 0)
GUISetState(@SW_SHOW)
guictrlsetdata($status, "Status: Getting File Size...")
$size = InetGetSize ($dload_url)
if number($size) = 0 then
msgbox(0, "", "No Internet connection.")
exit
endif

InetGet ( $dload_url ,@scriptdir & "\abyss_webserver_install.exe", 0, 1)

$temp = 0
While @InetGetActive
	$nMsg = GUIGetMsg()
	if $nmsg = $GUI_EVENT_CLOSE then
	InetGet("abort")
	filedelete(@scriptdir & "\abyss_webserver_install.exe")
	exit
	endif

	if $nmsg = $cancel then
	InetGet("abort")
	filedelete(@scriptdir & "\abyss_webserver_install.exe")
	exit
	endif

	if $temp <> @InetGetBytesRead then
	$temp = @InetGetBytesRead
	guictrlsetdata($status, "Status: Downloaded " & round(@InetGetBytesRead / 1024, 0) & "KB / " & round($size / 1024, 0) & "KB - " & round(@InetGetBytesRead / $size * 100, 0) & "% Done")
	WinSetTitle ( $dload, "", "Downloading Abyss Web Server... " & round(@InetGetBytesRead / $size * 100, 0) & "% Done" )
	guictrlsetdata($progress, round(@InetGetBytesRead / $size * 100, 0))
	endif
WEnd
MsgBox(64,"Web-Based AutoIt Easy Installer","Abyss Web Server has been downloaded." & @CRLF & "" & @CRLF & "Easy Installer will now exit and run the Abyss Web Server setup. Please compleate the setup of Abyss Web Server then run this easy installer again.")
run('"' & @scriptdir & '\abyss_webserver_install.exe"')
exit
endfunc