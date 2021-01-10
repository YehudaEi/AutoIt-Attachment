Func ok($title, $message, $time) 
	MsgBox(0,$title,$message,$time)
EndFunc

Func ok_cancel($title,$message,$time)
		MsgBox(1,$title,$message,$time)
	EndFunc
	
Func abort_retry_ignore($title,$message,$time)
		MsgBox(2,$title,$message,$time)
	EndFunc
	
Func yes_no_cancel($title,$message,$time)
			MsgBox(3,$title,$message,$time)
	EndFunc
		
		Func yes_no($title,$message,$time)
				MsgBox(4,$title,$message,$time)
			EndFunc
			
			Func retry_cancel($title,$message,$time)
					MsgBox(5,$title,$message,$time)
				EndFunc
				