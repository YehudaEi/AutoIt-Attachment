; ***********************************************************************
; Antivirus Update - Copy latest versions of Malwarebytes, Stinger, etc
; ***********************************************************************
;
#include <IE.au3>

; Declarations
Dim $sSaveBaseDir = "c:\utils\antivirus"

;
; MALWAREBYTES - Download latest from CNET
;
$oIE = _IECreate ("                                                                                                                                                                                      ")

; Select first item in cnet search results which should be latest MalwareBytes version
MouseClick("primary", 1080, 737) ;This is NOT reliable due to varying size of ad above link changing the link location

; How do I get the link handle itself so I can invoke a click on it directly?