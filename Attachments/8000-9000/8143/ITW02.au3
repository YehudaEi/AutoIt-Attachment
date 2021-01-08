#include <date.au3>
; ZIP Main.bak & Folders With Day of week
Const $sLongDayName = _DateDayOfWeek( @WDAY )
RunWait("7z.exe u -tzip E:\"& $sLongDayName & "-RxMain.zip -mx5 @t.txt")

