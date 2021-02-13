;~ todo lo que empieza con #AutoIt3Wrapper son ficheros que se van a incrustar al programa
;~ nosotros podríamos decírle que leyese cada imagen de un archivo del disco duro, pero así tenemos un programa que no necesita
;~ instalarse porque ya lleva incorporadas las imágenes (o los sonidos o lo que haga falta)
#AutoIt3Wrapper_Icon=ico.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_File_Add=arriba.bmp, rt_bitmap, arriba
#AutoIt3Wrapper_Res_File_Add=abajo.bmp, rt_bitmap, abajo
#AutoIt3Wrapper_Res_File_Add=izquierda.bmp, rt_bitmap, izquierda
#AutoIt3Wrapper_Res_File_Add=derecha.bmp, rt_bitmap, derecha
#AutoIt3Wrapper_Res_File_Add=alto.bmp, rt_bitmap, alto
#AutoIt3Wrapper_Res_File_Add=bajo.bmp, rt_bitmap, bajo
#AutoIt3Wrapper_Res_File_Add=ancho.bmp, rt_bitmap, ancho
#AutoIt3Wrapper_Res_File_Add=estrecho.bmp, rt_bitmap, estrecho
#AutoIt3Wrapper_Res_File_Add=medir.bmp, rt_bitmap, medir
#AutoIt3Wrapper_Res_File_Add=mas.bmp, rt_bitmap, mas
#AutoIt3Wrapper_Res_File_Add=mas1.bmp, rt_bitmap, mas1
#AutoIt3Wrapper_Res_File_Add=mas2.bmp, rt_bitmap, mas2
#AutoIt3Wrapper_Res_File_Add=menos.bmp, rt_bitmap, menos
#AutoIt3Wrapper_Res_File_Add=menos1.bmp, rt_bitmap, menos1
#AutoIt3Wrapper_Res_File_Add=menos2.bmp, rt_bitmap, menos2
#AutoIt3Wrapper_Res_File_Add=apagar.bmp, rt_bitmap, apagar
#AutoIt3Wrapper_Res_File_Add=ok.bmp, rt_bitmap, ok
#AutoIt3Wrapper_Res_File_Add=ok2.bmp, rt_bitmap, ok2
#AutoIt3Wrapper_Res_File_Add=camara.bmp, rt_bitmap, camara


;~ Aquí vamos poniendo las variables que necesitan ser declaradas
Global $XX = 0
Global $XXX = 0
Global $YY = 0
Global $YYY = 0
Global $coord
Global $hColourBorder
Global $hColorFill
Global $coord1
Global $coord2
Global $coord3
Global $coord4
Global $medida
Global $valorinput1
Global $valorinput2
Global $input7

; Toda esta parrafada es necesaria para arrancar la webcam
$WM_CAP_START = 0x400
$WM_CAP_UNICODE_START = $WM_CAP_START + 100
$WM_CAP_PAL_SAVEA = $WM_CAP_START + 81
$WM_CAP_PAL_SAVEW = $WM_CAP_UNICODE_START + 81
$WM_CAP_UNICODE_END = $WM_CAP_PAL_SAVEW
$WM_CAP_ABORT = $WM_CAP_START + 69
$WM_CAP_DLG_VIDEOCOMPRESSION = $WM_CAP_START + 46
$WM_CAP_DLG_VIDEODISPLAY = $WM_CAP_START + 43
$WM_CAP_DLG_VIDEOFORMAT = $WM_CAP_START + 41
$WM_CAP_DLG_VIDEOSOURCE = $WM_CAP_START + 42
$WM_CAP_DRIVER_CONNECT = $WM_CAP_START + 10
$WM_CAP_DRIVER_DISCONNECT = $WM_CAP_START + 11
$WM_CAP_DRIVER_GET_CAPS = $WM_CAP_START + 14
$WM_CAP_DRIVER_GET_NAMEA = $WM_CAP_START + 12
$WM_CAP_DRIVER_GET_NAMEW = $WM_CAP_UNICODE_START + 12
$WM_CAP_DRIVER_GET_VERSIONA = $WM_CAP_START + 13
$WM_CAP_DRIVER_GET_VERSIONW = $WM_CAP_UNICODE_START + 13
$WM_CAP_EDIT_COPY = $WM_CAP_START + 30
$WM_CAP_END = $WM_CAP_UNICODE_END
$WM_CAP_FILE_ALLOCATE = $WM_CAP_START + 22
$WM_CAP_FILE_GET_CAPTURE_FILEA = $WM_CAP_START + 21
$WM_CAP_FILE_GET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 21
$WM_CAP_FILE_SAVEASA = $WM_CAP_START + 23
$WM_CAP_FILE_SAVEASW = $WM_CAP_UNICODE_START + 23
$WM_CAP_FILE_SAVEDIBA = $WM_CAP_START + 25
$WM_CAP_FILE_SAVEDIBW = $WM_CAP_UNICODE_START + 25
$WM_CAP_FILE_SET_CAPTURE_FILEA = $WM_CAP_START + 20
$WM_CAP_FILE_SET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 20
$WM_CAP_FILE_SET_INFOCHUNK = $WM_CAP_START + 24
$WM_CAP_GET_AUDIOFORMAT = $WM_CAP_START + 36
$WM_CAP_GET_CAPSTREAMPTR = $WM_CAP_START + 1
$WM_CAP_GET_MCI_DEVICEA = $WM_CAP_START + 67
$WM_CAP_GET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 67
$WM_CAP_GET_SEQUENCE_SETUP = $WM_CAP_START + 65
$WM_CAP_GET_STATUS = $WM_CAP_START + 54
$WM_CAP_GET_USER_DATA = $WM_CAP_START + 8
$WM_CAP_GET_VIDEOFORMAT = $WM_CAP_START + 44
$WM_CAP_GRAB_FRAME = $WM_CAP_START + 60
$WM_CAP_GRAB_FRAME_NOSTOP = $WM_CAP_START + 61
$WM_CAP_PAL_AUTOCREATE = $WM_CAP_START + 83
$WM_CAP_PAL_MANUALCREATE = $WM_CAP_START + 84
$WM_CAP_PAL_OPENA = $WM_CAP_START + 80
$WM_CAP_PAL_OPENW = $WM_CAP_UNICODE_START + 80
$WM_CAP_PAL_PASTE = $WM_CAP_START + 82
$WM_CAP_SEQUENCE = $WM_CAP_START + 62
$WM_CAP_SEQUENCE_NOFILE = $WM_CAP_START + 63
$WM_CAP_SET_AUDIOFORMAT = $WM_CAP_START + 35
$WM_CAP_SET_CALLBACK_CAPCONTROL = $WM_CAP_START + 85
$WM_CAP_SET_CALLBACK_ERRORA = $WM_CAP_START + 2
$WM_CAP_SET_CALLBACK_ERRORW = $WM_CAP_UNICODE_START + 2
$WM_CAP_SET_CALLBACK_FRAME = $WM_CAP_START + 5
$WM_CAP_SET_CALLBACK_STATUSA = $WM_CAP_START + 3
$WM_CAP_SET_CALLBACK_STATUSW = $WM_CAP_UNICODE_START + 3
$WM_CAP_SET_CALLBACK_VIDEOSTREAM = $WM_CAP_START + 6
$WM_CAP_SET_CALLBACK_WAVESTREAM = $WM_CAP_START + 7
$WM_CAP_SET_CALLBACK_YIELD = $WM_CAP_START + 4
$WM_CAP_SET_MCI_DEVICEA = $WM_CAP_START + 66
$WM_CAP_SET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 66
$WM_CAP_SET_OVERLAY = $WM_CAP_START + 51
$WM_CAP_SET_PREVIEW = $WM_CAP_START + 50
$WM_CAP_SET_PREVIEWRATE = $WM_CAP_START + 52
$WM_CAP_SET_SCALE = $WM_CAP_START + 53
$WM_CAP_SET_SCROLL = $WM_CAP_START + 55
$WM_CAP_SET_SEQUENCE_SETUP = $WM_CAP_START + 64
$WM_CAP_SET_USER_DATA = $WM_CAP_START + 9
$WM_CAP_SET_VIDEOFORMAT = $WM_CAP_START + 45
$WM_CAP_SINGLE_FRAME = $WM_CAP_START + 72
$WM_CAP_SINGLE_FRAME_CLOSE = $WM_CAP_START + 71
$WM_CAP_SINGLE_FRAME_OPEN = $WM_CAP_START + 70
$WM_CAP_STOP = $WM_CAP_START + 68


;~ Todo esto son miniprogramas auxiliares que usa el programa principal,
;~ tienen que estar metidos en la carpeta INCLUDE de la instalación del autoit para poder compilar el programa.
;~ Luego, cuando ya tenemos el .exe ya no hacen falta
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StructureConstants.au3>
#include <GUIScrollBars.au3>
#include <ScrollBarConstants.au3>
#include <webcam.au3>
#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <Misc.au3>
#include <date.au3>
#include <resources.au3>
#include <audio.au3>
#include <string.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <GuiComboBox.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include <SendMessage.au3>
#include <ProgressConstants.au3>
#include <ButtonConstants.au3>
#include <WinAPI.au3>
#include <ClipBoard.au3>
#include <UpdownConstants.au3>
#include <Graph UDF.au3>

;~ Solo 1 medidor de muelles trabajando a la vez. Con esta linea le indicamos que no puedan correr dos programas a la vez
_Singleton("Unique String Here")

$avi = DllOpen("avicap32.dll");~ esto lo pide la webcam
$user = DllOpen("user32.dll");~ esto también
$snapfile = @ScriptDir & "\foto.bmp";~ esto es por si necesitamos pasar de video a foto estática para aplicarle el algoritmo de reducción de ruido Sobel.
;~ Lo que viene a decir es que cuando se llame a la variable $sanapfile guarde el archivo resultante al mismo directorio donde esté el script y lo llame foto.bmp

;~ Este es un miniprograma que calcula cuanto mide la barra de tareas.
;~ Es necesario para luego decirle al programa cuanto tiene que medir de ancho y de alto la gui (interfaz gráfica de usuario)
Local $iPrevMode = AutoItSetOption("WinTitleMatchMode", 4)
Local $aTaskBar_Pos = WinGetPos("classname=Shell_TrayWnd")
AutoItSetOption("WinTitleMatchMode", $iPrevMode)
$altogui4 = @DesktopHeight - $aTaskBar_Pos[3] - 15
$anchogui4 = @DesktopWidth

;~ con esto creamos la ventana principal y le ponemos todos los botones      mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
$Main = GUICreate("Medidor de Muelles Beta", @DesktopWidth, $altogui4)

$Button1 = GUICtrlCreateButton("", 2 + 5, 160 + 335, 75, 75, $BS_BITMAP)
_ResourceSetImageToCtrl($Button1, "arriba", $RT_BITMAP)

$Button2 = GUICtrlCreateButton("", 2 + 85, 160 + 335, 75, 75, $BS_BITMAP)
_ResourceSetImageToCtrl($Button2, "izquierda", $RT_BITMAP)

$Button3 = GUICtrlCreateButton("", 2 + 165, 160 + 335, 75, 75, $BS_BITMAP)
_ResourceSetImageToCtrl($Button3, "derecha", $RT_BITMAP)

$Button4 = GUICtrlCreateButton("", 2 + 245, 160 + 335, 75, 75, $BS_BITMAP)
_ResourceSetImageToCtrl($Button4, "abajo", $RT_BITMAP)

$Button5 = GUICtrlCreateButton("", 2 + 325, 160 + 335, 75, 75, $BS_BITMAP)
_ResourceSetImageToCtrl($Button5, "alto", $RT_BITMAP)

$Button6 = GUICtrlCreateButton("", 2 + 405, 160 + 335, 75, 75, $BS_BITMAP)
_ResourceSetImageToCtrl($Button6, "ancho", $RT_BITMAP)

$Button7 = GUICtrlCreateButton("", 2 + 485, 160 + 335, 75, 75, $BS_BITMAP)
_ResourceSetImageToCtrl($Button7, "estrecho", $RT_BITMAP)

$Button8 = GUICtrlCreateButton("", 2 + 565, 160 + 335, 75, 75, $BS_BITMAP)
_ResourceSetImageToCtrl($Button8, "bajo", $RT_BITMAP)

$Button9 = GUICtrlCreateButton("", 5 + 645, 160 + 335, 75, 75, $BS_BITMAP)
_ResourceSetImageToCtrl($Button9, "medir", $RT_BITMAP)

$Button10 = GUICtrlCreateButton("", 160 + 632, 31, 30, 30, $BS_BITMAP)
_ResourceSetImageToCtrl($Button10, "mas", $RT_BITMAP)

$Button11 = GUICtrlCreateButton("", 160 + 632, 64, 30, 30, $BS_BITMAP)
_ResourceSetImageToCtrl($Button11, "menos", $RT_BITMAP)

$Button12 = GUICtrlCreateButton("", 160 + 632, 155 + 269, 30, 30, $BS_BITMAP)
_ResourceSetImageToCtrl($Button12, "mas1", $RT_BITMAP)

$Button13 = GUICtrlCreateButton("", 160 + 632, 185 + 270, 30, 30, $BS_BITMAP)
_ResourceSetImageToCtrl($Button13, "menos1", $RT_BITMAP)

$Button14 = GUICtrlCreateButton("", $anchogui4 - 74, $altogui4 - 74, 68, 68, $BS_BITMAP)
_ResourceSetImageToCtrl($Button14, "apagar", $RT_BITMAP)

$Button15 = GUICtrlCreateButton("", 160 + 632, 144, 30, 30, $BS_BITMAP)
_ResourceSetImageToCtrl($Button15, "ok", $RT_BITMAP)

$Button16 = GUICtrlCreateButton("", 160 + 632, 259, 30, 30, $BS_BITMAP)
_ResourceSetImageToCtrl($Button16, "ok2", $RT_BITMAP)

$Button17 = GUICtrlCreateButton("", 160 + 632, 289, 30, 30, $BS_BITMAP)
_ResourceSetImageToCtrl($Button17, "mas2", $RT_BITMAP)

$Button18 = GUICtrlCreateButton("", 160 + 632, 319, 30, 30, $BS_BITMAP)
_ResourceSetImageToCtrl($Button18, "menos2", $RT_BITMAP)

$Button19 = GUICtrlCreateButton("", $anchogui4 - 74, $altogui4 - 150, 68, 68, $BS_BITMAP)
_ResourceSetImageToCtrl($Button19, "camara", $RT_BITMAP)


$algoritmo = 25 ;~ valor por defecto del algoritmo. Esto es cuanto puede desviarse del color puro a buscar para encontrar un pixel
$valorinput1 = 1 / 5 ;~ valor por defecto de la toleráncia a más
$valorinput2 = -1 / 5 ;~ valor por defecto de la toleráncia a menos
$valorinput7 = 0 ;~ valor por defecto del valor de la medición
$valorinput8 = 0 ;~ ventana de entrada de datos que usaremos para decirle cuanto mide realmente un muelle (un poco como el aprendizage de la FUL 25)

GUICtrlCreateGroup("", 640, 4, 190, 486);~ con la orden creategroup queda los controles de la misma família un poquito más apañados y en orden
GUICtrlCreateLabel("TOLERANCIA SUP.", 160 + 490, 11, 170, 20);~ todo lo que ponga label son simplemente texto metido en la ventana del programa
GUICtrlSetFont(-1, 14, 400, 1, "Verdana")

GUICtrlCreateLabel("TOLERANCIA INF.", 160 + 490, 155 + 246, 170, 20)
GUICtrlSetFont(-1, 14, 400, 1, "Verdana")

GUICtrlCreateLabel("VALOR MEDIDO", 160 + 490, 120, 170, 20)
GUICtrlSetFont(-1, 14, 400, 1, "Verdana")

GUICtrlCreateLabel("VALOR REAL", 160 + 490, 263, 135, 20)
GUICtrlSetFont(-1, 14, 400, 1, "Verdana")


$input1 = GUICtrlCreateInput($valorinput1, 160 + 485, 33, 145, 60, $ES_READONLY);~tolerancia positiva
GUICtrlSetFont(-1, 30, 400, 3, "Verdana")
GUICtrlSetBkColor(-1, 0xffff00)

$input2 = GUICtrlCreateInput($valorinput2, 160 + 485, 155 + 270, 145, 60, $ES_READONLY);~tolerancia negativa
GUICtrlSetFont(-1, 30, 400, 3, "Verdana")
GUICtrlSetBkColor(-1, 0xffff00)

$input7 = GUICtrlCreateInput($valorinput7, 160 + 485, 145, 145, 60, $ES_READONLY);~donde indica el valor de la medición hecha
GUICtrlSetFont(-1, 30, 400, 3, "Verdana")
GUICtrlSetBkColor(-1, 0xaaea00)

$input8 = GUICtrlCreateInput($valorinput8, 160 + 485, 288, 145, 60, $ES_READONLY);~donde indica el valor de la medición hecha
GUICtrlSetFont(-1, 30, 400, 3, "Verdana")
GUICtrlSetBkColor(-1, 0xccffff)
GUICtrlCreateGroup("", -99, -99, 1, 1);~ con esto cerramos el grupo de controles

;~ le doy a elegir qué tonalidad buscar, si colores negro o colores grises
GUICtrlCreateGroup("COLORES", 730, 495, 75, 75)
$Radio1 = GUICtrlCreateRadio(" GRIS", 735, 74 + 440, 60, 15);~ los radio butons son botones que solo puede haber uno seleccionado a la vez
GUICtrlSetState($Radio1, $GUI_CHECKED)
$Radio2 = GUICtrlCreateRadio("GRIS 2", 735, 74 + 459, 60, 15)
$Radio3 = GUICtrlCreateRadio("NEGRO", 735, 74 + 478, 60, 15)
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group



If GUICtrlRead($Radio1) = $GUI_CHECKED Then ;~si el botón radio1 está activado, entonces la variable $color tiene un valor 0x666666
;~ 	luego a la hora de buscar píxel,en vez de decirle que color buscar l digo que lea el valor de $color
	$color = 0x666666 ;~ gris clarito
EndIf

If GUICtrlRead($Radio2) = $GUI_CHECKED Then ;~si el botón radio2 está activado, entonces la variable $color tiene un valor 0x999999
	$color = 0x999999 ;~ gris oscuro
EndIf

If GUICtrlRead($Radio3) = $GUI_CHECKED Then ;~si el botón radio3 está activado, entonces la variable $color tiene un valor 0x000000
	$color = 0x000000 ;~ negro
EndIf
;~ puedes mirar la lista de colores en hexadecimal en esta web:  http://html-color-codes.com/

;~ Aquí creamos la entrada de variación del algorítmo de medición.
;~ Lo que hace este algoritmo es aumentar las tonalidades de grises o de negros a buscar.
GUICtrlCreateGroup("ALGORITMO", 808, 495, 85, 75) ;~ empezamos un grupo para que quede bonito
$input3 = GUICtrlCreateInput($algoritmo, 813, 365 + 160, 75, 37, $ES_READONLY) ;~ creamos una entrada de datos, pero le damos atributo de solo lectura con READONLY.
GUICtrlSetFont(-1, 22, 400, 3, "Verdana") ;~ Así que no se podrá clickar con el ratón y escribir en esa ventana
GUICtrlSetBkColor(-1, 0xaeee00)
GUICtrlSetLimit($input3, 2, 2) ;~ aquí le decimos que como mucho podrá tener dos dígitos de longitud esa entrada
$upanddown = GUICtrlCreateUpdown($input3);~ con esto se crean los botones de subir y bajar. Fíjate en las lineas del programa 224 220 y 228
;~ que también son inputs pero no tienen este control. Eso es porqué este control aumenta el valor del input en 1 unidad, y las lineas 220 y 224
;~ necesitaba que aumentasen solo una décima cada vez. Por eso la toleráncia se sube y baja con los botones + y - y no como el algoritmo
;~ (realmente hay una forma de decirle que no aumente una unidad, pero daba bastante más trabajo)
GUICtrlCreateGroup("", -99, -99, 1, 1);~ cerramos el grupo y así queda dentro de un recuadro y queda bonito


;~ aquí le digo que el valor por defecto de las cantidades sea cero. podría ponerlo directamente como valor por defecto haciendo así:
;~ $input4 = GUICtrlCreateInput("0", blablabla) pero así luego puedo decirle al programa que busque un fichero de texto o de excel y si existe que coja
;~ la cantidad de una celda, y si no existe esa celda que entonces el valor de la cantidad sea cero. (Hy que pensar que la máquina hará porducciones con
;~ apagados entre jornada y jornada. Así que a la orden de apagar el sistema habrá que decirle que gusrade la cantidad fabricada en un fichero.
$cantidadafabricar = 0
$cantidadfabricada = 0
$cantidadquefalta = 0
GUICtrlCreateGroup("", @DesktopWidth - 250, 3, 255, 475)
$input4 = GUICtrlCreateInput($cantidadfabricada, @DesktopWidth - 240, 20 + 23, 225, 60, BitOR($ES_NUMBER, $ES_RIGHT))
GUICtrlSetFont(-1, 32, 400, 3, "Verdana")
GUICtrlSetBkColor(-1, 0xaeee00)
$input5 = GUICtrlCreateInput($cantidadafabricar, @DesktopWidth - 240, 270, 225, 60, BitOR($ES_NUMBER, $ES_RIGHT))
GUICtrlSetFont(-1, 32, 400, 3, "Verdana")
GUICtrlSetBkColor(-1, 0xccffcc)
$input6 = GUICtrlCreateInput($cantidadquefalta, @DesktopWidth - 240, 160, 225, 60, BitOR($ES_NUMBER, $ES_RIGHT, $ES_READONLY));~ este lo dejo que no se pueda escribir en él (es simplemnte una resta entre las que queremos y las que llevamos)
GUICtrlSetFont(-1, 32, 400, 3, "Verdana")
GUICtrlSetBkColor(-1, 0xccffff)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;~ textos. Fíjate que cuando le digo las coordenadas, a las cosas que están en la zona derecha de la pantalla, como coordenadas para ser dibujados le digo:
;~ "@DesktopWidth - 240" con esto le decimos "Lo que mida de ancho el escritorio menos 240 píxeles", esto da un poco de juego...
;~ por si alguien usa menos resolución de la que tú usas a la hora de programar (yo lo hago con las cosas que estan  a la derecha y por la zona de abajo de la pantalla
GUICtrlCreateLabel("CANTIDAD FABRICADA", @DesktopWidth - 240, 22, 280, 20)
GUICtrlSetFont(-1, 15.5, 400, 1, "Courier New");~ siempre que veas setfont es que le indicamos qué fuente de letra debe usar para ese comando
GUICtrlCreateLabel("CANTIDAD A FABRICAR", @DesktopWidth - 240, 248, 285, 20)
GUICtrlSetFont(-1, 15.5, 400, 1, "Courier New")
GUICtrlCreateLabel("CANTIDAD QUE FALTA", @DesktopWidth - 240, 138, 285, 20)
GUICtrlSetFont(-1, 15.5, 400, 1, "Courier New")

;creamos el gráfico
Global $aData[21]
Global $i
Global $gGraph = _Graph_Create(30, $altogui4 - 320, $anchogui4 - 350, 280) ;posición izquierda, posición arriba, ancho, alto
_Graph_Set_Color($gGraph, 0x000000)
_Graph_SetRange_X($gGraph, 1, 20, 20);nombre del gráfico, valor más bajo, valor más alto, número de marcas -> escala X
_Graph_SetRange_Y($gGraph, $valorinput2, $valorinput1, 10);nombre del gráfico, valor más bajo, valor más alto, número de marcas -> escala Y

Func _Randomise()
	For $i = 1 To 19
		$aData[$i] = $aData[$i + 1]
	Next
	$aData[20] = GUICtrlRead($input7)
EndFunc   ;==>_Randomise

Func _Redraw()
	GUISetState(@SW_LOCK)
	_Graph_Clear($gGraph)
	_Graph_SetGrid_X($gGraph, 5, 0x468c2f)
	_Graph_SetGrid_Y($gGraph, 10, 0x468c2f)
	_Graph_Set_Color($gGraph, 0xF9F32B)
	_Graph_Plot_Start($gGraph, 1, $gGraph[1])
	For $i = 1 To 20
		_Graph_Plot_Line($gGraph, $i, $aData[$i])
		_Graph_Plot_Point($gGraph, $i, $aData[$i])
	Next
	_Graph_Refresh($gGraph)
	GUISetState(@SW_UNLOCK)
EndFunc   ;==>_Redraw

GUISetState();~ esto dice que se mantenga la ventana abierta del programa hasta que una orden le mande lo contrario

;~ aquí le pongo valores que luego cojerá la ventana pequeñita dond e se hace la medición para ser dibujada. Como te ponía en la linea 272 es mejor ponerlo como variable y no como
;~ valor absoluto porque así se le le pueden ir sumando o restando valores y entonces es má fácil mover la ventana o decirle al programa que busque píxeles solo dentro de esas coordenadas
$posicionxguipeque = 200
$posicionyguipeque = 40
$altoguipeque = 40
$anchoguipeque = 200
$Q = -100
$QQ = -100
$posicionxguipeque1 = $posicionxguipeque
$posicionyguipeque1 = $posicionyguipeque
$altoguipeque1 = $altoguipeque
$anchoguipeque1 = $anchoguipeque


;~ aquí creamos la ventanita pequeñita, la transparente. $WS_POPUPWINDOW, $WS_EX_LAYERED + $GUI_WS_EX_PARENTDRAG, WinGetHandle(AutoItWinGetTitle())) son atributos de la ventana.
;~ si tienes ganas de jugar (que seguro que sí) prueba a borrar alguno de los atributos, como POPUPWINDOW y verás que se va la ventana a la porra
$Guipeque = GUICreate("minigui", $posicionxguipeque1, $posicionyguipeque1, $altoguipeque1, $anchoguipeque1, $WS_POPUPWINDOW, $WS_EX_LAYERED + $GUI_WS_EX_PARENTDRAG, WinGetHandle(AutoItWinGetTitle()))
WinSetOnTop($Guipeque, "minigui", 1);~con esta orden le decimos que esté siempre encima de todo la ventana pequeña. prueba a abrir el programa y a minimizarlo... siempre estará ahí la ventanita :D
GUISetBkColor(0xABCDEF);~y con esta orden y lo de abajo le decimos que la haga transparente
_WinAPI_SetLayeredWindowAttributes($Guipeque, 0xABCDEF, 255)


$cap = DllCall($avi, "int", "capCreateCaptureWindow", "str", "cap", "int", BitOR($WS_CHILD, $WS_VISIBLE), "int", 5, "int", 10, "int", 640, "int", 480, "hwnd", $Main, "int", 1)

DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_CONNECT, "int", 0, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DLG_VIDEOSOURCE, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DLG_VIDEOFORMAT, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_SCALE, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_OVERLAY, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEW, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEWRATE, "int", 1, "int", 0)

GUISetState(@SW_SHOW)

$medicion = 0

;~esta es una función que he puesto para limitar ciertas cosas, como donde se puede poner la ventana pequeña,ó el valor del input
;~aún tengo que limitarle la posición de la ventana transparente (ahora la puedes llevar todo lo que quieras hacia abajo y hacia la derecha :S
Func mantenerdentro()
	If GUICtrlRead($input3) < 1 Then ;~si el valor del algoritmo es menor que 1...
		Beep(100, 100) ;~pitar
		GUICtrlSetData($input3, 1);~ y asignarle un valor de 1 a el input3 (que es donde preguntamos el valor del algoritmo de cálculo)
	EndIf
	If GUICtrlRead($input3) > 99 Then ;~si el valor del algoritmo es mayor que 99...
		Beep(100, 100);~pitar
		GUICtrlSetData($input3, 99);~ y asignarle un valor de 99 a el input3 (que es donde preguntamos el valor del algoritmo de cálculo)
	EndIf

	If $altoguipeque + $YYY < 15 Then;~ lo mismo pero limitando la posición de la ventana pequeña en base a "posición original" + un valor que le sumamos o quitamos
		Beep(600, 100)
		$YYY = $YYY + 3
	EndIf


	If $anchoguipeque + $XXX < 75 Then
		Beep(600, 100)
		$XXX = $XXX + 3
	EndIf

	If $posicionyguipeque + $XX < 10 Then
		Beep(600, 100)
		$XX = $XX + 3
	EndIf

	If $posicionxguipeque + $YY < 35 Then
		Beep(600, 100)
		$YY = $YY + 3
	EndIf
EndFunc   ;==>mantenerdentro

;~ las hotkey son para decirle al programa "cuando se aprete este botón haz esto. ejemplo de aquí abajo: Cuando se aprete Control más arriba hacer la función llamada boton1
HotKeySet("^{UP}", "boton1")
;~ y la función botón 1 lo que hace es sumar a la posición y tamaño original de la ventanita pequeña un valor que solo afecta a uno de los 4 parámetros de ésta
;~ (o a la coordenada x, o a la coordenada y, o a la anchura o a la altura) y luego con Winmove mueve o redimensiona la ventana a los nuevos valores)
Func boton1()
	$YY = $YY - 3
	WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)
EndFunc   ;==>boton1

HotKeySet("^{LEFT}", "boton2")
Func boton2()
	$XX = $XX - 3
	WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)
EndFunc   ;==>boton2

HotKeySet("^{RIGHT}", "boton3")
Func boton3()
	$XX = $XX + 3
	WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)
EndFunc   ;==>boton3

HotKeySet("^{DOWN}", "boton4")
Func boton4()
	$YY = $YY + 3
	WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)
EndFunc   ;==>boton4

HotKeySet("!{UP}", "boton5")
Func boton5()
	$YYY = $YYY - 3
	WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)
EndFunc   ;==>boton5

HotKeySet("!{LEFT}", "boton6")
Func boton6()
	$XXX = $XXX - 3
	WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)
EndFunc   ;==>boton6

HotKeySet("!{RIGHT}", "boton7")
Func boton7()
	$XXX = $XXX + 3
	WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)
EndFunc   ;==>boton7

HotKeySet("!{DOWN}", "boton8")
Func boton8()
	$YYY = $YYY + 3
	WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)
EndFunc   ;==>boton8
;~ Con todas las funciones que has visto arriba lo que tenemos es que si apretas Control más alguna de las 4 flechas de dirección del teclado moverás la ventana
;~ transparente más rápido que con el ratón 8porque el ratón hay que pulsar cada vez y con el teclado puedes dejar pulsado)
;~ y si aprietas ALT + alguna de las 4 flechas redimensionamos la ventana también cagando hostias

;~ ahora viene el While, que es lo que hace el programa mientras está abierto
While 1
	$msg = GUIGetMsg()
	mantenerdentro();~aquí le pongo las funciones que deben trabajar mientras está la ventana activa (vaya , que no necesitan un botón que las llame, siempre trabajan)
	Select;~lo que viene debajo de un select son acciones que suceden cuando se puelsa un botón
		Case $msg = $GUI_EVENT_CLOSE ;~por ejemplo este: en caso de que la gui reciva la orden de ser cerrada (botón de cerrar)...
			Beep(100, 100);~...pitar...
			$ok = MsgBox(20, "CERRAR", "DESEA CERRAR EL PROGRAMA ?");~...avisar con una ventana emergente si se quiere cerrar de verdad...
			If $ok = 6 Then Exit;~... y si el ususraio aprieta que sí entonces salir del porgrama

;~todos estos son los botones de las flechas para redimensionar la ventanita de medición transparente. Es como lo que has visto arriba con las flechas del teclado
		Case $msg = $Button1
			$YY = $YY - 3 ;~realmente el tema de moverla y redimensionarla es simplemente decirle lee este valor, y ahora este valor será lo que medía antes mas o mneos x
			WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)
		Case $msg = $Button2
			$XX = $XX - 3
			WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)

		Case $msg = $Button3
			$XX = $XX + 3
			WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)

		Case $msg = $Button4
			$YY = $YY + 3
			WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)

		Case $msg = $Button5
			$YYY = $YYY + 3
			WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)

		Case $msg = $Button6
			$XXX = $XXX + 3
			WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)

		Case $msg = $Button7
			$XXX = $XXX - 3
			WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)

		Case $msg = $Button8
			$YYY = $YYY - 3
			WinMove("minigui", "", $posicionyguipeque + $XX, $posicionxguipeque + $YY, $anchoguipeque + $XXX, $altoguipeque + $YYY)

;~ El botón 9 es el de la medición manual. aquí hay chicha que explicar. cuando consiga la webcam buena implementaré lo que me ha recomendado el ingeniero mecánico, pero de momento
;~ lo que hace el programa es
		Case $msg = $Button9
			GUICtrlRead($input3) ;~leer el valor del input3, que era el algoritmo de cálculo
			$size = WinGetPos("minigui") ;~buscar las coordenadas actuales de la ventana transparente y su tamaño (nos devuelve una cadena de 4 valores:$size[0] coordenada x a la izquierda,
;~ 	$size[1] coordenada y arriba, $size[2]coordenada x a la derecha (con lo que tenemos el ancho de la ventana) y $size[3] coordenada y abajo (con lo que tenemos la altura de la ventana)
			$mitad = $size[3] / 2;~con esto calculamos cuanto es la mitad de la altura de la ventana de medición, porque el programa nos devuelve el pixel que buscamos más a la izquierda... Y MAS ARRIBA!
;~ por eso pregunté en el foro, porque no todos los muelles van a quedar perpendiculares perfectos
			Sleep(10);~le damos 10 milisegundos de pausa para que no se sature la CPU
			$coord1 = PixelSearch($size[0], $size[1] + $mitad, $size[0] + $size[2], $size[1] + $mitad, $color, $algoritmo * 3);~le decimos que busque un pixel del color $color, pudiendo variar $algoritmo x3...
;~ 			dentro de las coordenadas de la ventana pequeña 8pero en la mitad de la altura de esta)
			If Not @error Then ;~si nada falla, entonces...
				$medida = ($coord1[0] - $size[0]) / 10;~establecer que la variable $medida sea el valor de las coordenada x de la ventana transparente menos la coordenada x donde ha sido encontrado ese pixel
				$medida2 = $medida - $medicion
				StringFormat("%#.2f", $medida2)
				GUICtrlSetData($input7, $medida2);~nos interesa meter un valor que pueda cambiar para luego decirle al trasto que la medida buena es la distancia en pixeles menos este valor
				WinGetPos("Medidor de Muelles Beta")
				MouseMove($coord1[0], $coord1[1], 0);~movemos el ratón a ese píxel enontrado (para saber qué coño ha encontrado), para hacer una mejora habría que dibujar una recta o algo así
				_Randomise()
				_Redraw()
			Else;~...pero si algo falla...
				Beep(100, 100);~pitar y ventana de error...
				MsgBox(48, "ERROR", "NO HA SIDO POSIBLE MEDIR" & @CRLF & "" & @CRLF & "POR FAVOR, AJUSTE LA VENTANA" & @CRLF & "DE MEDICIÓN Y EL ALGORÍTMO" & @CRLF & "DE CÁLCULO Y PRUEBE OTRA VEZ", 10)
			EndIf

;~del botón 10 al 13 son para subir y bjar el valor de la toleráncia admitida
		Case $msg = $Button10
			GUICtrlRead($valorinput1)
			If GUICtrlRead($input1) < 5 Then
				$nuevovalorinput1 = $valorinput1 + 1 / 20
				GUICtrlSetData($input1, $nuevovalorinput1)
				$valorinput1 = $nuevovalorinput1

			Else
				Beep(100, 100)
			EndIf

		Case $msg = $Button11
			GUICtrlRead($valorinput1)
			If GUICtrlRead($input1) > 1 / 10 Then
				$nuevovalorinput1 = $valorinput1 - 1 / 20
				GUICtrlSetData($input1, $nuevovalorinput1)
				$valorinput1 = $nuevovalorinput1
			Else
				Beep(100, 100)
			EndIf

		Case $msg = $Button12
			GUICtrlRead($valorinput1)
			If GUICtrlRead($input2) > -5 Then
				$nuevovalorinput2 = $valorinput2 - 1 / 20
				GUICtrlSetData($input2, $nuevovalorinput2)
				$valorinput2 = $nuevovalorinput2
			Else
				Beep(100, 100)
			EndIf

		Case $msg = $Button13
			GUICtrlRead($valorinput2)
			If GUICtrlRead($input2) < -1 / 10 Then
				$nuevovalorinput2 = $valorinput2 + 1 / 20
				GUICtrlSetData($input2, $nuevovalorinput2)
				$valorinput2 = $nuevovalorinput2
			Else
				Beep(100, 100)
			EndIf
;~y finalmente el botón apagar, que trabaja un poco como el de cerrar el sistema
		Case $msg = $Button14
			Beep(100, 100)
			$ok = MsgBox(52, "APAGAR", "DESEA APAGAR EL SISTEMA ?")
			If $ok = 6 Then Shutdown(1)

		Case $msg = $Button17
			GUICtrlRead($valorinput8)
			$nuevovalorinput8 = $valorinput8 + 1 / 20
			GUICtrlSetData($input8, $nuevovalorinput8)
			$valorinput8 = $nuevovalorinput8

		Case $msg = $Button18
			GUICtrlRead($valorinput8)
			$nuevovalorinput8 = $valorinput8 - 1 / 20
			GUICtrlSetData($input8, $nuevovalorinput8)
			$valorinput8 = $nuevovalorinput8

		Case $msg = $Button19
			DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_GRAB_FRAME_NOSTOP, "int", 0, "int", 0)
			DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_FILE_SAVEDIBA, "int", 0, "str", $snapfile)

		Case $msg = $Button16
			GUICtrlRead($valorinput8)
			GUICtrlSetData($input7, $valorinput8)

		Case $msg = $Button15
			$medicion = GUICtrlRead($input7)
			Sleep(20)
			GUICtrlSetData($input7, 0)
	EndSelect
WEnd

