#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         GreenCan

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

Logon(@UserName,True,"Connecting to \\Host\Root")


#FUNCTION# ==============================================================
Func Logon($UsrID = "",$Greyed = False, $Label = "")
	; create a User authentication window
	; Parameters : 
	;		- $UsrID: User Name
	; 		- $Greyed: if True (UserID should not be empty in this case), the User Name input will be greyed out
	; 		- $Label: Extra info in the login screen (keep sting narrow enough!)	
	; Remark: all parameters are optional
	Local $OKbtn, $msg, $logon
	
	$logon = GUICreate("User authentication", 320, 240, -1, -1, $WS_CAPTION, $WS_EX_TOPMOST )
	


	GuiCtrlCreatePic(@ScriptDir & "\authentication.jpg",0,0,322,60)
	
	GuiCtrlCreateLabel($Label, 10, 77, 300, 15)
	;GuiCtrlCreateLabel("to mount Drive " & $driveletter, 10, 97, 150, 15)
	GuiCtrlCreateLabel("User name :", 10, 137, 93, 15)
	If $Greyed = True Then
		$UsrID = GUICtrlCreateInput($UsrID, 95, 135, 190, 20, $ES_READONLY)
	Else
		$UsrID = GUICtrlCreateInput($UsrID, 95, 135, 190, 20)
	EndIf
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GuiCtrlCreateLabel("Password :", 10, 167, 93, 15)
	$Passwd = GUICtrlCreateInput("", 95, 165, 190, 20, $ES_PASSWORD) 
	$OKbtn = GUICtrlCreateButton("Ok", 130, 200, 60, 20, $BS_DEFPUSHBUTTON )

	; and the perforated Ghost !!!!
Local $_Left_pos, $_Top_pos, $_GUI_NAME
$_Left_pos = 170
$_Top_pos =  _WinAPI_GetSystemMetrics(4) ; under the title bar
$_GUI_NAME = $logon	
_GuiImageHole($_GUI_NAME, $_Left_pos, $_Top_pos, 50, 63 )
	
	GUISetState()

	$msg = 0
	While $msg <> $GUI_EVENT_CLOSE
		$msg = GUIGetMsg()
		Select
			Case $msg = $OKbtn
				$UserID = GUICtrlRead($UsrID)
				$Password = GUICtrlRead($Passwd)
				ExitLoop
			Case $msg = -3 ; escape key pressed so quit
				GUIDelete ( $logon )
				exit				
		EndSelect
	WEnd

	GUIDelete ( $logon )
	MsgBox(0,"result", "User: " & $UserID & @CR & "Password: " & $Password)
	Return
EndFunc   ;==>Logon

#FUNCTION# ==============================================================
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
_GuiImageHole($_GUI_NAME, $_Left_pos, $_Top_pos, 50, 63)
# <== End

#comments-end

#FUNCTION# ==============================================================
Func _GuiImageHole($window_handle, $pos_x, $pos_y,$Image_Width ,$Image_Height)
    Local $aClassList, $aM_Mask, $aMask
#Region picture array
Local $PictArray[139]
$PictArray[0] = '1,1,50,1'
$PictArray[1] = '1,2,50,2'
$PictArray[2] = '1,3,50,3'
$PictArray[3] = '1,4,50,4'
$PictArray[4] = '1,5,50,5'
$PictArray[5] = '1,6,26,6'
$PictArray[6] = '28,6,28,6'
$PictArray[7] = '32,6,50,6'
$PictArray[8] = '1,7,16,7'
$PictArray[9] = '18,7,18,7'
$PictArray[10] = '22,7,24,7'
$PictArray[11] = '31,7,50,7'
$PictArray[12] = '1,8,15,8'
$PictArray[13] = '32,8,50,8'
$PictArray[14] = '1,9,15,9'
$PictArray[15] = '33,9,50,9'
$PictArray[16] = '1,10,14,10'
$PictArray[17] = '34,10,50,10'
$PictArray[18] = '1,11,13,11'
$PictArray[19] = '35,11,50,11'
$PictArray[20] = '1,12,11,12'
$PictArray[21] = '36,12,50,12'
$PictArray[22] = '1,13,12,13'
$PictArray[23] = '37,13,50,13'
$PictArray[24] = '1,14,11,14'
$PictArray[25] = '37,14,50,14'
$PictArray[26] = '1,15,11,15'
$PictArray[27] = '17,15,24,15'
$PictArray[28] = '38,15,50,15'
$PictArray[29] = '1,16,11,16'
$PictArray[30] = '15,16,26,16'
$PictArray[31] = '38,16,50,16'
$PictArray[32] = '1,17,11,17'
$PictArray[33] = '14,17,26,17'
$PictArray[34] = '38,17,50,17'
$PictArray[35] = '1,18,11,18'
$PictArray[36] = '14,18,27,18'
$PictArray[37] = '38,18,50,18'
$PictArray[38] = '1,19,10,19'
$PictArray[39] = '13,19,28,19'
$PictArray[40] = '38,19,50,19'
$PictArray[41] = '1,20,10,20'
$PictArray[42] = '13,20,29,20'
$PictArray[43] = '34,20,35,20'
$PictArray[44] = '38,20,50,20'
$PictArray[45] = '1,21,10,21'
$PictArray[46] = '12,21,34,21'
$PictArray[47] = '38,21,50,21'
$PictArray[48] = '1,22,34,22'
$PictArray[49] = '38,22,50,22'
$PictArray[50] = '1,23,34,23'
$PictArray[51] = '38,23,50,23'
$PictArray[52] = '1,24,11,24'
$PictArray[53] = '13,24,15,24'
$PictArray[54] = '22,24,25,24'
$PictArray[55] = '33,24,34,24'
$PictArray[56] = '39,24,50,24'
$PictArray[57] = '1,25,11,25'
$PictArray[58] = '13,25,14,25'
$PictArray[59] = '23,25,24,25'
$PictArray[60] = '34,25,34,25'
$PictArray[61] = '39,25,50,25'
$PictArray[62] = '1,26,11,26'
$PictArray[63] = '13,26,14,26'
$PictArray[64] = '22,26,24,26'
$PictArray[65] = '34,26,34,26'
$PictArray[66] = '39,26,50,26'
$PictArray[67] = '1,27,9,27'
$PictArray[68] = '13,27,24,27'
$PictArray[69] = '26,27,35,27'
$PictArray[70] = '39,27,50,27'
$PictArray[71] = '1,28,9,28'
$PictArray[72] = '13,28,35,28'
$PictArray[73] = '39,28,50,28'
$PictArray[74] = '1,29,10,29'
$PictArray[75] = '12,29,35,29'
$PictArray[76] = '40,29,50,29'
$PictArray[77] = '1,30,10,30'
$PictArray[78] = '12,30,35,30'
$PictArray[79] = '40,30,50,30'
$PictArray[80] = '1,31,35,31'
$PictArray[81] = '39,31,50,31'
$PictArray[82] = '1,32,24,32'
$PictArray[83] = '28,32,35,32'
$PictArray[84] = '39,32,50,32'
$PictArray[85] = '1,33,20,33'
$PictArray[86] = '28,33,35,33'
$PictArray[87] = '38,33,50,33'
$PictArray[88] = '1,34,21,34'
$PictArray[89] = '30,34,34,34'
$PictArray[90] = '36,34,50,34'
$PictArray[91] = '1,35,20,35'
$PictArray[92] = '31,35,33,35'
$PictArray[93] = '36,35,50,35'
$PictArray[94] = '1,36,17,36'
$PictArray[95] = '31,36,32,36'
$PictArray[96] = '36,36,50,36'
$PictArray[97] = '1,37,12,37'
$PictArray[98] = '15,37,17,37'
$PictArray[99] = '22,37,25,37'
$PictArray[100] = '31,37,32,37'
$PictArray[101] = '36,37,50,37'
$PictArray[102] = '1,38,12,38'
$PictArray[103] = '15,38,17,38'
$PictArray[104] = '19,38,25,38'
$PictArray[105] = '35,38,50,38'
$PictArray[106] = '1,39,13,39'
$PictArray[107] = '19,39,25,39'
$PictArray[108] = '28,39,28,39'
$PictArray[109] = '35,39,50,39'
$PictArray[110] = '1,40,13,40'
$PictArray[111] = '19,40,25,40'
$PictArray[112] = '28,40,28,40'
$PictArray[113] = '35,40,50,40'
$PictArray[114] = '1,41,14,41'
$PictArray[115] = '20,41,21,41'
$PictArray[116] = '34,41,50,41'
$PictArray[117] = '1,42,14,42'
$PictArray[118] = '20,42,22,42'
$PictArray[119] = '27,42,27,42'
$PictArray[120] = '34,42,50,42'
$PictArray[121] = '1,43,14,43'
$PictArray[122] = '21,43,22,43'
$PictArray[123] = '34,43,50,43'
$PictArray[124] = '1,44,14,44'
$PictArray[125] = '36,44,50,44'
$PictArray[126] = '1,45,13,45'
$PictArray[127] = '15,45,15,45'
$PictArray[128] = '37,45,50,45'
$PictArray[129] = '1,46,12,46'
$PictArray[130] = '16,46,16,46'
$PictArray[131] = '39,46,50,46'
$PictArray[132] = '1,47,9,47'
$PictArray[133] = '42,47,50,47'
$PictArray[134] = '1,48,6,48'
$PictArray[135] = '46,48,50,48'
$PictArray[136] = '1,49,4,49'
$PictArray[137] = '49,49,50,49'
$PictArray[138] = '1,50,2,50'
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
