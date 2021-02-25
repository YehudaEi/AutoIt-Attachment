	#include <array.au3>
#Include-Once

Global $OverViewTemp[10], $OverViewImage[5], $OverViewStatus[5], $OverViewTime[5]
Global $Url, $RightNowImage, $TodayImage, $TonightImage, $TomorrowImage

Func _GetOverViewTimes()
	Global $sSource = BinaryToString(InetRead($Url))
For $i = 1 To 5
	If $i = 1 Then
		$Time1 = StringRegExp($sSource,'(?i)(?s)<span class="twc-forecast-when twc-none">(.*?)</span>',1)
	ElseIf $i = 2 Then
		$Time2 = StringRegExp($sSource,'(?i)(?s)<td class="twc-col-2 twc-forecast-when">(.*?)</td>',1)
	ElseIf $i = 3 Then
		$Time3 = StringRegExp($sSource,'(?i)(?s)<td class="twc-col-3 twc-forecast-when">(.*?)</td>',1)
	ElseIf $i = 4 Then
		$Time4 = StringRegExp($sSource,'(?i)(?s)<td class="twc-col-4 twc-forecast-when">(.*?)</td>',1)
	EndIf
Next
For $i = 1 To 4
	If $i = 1 Then
	$OverViewTime[1] = $Time1[0]
ElseIf $i = 2 Then
	$OverViewTime[2] = $Time2[0]
ElseIf $i = 3 Then
	$OverViewTime[3] = $Time3[0]
ElseIf $i = 4 Then
	$OverViewTime[4] = $Time4[0]
EndIf
Next
EndFunc

Func _GetOverViewTemperature()
Global $sSource = BinaryToString(InetRead($Url))
For $i = 1 To 5
	If $i = 1 Then
		$Temp1 = StringRegExp($sSource,'(?i)(?s)<td class="twc-col-1 twc-forecast-temperature"><strong>(.*?)&deg',1)
	ElseIf $i = 2 Then
		$Temp2 = StringRegExp($sSource,'(?i)(?s)<td class="twc-col-2 twc-forecast-temperature"><strong>(.*?)&deg',1)
	ElseIf $i = 3 Then
		$Temp3 = StringRegExp($sSource,'(?i)(?s)<td class="twc-col-3 twc-forecast-temperature"><strong>(.*?)&deg',1)
	ElseIf $i = 4 Then
		$Temp4 = StringRegExp($sSource,'(?i)(?s)<td class="twc-col-4 twc-forecast-temperature"><strong>(.*?)&deg',1)
	EndIf
Next
For $i = 1 To 4
	If $i = 1 Then
	$OverViewTemp[1] = $Temp1[0]
ElseIf $i = 2 Then
	$OverViewTemp[2] = $Temp2[0]
ElseIf $i = 3 Then
	$OverViewTemp[3] = $Temp3[0]
ElseIf $i = 4 Then
	$OverViewTemp[4] = $Temp4[0]
EndIf
Next
EndFunc

Func _GetOverViewImages()
	Global $sSource = BinaryToString(InetRead($Url))
	$Image1 = StringRegExp($sSource, "(?i)<img\ssrc=.+(http.+\.png).*column 1.*-->", 1)
	$Image2 = StringRegExp($sSource, "(?i)<img\ssrc=.+(http.+\.png).*column 2.*-->", 1)
	$Image3 = StringRegExp($sSource, "(?i)<img\ssrc=.+(http.+\.png).*column 3.*-->", 1)
	$Image4 = StringRegExp($sSource, "(?i)<img\ssrc=.+(http.+\.png).*column 4.*-->", 1)
For $i = 1 To 4
	If $i = 1 Then
	$OverViewImage[1] = $Image1[0]
ElseIf $i = 2 Then
	$OverViewImage[2] = $Image2[0]
ElseIf $i = 3 Then
	$OverViewImage[3] = $Image3[0]
ElseIf $i = 4 Then
	$OverViewImage[4] = $Image4[0]
EndIf
Next
For $i = 1 To 4
	If $i = 1 Then
		$RightNowImage = InetGet($OverViewImage[1], @ScriptDir & "\Images\Image1.png")
EndIf
	If $i = 2 Then
		$TodayImage = InetGet($OverViewImage[2], @ScriptDir & "\Images\Image2.png")
EndIf
	If $i = 3 Then
		$TonightImage = InetGet($OverViewImage[3], @ScriptDir & "\Images\Image3.png")
EndIf
	If $i = 4 Then
		$TomorrowImage = InetGet($OverViewImage[4], @ScriptDir & "\Images\Image4.png")
	EndIf
Next
EndFunc

Func _GetOverViewStatus()
	Global $sSource = BinaryToString(InetRead($Url))
	For $i = 1 To 4
	If $i = 1 Then
		$Status1 = StringRegExp($sSource,'(?i)(?s)<span class="twc-forecast-when twc-none">Right Now</span>(.*?).png"(.*?)alt="(.*?)"',1)
	ElseIf $i = 2 Then
		$Status2 = StringRegExp($sSource,'(?i)(?s)<td class="twc-col-2 twc-forecast-icon">(.*?)alt="(.*?)"',1)
	ElseIf $i = 3 Then
		$Status3 = StringRegExp($sSource,'<td class="twc-col-3 twc-forecast-icon">(.*?)alt="(.*?)"',1)
	ElseIf $i = 4 Then
		$Status4 = StringRegExp($sSource,'(?i)(?s)<td class="twc-col-4 twc-forecast-icon">(.*?)alt="(.*?)"',1)
	EndIf
Next
For $i = 1 To 4
	If $i = 1 Then
	$OverViewStatus[1] = $Status1[0]
ElseIf $i = 2 Then
	$OverViewStatus[2] = $Status2[0]
ElseIf $i = 3 Then
	$OverViewStatus[3] = $Status3[0]
ElseIf $i = 4 Then
	$OverViewStatus[4] = $Status4[0]
EndIf
Next
EndFunc
