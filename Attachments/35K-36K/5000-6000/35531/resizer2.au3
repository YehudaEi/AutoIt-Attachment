;======================================================================================
; Function Name:        RedimensionarImagen
; Descripcion:          Carga una imagen y la escala a la anchura o la altura deseada
;
; Parametros:                   $fImage:                imagen q va a ser redimensionada
;                               $iW:                    ancho de la imagen nueva. Si $iW = 0 entonces el valor por defecto es 96
;                               $iH:                    altura de la imagen nueva. If $iH = 0 entonces el valor por defecto es 96
;                               $fDestFolder:           carpeta de destino donde se guardara la imagen escalada
;                               $fExt:                  formato de imagen de salida (puede ser jpg, gif, bmp, gif, tiff) - por defecto es PNG, -1 para mantener la extensión
;                               $fPart:                 parte del nombre que lo separa del nombre orignal. Por defecto es .resized. -> filename.resized.ext
;
; Se requiere(s):       	GDIPlus.au3
; Valor devuelto(s):     		Exito: True, Error: ver abajo
; Codigos de error:         	1: no hay archivo
;                               2: el nombre del archivo no existe
;                               3: la imagen no puede ser redimensionada
;                               4: el tamaño de la imagen no pudo ser salvado
;
;=======================================================================================

#include <File.au3>
#include <GDIPlus.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <Misc.au3>
#Include <GuiMenu.au3>


_GDIPlus_Startup()
Global $Resize = 0
Global $folder = FileSelectFolder ("", "", 4)
Global $outfolder = @ScriptDir & "\Imagenes redimensionadas"
$oImg = ObjCreate("ImageMagickObject.MagickImage.1")
If @error Then Exit MsgBox(0, "Information", "Nothing selected - closing program", 10)
Global $fImage= _FileListToArray($folder, "*.???", 0)
For $i = 1 To $fImage[0]
    If StringRegExp($fImage[$i], "(?i).*\.png|.*\.jpg|.*\.bmp.*\.jpeg", 0) Then ResizeGUI($folder & $fImage[$i],0,0, $outfolder, -1)
	Next	
_GDIPlus_Shutdown()
ShellExecute($outfolder)

Local $hImageFromFile = _GDIPlus_ImageLoadFromFile($fImage)
Global $iWidth = _GDIPlus_ImageGetWidth($hImageFromFile)
Global $iHeight = _GDIPlus_ImageGetHeight($hImageFromFile)
Exit


func barra()
ProgressOn("Progress Bar", "", "Trabajando...")

For $i = 0 To 100
	ProgressSet($i)
	Sleep(5)
Next

ProgressSet(100, "Hecho!")
Sleep(750)
ProgressOff()
EndFunc

Func ResizeGUI($fImage,$iWidth,$iHeight,$fDestFolder,  $fExt = "-1",$fPart = ".resized.")
	
    $ResizeForm = GUICreate("Redimensionar Imagen", 210, 110, -1, -1)
    $ResizeInput1 = GUICtrlCreateInput("", 56, 40, 41, 21)
    $ResizeLabel2 = GUICtrlCreateLabel("Anchura :", 16, 48, 38, 17)
    $ResizeLabel3 = GUICtrlCreateLabel("Altura :", 104, 48, 41, 17)
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
			barra()
            ExitLoop
        ElseIf $msg[0] = $ResizeButton2 Or $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $ResizeForm Then
            ExitLoop
        ElseIf $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $GUI Then
            Exit
        EndIf
    WEnd
    GUIDelete($ResizeForm)
    If $Resize = 1 Then
        Resize($fImage, $NewWidth, $NewHeight, $fDestFolder)
        $Resize = 0
    EndIf
	
	 Local $fName = StringRegExpReplace($fImage, ".*\\(.*).{4}", "$1")
	 Local $declared = True
    If Not $ghGDIPDll Then
        _GDIPlus_Startup()
        $declared = False
    EndIf
	Local $hImageThumbnail = DllCall($ghGDIPDll, "uint", "GdipGetImageThumbnail", "handle", $hImageFromFile, "uint", $iWidth, "uint", $iHeight, "int*", 0, "ptr", 0, "ptr", 0)
	If @error Then
        _GDIPlus_ImageDispose($hImageFromFile)
        If Not $de1clared Then _GDIPlus_Shutdown()
        Return SetError(3, 0, 0)
    EndIf
    $hImageThumbnail = $hImageThumbnail[4]
    If Not FileExists($fDestFolder) Then DirCreate($fDestFolder)
    If $fPart = "" Then $fPart = "."
    If Not _GDIPlus_ImageSaveToFile($hImageThumbnail, $fDestFolder & "\" & $fImage & $fName & $fPart & $fExt) Then
        _GDIPlus_ImageDispose($hImageFromFile)
        _GDIPlus_ImageDispose($hImageThumbnail)
        If Not $declared Then _GDIPlus_Shutdown()
        Return SetError(4, 0, 0)
    EndIf
    _GDIPlus_ImageDispose($hImageFromFile)
    _GDIPlus_ImageDispose($hImageThumbnail)
    If Not $declared Then _GDIPlus_Shutdown()
    Return True
EndFunc   ;==>ResizeGUI


Func Resize($fImage, $fDestFolder, $NewWidth, $NewHeight)
    $oImg.Convert($fImage, "-resize", $NewWidth & "x" & $NewHeight & "!", $fDestFolder)
EndFunc   ;==>Resize
