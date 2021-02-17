#cs

jksmurf,

This ran at 22:30 and produced valid output.  Hpoefully it will do the same for you.  After the last several hours
I am convinced that these web pages are possessed.

I spent about three hours looking for how other people do this but cannot find anyhting that I understand.  I'm sure that the
answer is there, just over my head.

One interesting thing I found was in IE8 under TOOLS|DEVELOPER TOOLS I could examine the web page complete with current data.

Things you need to be aware of:

    1 - I write the files to a work drive.  You will probably want to change that.
    2 - I found a way to embed the date from the web page in the file name.  I used this to match the result to the web page
        for verification.
    3 - I changed most of "savetbvxhtml".  Especially the way files are written.
    4 - "proc_files" gets all files from a dir on the work drive that I mentioned.
    5 - The final result is a 2X array.  You can process it with a simple row/col nested loop.  For an example, look at how
        the array is constructed in "proc_files".

Manadar and daleholm responded to your origional post, albeit vaguely.  I am REALLY interested in thier opinion and am going
to open another thread asking why the sleep works and ieloadwait does not.

The parser is a very rudimentary post processor, lot of room for improvement.

10:55PM - ran it again, the fucker still works!!!

I am going to be unavailable starting next week for the following several months except for short periods every couple days.
If you find anything interesting or have any problems that I can help with just PM me.

I'm sure you're aware of this but you can leave blank lines in your script without putting semi-colons all over the place.

kylomas

11:04 - still works, GOOD NIGHT!

#ce

;#include <Date.au3>
#include <IE.au3>
#include <array.au3>

global $file,$files,$aTV[30][15],$aTMP,$str2,$str1,$fhnd,$savedate

_IEErrorHandlerRegister()

$oIE = _IECreate()

_IENavigate($oIE, "http://www.setanta.com/HongKong/TV-Listings/")
sleep(3000)
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl00$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl01$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl03$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl04$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl05$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl06$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$btnNextWeek','')",0)
sleep(3000)
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl00$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl01$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl02$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl03$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl04$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl05$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()
_IENavigate($oIE, "javascript:__doPostBack('ctl00$cphForm$AllCols$tvlHeader$rptDays$ctl06$btnDay','')",0)
sleep(3000)
SaveTVxBhtml()

_IEQuit($oie)

proc_files()

_arraydisplay($atv)

Func SaveTVxBhtml()
    $sHTML    = _IEbodyReadHTML($oIE)
    $savedate = stringregexp($shtml, 'class=selected><A(.+?)'', ''Tab-Date',3)
    local $fl = fileopen("C:\Users\Kristian\Desktop\Setanta\cache\TVxb-setanta.hk-" & stringright($savedate[0],6),2)
	FileChangeDir(@ScriptDir); Added by KM
    if $fl    = -1 then msgbox(0,'','Fileopen failed for file = ' & "C:\Users\Kristian\Desktop\Setanta\cache\TVxb-setanta.hk-" & StringReplace($savedate, "/", ""))
    FileWrite($fl, $sHTML)
    fileclose($fl)
EndFunc

func proc_files()

    local $i = 0

    $files = FileFindFirstFile('C:\Users\Kristian\Desktop\Setanta\cache\*.*')
    switch @error
        case -1
            msgbox(0,'','No Matching Folders / Directories')
            Exit
        case 1
            msgbox(0,'','Folder is empty')
            Exit
    endswitch

    while 1

        $file = FileFindNextFile($files)
        if @error then exitloop

        $fhnd = fileopen('C:\Users\Kristian\Desktop\Setanta\cache\' & $file)
		FileChangeDir(@ScriptDir); Added by KM
        if $fhnd = -1 then msgbox(0,'','Error opening - ' & $file)
        $str2 = stripall(fileread($fhnd))
        fileclose($fhnd)

        $str2 = StringRegExpReplace($str2,'`',' ')

        $aTV[0][$i] = stringright($file,6)

        $aTMP = stringsplit($str2,@crlf,1)

        local $row = 1

        for $j = 1 to $aTMP[0]
            if stringinstr(stringleft($aTMP[$j],5),':') > 0 then
                $aTV[$row][$i] = $aTMP[$j]
                if $atmp[$j+1] = '' then
                    $aTV[$row+1][$i] = $aTMP[$j+2]
                Else
                    $aTV[$row+1][$i] = $aTMP[$j+1]
                endif
                $row += 1
            endif
        Next

        $i += 1

    wend

endfunc

func STRIPALL($str,$debug = 0)

    local $file,$arr10,$out10 = '',$sport = '',$dte = '',$ep,$i

    $str = StringRegExpreplace($str, '(?i)(?s)<script.*?</script>', "")
    $str = StringRegExpreplace($str, '[\r\n\t]', "")
    $str = StringRegExpreplace($str, '(?i)(?s)<div', "<div>" & @crlf & "</div><div")
    $str = StringRegExpreplace($str, '(?i)(?s)<tr', "<tr>" & @crlf & "</tr><tr")
    $str = StringRegExpreplace($str, '(?i)(?s)<li', "<li>" & @crlf & "</li><li")

    if $debug then
        $file = fileopen("C:\Users\Kristian\Desktop\Setanta\cache\test10.txt", 2)
		FileChangeDir(@ScriptDir); Added by KM
        filewrite($file, $str)
        FileClose($file)
    endif

    $arr10 = stringregexp($str,'(?s)>([^<].*?)<',3)

    $str   = _ArrayToString($arr10,"`")

    return $str

EndFunc