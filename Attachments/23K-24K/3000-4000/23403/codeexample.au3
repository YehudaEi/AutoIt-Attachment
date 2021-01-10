#include <windowsConstants.au3>
#include <IE.au3>

_IEErrorHandlerRegister()

$oIE = _IECreateEmbedded()
$GUI = GUICreate("Last.fm Player", 640, 580, _
		(@DesktopWidth - 640) / 2, (@DesktopHeight - 580) / 2, _
		$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$GUIActiveX = GUICtrlCreateObj($oIE, 10, 40, 500, 400)
GUISetState() ;Show GUI
_IENavigate($oIE, "                                                ")
$username = "toonboon"
DirGetSize(@ScriptDir & "\Url")
If @error = 1 Then
	DirCreate(@ScriptDir & "\Url")
EndIf
$File = FileOpen(@ScriptDir & "\Url\" & $username & ".html",2)
MsgBox(0,'',$File)
FileWriteLine($File, '<object type="application/x-shockwave-flash" data="http://cdn.last.fm/webclient/s12n/s/3/lfmPlayer.swf" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0"' & @CRLF & '        id="lfmPlayer" name="lfmPlayer" align="middle"' & @CRLF & '        width="300" height="221">' & @CRLF & '    <param name="movie" value="http://cdn.last.fm/webclient/s12n/s/3/lfmPlayer.swf" />' & @CRLF & '    <param name="flashvars" value="lang=en&amp;lfmMode=radio&amp;FOD=true&amp;expanded=true&amp;url=lastfm%3A%2F%2Fuser%2F' & $username & '%2Fpersonal&amp;autostart=true" />' & @CRLF & '    <param name="allowScriptAccess" value="always" />' & @CRLF & '    <param name="allowNetworking" value="all" />' & @CRLF & '    <param name="allowFullScreen" value="true" />' & @CRLF & '    <param name="quality" value="high" />' & @CRLF & '    <param name="bgcolor" value="fff" />' & @CRLF & '    <param name="wmode" value="transparent" />' & @CRLF & '    <param name="menu" value="true" />' & @CRLF & '</object></noscript>' & @CRLF & '</div>' & @CRLF & '' & @CRLF & '' & @CRLF & '<script>' & @CRLF & 'var lfmPlayer_params = {"movie":"http:\/\/cdn.last.fm\/webclient\/s12n\/s\/3\/lfmPlayer.swf","flashvars":"lang=en&lfmMode=radio&FOD=true&expanded=true&url=lastfm%3A%2F%2Fuser%2F' & $username & '%2Fpersonal&autostart=true","width":300,"height":221,"majorversion":7,"build":"0","allowscriptaccess":"always","allownetworking":"all","allowfullscreen":"true","quality":"high","bgcolor":"#fff","wmode":"transparent","menu":"true","id":"lfmPlayer","setcontainercss":false,"swliveconnect":"true","name":"lfmPlayer","align":"middle"};' & @CRLF & 'UFO.create(lfmPlayer_params, "lfmPlayer_container");' & @CRLF & '</script>')
_IENavigate($oIE,@ScriptDir & "\Url\" & $username & ".html")
While 1
	Sleep(1000)
	WinSetTitle($GUI, '', StringReplace($oIE.document.title, " - Last.fm", ""))
WEnd