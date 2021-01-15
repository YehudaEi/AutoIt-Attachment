#include <Process.au3>

Func _INetConnect($Service, $Username, $Password)
	_RunDOS('rasdial "' & $Service & '" ' & $Username & " " & $Password & " > " & @TempDir & "/" & $Service & "-Con.txt")
	Local $Con = FileRead(@TempDir & "/" & $Service & "-Con.txt", FileGetSize(@TempDir & "/" & $Service & "-Con.txt"))
	FileDelete(@TempDir & "/" & $Service & "-Con.txt")
	Select
		Case StringInStr($Con, "Remote Access error 691")
			Return 0
		Case StringInStr($Con, "Command completed successfully.")
			Return 1
	EndSelect
	Return -1
EndFunc

Func _INetDisconnect($Service)
	_RunDOS('rasdial "' & $Service & '" /DISCONNECT ' & " > " & @TempDir & "/" & $Service & "-DisCon.txt")
	Local $Con = FileRead(@TempDir & "/" & $Service & "-DisCon.txt", FileGetSize(@TempDir & "/" & $Service & "-DisCon.txt"))
	FileDelete(@TempDir & "/" & $Service & "-Con.txt")
	If StringInStr($Con, "Command completed successfully.") Then Return 1
	Return 0
EndFunc

Func _INetStatus($Service)
	_RunDOS('rasdial > ' & @TempDir & "/" & $Service & "-Status.txt")
	Local $Con = FileRead(@TempDir & "/" & $Service & "-Status.txt", FileGetSize(@TempDir & "/" & $Service & "-Status.txt"))
	FileDelete(@TempDir & "/" & $Service & "-Status.txt")
	If StringInStr($Con, "No connections") <> 0 Then Return 0;No connections @ all
	If StringInStr($Con, "Connected to") AND StringInStr($Con, $Service) Then Return 1;We are connected to something and the Service is in the name
	Return 0;We are connected, but not to the Service asked
EndFunc

Func _INetReconnect($Service, $Username, $Password)
	If _INetStatus($Service) = 1 Then _INetDisconnect($Service)
	If _INetConnect($Service, $Username, $Password) = 0 Then Return 0
	Return 1
EndFunc