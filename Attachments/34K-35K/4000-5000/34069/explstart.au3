;www.cnc-cutting.eu

Dim $wait
Dim $wait_start
Dim $1_display_x
Dim $1_display_y
Dim $2_display_x
Dim $2_display_y
Dim $3_display_x
Dim $3_display_y
Dim $4_display_x
Dim $4_display_y

$wait_start = 4000		;wait systemstart stabil
$wait = 500				;wait window stabil open
$1_display_x = 1920		;display x resolution
$1_display_y = 1200		;display y resolution
$2_display_x = 1600
$2_display_y = 1200
$3_display_x = 1680
$3_display_y = 1050
$4_display_x = 1680
$4_display_y = 1050

Sleep($wait_start)
Run(@WindowsDir & "\explorer.exe", "")		;start explorer
Sleep($wait*6)								;wait
$size = WinGetPos("[active]")				;active window position
WinMove("[active]", "", 0, 0, $1_display_x/2, $1_display_y)	;move activ window

Run(@WindowsDir & "\explorer.exe", "")
Sleep($wait*4)
$size = WinGetPos("[active]")
WinMove("[active]", "", $1_display_x/2, 0, $1_display_x/2, $1_display_y)

Run(@WindowsDir & "\explorer.exe", "")
Sleep($wait*2)
$size = WinGetPos("[active]")
WinMove("[active]", "", $1_display_x+1, 0, $2_display_x/2, $2_display_y)

Run(@WindowsDir & "\explorer.exe", "")
Sleep($wait)
$size = WinGetPos("[active]")
WinMove("[active]", "", $1_display_x+1+($2_display_x/2), 0, $2_display_x/2, $2_display_y)

Run(@WindowsDir & "\explorer.exe", "")
Sleep($wait)
$size = WinGetPos("[active]")
WinMove("[active]", "", $1_display_x+1+$2_display_x, 0, $3_display_x/2, $3_display_y)

Run(@WindowsDir & "\explorer.exe", "")
Sleep($wait)
$size = WinGetPos("[active]")
WinMove("[active]", "", $1_display_x+1+$2_display_x+($3_display_x/2), 0, $3_display_x/2, $3_display_y)

Run(@WindowsDir & "\explorer.exe", "")
Sleep($wait)
$size = WinGetPos("[active]")
WinMove("[active]", "", $1_display_x+1+$2_display_x+$3_display_x, 0, $4_display_x/2, $4_display_y)

Run(@WindowsDir & "\explorer.exe", "")
Sleep($wait)
$size = WinGetPos("[active]")
WinMove("[active]", "", $1_display_x+1+$2_display_x+$3_display_x+($3_display_x/2), 0, $4_display_x/2, $4_display_y)

