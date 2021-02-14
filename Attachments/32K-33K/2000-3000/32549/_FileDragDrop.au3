#include-once
#include <WinAPI.au3>
#include <Memory.au3>
; ===============================================================================================================================
; <_FileDragDrop.au3>
;
;	Function to pass a 'Drag&Drop Files' message (WM_DROPFILES) to another control/window.
;
; Functions:
;	_FileDragDrop()		; sends a WM_DROPFILES message to another control/window
;
; References:
;	Original code by Martin in Thread: 'Drag and Drop - the other way around', Post # 60
;		@ http://www.autoitscript.com/forum/topic/89808-drag-and-drop-the-other-way-around/page__st__40__p__650573#entry650573
;	'How to Implement Drag and Drop Between Your Program and Explorer - CodeProject':
;		@ http://www.codeproject.com/KB/shell/explorerdragdrop.aspx
; See also:
;	ProgAndy's COM implementation of Drag&Drop: 'Drag and Drop with Explorer'
;		@ http://www.autoitscript.com/forum/topic/90831-drag-and-drop-with-explorer/
;
; Author: Martin (original code), Ascend4nt (modifications - see function header)
; ===============================================================================================================================


; ==========================================================================================================================
; Func _FileDragDrop($hWnd,$sFiles,$iXPos=0,$iYPos=0,$sSep='|',$bUnicode=True)
;
; Function to pass a 'Drag&Drop Files' message to another window.
;
; $hWnd = Target control, or in many cases target window
; $sFiles = String of files to copy. For more than one, $sSep is used to separate them
; $iXPos = X Position in window, in client coordinates (0 [default] = left side of window). Parameter is often ignored
; $iYPos = Y Position in window, in client coordinates (0 [default] = top of window). Parameter is often ignored
; $sSep = Separator character(s) that were used to separate the passed list of file strings
; $bUnicode = If True, sends a Unicode WM_DROPFILES message, otherwise sends an ANSI message
;
; Returns:
;	Success: True, @error = 0
;	Failure: False, with @error set:
;		@error =  1 = invalid parameter(s)
;		@error = -1 = memory allocation failure
;		@error = 16 = PostMessage failure (could be the window handle is invalid, or it doesn't accept drag-drop)
;
; Authors: Martin, Ascend4nt (fixed Global memory issues, code cleanup, error handling, Unicode & x64 support)
; ==========================================================================================================================

Func _FileDragDrop($hWnd,$sFiles,$iXPos=0,$iYPos=0,$sSep='|',$bUnicode=True)
	Local Const $WM_DROPFILES=0x0233
#cs
	; DROPFILES structure: dword offset;int x,int y;BOOL fNC;BOOL fWide
	;	(offset is offset of start of file list, x,y point is location in window [client coords],
	;	  fNC = if dropped on non-client area [in which case point is in screen coords ], fWide= Unicode flag)
#ce
	Local Const $tagDROP_FILES = "dword offset;int px;int py;bool fNC;bool fWide"
;~ 	Parameter checks
	If Not IsHWnd($hWnd) Or Not IsString($sFiles) Or $sFiles='' Or $sSep='' Then Return SetError(1,0,False)
;~ 	Local vars
	Local $pDropFiles,$stDropFiles,$iExtra=0,$sType=';byte'
	Local $iStSize=DllStructGetSize(DllStructCreate($tagDROP_FILES)),$iStrLen=StringLen($sFiles)+2	; 2 for double-NULL term

	If $bUnicode Then
		$iExtra=$iStrLen	; Unicode = 2 bytes per character, so we need to add a 2nd $iStrLen to the allocation
		$bUnicode=-1
		$sType=';wchar'		; change type of data (note 'byte' is needed for ANSI/ASCII - not sure why, but it chokes otherwise)
	EndIf

;~ 	Allocate memory for the structure and strings, get a pointer to it
;~ 		0x40 = $GMEM_ZEROINIT (zero-initialize memory) 0 = $GMEM_FIXED (returns a pointer instead of a handle)
	$pDropFiles = _MemGlobalAlloc($iStSize + $iStrLen+$iExtra,0x40)
	If $pDropFiles=0 Then Return SetError(-1,0,False)

;~ 	Create the structure with strings appended
	$stDropFiles = DllStructCreate($tagDROP_FILES & $sType & " filelist[" & $iStrLen & "]", $pDropFiles)

	DllStructSetData($stDropFiles, "offset", $iStSize)	; Offset of file list

;~ 	X,Y Position, in client coords (makes a difference in some programs [Notepad++ for example - center of window is good])
	DllStructSetData($stDropFiles, "px", $iXPos)
	DllStructSetData($stDropFiles, "py", $iYPos)

	DllStructSetData($stDropFiles, "fWide", $bUnicode)	; TRUE = unicode
;~ 	DllStructSetData($stDropFiles, "fNC", 0)		; FALSE = in client area, TRUE = non-client (and x,y pos in screen coords)
	DllStructSetData($stDropFiles, "filelist", StringReplace($sFiles,$sSep,ChrW(0)))

	; Attempt to Post the Message to the window (SendMessage doesn't work here)
	If Not _WinAPI_PostMessage($hWnd, $WM_DROPFILES, $pDropFiles, 0) Then
;~ 		Failed to send message. We can free the memory in this case
		_MemGlobalFree($pDropFiles)
		Return SetError(16,0,False)
	EndIf
#cs
	; NOTE: We do *not* free the memory - this is handled by the program receiving the message (and by Windows)
	;	Technically if that program doesn't handle the message correctly, then we'll wind up with a memory leak
	;	However, since we can not be sure when/if the message was or will be received, we can't just discard the memory
	;	that will be used by Windows
;~ 	_MemGlobalFree($pDropFiles)
#ce
	Return True
EndFunc	;==> _FileDragDrop()
