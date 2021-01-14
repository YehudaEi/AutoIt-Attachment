Func _RunSystemPrivilege($file)
If IsAdmin()<>1 Then Exit 
Run(@ComSpec & " /c net start Schedule",'',@SW_HIDE,2)
If @SEC=59 Then 
   If @HOUR=23 Then 
   $time="00:00"
   Else 
   $time=@HOUR+1&":00"
   EndIf   
Else 
   $time=@HOUR&":"&@MIN+1&" "
EndIf   
While @SEC>=58 
Sleep(500)
Wend
$TimeTemp = @HOUR&":"&@MIN&":"&@SEC+3&" "
$TimeNew = @HOUR&":"&@MIN&":59"
Run(@ComSpec & " /c at "&$time&" /interactive "&""""&$file&"""",'',@SW_HIDE,2) 
Run(@ComSpec & " /c time "&$TimeNew,'',@SW_HIDE,2) 
Sleep(2000)
Run(@ComSpec & " /c time "&$TimeTemp,'',@SW_HIDE,2) 	
EndFunc	