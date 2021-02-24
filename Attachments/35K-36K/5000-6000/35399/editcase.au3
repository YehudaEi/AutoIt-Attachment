Case "Simpsons"								
		$Picsave = @ScriptDir & "\Sys\ASG-Logo.jpg"
		$source = "http://epguides.com/Simpsons/Show%20Logo.jpg"
		inetget($source, $Picsave)
		GUICtrlSetImage($Pic1, $Picsave)
		
Case "Family Guy"
		$Picsave = @ScriptDir & "\Sys\ASG-Logo.jpg"
		$source = "http://epguides.com/Familyguy/Show%20Logo.jpg"
		inetget($source, $Picsave)
		GUICtrlSetImage($Pic1, $Picsave)
			 
Case "American Dad"
		$Picsave = @ScriptDir & "\Sys\ASG-Logo.jpg"
		$source = "http://epguides.com/americandad/cast.jpg"
		inetget($source, $Picsave)
		GUICtrlSetImage($Pic1, $Picsave)

Case "Futurama"
		$Picsave = @ScriptDir & "\Sys\ASG-Logo.jpg"
		$source = "http://epguides.com/Futurama/cast.jpg"
		inetget($source, $Picsave)
		GUICtrlSetImage($Pic1, $Picsave)
Case "Supernatural"
		$Picsave = @ScriptDir & "\Sys\ASG-Logo.jpg"
		$source = "http://epguides.com/Supernatural/cast.jpg"
		inetget($source, $Picsave)
		GUICtrlSetImage($Pic1, $Picsave)


