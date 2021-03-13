#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Neutro

 Script Function:
	Clean users temporary windows files

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <File.au3>
#include <Array.au3>
#include <RecFileListToArray.au3>

SplashTextOn("Please wait","Cleaning Windows users profiles directories.",800,100)

clean_profils()

SplashOff()

func clean_profils()

$userdir = stringleft(@userprofiledir, stringinstr(@userprofiledir, @username ) -2)

$listing = _FileListToArray($userdir, "*", 2) ;returns an array containing the name of all users directories

$i = 1

Do
   if stringinstr(FileGetAttrib($userdir & "\" & $listing[$i]), "H") <> 0 then ;if the folder has "hidden" as attribute (system user), we remove it from $listing array
	  _arraydelete($listing, $i)
	  $listing[0] = $listing[0] - 1
	  
   Else
	  $i = $i+1
   endif

until $listing[0] == $i

for $i = 1 to $listing[0] step 1 ; for all user directories, we clean the below folders:
   
   if @OSVersion == "WIN_7" then
   
      delfolder($userdir & "\" & $listing[$i] & "\AppData\Local\Microsoft\Windows\Temporary Internet Files")
      delfolder($userdir & "\" & $listing[$i] & "\AppData\Local\Temp")
      delfolder($userdir & "\" & $listing[$i] & "\AppData\LocalLow\Temp")
      delfolder($userdir & "\" & $listing[$i] & "\AppData\Local\Google\Chrome\User Data\Default\Cache")
   
      $firefox = _FileListToArray(@Homedrive & "\Users\" & $listing[$i] & "\AppData\Local\Mozilla\Firefox\Profiles", "*", 2)
   
      if IsArray($firefox) then ; if at least 1 firefox profile is found, we clean it/them
	  
	     for $k = 1 to $firefox[0] step 1
		 
		    delfolder($userdir & "\" & $listing[$i] & "\AppData\Local\Mozilla\Firefox\Profiles\" & $firefox[$k] & "\Cache")
			delfolder($userdir & "\" & $listing[$i] & "\AppData\Local\Mozilla\Firefox\Profiles\" & $firefox[$k] & "\OfflineCache")
		    delfolder($userdir & "\" & $listing[$i] & "\AppData\Local\Mozilla\Firefox\Profiles\" & $firefox[$k] & "\startupCache")
		 
	     next
	  
      endif
   
   elseif @OSVersion == "WIN_XP" Then
   
      delfolder($userdir & "\" & $listing[$i] & "\Local Settings\Temporary Internet Files")
      delfolder($userdir & "\" & $listing[$i] & "\Local Settings\Temp")
      delfolder($userdir & "\" & $listing[$i] & "\Local Settings\Application Data\Google\Chrome\User Data\Default\Cache")
   
      $firefox = _FileListToArray(@Homedrive & "\Users\" & $listing[$i] & "\AppData\Local\Mozilla\Firefox\Profiles", "*", 2)
   
      if IsArray($firefox) then ; if at least 1 firefox profile is found, we clean it/them
	  
	     for $k = 1 to $firefox[0] step 1
		 
		    delfolder($userdir & "\" & $listing[$i] & "\AppData\Local\Mozilla\Firefox\Profiles\" & $firefox[$k] & "\Cache")
	        delfolder($userdir & "\" & $listing[$i] & "\AppData\Local\Mozilla\Firefox\Profiles\" & $firefox[$k] & "\OfflineCache")
	        delfolder($userdir & "\" & $listing[$i] & "\AppData\Local\Mozilla\Firefox\Profiles\" & $firefox[$k] & "\startupCache")
		 
		 next
	  
       endif
   
   endif

next

EndFunc


func delfolder ($folder)
   
   $dirlisting = _RecFileListToArray($folder, "*", 2, 1) ;getting all folders/subfolders into an array
   
   if isArray($dirlisting) then ;if the folder contains subfolder, we delete everything inside each subfolders
   
      filedelete_enhanced($folder)
   
         for $i = $dirlisting[0] to 1 step -1
			
         filedelete_enhanced($folder & "\" & $dirlisting[$i])
		 sleep(250)
		 Dirremove($folder & "\" & $dirlisting[$i], 0)
	     next
	  

	  
   else ;if the folder doesn't contains subfolder, we simply delete what's inside it.
	 
	  filedelete_enhanced($folder)
	  
   endif
   
endfunc

func filedelete_enhanced ($dossier)
   
   $fichiers = _FileListToArray($dossier)
   
   If IsArray($fichiers) then
	  
	  for $l = 1 to $fichiers[0] step 1
		 
		 controlsettext("Please wait", "Cleaning Windows users profiles directories", "Static1", "Cleaning Windows users profiles directories" & @CRLF & @CRLF & $dossier & "\" & $fichiers[$l])
		 
		 filedelete($dossier & "\" & $fichiers[$l])
		 
	  Next
	  
   endif
   
EndFunc