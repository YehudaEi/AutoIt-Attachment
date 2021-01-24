#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         A GreenCan

 Script Function:
	Create a window with my perforated image

#ce ----------------------------------------------------------------------------
#include <GuiConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <Array.au3>
#include <WinAPI.au3> 

$H_GUI = GuiCreate("Sphere", 380, 380)

$OKbtn = GUICtrlCreateButton("Ok", 160, 360, 60, 20, $BS_DEFPUSHBUTTON )


# ==> Start
Local $_Left_pos, $_Top_pos, $_GUI_NAME
$_Left_pos = 4 ; Replace with correct position
$_Top_pos =  _WinAPI_GetSystemMetrics(4) +5 ; Just below the title bar (Must #include <WinAPI.au3> if using this function!!!)
$_GUI_NAME = $H_GUI
_GuiImageHole($_GUI_NAME, $_Left_pos, $_Top_pos, 376, 358)
# <== End



GUISetState()


$msg = 0
While $msg <> $GUI_EVENT_CLOSE
	$msg = GUIGetMsg()
	Select
		Case $msg = $OKbtn
			Exit
		Case $msg = -3 ; escape key pressed so quit
			Exit				
	EndSelect
WEnd

GUIDelete ( $H_GUI )
Exit



#comments-start
	The lines below will generate the perforated image (bewteen start and end)
	Move these lines into your GUI code, usually just before GUISetState()
	Don't forget to fill in the correct coordinates for $Left_pos, $Top_pos
	and enter the GUI Window Handle in the last line

# ==> Start
Local $_Left_pos, $_Top_pos, $_GUI_NAME
$_Left_pos = 10 ; Replace with correct position
$_Top_pos =  _WinAPI_GetSystemMetrics(4) ; Just below the title bar (Must #include <WinAPI.au3> if using this function!!!)
$_GUI_NAME = 'The name of your GUI window'
_GuiImageHole($_GUI_NAME, $_Left_pos, $_Top_pos, 376, 358)
# <== End

#comments-end

#FUNCTION# ==============================================================
Func _GuiImageHole($window_handle, $pos_x, $pos_y,$Image_Width ,$Image_Height)
    Local $aClassList, $aM_Mask, $aMask
#Region picture array
Local $PictArray[37]
$PictArray[0] = '171,45,202,45'
$PictArray[1] = '202,46,202,46'
$PictArray[2] = '203,47,212,47'
$PictArray[3] = '212,48,212,48'
$PictArray[4] = '213,49,220,49'
$PictArray[5] = '220,50,220,50'
$PictArray[6] = '221,51,224,51'
$PictArray[7] = '224,52,224,52'
$PictArray[8] = '225,53,230,53'
$PictArray[9] = '230,54,230,54'
$PictArray[10] = '220,50,220,50'
$PictArray[11] = '230,54,230,54'
$PictArray[12] = '231,55,234,55'
$PictArray[13] = '234,56,234,56'
$PictArray[14] = '235,57,240,57'
$PictArray[15] = '240,58,240,58'
$PictArray[16] = '241,59,242,59'
$PictArray[17] = '242,60,242,60'
$PictArray[18] = '243,61,246,61'
$PictArray[19] = '246,62,246,62'
$PictArray[20] = '247,63,250,63'
$PictArray[21] = '250,64,250,64'
$PictArray[22] = '251,65,254,65'
$PictArray[23] = '254,66,254,66'
$PictArray[24] = '255,67,256,67'
$PictArray[25] = '256,68,256,68'
$PictArray[26] = '257,69,260,69'
$PictArray[27] = '260,70,260,70'
$PictArray[28] = '261,71,262,71'
$PictArray[29] = '262,72,262,72'
$PictArray[30] = '263,73,264,73'
$PictArray[31] = '264,74,264,74'
$PictArray[32] = '265,75,268,75'
$PictArray[33] = '268,76,270,77'
$PictArray[34] = '269,77,271,79'
$PictArray[35] = '272,79,272,80'
$PictArray[36] = '273,81,274,81'

#EndRegion picture array

	; get the size of the active window
	$size = WinGetClientSize($window_handle)
	$Window_width = $size[0]
	$Window_height = $size[1] + 40 ; include height of title bar up to 30 dots
	; First hide the window
	$aClassList = StringSplit(_WinGetClassListEx($window_handle), @LF)
	$aM_Mask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', 0, 'long', 0, 'long', 0)
	; rectangle A - left side
	$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', 0, 'long', $pos_x, 'long', $Window_height)
	DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	; rectangle B - Top
	$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0, 'long', 0, 'long', $Window_width, 'long', $pos_y)
	DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	; rectangle C - Right side
	$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', $pos_x  + $Image_Width , 'long', 0 , 'long', $Window_width + 30, 'long', $Window_height)
	DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	; rectangle D - Bottom
	$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', 0 , 'long', $pos_y + $Image_Height, 'long', $Window_width, 'long', $Window_height)
	DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	; now unhide all regions as defined  in array $PictArray
	For $i = 0 To (UBound($PictArray) - 1)
		$Block_value = StringSplit($PictArray[$i],',')
		$aMask = DllCall('gdi32.dll', 'long', 'CreateRectRgn', 'long', $pos_x + $Block_value[1] - 1 , 'long', $pos_y + $Block_value[2], 'long', $pos_x + $Block_value[3], 'long', $pos_y + $Block_value[4] -1)
		DllCall('gdi32.dll', 'long', 'CombineRgn', 'long', $aM_Mask[0], 'long', $aMask[0], 'long', $aM_Mask[0], 'int', 2)
	Next
	DllCall('user32.dll', 'long', 'SetWindowRgn', 'hwnd', $window_handle, 'long', $aM_Mask[0], 'int', 1)
	$PictArray='' ; empty array
EndFunc  ;==>_GuiImageHole
#FUNCTION# ==============================================================
Func _WinGetClassListEx($sTitle)
    Local $sClassList = WinGetClassList($sTitle)
    Local $aClassList = StringSplit($sClassList, @LF)
    Local $sRetClassList = '', $sHold_List = '|'
    Local $aiInHold, $iInHold
    For $i = 1 To UBound($aClassList) - 1
        If $aClassList[$i] = '' Then ContinueLoop
        If StringRegExp($sHold_List, '\|' & $aClassList[$i] & '~(\d+)\|') Then
            $aiInHold = StringRegExp($sHold_List, '.*\|' & $aClassList[$i] & '~(\d+)\|.*', 1)
            $iInHold = Number($aiInHold[UBound($aiInHold)-1])
            If $iInHold = 0 Then $iInHold += 1
            $aClassList[$i] &= '~' & $iInHold + 1
            $sHold_List &= $aClassList[$i] & '|'
            $sRetClassList &= $aClassList[$i] & @LF
        Else
            $aClassList[$i] &= '~1'
            $sHold_List &= $aClassList[$i] & '|'
            $sRetClassList &= $aClassList[$i] & @LF
        EndIf
    Next
    Return StringReplace(StringStripWS($sRetClassList, 3), '~', '')
EndFunc ;==>_WinGetClassListEx
#FUNCTION# ==============================================================
