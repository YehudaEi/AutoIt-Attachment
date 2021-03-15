#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

Global $result1s[2]=["0", "0"]
Global $result2s[4]=["1", "2", "3", "4"]
Global $result3s[4]=["0", "0", "0", "0"]
Global $result4s[6]=["0", "0", "0", "0", "0", "0"]
Global $result5s[8]=["0", "0", "0", "0", "0", "0", "0", "0"]
Global $result6s[10]=["0", "0", "0", "0", "0", _
                        "0", "0", "0", "0", "0"]
Global $result7s[2]=["0", "0"]
Global $result8s[11]=["553", "742", "554", "538", "518", "553", "471", "511", "491", "595", "596"]
Global $result9s[4]=["10000", "20000", "30000", "40000"]
Global $result10s[6]=["0", "0", "0", "0", "0", "0"]
Global $result11s[8]=["0", "0", "0", "0", "0", "0", "0", "0"]
Global $result12s[10]=["0", "0", "0", "0", "0", _
			            "0", "0", "0", "0", "0"]
Global $result13s[2]=["0", "0"]
Global $result14s[4]=["1", "2", "3", "4"]
Global $result15s[4]=["0", "0", "0", "0"]
Global $result16s[6]=["0", "11", "12", "8", "7", "0"]
Global $result17s[8]=["0", "0", "0", "0", "0", "0", "0", "0"]
Global $result18s[10]=["0", "0", "0", "0", "0", _
                        "0", "0", "0", "0", "0"]
Global $result19s[2]=["1", "2"]
Global $result20s[4]=["0", "0", "0", "0"]
Global $result21s[5]=["0", "6", "7", "1", "2"]
Global $result22s[8]=["1", "2", "3", "4", "5", "6", "7", "0"]
Global $result23s[4]=["0", "3", "2", "1"]
Global $result24s[10]=["0", "0", "0", "0", "0", _
			            "0", "0", "0", "0", "0"]
Global $result25s[2]=["0", "0"]
Global $result26s[4]=["0", "149", "9", "13"]
Global $result27s[4]=["30000", "50000", "2000", "2500"]
Global $result28s[6]=["5", "5", "5", "5", "5", "5"]
Global $result29s[8]=["1", "1", "1", "0", "0", "0", "0", "0"]
Global $result30s[10]=["1", "1", "0", "0", "0", _
                        "0", "0", "0", "0", "0"]
_Main()

Func _Main()
    Local $button1
    Local $output, $die, $msg, $results1, $results2, $results3, $results4, $results5, $results6, $results7, $results8, _ 
	$results9, $results10, $results11, $results12, $results13, $results14, $results15, $results16, $results17, $results18, _ 
	$results19, $results20, $results21, $results22, $results23, $results24, $results25, $results26, $results27, $results28, $results29, $results30
	
    GUICreate("item stats", 300, 400, -1, -1)
    $button1 = GUICtrlCreateButton("Generate", 200, 300, 50, 30)
    $output1 = GUICtrlCreateInput("", 60, 10, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Shape", 5, 12)
    $output2 = GUICtrlCreateInput("", 60, 30, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Weight", 5, 32)
    $output3 = GUICtrlCreateInput("", 60, 50, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Charlooks", 5, 52)
    $output4 = GUICtrlCreateInput("", 60, 70, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Anicount", 5, 72)
    $output5 = GUICtrlCreateInput("", 60, 90, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Source", 5, 92)
    $output6 = GUICtrlCreateInput("", 60, 110, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Reserved", 5, 112)
	$output7 = GUICtrlCreateInput("", 60, 130, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Throw", 5, 132)
    $output8 = GUICtrlCreateInput("", 60, 150, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Looks", 5, 152)
    $output9 = GUICtrlCreateInput("", 60, 170, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Duramax", 5, 172)
    $output10 = GUICtrlCreateInput("", 60, 190, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("AC", 5, 192)
    $output11 = GUICtrlCreateInput("", 60, 210, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("AC1", 5, 212)
    $output12 = GUICtrlCreateInput("", 60, 230, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Mactype", 5, 232)
	$output13 = GUICtrlCreateInput("", 60, 250, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("MAC", 5, 252)
    $output14 = GUICtrlCreateInput("", 60, 270, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("MAC2", 5, 272)
    $output15 = GUICtrlCreateInput("", 60, 290, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("DC", 5, 292)
    $output16 = GUICtrlCreateInput("", 60, 310, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("DC2", 5, 312)
    $output17 = GUICtrlCreateInput("", 200, 10, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
    GUICtrlCreateLabel("Sac", 142, 12)
    $output18 = GUICtrlCreateInput("", 200, 30, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Sac 2", 142, 32)
	$output19 = GUICtrlCreateInput("", 200, 50, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Mc type", 142, 52)
    $output20 = GUICtrlCreateInput("", 200, 70, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("MC", 142, 72)
    $output21 = GUICtrlCreateInput("", 200, 90, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("MC2", 142, 92)
    $output22 = GUICtrlCreateInput("", 200, 110, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Func Type", 142, 112)
    $output23 = GUICtrlCreateInput("", 200, 130, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Func", 142, 132)
    $output24 = GUICtrlCreateInput("", 200, 150, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Amulet", 142, 152)
	$output25 = GUICtrlCreateInput("", 200, 170, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Need", 142, 172)
    $output26 = GUICtrlCreateInput("", 200, 190, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Need Level", 142, 192)
    $output27 = GUICtrlCreateInput("", 200, 210, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Price", 142, 212)
    $output28 = GUICtrlCreateInput("", 200, 230, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Stock", 142, 232)
    $output29 = GUICtrlCreateInput("", 200, 250, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Dissapear", 142, 252)
    $output30 = GUICtrlCreateInput("", 200, 270, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlCreateLabel("Fame", 142, 272)
    $die = GUICtrlCreateLabel("", 700, 120, 700, 20, $SS_SUNKEN)
    GUICtrlSetFont($output, 8, 800, "", "Verdana")
    GUISetState()

    ; Run the GUI until the dialog is closed
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $button1
                $results1 = Random(1, 2, 1)
                GUICtrlSetData($output1, $result1s[$results1-1])

                $results2 = Random(1, 4, 1)
                GUICtrlSetData($output2, $result2s[$results2-1])

                $results3 = Random(1, 4, 1)
                GUICtrlSetData($output3, $result3s[$results3-1])

                $results4 = Random(1, 6, 1)
                GUICtrlSetData($output4, $result4s[$results4-1])

                $results5 = Random(1, 8, 1)
                GUICtrlSetData($output5, $result5s[$results5-1])

                $results6 = Random(1, 10, 1)
                GUICtrlSetData($output6, $result6s[$results6-1])

			    $results7 = Random(1, 2, 1)
                GUICtrlSetData($output7, $result7s[$results7-1])

                $results8 = Random(1, 11, 1)
                GUICtrlSetData($output8, $result8s[$results8-1])

                $results9 = Random(1, 4, 1)
                GUICtrlSetData($output9, $result9s[$results9-1])

                $results10 = Random(1, 6, 1)
                GUICtrlSetData($output10, $result10s[$results10-1])

                $results11 = Random(1, 8, 1)
                GUICtrlSetData($output11, $result11s[$results11-1])

                $results12 = Random(1, 10, 1)
                GUICtrlSetData($output12, $result12s[$results12-1])

				$results13 = Random(1, 2, 1)
                GUICtrlSetData($output13, $result13s[$results13-1])

                $results14 = Random(1, 4, 1)
                GUICtrlSetData($output14, $result14s[$results14-1])

                $results15 = Random(1, 4, 1)
                GUICtrlSetData($output15, $result15s[$results15-1])

                $results16 = Random(1, 6, 1)
                GUICtrlSetData($output16, $result16s[$results16-1])

                $results17 = Random(1, 8, 1)
                GUICtrlSetData($output17, $result17s[$results17-1])

                $results18 = Random(1, 10, 1)
                GUICtrlSetData($output18, $result18s[$results18-1])

				$results19 = Random(1, 2, 1)
                GUICtrlSetData($output19, $result19s[$results19-1])

                $results20 = Random(1, 3, 1)
                GUICtrlSetData($output20, $result20s[$results20-1])

                $results21 = Random(1, 4, 1)
                GUICtrlSetData($output21, $result21s[$results21-1])

                $results22 = Random(1, 6, 1)
                GUICtrlSetData($output22, $result22s[$results22-1])

                $results23 = Random(1, 8, 1)
                GUICtrlSetData($output23, $result23s[$results23-1])

                $results24 = Random(1, 10, 1)
                GUICtrlSetData($output24, $result24s[$results24-1])

				$results25 = Random(1, 2, 1)
                GUICtrlSetData($output25, $result25s[$results25-1])

                $results26 = Random(1, 4, 1)
                GUICtrlSetData($output26, $result26s[$results26-1])

                $results27 = Random(1, 4, 1)
                GUICtrlSetData($output27, $result27s[$results27-1])

				$results28= Random(1, 6, 1)
                GUICtrlSetData($output28, $result28s[$results28-1])

                $results29 = Random(1, 8, 1)
                GUICtrlSetData($output29, $result29s[$results29-1])

                $results30 = Random(1, 10, 1)
                GUICtrlSetData($output30, $result30s[$results30-1])


        EndSelect
        If $msg = $GUI_EVENT_CLOSE Then ExitLoop
    WEnd
EndFunc   ;==>_Main