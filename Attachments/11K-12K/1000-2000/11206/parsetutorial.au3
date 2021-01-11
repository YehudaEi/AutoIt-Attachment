$file = FileOpen("C:\Parse.txt",0)

$text = FileRead($file)
#cs
Now you have the entire contents of the text file in $text.
You can then do string manipulation on it instead of reading one line at a time.
While there is no noticible difference on small files, on larger files I have found this to be much faster.
We can create a new text stream so that we don't damage the $text so we can search multiple times
Make sure on the second time around though you use your new variable otherwise you won't get correct results since the lengths will be different.
If you know what you are looking for, say key = 3
#ce
$key = 3
$searchline = StringRight($text, StringLen($text) - StringInStr($text, chr(10) & $key & chr(9)));This cuts out everything BEFORE the portion we want. It looks for New Line + key + tab so that it will only find the one key
$searchline = StringLeft($searchline, StringInStr($searchline, Chr(10))-2);This cuts out everything AFTER our line. The -2 removes the final New Line character so it's a clean entry.
MsgBox(0,"Result","The line you were searching for is: " & $searchline)