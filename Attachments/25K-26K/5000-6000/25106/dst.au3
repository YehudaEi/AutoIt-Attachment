#include <array.au3>
#include <File.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
FileInstall("zcta5.txt", @ScriptDir & "\zcta5.txt")
Dim $data, $lat1, $lat2, $lng1, $lng2, $zip1, $zip2, $lat1cords, $lat2cords, $tot
Dim $tmp[1]
$prog = ProgressOn("Loading...", "Loading Zips....")
_FileReadToArray("zcta5.txt", $tmp)
$tot = UBound($tmp)
Dim $zips[$tot][2]
For $i = 0 To UBound($tmp) - 1
	$zips[$i][0] = StringLeft($tmp[$i], 7)
	$zips[$i][1] = StringTrimLeft($tmp[$i], 7)
	ProgressSet(Int(($i / $tot) * 100))
Next
ProgressOff()

$Form1 = GUICreate("Distance between Zip Codes", 249, 134, -1, -1, $WS_POPUP + $WS_CLIPCHILDREN)
GUISetBkColor(0x000000)
GUISetFont(10, 800, 0, "Times New Roman")
GUICtrlCreateLabel("Start", 5, 1, 73, 19)
GUICtrlSetFont(-1, 12, 800, 0, "Times New Roman")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateLabel("End", 90, 1, 65, 19)
GUICtrlSetFont(-1, 12, 800, 0, "Times New Roman")
GUICtrlSetColor(-1, 0xFFFFFF)
$zip1Input = GUICtrlCreateInput("", 4, 21, 76, 26)
GUICtrlSetFont(-1, 12, 800, 0, "Times New Roman")
$zip2Input = GUICtrlCreateInput("", 90, 21, 71, 26)
GUICtrlSetFont(-1, 12, 800, 0, "Times New Roman")
$distSubmit = GUICtrlCreateButton("Calculate", 171, 8, 73, 41, $BS_DEFPUSHBUTTON)
$miles = GUICtrlCreateLabel("", 3, 51, 239, 59, $SS_CENTER)
GUICtrlSetFont(-1, 36, 800, 0, "Times New Roman")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlCreateLabel("Miles", 206, 112, 43, 19)
GUICtrlSetFont(-1, 12, 1200, 0, "Times New Roman")
GUICtrlSetColor(-1, 0xFFFFFF)
$close = GUICtrlCreateLabel("Exit", 0, 112, 43, 19)
GUICtrlSetFont(-1, 12, 1200, 0, "Times New Roman")
GUICtrlSetColor(-1, 0xCCCC33)
$info = GUICtrlCreateLabel("", 40, 112, 169, 19, $SS_CENTER)
GUICtrlSetFont(-1, 12, 1200, 0, "Times New Roman")
GUICtrlSetColor(-1, 0xFAAFBE)
GUISetState(@SW_SHOW)

While 1
	$nMSG = GUIGetMsg()
	Switch $nMSG
		Case $GUI_EVENT_CLOSE, $close
			Exit
		Case $distSubmit
			If GUICtrlRead($zip1Input, 1) = "" Or GUICtrlRead($zip2Input, 1) = "" Then
			Else
				$zip1 = GUICtrlRead($zip1Input, 1)
				If StringLen($zip1) < 5 And StringLen($zip1) > 5 Then
				Else
					$data = _ArraySearch($zips, $zip1, 0, 0, 0, 1, 1, 0)
					If $data > 0 Then
						$lat1cords = StringRight($zips[$data][1], 20)
						$zip2 = GUICtrlRead($zip2Input, 1)
						If StringLen($zip2) < 5 And StringLen($zip2) > 5 Then
						Else
							$data = _ArraySearch($zips, $zip2, 0, 0, 0, 1, 1, 0)
							If $data > 0 Then
								$lat2cords = StringRight($zips[$data][1], 20)
								GUICtrlSetData($info, "")
								GUICtrlSetData($miles, "")
								calc($lat1cords, $lat2cords)
								ControlFocus("", "", $zip1Input)
							Else
								GUICtrlSetData($zip2Input, "")
								GUICtrlSetData($zip1Input, "")
								GUICtrlSetData($miles, "ERROR")
								GUICtrlSetData($info, "Zip 2 Not Found")
								ControlFocus("", "", $zip1Input)
							EndIf
						EndIf
					Else
						GUICtrlSetData($zip1Input, "")
						GUICtrlSetData($zip2Input, "")
						GUICtrlSetData($miles, "ERROR")
						GUICtrlSetData($info, "Zip 1 Not Found")
						ControlFocus("", "", $zip1Input)
					EndIf
				EndIf
			EndIf
	EndSwitch
WEnd

Func calc($lat1cords, $lat2cords)
	$lat1 = Number(StringLeft($lat1cords, 9))
	$lng1 = Number(StringTrimLeft($lat1cords, 9))
	$lat2 = Number(StringLeft($lat2cords, 9))
	$lng2 = Number(StringTrimLeft($lat2cords, 9))
	$earthRadius = 3956.087107103049
	$pi = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141273724587006606315588174881520920962829254091715364367892590360011330530548820466521384146951941511609433057270365759591953092186117381932611793105118548074462379962749567351885752724891227938183011949129833673362440656643086021394946395224737190702179860943702770539217176293176752384674818467669405132000568127145263560827785771342757789609173637178721468440901224953430146549585371050792279689258923542019956112129021960864034418159813629774771309960518707211349999998372978049951059731732816096318595024459455346908302642522308253344685035261931188171010003137838752886587533208381420617177669147303598253490428755468731159562863882353787593751957781857780532171226806613001927876611195909216420198
	$lat1rad = ($lat1 / 180) * $pi
	$lng1rad = ($lng1 / 180) * $pi
	$Lat2Rad = ($lat2 / 180) * $pi
	$Lng2Rad = ($lng2 / 180) * $pi
	$distance = (Sin($lat1rad) * Sin($Lat2Rad) + Cos($lat1rad) * Cos($Lat2Rad) * Cos(($lng1rad - $Lng2Rad)))
	$distance = ((ACos($distance)) * 69.09) * 180 / $pi
	GUICtrlSetData($miles, Round($distance, 2))
EndFunc   ;==>calc