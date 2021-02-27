#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=IP Detector Created July 11, 2011 9:00 AM -0400 EDT. Last updated January 27th, 2012 11:05 -0500 EST.
#AutoIt3Wrapper_Res_Description=IP Detector For Windows
#AutoIt3Wrapper_Res_Fileversion=1.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=Copyright 2012 Daniel Chavez
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#All original copyright notices must stay intact regardless of modifications!!!!!
#Program License
#This program is licensed under the GPL open-source styled license. Please see below for further information.
#IP Detect Detecting a public/Lan IP address
#Copyright © 2012 Daniel Chavez
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#as published by the Free Software Foundation; either version 2
#of the License, or (at your option) any later version.
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#Or contact topdog2046@gmail.com via email to receive a copy.
;This is Version 1.0 of IP Detect
#include <GUIConstantsEx.au3>
$gui = GUICreate("Welcome To IP Detect: Version 1.0", 400, 100)
GUISetState()
Sleep(3000)
;Run through diagnostics
;Check system CPU to see if we are running on 32 or 64 bit and report to the user the CPU arch, not that it'd matter anyway. Also include OS version and computer name.
TrayTip("Running Diagnostics", " Checking CPU architecture, OS, and computer name  we are running on. One moment.", 15, 1)
sleep(5000)
MsgBox(0,"OS Version, CPU architecture, and computer name","OS is :" & @OSVersion & @CRLF & "CPU architecture is :" & @CPUArch & @CRLF & "You are running under computer name :" & @ComputerName, 0)
MsgBox(0, "Internet Required", "This program requires internet access. Please insure you have internet access available before running this program.", 5)
TrayTip("Checking Admin Permissions", "Checking For Admin level permissions. One moment.", 15, 1)
sleep(3000)
If IsAdmin() Then MsgBox(0, "Administrative Check", "Admin rights detected", 6)
#include <Inet.au3>
SoundSetWaveVolume(15)
SoundPlay ("wait.mp3", 0)
ToolTip("Gathering your Public and Lan IP addresses.", 0, 0, "Checking for existing IP Addresses. Checking network adapters ... Connecting to internet ...", 0)
Sleep(9000)
$PublicIP = _GetIP()
If @ERROR=1 Then
MsgBox(0, "Connection Error", "No internet access could be found. Please make sure internet is available before re-running the program.", 6)
exit;
Endif
If @ERROR=0 Then
MsgBox(0, "IP Addresses detected", "The following were the IP addresses we found on your system. " & "Public:" & $PublicIP & "Lan:" & @IPAddress1 & @crlf & "This information has been copied to the clipboard." & @crlf & "You may dismiss this box by pressing ok.", 0)
Endif
ClipPut($PublicIP & @crlf & @IPAddress1)
exit;