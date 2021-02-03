Sleep(100000);give time to open FFXI

$fisha = 2;

$event = 0;

$bite = 0;

$failsafe=0;

$nobait = 0;

WinWaitActive(’FFXiApp’);



While $fisha > 1

AutoItSetOption(’SendKeyDelay’, 40);

Send (’1'); fishing macro

$event = 0;

$failsafe = 0;

$nobait = 0;



Do

Sleep(250);



If PixelGetColor(22,994) = 16777215 AND PixelGetColor(108,996) = 16777215 AND PixelGetColor(228,997) = 16777215 Then

AutoItSetOption(’SendKeyDelay’, 40);

Sleep(Random(3000,3200));

Send(’{ENTER}’);

Sleep(5400);

EndIf



If PixelGetColor(43,997) = 16777215 AND PixelGetColor(83,998) = 16777215 AND PixelGetColor(175,999) = 16777215 Then

Sleep(Random(5100,5400));You lost your catch. Finish and speed things up a little.

$event = 1;

EndIf



If PixelGetColor(37,1000) = 16777215 AND PixelGetColor(77,1000) = 16777215 AND PixelGetColor(180,998) = 16777215 Then

Sleep(Random(5100,5400));You didn’t catch anything. Finish and speed things up a little.

$event = 1;

EndIf



If PixelGetColor(47,1000) = 16777215 AND PixelGetColor(142,999) = 16777215 AND PixelGetColor(330,997) = 16777215 Then

$nobait = 1;You ran out of bait so let’s get ready to change it.

EndIf



If PixelGetColor(43,995) = 16777215 AND PixelGetColor(71,997) = 16777215 AND PixelGetColor(84,995) = 16777215 Then

autosort()

Sleep(Random(2100,2200));

$event = 1;You caught something so now autosort, sleep a bit, and finish the event.

EndIf





$failsafe = $failsafe+1;

If $failsafe = 175 Then

$event = 1;

EndIf



Until $event = 1



sleep(2000);



If $nobait = 1 Then

Send(’!2');change bait

EndIf



WEnd



Func autosort()

Sleep(9000);

AutoItSetOption(’SendKeyDelay’, 0235);

Send (’!i’);

Sleep(0250);

Send (’{NUMPADADD}’);

Sleep (0250);

Send (’{ENTER}’);

sleep(0350);

Send ( ‘a’ );

sleep(0350);

Send (’{ENTER}’);

sleep(0250);

Send (’{ESCAPE}’);

sleep(0250);

Send (’{ESCAPE}’);

Sleep (0250);

EndFunc