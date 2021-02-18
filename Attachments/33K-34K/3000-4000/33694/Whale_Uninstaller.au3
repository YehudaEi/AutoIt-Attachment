; -----------------------------------------------------------------
; AutoIt Version  : 3.0
; Author          : Erin Carter
; Script Function : Aggresively uninstalls the Whale Client Components version 3.7.x
; -----------------------------------------------------------------

; Kill the DM Service
RunWait(@ComSpec & " /c " & 'taskkill.exe /IM DMService.exe /F', "", @SW_HIDE)
Sleep ( 10000 )
; Delete the ActiveX component
FileDelete ("C:\Windows\Downloaded Program Files\WhlMgr.dll")

; Delete the client folder
DirRemove ("C:\Program Files\Whale Communications", 1)

; Delete the DMService
FileDelete ("C:\Windows\Prefetch\DMSERVICE*.*")

; Registry Cleanup
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\WhaleCom")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{8D9563A9-8D5F-459B-87F2-BA842255CB9A}")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Whale Communications' Client Components 3.1.0")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Ext\PreApproved\{8D9563A9-8D5F-459B-87F2-BA842255CB9A}")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedDlls", "C:\WINDOWS\Downloaded Program Files\WhlMgr.dll")
RegDelete("HKEY_USERS\S-1-5-21-1611824753-1261255315-768597190-4916\Software\WhaleCom")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{3640A335-73A6-424C-A6E8-B21DCCCABD0C}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{39D5C607-E34D-4B04-A8BE-976F012EBC40}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{3E68CD98-DD9D-400C-B947-5F9674646BE9}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{409D6F7F-339C-4E7C-B89B-52E7C54644DB}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{5B6B36EC-8A18-4113-A48F-5C4C87630BD7}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{656E5CEE-3585-4C95-AD65-037CB12288F6}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{8CF765DD-4C21-4682-B00E-BF439A82793E}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{8D9D76AD-C2F5-48BC-86AD-08DDE6ED3C92}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{961D9D8E-4CE1-405B-BAD1-CF03A2D96F18}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{9E8D6288-6AF2-4720-B80A-43ABFBDC8FE7}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{A99E6846-B0A9-4E5E-AED1-ACEA8CBEF92E}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{C570AD40-59E6-4E17-A8DB-61E1573EEE3F}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{C7034F79-EE0E-466A-8252-81DDB917EDF6}")
RegDelete("HKEY_CLASSES_ROOT\CLSID\{E15F4694-9C73-4C6F-BBB5-2A532EBD85CA}")
RegDelete("HKEY_CLASSES_ROOT\ComponentManager.Installer")
RegDelete("HKEY_CLASSES_ROOT\ComponentManager.Installer.1")
RegDelete("HKEY_CLASSES_ROOT\ComponentManager.Installer.2")
RegDelete("HKEY_CLASSES_ROOT\EndpointCompliance.Detector")
RegDelete("HKEY_CLASSES_ROOT\EndpointCompliance.Detector.2")
RegDelete("HKEY_CLASSES_ROOT\EndpointCompliance.WhaleUtils")
RegDelete("HKEY_CLASSES_ROOT\EndpointCompliance.WhaleUtils.1")
RegDelete("HKEY_CLASSES_ROOT\Interface\{1011D561-A5FC-44A7-9BF8-98F01D0BB725}")
RegDelete("HKEY_CLASSES_ROOT\Interface\{B2F43F44-910A-4078-83A9-79D8FA1AF34E}")
RegDelete("HKEY_CLASSES_ROOT\TypeLib\{0B960C4A-1958-49DA-87C0-C84CF3F88D37}")
RegDelete("HKEY_CLASSES_ROOT\TypeLib\{4E19D652-1A83-4CB9-A601-B89D07950B95}")
RegDelete("HKEY_CLASSES_ROOT\TypeLib\{55F7C4AB-81BA-416B-A339-1D5660094349}")
RegDelete("HKEY_CLASSES_ROOT\TypeLib\{88C61F1E-4E0F-4440-93B5-389EBB5CB362}")
RegDelete("HKEY_CLASSES_ROOT\TypeLib\{AF42105D-EA21-4A0A-B934-C97CEED07CC7}")
RegDelete("HKEY_CLASSES_ROOT\WhlCache.Scramble")
RegDelete("HKEY_CLASSES_ROOT\WhlCache.Scramble.6")
RegDelete("HKEY_CLASSES_ROOT\WhlClnt3.LocalProxy")
RegDelete("HKEY_CLASSES_ROOT\WhlClnt3.LocalProxy.2")
RegDelete("HKEY_CLASSES_ROOT\Whliocsv.NcDialer")
RegDelete("HKEY_CLASSES_ROOT\Whliocsv.NcDialer.1")
RegDelete("HKEY_CLASSES_ROOT\Whliocsv.NcSession")
RegDelete("HKEY_CLASSES_ROOT\Whliocsv.NcSession.1")
RegDelete("HKEY_CLASSES_ROOT\WhlWmiDetect.DetectCenter")
RegDelete("HKEY_CLASSES_ROOT\WhlWmiDetect.DetectCenter.1")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{3640A335-73A6-424C-A6E8-B21DCCCABD0C}")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{39D5C607-E34D-4B04-A8BE-976F012EBC40}")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{A99E6846-B0A9-4E5E-AED1-ACEA8CBEF92E}")
RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{F338ACF7-4317-4c5d-8C4F-658098332058}")
RegDelete("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DMService")
RegDelete("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\whliocsv")
RegDelete("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\whlva")