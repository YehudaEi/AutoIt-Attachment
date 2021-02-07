#include <Array.au3>

; A good place to start in the MSDN Documentation
;http://msdn.microsoft.com/en-us/library/aa373214(v=VS.85).aspx


;Open the DLL manually so Query handles can persist
Local $hPDH = DllOpen("pdh.dll")
if $hPDH = -1 Then
	MsgBox(16,"Error","Opening pdh.dll failed")
	Exit
EndIf

Local $sCounterPath="\Process(*)\% Processor Time"
Local $hPDHQueryHandle

;~ ******************************************************************
;~ http://msdn.microsoft.com/en-us/library/aa372652(v=VS.85).aspx
;~ 		PDH_STATUS PdhOpenQuery(
;~ 		  __in   LPCTSTR szDataSource,
;~ 		  __in   DWORD_PTR dwUserData,
;~ 		  __out  PDH_HQUERY *phQuery
;~ 		);
;~ ******************************************************************

; PdhOpenQuery: Create a PDH Query Handle
Local $aRet=DllCall($hPDH,"long","PdhOpenQueryW","ptr",0,"dword*",0,"ptr*",$hPDHQueryHandle)
; Error?
If @error Or Not IsArray($aRet) Or $aRet[0] Then Exit

; DEBUG: Return info
ConsoleWrite("1st PDH Call succeeded, return:" &$aRet[0]&",param1:"&$aRet[1]&",param2:"&$aRet[2]&",handle:" & $aRet[3] & @CRLF)
; Copy handle
$hPDHQueryHandle=$aRet[3]

Local $iBufSize

;~ ******************************************************************
;~ http://msdn.microsoft.com/en-us/library/aa372606(v=VS.85).aspx
;~ PDH_STATUS PdhExpandWildCardPath(
;~   __in     LPCTSTR szDataSource,
;~   __in     LPCTSTR szWildCardPath,
;~   __out    LPTSTR mszExpandedPathList,
;~   __inout  LPDWORD pcchPathListLength,
;~   __in     DWORD dwFlags
;~ );
;~ ******************************************************************

; 1st call - get buffer size
$aRet=DllCall($hPDH,"long","PdhExpandWildCardPathW","ptr",ChrW(0),"wstr",$sCounterPath,"ptr",ChrW(0),"dword*",$iBufSize,"dword",0)

; Return should be PDH_MORE_DATA (0x800007D2)
If @error Or Not IsArray($aRet) Or $aRet[0]<>0x800007D2 Then
    ; Close PDH Query Handle
    DllCall($hPDH,"long","PdhCloseQuery","ptr",$hPDHQueryHandle)
    Exit
EndIf

; Get required buffer size
$iBufSize=$aRet[4]
; DEBUG
ConsoleWrite("BufSize required:" & $iBufSize & @CRLF)
; Setup a buffer (ubytes because pulling a multi-NULL-terminated Unicode string out is impossible with wchars)
Local $stExpandedPathList=DllStructCreate("ubyte["&($iBufSize*2)&']')
; 2nd call - fill buffer with expanded PDH Paths
$aRet=DllCall($hPDH,"long","PdhExpandWildCardPathW","ptr",ChrW(0),"wstr",$sCounterPath, _
    "ptr",DllStructGetPtr($stExpandedPathList),"dword*",$iBufSize,"dword",0)
; Error?
If @error Or Not IsArray($aRet) Or $aRet[0] Then
    ; Close PDH Query Handle
    DllCall($hPDH,"long","PdhCloseQuery","ptr",$hPDHQueryHandle)
    Exit
EndIf
; DEBUG INFO
ConsoleWrite("Call successful, Bufsize=" & $aRet[4]&", Expanded Path List w\ len:" & _
    StringLen(BinaryToString(DllStructGetData($stExpandedPathList,1),2))&@CRLF&"Contents:" & @CRLF)

; GET UNICODE STRING, SPLIT BY NULL-TERMS INTO ARRAY
Local $ahPDHCounterHandle,$aPDHProcessList=StringSplit(BinaryToString(DllStructGetData($stExpandedPathList,1),2),ChrW(0),1)
; Now to go through and add them one by one to the PDH Query Handle
If IsArray($aPDHProcessList) Then
    ; Last split is probably at the double-NULL term, so remove the last element and decrease count
    If $aPDHProcessList[$aPDHProcessList[0]]=="" Then
        ReDim $aPDHProcessList[$aPDHProcessList[0]]
        $aPDHProcessList[0]-=1
		; Create counter handle array. Set index to count of ProcessList
		Dim $hPDHCounterHandle[$aPDHProcessList[0] + 1]
		$hPDHCounterHandle[0] = $aPDHProcessList[0]
    EndIf
    ; DEBUG: Show PDH Process List (as split)
;~     _ArrayDisplay($aPDHProcessList,"PDH Process List")
    ; Set size of Counter Handles to the same size as the PDH Process List
    Dim $ahPDHCounterHandle[$aPDHProcessList[0]+1]
    ; Equalize Bottom element (count)
    $ahPDHCounterHandle[0]=$aPDHProcessList[0]
    ; Iterate through array
    For $i=1 to $aPDHProcessList[0]
        ; DEBUG
;~         ConsoleWrite("Handle (" &$hPDHQueryHandle&") Adding:" &$aPDHProcessList[$i] & @CRLF)

        ; DEBUG CALL - Validate Path. Works! Argh
        ;$aRet=DllCall($hPDH,"long","PdhValidatePathW","wstr",$aPDHProcessList[$i])
        ;If IsArray($aRet) And Not $aRet[0] Then ConsoleWrite("Path validated!" & @CRLF)

;~ ******************************************************************
;~ http://msdn.microsoft.com/en-us/library/aa372204(v=VS.85).aspx
;~ PDH_STATUS PdhAddCounter(
;~   __in   PDH_HQUERY hQuery,
;~   __in   LPCTSTR szFullCounterPath,
;~   __in   DWORD_PTR dwUserData,
;~   __out  PDH_HCOUNTER *phCounter
;~ );
;~ ******************************************************************

        $aRet=DllCall($hPDH,"long","PdhAddCounterW","ptr",$hPDHQueryHandle,"wstr",$aPDHProcessList[$i],"dword*",$i,"ptr*",$ahPDHCounterHandle[$i])
        If @error Or Not IsArray($aRet) Or $aRet[0] Then
            ; Return code C0000BBC = INVALID HANDLE. WHY?!?!

            ; Technically this could throw an error since $aRet might not be an array.. but here for DEBUG info
            ConsoleWrite("Ret:" & Hex($aRet[0]) & @CRLF)
            ; Close PDH Query Handle
            $aRet=DllCall($hPDH,"long","PdhCloseQuery","ptr",$hPDHQueryHandle)
            ; Technically not a good idea since $aRet might not be an array.. but here for DEBUG info
            ConsoleWrite("Ret:" & Hex($aRet[0]) & @CRLF)
            Exit
        EndIf

		$hPDHCounterHandle[$i] = $aRet[4]
		ConsoleWrite("Counter Added. Result: " & $aRet[0] & " QueryHandle: " & $aRet[1] & " CounterName: " & $aRet[2] & " Index: " & $aRet[3] & " CounterHandle: " & $aRet[4] & @CRLF)
		;_ArrayDisplay($aRet)
    Next
EndIf

;~ ******************************************************************
;~ http://msdn.microsoft.com/en-us/library/aa372563(v=VS.85).aspx
;~ PDH_STATUS PdhCollectQueryData(
;~   __inout  PDH_HQUERY hQuery
;~ );
;~ ******************************************************************

; Added multiple calls just in case more than 1 sample is needed...
For $i = 1 to 5
	; I beleive this tells PDH to have the Query collect a sample for all Counters that have been added
	$aRet = DllCall($hPDH,"long", "PdhCollectQueryData","ptr", $hPDHQueryHandle)
	If @error Then
		MsgBox(16,"Error","Error while attempting to collect a sample")
		Exit
	EndIf
	;DEBUG - Confirm result from call
	;_ArrayDisplay($aRet,"Return from CollectQuery Call",10)
	Sleep(1000)
Next


; This is the struct that will be returned from the GetFormattedCounterValue call
;http://msdn.microsoft.com/en-us/library/ms724950(v=VS.85).aspx
;~ ============================================================
;~ 	PDH_COUNTER_INFO Struct
;~
;~ 		typedef struct _PDH_COUNTER_INFO {
;~ 		  DWORD     dwLength;
;~ 		  DWORD     dwType;
;~ 		  DWORD     CVersion;
;~ 		  DWORD     CStatus;
;~ 		  LONG      lScale;
;~ 		  LONG      lDefaultScale;
;~ 		  DWORD_PTR dwUserData;
;~ 		  DWORD_PTR dwQueryUserData;
;~ 		  LPTSTR    szFullPath;
;~ 		  union {
;~ 			PDH_DATA_ITEM_PATH_ELEMENTS DataItemPath;
;~ 			PDH_COUNTER_PATH_ELEMENTS CounterPath;
;~ 			struct {
;~ 			  LPTSTR szMachineName;
;~ 			  LPTSTR szObjectName;
;~ 			  LPTSTR szInstanceName;
;~ 			  LPTSTR szParentInstance;
;~ 			  DWORD dwInstanceIndex;
;~ 			  LPTSTR szCounterName;
;~ 			} ;
;~ 		  } ;
;~ 		  LPTSTR    szExplainText;
;~ 		  DWORD     DataBuffer[1];
;~ 		} PDH_COUNTER_INFO, *PPDH_COUNTER_INFO;
;~ ==============================================================


Global Const $PDH_FMT_LARGE = 0x00000400
; Not sure if I need to explicitly build the structure above, or if it will be built by the call below...
;$s=DllStructCreate("dword dwLength;dword dwtype;dword CVersion;dword CStatus;long LScale;long lDefaultScale;dword dwUserData;dword dwQueryUserData;dword dwQueryUserData;string szFullPath; int64 union")
$s=DllStructCreate("int64 union")
if @error Then ConsoleWrite("Error creating struct")


ConsoleWrite("------")
For $i = 1 to $hPDHCounterHandle[0]
;~ 	******************************************************************
;~ 	;http://msdn.microsoft.com/en-us/library/aa372637(v=VS.85).aspx
;~ 		PDH_STATUS PdhGetFormattedCounterValue(
;~ 	  __in   PDH_HCOUNTER hCounter,
;~ 	  __in   DWORD dwFormat,
;~ 	  __out  LPDWORD lpdwType,
;~ 	  __out  PPDH_FMT_COUNTERVALUE pValue
;~ 	);
;~ 	******************************************************************
	$call=DllCall("Pdh.dll","dword","PdhGetFormattedCounterValue","ptr",$hPDHCounterHandle[$i],"dword",$PDH_FMT_LARGE,"ptr",0,"ptr*",DllStructGetPtr($s))


	;Terrible ugly and probably wrong method of getting what I want...nothing seems to return what I want! What have I done wrong?
	;_ArrayDisplay($call,"Return result from GetFormattedCounter call")
	ConsoleWrite("Size: " & DllStructGetSize($s) & @CRLF)
	ConsoleWrite("Element 1 " & DllStructGetData($s,1) & @CRLF)
	ConsoleWrite("Element 2 " & DllStructGetData($s,2) & @CRLF)
	ConsoleWrite("Element 3 " & DllStructGetData($s,3) & @CRLF)
	ConsoleWrite("Element 4 " & DllStructGetData($s,4) & @CRLF)
	ConsoleWrite("Element 5 " & DllStructGetData($s,5) & @CRLF)
	ConsoleWrite("Element 6 " & DllStructGetData($s,6) & @CRLF)
	ConsoleWrite("Element 7 " & DllStructGetData($s,7) & @CRLF)
	ConsoleWrite("Element 8 " & DllStructGetData($s,8) & @CRLF)
	ConsoleWrite("Element 9 " & DllStructGetData($s,9) & @CRLF)
	ConsoleWrite("Element 10 " & DllStructGetData($s,10) & @CRLF)
	ConsoleWrite("Element 11 " & DllStructGetData($s,11) & @CRLF)
	ConsoleWrite("Element 12 " & DllStructGetData($s,12) & @CRLF)
	ConsoleWrite("Element 13 " & DllStructGetData($s,13) & @CRLF)
	ConsoleWrite("Element 14 " & DllStructGetData($s,14) & @CRLF)
	ConsoleWrite("Element 15 " & DllStructGetData($s,15) & @CRLF)
	ConsoleWrite("Element 16 " & DllStructGetData($s,16) & @CRLF)

	; Clear the struct for the next call
	$s=0
Next
;~ MsgBox(0,"",DllStructGetData($s,"union"))


; Close PDH Query Handle
DllCall($hPDH,"long","PdhCloseQuery","ptr",$hPDHQueryHandle)
DllClose($hPDH)
