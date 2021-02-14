				Local $AC1,$filename="OrbitSetup.exe"
				ProgressOn("Progress Meter", "Increments every second", "0 percent")
;~ 				$AC1 = RunWait("innounp.exe -x "&$filename&' -d"App\"');,'',@SW_HIDE)
				For $i = 10 to 100 step 10
;~                  While $AC1
                    Sleep ( 1000 )
;~                     ProgressSet("100",$AC1)
;~                     ProgressSet( $AC1,$i& " percent")
				$AC1 = RunWait("innounp.exe -x "&$filename&' -d"App\"');,'',@SW_HIDE)
					ProgressSet(Round(($i*100)/$AC1),"")
					Next
;~                     $AC1 = ProcessExists($AC1)
					ProgressSet(100,"")
;~                 Wend