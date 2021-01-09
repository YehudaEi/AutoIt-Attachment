; ###################################################################################
;
; Within this file some (not all) of the settings to be used by "PostInstall.exe"
; are configured.
;
;##################################General Settings##################################
[Settings]
; UNC-Name of the server the tools used by this program reside on
ToolsServer=\\Server

; UNC-Name of the share the tools used by this program reside on ("\\Server\Share\Directory")
ToolsShare=\\Server-1\PostInstall\Tools

; REG-File to host the Default Registry Settings
RegFile=_PostInstall.reg

; UNC-Path of the file to be executed for AD-Share by a chronjob ("\\Server\Share\Directory\Filename")
ADshare=\\Server-2\ad_share\windows\StartScript.bat

; Names and Passwords for the accounts to be created on the local system; a maximum of
; tree (3) users can be defined here.
User_1=user-1
Pass_1=pass-1
User_2=user-2
Pass_2=pass-2
User_3=
Pass_3=

; Name and Password of the administrative Domain-Account to be used ("domain\AdminUser")
AdminUser=ourdomain\Administrator
AdminPass=adminpass


;####################################NIC Settings###################################
; Name of Network Interface - exactly as shown in "Network Connections"
Interface=Local Area Connection

; Currently used network
Current=0


;##################################Network Profiles##################################
[Hardware]
; 1st DNS
DNS1=1.1.1.1

; 2nd DNS
DNS2=2.2.2.2

; 3rd DNS
DNS3=

; 4th DNS
DNS4=

; 1st WINS
WINS1=10.10.10.10

; 2nd WINS
WINS2=20.20.20.20


[VMware]
; 1st DNS
DNS1=1.1.1.1

; 2nd DNS
DNS2=2.2.2.2

; 3rd DNS
DNS3=3.3.3.3

; 4th DNS
DNS4=4.4.4.4

; 1st WINS
WINS1=10.10.10.10

; 2nd WINS
WINS2=20.20.20.20


[DHCP]
;Section for DHCP settings; not needed to be changed
Address=DHCP

; 1st WINS
WINS1=10.10.10.10

; 2nd WINS
WINS2=20.20.20.20


; One section = one network settings
; if needed more - simly copy a section, rename it and edit settings as needed


; Possible other values here are:
; IP Address
;Address=192.168.1.5
; Network mask
;Mask=255.255.255.0
; Routing list
; Possible use of unlimited routes.
; Format xxx.xxx.xxx.xxx mask yyy.yyy.yyy.yyy zzz.zzz.zzz.zzz where
; xxx.xxx.xxx.xxx - destination network
; yyy.yyy.yyy.yyy - destination networks subnet mask
; zzz.zzz.zzz.zzz - gateway for this network
;
;Route1=0.0.0.0 mask 0.0.0.0 192.168.1.1
;Route2=192.168.10.0 mask 255.255.255.0 192.168.1.254