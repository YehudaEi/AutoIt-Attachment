#NoTrayIcon
#RequireAdmin

#region
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Tools By Soebis@TG
#AutoIt3Wrapper_Res_Fileversion=1.0.1.0
#AutoIt3Wrapper_Res_ProductVersion=1.01
#AutoIt3Wrapper_Res_Field=company|Trikgratis.com
#EndRegion

#region
$image = @AppDataDir & "\soebis.gif"
If Not FileExists($image) Then
FileInstall("Soebis.gif", @AppDataDir & "\soebis.gif")
EndIf
#endregion

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Constants.au3>
#include <StaticConstants.au3>
#Region ### START Koda GUI section ### Form=e:\kumpulan script\koda_1.7.3.0\forms\formprint.kxf
$Formprint = GUICreate("Simple Commad And Route", 570, 428, -1, -1)
$MenuItem1 = GUICtrlCreateMenu("Tentang")
GUISetFont(9, 400, 0, "Calibri")
$cmd = GUICtrlCreateEdit("", 0, 0, 569, 257, BitOR($ES_AUTOVSCROLL,$ES_WANTRETURN,$WS_VSCROLL))
GUICtrlSetFont($cmd, 9, 400, 0, "Courier New")
GUICtrlSetColor(-1, 0x00FF00)
GUICtrlSetBkColor(-1, 0x000000)
$keluar = GUICtrlCreateButton("Keluar", 480, 368, 81, 25)
$hapus = GUICtrlCreateButton("Hapus Table", 480, 263, 81, 25)
$print = GUICtrlCreateButton("Route Print", 208, 367, 81, 25)
$Input1 = GUICtrlCreateInput("", 8, 264, 289, 22)
$kirim = GUICtrlCreateButton("Send", 304, 263, 65, 25)
$Group1 = GUICtrlCreateGroup("Route", 8, 288, 289, 113)
$proxy = GUICtrlCreateCombo("", 112, 304, 177, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "10.1.89.130|202.152.240.50|10.4.0.10|10.8.3.8|10.19.19.19|0.0.0.0")
$ip = GUICtrlCreateEdit("", 112, 336, 177, 25, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN))
GUICtrlSetData(-1, "")
$route = GUICtrlCreateButton("Route ADD", 32, 368, 73, 25)
$delete = GUICtrlCreateButton("Route Delete", 112, 368, 89, 25)
$Label1 = GUICtrlCreateLabel("PROXY", 34, 308, 38, 18)
GUICtrlSetFont(-1, 9, 800, 0, "Calibri")
$get = GUICtrlCreateButton("Get IP", 32, 336, 65, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Pic1 = GUICtrlCreatePic(@AppDataDir & "\soebis.gif", 320, 296, 121, 105, -1, BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
GUICtrlSetCursor (-1, 0)
$stop = GUICtrlCreateButton("Stop Proces", 376, 264, 81, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$hENTER = GUICtrlCreateDummy()
Dim $AccelKeys[1][2] = [["{ENTER}", $hENTER]] ; Set accelerators
GUISetAccelerators($AccelKeys)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		case $kirim, $hENTER
			kirim()
		case $hapus
			Hapus()
		case $print
			print()
		case $stop()
			stop()
		case $get
			get()
		case $route
			route()
		case $delete
			delete()
		case $Pic1
			ShellExecute("http://trikgratis.com/str/anketa.php")
		case $MenuItem1
			Tentang()
		case $keluar
			stop()
			Exit

	EndSwitch
WEnd

func kirim()
			Local $hostdata = Run(@ComSpec & " /c " & Guictrlread($input1), @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
            Local $line1
            While 1
                $line1 = StdoutRead($hostdata)
                If @error Then ExitLoop
                If $line1 <> "" Then
				pesan("" & $line1)
                EndIf
            WEnd
            While 1
                $line1 = StderrRead($hostdata)
                If @error Then ExitLoop
			WEnd

EndFunc

func print()

			Local $hostdata = Run(@ComSpec & " /c route print", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
            Local $line1
            While 1
                $line1 = StdoutRead($hostdata)
                If @error Then ExitLoop
                If $line1 <> "" Then
				pesan("Route Print: " & $line1)
                EndIf
            WEnd
            While 1
                $line1 = StderrRead($hostdata)
                If @error Then ExitLoop
			WEnd
			pesan("Route Print Telah Selesai")
			pesan("By : Soebis")

		EndFunc

func stop()

Hapus()
if ProcessExists("ping") Then ProcessClose("ping.exe")
Sleep(100)
If ProcessExists("cmd.exe") Then ProcessClose("cmd.exe")
Sleep(100)
If ProcessExists("tracert.exe") Then ProcessClose("tracert.exe")
Sleep(100)

pesan("Proses Telah Dihentikan")

EndFunc

func get()

If @IPAddress2 = "0.0.0.0" Then
		GUICtrlSetData($ip, @IPAddress1)
	Else
		Guictrlsetdata($ip, @IPAddress2)
	EndIf
EndFunc

func route()

$poksay = Guictrlread($proxy)
$ipc = GUICtrlRead($ip)

Run(@SystemDir & "\route.exe add " & $poksay & " mask 255.255.255.255 " & $ipc , @SystemDir, @SW_HIDE)
Hapus()
pesan("Route Add Telah Berhasil, Silahkan Tekan Tombol Route Print untuk melihat hasilnya")
MsgBox(8256, "Route Add", "Route Add telah berhasil")
Hapus()

EndFunc

Func delete()

Run(@SystemDir & "\route.exe DELETE 0.0.0.0", @SystemDir, @SW_HIDE)
Hapus()
pesan("Route Delete Telah Berhasil, Silahkan Tekan Tombol Route Print untuk melihat hasilnya")
MsgBox(8256, "Route Delete", "Route Delete Telah Berhasil")
Hapus()

EndFunc

Func Hapus()

GUICtrlSetData($cmd, "")

EndFunc

Func pesan($Message)

    GUICtrlSetData($cmd, $Message & @CRLF, 1)

EndFunc
