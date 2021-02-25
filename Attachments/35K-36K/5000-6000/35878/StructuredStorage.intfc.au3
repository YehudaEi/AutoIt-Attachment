#include-once
;===============================================================================
#API "Structured Storage"
; ISequentialStream
; IStream
; IDirectWriterLock
; IEnumSTATPROPSETSTG
; IEnumSTATPROPSTG
; IEnumSTATSTG
; IFillLockBytes
; ILayoutStorage
; ILockBytes
;-- IMemoryAllocator --
; IPropertySetStorage
; IPropertyStorage
; IRootStorage
; IStorage

;===============================================================================

;.......written by trancexx (trancexx at yahoo dot com)

;===============================================================================
#interface "IEnumSTATSTG"
Global Const $sIID_IEnumSTATSTG = "{0000000d-0000-0000-C000-000000000046}"
; Definition
Global Const $tagIEnumSTATSTG = "" & _
		"Next hresult(dword;ptr;dword*);" & _
		"Skip hresult(dword);" & _
		"Reset hresult();" & _
		"Clone hresult(ptr*);"
;===============================================================================


;===============================================================================
#interface "IEnumSTATPROPSETSTG"
Global Const $sIID_IEnumSTATPROPSETSTG = "{0000013B-0000-0000-C000-000000000046}"
; Definition
Global Const $tagIEnumSTATPROPSETSTG = "" & _
		"Next hresult(dword;ptr;dword*);" & _
		"Skip hresult(dword);" & _
		"Reset hresult();" & _
		"Clone hresult(ptr*);"
;===============================================================================


;===============================================================================
#interface "IStorage"
Global Const $sIID_IStorage = "{0000000b-0000-0000-C000-000000000046}"
; Definition
Global Const $tagIStorage = "" & _
		"CreateStream hresult(wstr;dword;dword;dword;ptr*);" & _
		"OpenStream hresult(wstr;ptr;dword;dword;ptr*);" & _
		"CreateStorage hresult(wstr;dword;dword;dword;ptr*);" & _
		"OpenStorage hresult(wstr;ptr;dword;wstr;dword;ptr*);" & _
		"CopyTo hresult(dword;ptr;wstr;ptr);" & _
		"MoveElementTo hresult(wstr;ptr;wstr;dword);" & _
		"Commit hresult(dword);" & _
		"Revert hresult();" & _
		"EnumElements hresult(dword;ptr;dword;ptr*);" & _
		"DestroyElement hresult(wstr);" & _
		"RenameElement hresult(wstr;wstr);" & _
		"SetElementTimes hresult(wstr;ptr;ptr;ptr);" & _
		"SetClass hresult(ptr);" & _
		"SetStateBits hresult(dword;dword);" & _
		"Stat hresult(ptr*;dword);"
;===============================================================================


;===============================================================================
#interface "IRootStorage"
Global Const $sIID_IRootStorage = "{00000012-0000-0000-C000-000000000046}"
; Definition
Global Const $tagIRootStorage = "" & _
		"SwitchToFile hresult(wstr);"
;===============================================================================


;===============================================================================
#interface "IPropertyStorage"
Global Const $sIID_IPropertyStorage = "{00000138-0000-0000-C000-000000000046}"
; Definition
Global Const $tagIPropertyStorage = "" & _
		"ReadMultiple hresult(ptr;ptr;ptr*);" & _
		"WriteMultiple hresult(dword;ptr;ptr;ptr);" & _
		"DeleteMultiple hresult(dword;ptr);" & _
		"ReadPropertyNames hresult(dword;ptr;wstr);" & _
		"WritePropertyNames hresult(dword;ptr;wstr);" & _
		"DeletePropertyNames hresult(dword;dword);" & _
		"Commit hresult(dword);" & _
		"Revert hresult();" & _
		"Enum hresult(ptr*);" & _
		"SetTimes hresult(ptr;ptr;ptr);" & _
		"SetClass hresult(ptr);" & _
		"Stat hresult(ptr*);"
;===============================================================================


;===============================================================================
#interface "IPropertySetStorage"
Global Const $sIID_IPropertySetStorage = "{0000013A-0000-0000-C000-000000000046}"
; Definition
Global Const $tagIPropertySetStorage = "" & _
		"Create hresult(ptr;ptr;dword;dword;ptr*);" & _
		"Open hresult(ptr;dword;ptr*);" & _
		"Delete hresult(ptr);" & _
		"Enum hresult(ptr*);"
;===============================================================================


;===============================================================================
#interface "ILockBytes"
Global Const $sIID_ILockBytes = "{0000000a-0000-0000-C000-000000000046}"
; Definition
Global Const $tagILockBytes = "" & _
		"ReadAt hresult(uint64;ptr;dword;dword);" & _
		"WriteAt hresult(uint64;ptr;dword;dword);" & _
		"Flush hresult();" & _
		"SetSize hresult(uint64);" & _
		"LockRegion hresult(uint64;uint64;dword);" & _
		"UnlockRegion hresult(uint64;uint64;dword);" & _
		"Stat hresult(ptr*;dword);"
;===============================================================================


;===============================================================================
#interface "ILayoutStorage"
Global Const $sIID_ILayoutStorage = "{0e6d4d90-6738-11cf-9608-00aa00680db4}"
; Definition
Global Const $tagILayoutStorage = "" & _
		"LayoutScript hresult(ptr;dword;dword);" & _
		"BeginMonitor hresult();" & _
		"EndMonitor hresult();" & _
		"ReLayoutDocfile hresult(wstr);" & _
		"ReLayoutDocfileOnILockBytes hresult(ptr);"
;===============================================================================


;===============================================================================
#interface "IDirectWriterLock"
Global Const $sIID_IFillLockBytes = "{99caf010-415e-11cf-8814-00aa00b569f5}"
; Definition
Global Const $tagIFillLockBytes = "" & _
		"FillAppend hresult(ptr;dword;dword*);" & _
		"FillAt hresult(uint64;ptr;dword;dword*);" & _
		"SetFillSize hresult(uint64);" & _
		"Terminate hresult(bool);"
;===============================================================================


;===============================================================================
#interface "IDirectWriterLock"
Global Const $sIID_IDirectWriterLock = "{0e6d4d92-6738-11cf-9608-00aa00680db4}"
; Definition
Global Const $tagIDirectWriterLock = "" & _
		"WaitForWriteAccess hresult(dword);" & _
		"ReleaseWriteAccess hresult();" & _
		"HaveWriteAccess hresult();"
;===============================================================================


;===============================================================================
#interface "ISequentialStream"
Global Const $sIID_ISequentialStream = "{0c733a30-2a1c-11ce-ade5-00aa0044773d}"
; Definition
Global Const $tagISequentialStream = "" & _
		"Read hresult(ptr;dword;dword*);" & _
		"Write hresult(ptr;dword;dword*);"
;===============================================================================


;===============================================================================
#interface "IStream"
Global Const $sIID_IStream = "{000000c-0000-0000-C000-000000000046}"
; Definition
Global Const $tagIStream = $tagISequentialStream & _
		"Seek hresult(uint64;dword;uint64*);" & _
		"SetSize hresult(uint64);" & _
		"CopyTo hresult(ptr;uint64;uint64*;uint64*);" & _
		"Commit hresult(dword);" & _
		"Revert hresult();" & _
		"LockRegion hresult(uint64;uint64;dword);" & _
		"UnlockRegion hresult(uint64;uint64;dword);" & _
		"Stat hresult(ptr;dword);" & _
		"Clone hresult(ptr*);"
;===============================================================================
