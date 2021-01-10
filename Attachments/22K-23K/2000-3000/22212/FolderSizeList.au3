#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
;#include <ProgressConstants.au3>


Global $child
Global $child_2
Global $combo

$main=GUICreate("How much MB?",300,150,200,200)
GUISetState (@SW_SHOW)   

$Label=GUICtrlCreateLabel("Folder location:",20,30)
$input=GUICtrlCreateInput("C:\",20,50,200,20)
GUICtrlSetState (-1,$GUI_FOCUS)
$location=GUICtrlCreateButton ( "...",230,50,30,20)

$proced=GUICtrlCreateButton ( "Perform!",20,90,70,20)
;$progress=GUICtrlCreateProgress (100,90,120,20,$PBS_SMOOTH)

$statuslabel = GUICtrlCreateLabel ("Ready",0,132,300,18,BitOr($SS_SIMPLE,$SS_SUNKEN))


While 1

    $msg = GUIGetMsg(1)
    Select
    Case $msg[0]=-3
         If $msg[1]=$child then
            GuiSwitch($child)
            GuiDelete()
         elseif $msg[1]=$child_2 then
            GuiSwitch($child_2)
            GuiDelete()   
         elseif $msg[1]=$main then
            GuiSwitch($main)
            GuiDelete()
            exit
         Endif
    
	
    Case $msg[0]=$location  
         $where = FileSelectFolder("Choose a folder.", "")
         GUICtrlSetData ($input,$where)
    
    
    Case $msg[0]=$proced
         FileChangeDir(GUICtrlRead($input))
         
         ; find folders >>>>>>>>>>>>>>>
         $folder_count=0
         
         $search = FileFindFirstFile("*.*") 
         If $search = -1 Then
            MsgBox(0, "Error", "No files/directories matched the search pattern")
         Exit
         EndIf
         
         $child=GUICreate("Results",500,400,-1,-1,-1,-1,$main)
         $statuslabel = GUICtrlCreateLabel ("loading files..",0,382,500,18,BitOr($SS_SIMPLE,$SS_SUNKEN))
         $mylist=GUICtrlCreateListView("File|Size     |  |  Comment",0,0, 500,380)
         GUICtrlSetBkColor (-1,0x9999FF)
         _GUICtrlListView_SetColumnWidth($mylist,0,250)
        
         
         While 1
         
                $file = FileFindNextFile($search) 
                If @error Then ExitLoop
                If (($file<>".") and ($file<>"..") and (StringInStr(FileGetAttrib($file),"D"))) then
                $folder_count=$folder_count+1
                $size_1=Dirgetsize($file)
                
               
                if($size_1>500000) then
                $size=Round($size_1/1024/1024,1)
                $item=GUICtrlCreateListViewItem($file & "|" & $size & "|MB" & "|", $mylist)
                elseif($size_1>0) then
                $size=Round($size_1/1024,2)
                $item=GUICtrlCreateListViewItem($file & "|" & $size & "|KB" & "|", $mylist)
                else
                $item=GUICtrlCreateListViewItem($file & "|" & $size_1 & "|KB" & "|empty folder!!", $mylist)
                endif
                
                
                if($size_1>200000000) then 
                GuiCtrlSetColor($item,0xFF0000)
                elseif($size_1=0) then 
                GuiCtrlSetColor($item,0x0000FF)
                endif
                
                guisetstate()
               endif
                
         WEnd
         GUICtrlSetData($statuslabel,"Done - total: " & $folder_count & " folders")
         
         FileClose($search)
    
	
    EndSelect
wend