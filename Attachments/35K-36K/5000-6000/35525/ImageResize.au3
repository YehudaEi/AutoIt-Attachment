#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <File.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <Misc.au3>
#Include <GuiMenu.au3>

Global $Picture, $Recentcount = 1, $Recent[2], $Edit = 0, $Place, $ImageWidth, $ImageHeight, $Resize = 0, $Sharpen = 0
Global $Output = @WindowsDir & "\Autoit.jpg"

FileInstall("ImageMagickObject.dll", @SystemDir & "\ImageMagickObject.dll", 0)
RunWait(@ComSpec & " /c regsvr32 /s ImageMagickObject.dll", @SystemDir, @SW_HIDE)

$GUI = GUICreate("Editor Imagen", 300, 300, 300, 200, $WS_OVERLAPPEDWINDOW)
$FileMenu = GUICtrlCreateMenu("Archivos")
$FileMenuOpen = GUICtrlCreateMenuItem("Abrir...", $FileMenu)
$FileMenuSave = GUICtrlCreateMenuItem("Guardar", $FileMenu)
GUICtrlSetState(-1, $GUI_DISABLE)
$FileMenuSaveAs = GUICtrlCreateMenuItem("Guardar como..", $FileMenu)
GUICtrlSetState(-1, $GUI_DISABLE)
$FileMenuRecentFiles = GUICtrlCreateMenu("Archivos recientes", $FileMenu)
GUICtrlSetState(-1, $GUI_DISABLE)
$FileMenuSeparator1 = GUICtrlCreateMenuItem("", $FileMenu)
$FileMenuRenameFile = GUICtrlCreateMenuItem("Renombrar Archivo...", $FileMenu)
GUICtrlSetState(-1, $GUI_DISABLE)
$FileMenuDeleteFile = GUICtrlCreateMenuItem("Borrar Archivo...", $FileMenu)
GUICtrlSetState(-1, $GUI_DISABLE)
$FileMenuSeparator2 = GUICtrlCreateMenuItem("", $FileMenu)
$FileMenuExit = GUICtrlCreateMenuItem("Salir", $FileMenu)
$EditMenu = GUICtrlCreateMenu("Editar")
GUICtrlSetState(-1, $GUI_DISABLE)
$EditMenuResizeImage = GUICtrlCreateMenuItem("Resize Image...", $EditMenu)


_GDIPlus_Startup()
$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
$oImg = ObjCreate("ImageMagickObject.MagickImage.1")
GUISetState()
Global $Client = _WinGetClientPos(1)
While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $FileMenuOpen
            $Image = FileOpenDialog("Choose file...", @DesktopCommonDir, "JPG (*.jpg)")
            If Not @error Then
                For $i = 1 To $Recentcount
                    If _GUICtrlMenu_GetItemText(GUICtrlGetHandle($FileMenuRecentFiles), $i - 1) = $Image Then
                        ExitLoop
                    EndIf
                    If $i = $Recentcount Then
                        $Recent[$Recentcount] = GUICtrlCreateMenuItem($Image, $FileMenuRecentFiles)
                        $Recentcount += 1
                        ReDim $Recent[$Recentcount + 1]
                    EndIf
                Next
                MenuEnable()
                Preview($Image)
            EndIf
        Case $FileMenuSave
            If FileExists(@WindowsDir & "\Autoit.jpg") Then FileCopy(@WindowsDir & "\Autoit.jpg", $Place, 9)
        Case $FileMenuSaveAs
            If FileExists(@WindowsDir & "\Autoit.jpg") Then
                $Save = FileSaveDialog("Escoge donde guardarla", @DesktopCommonDir, "JPG - JPEG Files (*.jpg)")
                If Not StringInStr($Save, ".jpg") Then $Save &= ".jpg"
                FileCopy(@WindowsDir & "\Autoit.jpg", $Save, 9)
                $Place = $Save
            EndIf
        Case $FileMenuRenameFile
            $SplitPlace = StringSplit($Place, "\", 1)
            $Input = InputBox("Renombrar archivo", "New name :", $SplitPlace[UBound($SplitPlace) - 1], "", 200, 130)
            If Not @error And $Input <> "" Then
                $TrimPlace = StringTrimRight($Place, StringLen($SplitPlace[UBound($SplitPlace) - 1]))
                MsgBox("", "", $TrimPlace & $Input)
                FileMove($Place, $TrimPlace & $Input, 1)
            EndIf
        Case $FileMenuDeleteFile
            $Delete = MsgBox(36, "Borrar Archivo", "Estas seguro de querer borrar el archivo?")
            If $Delete = 6 Then FileDelete($Place)
        Case $FileMenuExit
            Exit
        Case $EditMenuResizeImage
            ResizeGUI()
        Case $GUI_EVENT_CLOSE
            Exit
        Case Else
            For $i = 1 To $Recentcount - 1
                If $Recent[$i] = $msg Then
                    $Image = _GUICtrlMenu_GetItemText(GUICtrlGetHandle($FileMenuRecentFiles), $i - 1)
                    Preview($Image)
                EndIf
            Next
    EndSwitch
WEnd
Exit
Func Preview($ImageName, $Edit = 0)
    Local $hImage = _GDIPlus_ImageLoadFromFile($ImageName)
    Global $ImageWidth = _GDIPlus_ImageGetWidth($hImage)
    Global $ImageHeight = _GDIPlus_ImageGetHeight($hImage)
    _GDIPlus_ImageDispose($hImage)
    If $Picture <> "" Then GUICtrlDelete($Picture)
    $Picture = GUICtrlCreatePic($ImageName, 0, 0, $ImageWidth, $ImageHeight)
    WinMove($GUI, "", Default, Default, $ImageWidth, $ImageHeight)
    Local $ClientSize = WinGetClientSize($GUI)
    WinMove($GUI, "", (@DesktopWidth / 2) - ($ImageWidth / 2), (@DesktopHeight / 2) - ($ImageHeight / 2), $ImageWidth + ($ImageWidth - $ClientSize[0]), $ImageHeight + ($ImageHeight - $ClientSize[1]))
    Global $Image = $ImageName
    If Not $Edit Then
        Global $Place = $Image
        FileCopy($Place, @WindowsDir & "\Autoit.jpg", 9)
    EndIf
EndFunc   ;==>Preview

Func ResizeGUI()
	$ResizeForm = GUICreate("Cambiar tamaño imagen", 210, 110, -1, -1)
    $ResizeLabel1 = GUICtrlCreateLabel("Tamaño :   " & $ImageWidth & " x " & $ImageHeight, 16, 16, 137, 17)
    $ResizeInput1 = GUICtrlCreateInput("", 56, 40, 41, 21)
    $ResizeLabel2 = GUICtrlCreateLabel("Ancho :", 10, 48, 38, 17)
    $ResizeLabel3 = GUICtrlCreateLabel("Alto :", 115, 48, 41, 17)
    $ResizeInput2 = GUICtrlCreateInput("", 152, 40, 41, 21)
    $ResizeButton1 = GUICtrlCreateButton("OK", 16, 72, 83, 25, 0)
    $ResizeButton2 = GUICtrlCreateButton("Cancelar", 112, 72, 83, 25, 0)
    GUISetState(@SW_SHOW, $ResizeForm)
    While 1
        $msg = GUIGetMsg(1)
        If $msg[0] = $ResizeButton1 Then
            $NewWidth = GUICtrlRead($ResizeInput1)
            $NewHeight = GUICtrlRead($ResizeInput2)
            $Resize = 1
            ExitLoop
        ElseIf $msg[0] = $ResizeButton2 Or $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $ResizeForm Then
            ExitLoop
        ElseIf $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $GUI Then
            Exit
        EndIf
    WEnd
    GUIDelete($ResizeForm)
    If $Resize = 1 Then
        Resize($Image, $Output, $NewWidth, $NewHeight)
		barra()
         Preview($Output, 1)
        $Resize = 0
    EndIf
EndFunc   ;==>ResizeGUI

Func MenuEnable()
    GUICtrlSetState($FileMenuSave, $GUI_ENABLE)
    GUICtrlSetState($FileMenuSaveAs, $GUI_ENABLE)
    GUICtrlSetState($FileMenuRecentFiles, $GUI_ENABLE)
    GUICtrlSetState($FileMenuRenameFile, $GUI_ENABLE)
    GUICtrlSetState($FileMenuDeleteFile, $GUI_ENABLE)
    GUICtrlSetState($EditMenu, $GUI_ENABLE)
EndFunc   ;==>MenuEnable
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    MsgBox(0, "COM Error Test", "We intercepted a COM Error !" & @CRLF & @CRLF & _
            "err.descripcion is: " & @TAB & $oMyError.description & @CRLF & _
            "err.windescriction:" & @TAB & $oMyError.windescription & @CRLF & _
            "err.numero is: " & @TAB & $HexNumber & @CRLF & _
            "err.ultimodllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
            "err.lineascript is: " & @TAB & $oMyError.scriptline & @CRLF & _
            "err.codigo is: " & @TAB & $oMyError.source & @CRLF & _
            "err.archivoayuda is: " & @TAB & $oMyError.helpfile & @CRLF & _
            "err.ayudacontextual is: " & @TAB & $oMyError.helpcontext _
            )
    SetError(1)
EndFunc   ;==>MyErrFunc

Func GetClientPos($wTitle = "")
    Local $cPos[6]
    $wPos = WinGetPos($wTitle)
    $cPos[0] = $wPos[0] + $Client[0]
    $cPos[1] = $wPos[1] + $Client[1]
    $cPos[2] = ($wPos[0] + $wPos[2]) - $Client[2]
    $cPos[3] = ($wPos[1] + $wPos[3]) - $Client[3]
    $cPos[4] = $cPos[2] - $cPos[0]
    $cPos[5] = $cPos[3] - $cPos[1]
    Return $cPos
EndFunc   ;==>GetClientPos

Func _WinGetClientPos($fAbsolute = 0)
    Local $cPos = DllStructCreate("long;long;long;long"), $hWin = WinGetHandle("")
    DllCall("user32.dll", "int", "GetClientRect", "hwnd", $hWin, "ptr", DllStructGetPtr($cPos))
    Local $cPos2[4] = [DllStructGetData($cPos, 1), DllStructGetData($cPos, 2), DllStructGetData($cPos, 3), DllStructGetData($cPos, 4)]
    If $fAbsolute Then
        Local $MousePosSav = MouseGetPos()
        Local $MouseModeSav = Opt("MouseCoordMode", 2)
        MouseMove(0, 0, 0)
        Opt("MouseCoordMode", 1)
        Local $avRET = MouseGetPos()
        Opt("MouseCoordMode", $MouseModeSav)
        MouseMove($MousePosSav[0], $MousePosSav[1], 0)
        $wPos = WinGetPos("")
        $cPos2[0] = $avRET[0] - $wPos[0]
        $cPos2[1] = $avRET[1] - $wPos[1]
        $cPos2[2] = ($wPos[0] + $wPos[2]) - ($avRET[0] + $cPos2[2])
        $cPos2[3] = ($wPos[1] + $wPos[3]) - ($avRET[1] + $cPos2[3])
    EndIf
    Return $cPos2
EndFunc   ;==>_WinGetClientPos


Func Resize($sInFile, $sOutFile, $sWidth, $sHeight)
    $oImg.Convert($sInFile, "-resize", $sWidth & "x" & $sHeight & "!", $sOutFile)
EndFunc   ;==>Resize

func barra()
ProgressOn("Progress Bar", "", "Trabajando..")

For $i = 0 To 100
	ProgressSet($i)
	Sleep(5)
Next

ProgressSet(100, "Hecho!")
Sleep(750)
ProgressOff()
EndFunc
