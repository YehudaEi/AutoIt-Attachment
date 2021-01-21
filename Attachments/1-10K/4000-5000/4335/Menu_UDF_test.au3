#include <menu.au3>
$r = "red"
$b = "blue"
$g = "green"
$all = $r & "," & $b & "," & $g
$x = _menu (1, "This bit is testing ""_menu()""" & @CRLF & " using  _menu (1,""choose a colour"", ""red"", ""blue"", ""green"")"  & @CRLF & @CRLF & "choose a colour", "red", "blue", "green")
MsgBox(0, "", $x[1])
$x = _menu (1, "This bit is testing ""_menu()""" & @CRLF & "using  _menu (1,""choose a colour"", $r, $b ,$g)"  & @CRLF &  @CRLF & "choose a colour", $r, $b ,$g)
MsgBox(0, "", $x[1])
$x = _menu (1, "This bit is testing ""_menu()""" & @CRLF & "using  _menu (1,""choose a colour"", $all)" & @CRLF & "where $all = $r & "","" & $b & "","" & $g"  & @CRLF & @CRLF & "choose a colour", $all)
MsgBox(0, "", $x[1])
$x = _menu (3, "Choose 3 reasons why I use AutoIT", _
							"It makes my job easy", _ 
							"It saves me loads of time", _ 
							"I learn more about windows systems", _ 
							"because the help file makes learning easy", _ 
							"The forums are great - so I can get most problems solved quickly", _ 
							"The desktop wallpaper is quite good")
$msg = ""
For $y = 1 To $x[0]
    $msg = $msg & @CRLF & $x[$y]
Next
MsgBox(0, "", "You chose " & $x[0] & " replies" & @CRLF & $msg)
$x = _MsgBox ("""_msgbox"" test 1", "_msgbox can create a message box with normal sized buttons", "Yes", "No", "Help")
MsgBox(0, "", "You clicked on   - " & $x)
$x = _MsgBox ("test 2", "_msgbox can create a message box with larger buttons", "Slightly larger button", "More options please")
MsgBox(0, "", "You clicked on   - " & $x)
$x = _MsgBox ("test 3", "_msgbox can create a message box also gives you the option to have up" & @CRLF & "to four buttons because sometimes you want to have more options", "Yes", "No", "Cancel", "More info")
MsgBox(0, "", "You clicked on   - " & $x)
$x = _MsgBox ("test 4", "End of test")