;Days until wedding
;MsgBox(0, "Wedding", "Days until Wedding" & @CRLF & @CRLF & $BigDay)
HotKeySet("!{ESC}", "Terminate")
#include <GuiConstants.au3>
#NoTrayIcon
Opt("WinTitleMatchMode", 4)
$Totaly = @DesktopHeight
$Totalx = @DesktopWidth
$Tray = WinGetClientSize("classname=Shell_TrayWnd", "")
$y = $Totaly - $Tray[1] - 100
$x = $Totalx - 240

$hidden = GUICreate("hidden", 10, 10, -1, -1)
$GUI = GUICreate("Day's Remaining  /  Alt+ESC to cancel", 240, 70, $x, $y, $WS_CAPTION, $WS_EX_TOPMOST, $hidden)
$Header = GUICtrlCreateLabel("Days until Guy && Girl get Married", 10, 15, 180, 20)
$TimeRemaining = GUICtrlCreateLabel("Hours Remaining", 10, 45, 180, 20)
$Daybox = GUICtrlCreateLabel("", 185, 10, 40, 20, $SS_SUNKEN + $SS_CENTER)
$HourBox = GUICtrlCreateLabel("", 185, 40, 40, 20, $SS_SUNKEN + $SS_CENTER)
GUICtrlSetFont($DayBox, 10, 500)

GuiSetState()
$i = 1
While 1
$year = 2006 - @YEAR
if $year = 1 then $Count = 365 - @YDAY + 126
if $Year = 0 then $Count = 126 - @YDAY
$TimeHour = ($Count - 1) * (24 - @HOUR) + 14
GUICtrlSetData($Daybox, $Count)
GUICtrlSetData($HourBox, $TimeHour)

if $i = 1 then $DayMark = $Count
if $DayMark <> $Count then 
	$i = 1
	$DayMark = $Count
EndIf

$weekday = @WDay
if $weekday = 2 and $i = 1 then
Select
Case $Count >= 364
	MsgBox(262176, "Reminder", "Did you call the Caterer?") ;364 Days prior
Case $Count < 364 and $Count >= 350
	MsgBox(262176, "Reminder", "Did you agree on the menu?") ;357 Days prior
Case $Count < 357 and $Count >= 343
	MsgBox(262176, "Reminder", "Don't forget the open bar") ;350 Days prior
Case $Count < 350 and $Count >= 336
	MsgBox(262176, "Reminder", "Did you order the Invitations?") ;343 Days prior
Case $Count < 343 and $Count >= 329
	MsgBox(262176, "Reminder", "Are you going to use a Calligrapher?") ;336 Days prior
Case $Count < 336 and $Count >= 322
	MsgBox(262176, "Reminder", "Make sure the Invitations are properly worded") ;329 Days prior
Case $Count < 329 and $Count >= 315
	MsgBox(262176, "Reminder", "Be sure to buy a Letter sponge to close the Invitations.") ;322 Days prior
Case $Count < 322 and $Count >= 308
	MsgBox(262176, "Reminder", "Have you decieded on the Postage Stamp for the Invitations?" & @CRLF & "            www.Stamps.com") ;315 Days prior
Case $Count < 315 and $Count >= 301
	MsgBox(262176, "Reminder", "Have you met with the Florist?") ;308 Days prior
Case $Count < 308 and $Count >= 294
	MsgBox(262176, "Reminder", "Have you picked your flower arrangements?") ;301 Days prior
Case $Count < 301 and $Count >= 287
	MsgBox(262176, "Reminder", "Have you decieded on the Bouquet") ;294 Days prior
Case $Count < 294 and $Count >= 280
	MsgBox(262176, "Reminder", "Did you Rent a runner for the Church?") ;287 Days prior
Case $Count < 287 and $Count >= 273
	MsgBox(262176, "Reminder", "Have you met with the Bakery?") ;280 Days prior
Case $Count < 280 and $Count >= 266
	MsgBox(262176, "Reminder", "Did you decied on the Cake design?") ;273 Days prior
Case $Count < 273 and $Count >= 259
	MsgBox(262176, "Reminder", "Are you going to have Cookies?") ;266 Days prior
Case $Count < 266 and $Count >= 252
	MsgBox(262176, "Reminder", "Have you booked the Limo?") ;259 Days prior
Case $Count < 259 and $Count >= 245
	MsgBox(262176, "Reminder", "Make sure the limo goes to the right locations") ;252 Days prior
Case $Count < 252 and $Count >= 238
	MsgBox(262176, "Reminder", "Have you decieded on a Limo car, Van, Bus, or SUV") ;245 Days prior
Case $Count < 245 and $Count >= 231
	MsgBox(262176, "Reminder", "Make sure you give the Limo Driver directions BEFORE the wedding day.") ;238 Days prior
Case $Count < 238 and $Count >= 224
	MsgBox(262176, "Reminder", "Have you planned the honeymoon?") ;231 Days prior
Case $Count < 231 and $Count >= 217
	MsgBox(262176, "Reminder", "have you confirmed plans with the Reception Hall?") ;224 Days prior
Case $Count < 224 and $Count >= 210
	MsgBox(262176, "Reminder", "Do you have the day fully scheduled?") ;217 Days prior
Case $Count < 217 and $Count >= 203
	MsgBox(262176, "Reminder", "Have you picked the Photo locations?") ;210 Days prior
Case $Count < 210 and $Count >= 196
	MsgBox(262176, "Reminder", "Have you scheduled the Quartet?") ;203 Days prior
Case $Count < 203 and $Count >= 189
	MsgBox(262176, "Reminder", "Have you picked out the Wedding Rings?") ;196 Days prior
Case $Count < 196 and $Count >= 182
	MsgBox(262176, "Reminder", "Have you finished the favors?") ;189 Days prior
Case $Count < 189 and $Count >= 175
	MsgBox(262176, "Reminder", "Don't forget the Jordan Almond") ;182 Days prior
Case $Count < 182 and $Count >= 168
	MsgBox(262176, "Reminder", "Have you picked the wedding party?") ;175 Days prior
Case $Count < 175 and $Count >= 161
	MsgBox(262176, "Reminder", "Have you picked the Tuxedo shop?") ;168 Days prior
Case $Count < 168 and $Count >= 154
	MsgBox(262176, "Reminder", "Vest or Cumberbun?") ;161 Days prior
Case $Count < 161 and $Count >= 147
	MsgBox(262176, "Reminder", "Tux with Bowtie or Tie") ;154 Days prior
Case $Count < 154 and $Count >= 140
	MsgBox(262176, "Reminder", "Have you decieded on the Seating chart for reception?") ;147 Days prior
Case $Count < 147 and $Count >= 133
	MsgBox(262176, "Reminder", "Have you Registered for Wedding gifts?") ;140 Days prior
Case $Count < 140 and $Count >= 126
	MsgBox(262176, "Reminder", "Have you picked your wedding colors") ;133 Days prior
Case $Count < 133 and $Count >= 119
	MsgBox(262176, "Reminder", "Have you decieded on the Bridesmaid Dresses?") ;126 Days prior
Case $Count < 126 and $Count >= 112
	MsgBox(262176, "Reminder", "Did you book the DJ?") ;119 Days prior
Case $Count < 119 and $Count >= 105
	MsgBox(262176, "Reminder", "Have you picked the First Dance song?") ;112 Days prior
Case $Count < 112 and $Count >= 98
	MsgBox(262176, "Reminder", "Have you picked the Father Daughter song?") ;105 Days prior
Case $Count < 105 and $Count >= 91
	MsgBox(262176, "Reminder", "Has the Wedding dress been purchased?") ;98 Days prior
Case $Count < 98 and $Count >= 84
	MsgBox(262176, "Reminder", "Have you purchased the Unity candle?") ;91 Days prior
Case $Count < 91 and $Count >= 77
	MsgBox(262176, "Reminder", "Have you gone through Pre-Kana") ;84 Days prior
Case $Count < 84 and $Count >= 70
	MsgBox(262176, "Reminder", "Have you confirmed with the Photographer?") ;77 Days prior
Case $Count < 77 and $Count >= 70
	MsgBox(262176, "Reminder", "Have you Met with the Priest?") ;70 Days prior
Case $Count < 70 and $Count >= 56
	MsgBox(262176, "Reminder", "Have you reserved a location for the Rehearsal Dinner") ;63 Days prior
Case $Count < 63 and $Count >= 49
	MsgBox(262176, "Reminder", "Have you reserved hotel accommodations for out of town guests?") ;56 Days prior
Case $Count < 56 and $Count >= 42
	MsgBox(262176, "Reminder", "Have you Chosen a Gift for your Bride?") ;49 Days prior
Case $Count < 49 and $Count >= 35
	MsgBox(262176, "Reminder", "Don't forget Handkerchiefs for the ladies.") ;42 Days prior
Case $Count < 42 and $Count >= 31
	MsgBox(262176, "Reminder", "Don't forget a Guest book") ;35 Days prior
Case $Count < 35 and $Count > 29
	MsgBox(262176, "Reminder", "Have fun at your Bachelor party!!!") ;31 Days prior
EndSelect
EndIf

if $i = 1 then
Select
Case $Count = 29
	MsgBox(262176, "Reminder", "Have your Groomsmen had their Final fitting for their Tux?") ;29 Days prior
Case $Count = 28
	MsgBox(262176, "Reminder", "Don't forget Dance Lessons") ;28 Days prior
Case $Count = 27
	MsgBox(262176, "Reminder", "Have you finished the Church Pamphlet?") ;27 Days prior
Case $Count = 26
	MsgBox(262176, "Reminder", "Have you contacted the newspaper for the Wedding Anouncement?") ;26 Days prior
Case $Count = 25
	MsgBox(262176, "Reminder", "Have you checked your Wedding Registry to see what's been bought?") ;25 Days prior
Case $Count = 24
	MsgBox(262176, "Reminder", "Don't forget to choose your Church music.") ;24 Days prior
Case $Count = 23
	MsgBox(262176, "Reminder", "Did you write your own Vows?") ;23 Days prior
Case $Count = 22
	MsgBox(262176, "Reminder", "Has the Wedding Dress had it's final Altering done") ;22 Days prior
Case $Count = 21
	MsgBox(262176, "Reminder", "Don't forget a Lockable box for the Envelopes") ;21 Days prior
Case $Count = 20
	MsgBox(262176, "Reminder", "Have you decieded how you are getting home after the Wedding?") ;20 Days prior
Case $Count = 19
	MsgBox(262176, "Reminder", "Did you choose your Wedding Speakers") ;19 Days prior
Case $Count = 18
	MsgBox(262176, "Reminder", "Are you going to have a singer at the church or just an organist?") ;18 Days prior
Case $Count = 17
	MsgBox(262176, "Reminder", "Did you choose the Readings for the Church Speakers") ;17 Days prior
Case $Count = 16
	MsgBox(262176, "Reminder", "Don't forget Kleenex") ;16 Days prior
Case $Count = 15
	MsgBox(262176, "Reminder", "Are you going to throw birdseed or blow bubbles?") ;15 Days prior
Case $Count = 14
	MsgBox(262176, "Reminder", "Pack for your Honeymoon at least a week in advance.") ;14 Days prior
Case $Count = 13
	MsgBox(262176, "Reminder", "Have you purchased the Groomsmen / Bridesmaids gifts?") ;13 Days prior
Case $Count = 12
	MsgBox(262176, "Reminder", "Don't forget your own personal camera") ;12 Days prior
Case $Count = 11
	MsgBox(262176, "Reminder", "Print directions from the Church to Reception?") ;11 Days prior
Case $Count = 10
	MsgBox(262176, "Reminder", "Bring an Extra Undershirt just in case.") ;10 Days prior
Case $Count = 9
	MsgBox(262176, "Reminder", "Bring Deodorant") ;9 Days prior
Case $Count = 8
	MsgBox(262176, "Reminder", "Call the Caterer, Photographer, Baker, Florist, Limo, DJ, Quartet, Church, Priest, and Reception Hall to confirm dates and times.") ;8 Days prior
Case $Count = 7
	MsgBox(262176, "Reminder", "Don't forget to get a haircut a week before the Wedding.") ;7 Days prior
Case $Count = 6
	MsgBox(262176, "Reminder", "Purchase something fun for the wedding night.") ;6 Days prior
Case $Count = 5
	MsgBox(262176, "Reminder", "Make sure you have good dress socks for the Tux") ;5 Days prior
Case $Count = 4
	MsgBox(262176, "Reminder", "Don't forget Tip money for the DJ and Quartet") ;4 Days prior
Case $Count = 3
	MsgBox(262176, "Reminder", "Pick up your Tux") ;3 Days prior
Case $Count = 2
	MsgBox(262176, "Reminder", "Decide where the Breakfast with the Groomsmen will be") ;2 days prior
Case $Count = 1
	MsgBox(262176, "Reminder", "RELAX!!!") ;1 day prior
Case $Count == 0
	MsgBox(262176, "Hmmm", "Are you going to be a daddy soon?")
EndSelect
EndIf

if $Count <= 0 then
	$Year = 2007 - @YEAR
	if $year = 2 then $BBCount = 365 + 365 - @YDAY + 40
	if $year = 1 then $BBCount = 365 - @YDAY + 40
	if $year = 0 then $BBCount = 40 - @YDAY
	$TimeHour = ($BBCount - 1) * (24 - @HOUR) + 14
	GUICtrlSetData($Header, " Days until Guy && Girl's First Born")
	guictrlsetData($TimeRemaining, "Hours until the First Born")
	GUICtrlSetData($DayBox, $BBCount)
	GUICtrlSetData($HourBox, $TimeHour)
EndIf
sleep(5000)
$i = $i + 1

WEnd

Func Terminate()
	if $Count > 0 then 
		MsgBox(262192, "Cancel?", "Oh my GOD!!!  you want to cancel the Wedding!!!" & @CRLF & @CRLF & "I thought you loved her...")
	else
		MsgBox(262192, "What???", "I thought you were Catholic!")
	EndIf
    Exit 0
EndFunc