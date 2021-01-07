#include <GUIConstants.au3>
#include <GuiListView.au3>
$Form1 = GUICreate("FeedMe", 932, 591, 28, 76)
$Group1 = GUICtrlCreateGroup("Player", 8, 8, 337, 265)
;WMPlayer.OCX.7
;VideoLAN.VLCPlugin.1
;QuickTime.QuickTime.4
$player = ObjCreate("QuickTime.QuickTime.4")
$playerob = GUICtrlCreateObj($player, 16, 24, 320, 240)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Feeds", 352, 8, 577, 265)
$list2 = GUICtrlCreateListView("#|Name|Feed", 360, 24, 561, 209, -1, BitOR($LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
$feedname = GUICtrlCreateInput("name", 360, 240, 200, 21, -1, $WS_EX_CLIENTEDGE)
$feed = GUICtrlCreateInput("url", 570, 240, 190, 21, -1, $WS_EX_CLIENTEDGE)
$addfeed = GUICtrlCreateButton("Add", 768, 240, 43, 21)
$delfeed = GUICtrlCreateButton("Del", 818, 240, 43, 21)
$getfeed = GUICtrlCreateButton("Load",868, 240, 43, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Media", 8, 280, 921, 305)
$list = GUICtrlCreateListView("#|Type|Length|Location", 16, 296, 905, 248, -1, BitOR($LVS_EX_GRIDLINES,$LVS_EX_FULLROWSELECT))
$watch = GUICtrlCreateButton("Watch", 840, 552, 81, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

load_feeds()

While 1
    $msg = GuiGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $msg = $addfeed
            add_feed()
        Case $msg = $getfeed
            get_feed()
        Case $msg = $delfeed
            del_feed()
        Case $msg = $watch
            $result = _GUICtrlListViewGetSelectedIndices($list)
            If $result >=0 Then
                $data = _GUICtrlListViewGetItemTextArray($list, $result)
                If $data[0]>0 Then
                    $player.SetAutoPlay(true);
                    $player.SetUrl($data[4])
                    sleep(20)
                    $player.Play()
                EndIf
            EndIf
        Case Else
    EndSelect
WEnd
Exit

Func load_feeds()
    $var = IniReadSectionNames("feeds.ini")
    If @error Then
        MsgBox(4096, "", "Error occured, probably no feeds.ini file.")
    Else
        _GUICtrlListViewDeleteAllItems($list2)
        For $i = 1 To $var[0]
            $sec = IniReadSection("feeds.ini", $var[$i])
            GUICtrlCreateListViewItem($i & "|" & $var[$i] & "|" & $sec[1][1], $list2)
        Next
    EndIf
EndFunc

Func get_feed()
    $box = GUICtrlRead($feed)
    If $box NOT="" Then
        $url = $box

    Else
        $url =""
    EndIf
    If $url == "" Then
        $result = _GUICtrlListViewGetSelectedIndices($list2)
        If $result >=0 Then
            $data = _GUICtrlListViewGetItemTextArray($list2, $result)
            $url = $data[3]
            GUICtrlSetData($Group3,$data[2])
        EndIf
    EndIf
    _GUICtrlListViewDeleteAllItems($list)
    GUICtrlSetData($feed,"")
    GUICtrlSetData($feedname,"")
    If $url NOT="" Then
        Inetget($url, @TempDir & "\temp.xml", 1, 0)
        $doc = ObjCreate("Msxml2.DOMDocument.3.0")
        $doc.async=false
        $doc.Load(@TempDir & "\temp.xml")
        $oXmlroot = $doc.documentElement
        $urlList = $oXmlroot.SelectNodes("/rss/channel/item/enclosure/@url")
        $lengthList = $oXmlroot.SelectNodes("/rss/channel/item/enclosure/@length")
        $typeList = $oXmlroot.SelectNodes("/rss/channel/item/enclosure/@type")
        $urls=""
        For $oXmlNode In $urlList
            $urls = $urls & $oXmlNode.text & "|"
        Next

        $lengths=""
        For $oXmlNode In $lengthList
            $lengths = $lengths & $oXmlNode.text & "|"
        Next
        $types=""
        For $oXmlNode In $typeList
            $types = $types & $oXmlNode.text & "|"
        Next
        $url_array = StringSplit($urls, "|")
        $length_array = StringSplit($lengths, "|")
        $type_array = StringSplit($types, "|")
        $cur=1

        For $item In $url_array
            If $url_array[$cur] NOT="" Then
                GUICtrlCreateListViewItem($cur & "|" & $type_array[$cur] & "|" & $length_array[$cur] & "|" & $url_array[$cur], $list);
                $cur=$cur+1
            EndIf
        Next
    EndIf
EndFunc


Func add_feed()
    $name = GUICtrlRead($feedname)
    $url = GUICtrlRead($feed)
    If $url NOT="" AND $name NOT="" Then
        $count = _GUICtrlListViewGetItemCount($list2)
        ;GUICtrlCreateListViewItem($count & "|" & $name & "|" & $url, $list2)
        IniWrite ( "feeds.ini", $name, "url", $url)
        load_feeds()
    EndIf
EndFunc

Func del_feed()
    $result = _GUICtrlListViewGetSelectedIndices($list2)
    $data = _GUICtrlListViewGetItemTextArray($list2, $result)
    $name = $data[2]
    IniDelete ( "feeds.ini", $name )
    load_feeds()
EndFunc
