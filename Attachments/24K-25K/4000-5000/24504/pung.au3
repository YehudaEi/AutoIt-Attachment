#Include <File.au3>
#include <Date.au3>
#include <String.au3>
#include <inet.au3>
 ;When the function fails (returns 0) @error contains extended information:
 ;1 = Host is offline
 ;2 = Host is unreachable
 ;3 = Bad destination
 ;4 = Other errors


dim $num_line = 0
dim $che_ore_sono
dim $file_HTML, $file




While 1
	;//////////////////////////////////////////////////////////////////////
	;//		determino in che mezz'ora sono
	;//////////////////////////////////////////////////////////////////////
	$che_ore_sono = number(_NowTime(4))
	;~ MsgBox(0,'',$che_ore_sono)

	if $che_ore_sono >= 0 and $che_ore_sono <= 0.29 Then $che_ore_sono = "--ore_00:00--"
	if $che_ore_sono >= 0.30 and $che_ore_sono <= 0.59 Then	$che_ore_sono = "--ore_00:30--"
	if $che_ore_sono >= 1.00 and $che_ore_sono <= 1.29 Then	$che_ore_sono = "--ore_01:00--"
	if $che_ore_sono >= 1.30 and $che_ore_sono <= 1.59 Then	$che_ore_sono = "--ore_01:30--"
	if $che_ore_sono >= 2.00 and $che_ore_sono <= 2.29 Then	$che_ore_sono = "--ore_02:00--"
	if $che_ore_sono >= 2.30 and $che_ore_sono <= 2.59 Then	$che_ore_sono = "--ore_02:30--"
	if $che_ore_sono >= 3.00 and $che_ore_sono <= 3.29 Then	$che_ore_sono = "--ore_03:00--"
	if $che_ore_sono >= 3.30 and $che_ore_sono <= 3.59 Then	$che_ore_sono = "--ore_03:30--"
	if $che_ore_sono >= 4.00 and $che_ore_sono <= 4.29 Then	$che_ore_sono = "--ore_04:00--"
	if $che_ore_sono >= 4.30 and $che_ore_sono <= 4.59 Then	$che_ore_sono = "--ore_04:30--"
	if $che_ore_sono >= 5.00 and $che_ore_sono <= 5.29 Then	$che_ore_sono = "--ore_05:00--"
	if $che_ore_sono >= 5.30 and $che_ore_sono <= 5.59 Then	$che_ore_sono = "--ore_05:30--"
	if $che_ore_sono >= 6.00 and $che_ore_sono <= 6.29 Then	$che_ore_sono = "--ore_06:00--"
	if $che_ore_sono >= 6.30 and $che_ore_sono <= 6.59 Then	$che_ore_sono = "--ore_06:30--"
	if $che_ore_sono >= 7.00 and $che_ore_sono <= 7.29 Then	$che_ore_sono = "--ore_07:00--"
	if $che_ore_sono >= 7.30 and $che_ore_sono <= 7.59 Then	$che_ore_sono = "--ore_07:30--"
	if $che_ore_sono >= 8.00 and $che_ore_sono <= 8.29 Then	$che_ore_sono = "--ore_08:00--"
	if $che_ore_sono >= 8.30 and $che_ore_sono <= 8.59 Then	$che_ore_sono = "--ore_08:30--"
	if $che_ore_sono >= 9.00 and $che_ore_sono <= 9.29 Then	$che_ore_sono = "--ore_09:00--"
	if $che_ore_sono >= 9.30 and $che_ore_sono <= 9.59 Then	$che_ore_sono = "--ore_09:30--"
	if $che_ore_sono >= 10.00 and $che_ore_sono <= 10.29 Then $che_ore_sono = "--ore_10:00--"
	if $che_ore_sono >= 10.30 and $che_ore_sono <= 10.59 Then $che_ore_sono = "--ore_10:30--"
	if $che_ore_sono >= 11.00 and $che_ore_sono <= 11.29 Then $che_ore_sono = "--ore_11:00--"
	if $che_ore_sono >= 11.30 and $che_ore_sono <= 11.59 Then $che_ore_sono = "--ore_11:30--"
	if $che_ore_sono >= 12.00 and $che_ore_sono <= 12.29 Then $che_ore_sono = "--ore_12:00--"
	if $che_ore_sono >= 12.30 and $che_ore_sono <= 12.59 Then $che_ore_sono = "--ore_12:30--"
	if $che_ore_sono >= 13.00 and $che_ore_sono <= 13.29 Then $che_ore_sono = "--ore_13:00--"
	if $che_ore_sono >= 13.30 and $che_ore_sono <= 13.59 Then $che_ore_sono = "--ore_13:30--"
	if $che_ore_sono >= 14.00 and $che_ore_sono <= 14.29 Then $che_ore_sono = "--ore_14:00--"
	if $che_ore_sono >= 14.30 and $che_ore_sono <= 14.59 Then $che_ore_sono = "--ore_14:30--"
	if $che_ore_sono >= 15.00 and $che_ore_sono <= 15.29 Then $che_ore_sono = "--ore_15:00--"
	if $che_ore_sono >= 15.30 and $che_ore_sono <= 15.59 Then $che_ore_sono = "--ore_15:30--"
	if $che_ore_sono >= 16.00 and $che_ore_sono <= 16.29 Then $che_ore_sono = "--ore_16:00--"
	if $che_ore_sono >= 16.30 and $che_ore_sono <= 16.59 Then $che_ore_sono = "--ore_16:30--"
	if $che_ore_sono >= 17.00 and $che_ore_sono <= 17.29 Then $che_ore_sono = "--ore_17:00--"
	if $che_ore_sono >= 17.30 and $che_ore_sono <= 17.59 Then $che_ore_sono = "--ore_17:30--"
	if $che_ore_sono >= 18.00 and $che_ore_sono <= 18.29 Then $che_ore_sono = "--ore_18:00--"
	if $che_ore_sono >= 18.30 and $che_ore_sono <= 18.59 Then $che_ore_sono = "--ore_18:30--"
	if $che_ore_sono >= 19.00 and $che_ore_sono <= 19.29 Then $che_ore_sono = "--ore_19:00--"
	if $che_ore_sono >= 19.30 and $che_ore_sono <= 19.59 Then $che_ore_sono = "--ore_19:30--"
	if $che_ore_sono >= 20.00 and $che_ore_sono <= 20.29 Then $che_ore_sono = "--ore_20:00--"
	if $che_ore_sono >= 20.30 and $che_ore_sono <= 20.59 Then $che_ore_sono = "--ore_20:30--"
	if $che_ore_sono >= 21.00 and $che_ore_sono <= 21.29 Then $che_ore_sono = "--ore_21:00--"
	if $che_ore_sono >= 21.30 and $che_ore_sono <= 21.59 Then $che_ore_sono = "--ore_21:30--"
	if $che_ore_sono >= 22.00 and $che_ore_sono <= 22.29 Then $che_ore_sono = "--ore_22:00--"
	if $che_ore_sono >= 22.30 and $che_ore_sono <= 22.59 Then $che_ore_sono = "--ore_22:30--"
	if $che_ore_sono >= 23.00 and $che_ore_sono <= 23.29 Then $che_ore_sono = "--ore_23:00--"
	if $che_ore_sono >= 23.30 and $che_ore_sono <= 23.59 Then $che_ore_sono = "--ore_23:30--"
		

	;~ msgbox(0,"",$che_ore_sono)

	;//////////////////////////////////////////////////////////////////////
	;//				creo apro file necessari
	;//////////////////////////////////////////////////////////////////////



	$file = FileOpen("IPLIST.txt", 0)



	If FileExists("Main_IP_table.html") Then
		;//////////////////////////////////////////////////////////////////////
		;//				aggiorna solo alcuni dati della pagina
		;//////////////////////////////////////////////////////////////////////
		$filename = "Main_IP_table.html"
		$find =  FileReadLine("Main_IP_table.html", 14)
		$replace = "      <div align=" & Chr(34) & "center" & Chr(34) & ">Check : " & $che_ore_sono & "</div> <!--aggiornata_al-->" & @CRLF
		
		$retval = _ReplaceStringInFile($filename,$find,StringReplace($replace,"--",""))


	Else
		$file_HTML = FileOpen("Main_IP_table.html", 10)
		sleep(1000)
		

		;//////////////////////////////////////////////////////////////////////
		;//				costruisci tabella generale
		;//////////////////////////////////////////////////////////////////////

		FileWrite($file_HTML, "<html>" & @CRLF)
		FileWrite($file_HTML, "<head>" & @CRLF)
		FileWrite($file_HTML, "<title>Nacios - Ping Checker</title>" & @CRLF)
		FileWrite($file_HTML, "<meta http-equiv=" & Chr(34) & "Content-Type" & Chr(34) & " content=" & Chr(34) & "text/html" & Chr(59) & " charset=iso-8859-1" & Chr(34) & ">" & @CRLF)
		FileWrite($file_HTML, "</head>" & @CRLF)
		FileWrite($file_HTML, "<body bgcolor=" & Chr(34) & "#FFFFFF" & Chr(34) & ">" & @CRLF)


		FileWrite($file_HTML, "<body bgcolor=" & Chr(34) & "#FFFFFF" & Chr(34) & ">" & @CRLF)
		FileWrite($file_HTML, "<table width=" & Chr(34) & "869" & Chr(34) & " border=" & Chr(34) & "1" & Chr(34) & ">" & @CRLF)
		FileWrite($file_HTML, "  <tr> " & @CRLF)
		FileWrite($file_HTML, "    <td width=" & Chr(34) & "19" & Chr(34) & "> " & @CRLF)
		FileWrite($file_HTML, "      <div align=" & Chr(34) & "center" & Chr(34) & "><font size=" & Chr(34) & "1" & Chr(34) & ">Now</font></div>" & @CRLF)
		FileWrite($file_HTML, "    </td>" & @CRLF)
		FileWrite($file_HTML, "    <td width=" & Chr(34) & "120" & Chr(34) & "> " & @CRLF)
		FileWrite($file_HTML, "      <div align=" & Chr(34) & "center" & Chr(34) & ">Check : " & StringReplace($che_ore_sono,"--","") & "</div> <!--aggiornata_al-->" & @CRLF)
		FileWrite($file_HTML, "    </td>" & @CRLF)
		FileWrite($file_HTML, "    <td width=" & Chr(34) & "122" & Chr(34) & "> " & @CRLF)
		FileWrite($file_HTML, "      <div align=" & Chr(34) & "center" & Chr(34) & ">DNS name</div>" & @CRLF)
		FileWrite($file_HTML, "    </td>" & @CRLF)
		FileWrite($file_HTML, "    <td width=" & Chr(34) & "563" & Chr(34) & ">0:00 ..................................................10:00......................15:00.....................20:00........23:30</td>" & @CRLF)
		FileWrite($file_HTML, "  </tr>" & @CRLF)
		FileWrite($file_HTML, "</table>" & @CRLF)
		FileWrite($file_HTML, "</body>" & @CRLF)






		; costruisci tabella generale 
		While 1
			;//////////////////////////////////////////////////////////////////////
			;//				leggi IP dalla lista
			;//////////////////////////////////////////////////////////////////////
			$num_line = $num_line + 1
			$line = FileReadLine($file,$num_line)
			If @error = -1 Then ExitLoop
			;//////////////////////////////////////////////////////////////////////
			;//				IP <-> DNS name
			;//////////////////////////////////////////////////////////////////////
			local $IPtoNAME
			
			
			If StringRegExp($line, "(\d+\.\d+\.\d+\.\d+)", 0) = 1 Then ; Check if $line is an IP address
					
				;msgbox(0,"",$line & " sono un IPPPPPPPPPPPPPPPPP")

				TCPStartup()
				$IPtoNAME =  _TCPIpToName($line)
				TCPShutdown()

				if $IPtoNAME ="" then $IPtoNAME = "    Unknow     "
						
				$my_IP = $line
			Elseif StringRegExp($line, "(\d+\.\d+\.\d+\.\d+)", 0) = 0 Then
				;msgbox(0,"",$line & " sono un DNS")
			
				TCPStartup()
				$IPtoNAME =  TCPNameToIP($line)
				TCPShutdown()

				if $IPtoNAME ="" then $IPtoNAME = "    Unknow     "
			
				$my_IP = $IPtoNAME
			EndIf






			;//////////////////////////////////////////////////////////////////////
			;//				Build HTML page
			;//////////////////////////////////////////////////////////////////////
		  
			FileWrite($file_HTML, "<table width=" & Chr(34) & "869" & Chr(34) & " border=" & Chr(34) & "1" & Chr(34) & ">" & @CRLF)
			FileWrite($file_HTML, "  <tr> " & @CRLF)
			FileWrite($file_HTML, "    <td width=" & Chr(34) & "1" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td>" & "<!" & $my_IP & ">" & @CRLF)
			FileWrite($file_HTML, "    <td width=" & Chr(34) & "160" & Chr(34) & " bgcolor=" & Chr(34) & "#FFFFFF" & Chr(34) & "> " & @CRLF)


	;~ <A HREF="http://www.yourdomain.com/" TITLE="Your text description">Your Text</A>




	;"<A HREF=" & Chr(34) & "http://www.yourdomain.com/" & Chr(34) & " TITLE=" & Chr(34) & "Your text description" & Chr(34) & ">Your Text</A>"




	;~ 		FileWrite($file_HTML, "<div align=" & Chr(34) & "center" & Chr(34) & ">" & $line & "</div>" & @CRLF)
			FileWrite($file_HTML, "<A HREF=" & Chr(34) & "http:\\" & $line & Chr(34) & " TITLE=" & Chr(34) & $IPtoNAME & Chr(34) & ">" & $line & "</A>")



			FileWrite($file_HTML, "</td>" & @CRLF)
	;~ 		FileWrite($file_HTML, "<td width=" & Chr(34) & "160" & Chr(34) & " bgcolor=" & Chr(34) & "#FFFFFF" & Chr(34) & "> " & @CRLF)
	;~ 		FileWrite($file_HTML, "  <div align=" & Chr(34) & "center" & Chr(34) & ">" & $IPtoNAME & "</div>" & @CRLF)
	;~ 		FileWrite($file_HTML, "</td>" & @CRLF)
			
			
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_00:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_00:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_01:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_01:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_02:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_02:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_03:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_03:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_04:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_04:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_05:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_05:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_06:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_06:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_07:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_07:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_08:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_08:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_09:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_09:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_10:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_10:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_11:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_11:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_12:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_12:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_13:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_13:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_14:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_14:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_15:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_15:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_16:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_16:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_17:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_17:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_18:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_18:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_19:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_19:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_20:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_20:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_21:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_21:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_22:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_22:30-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_23:00-->" & @CRLF)
			FileWrite($file_HTML, "<td width=" & Chr(34) & "7" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & "--ore_23:30-->" & @CRLF)














			FileWrite($file_HTML, "</tr>" & @CRLF)
			FileWrite($file_HTML, "</table>" & @CRLF)
			
			
			
	;~ 		FileWrite($file_HTML, "<table width=" & Chr(34) & "20" & Chr(34) & " border=" & Chr(34) & "1" & Chr(34) & ">" & @CRLF)
	;~ 		FileWrite($file_HTML, "<td width=" & Chr(34) & "160" & Chr(34) & " bgcolor=" & Chr(34) & "#FFFFFF" & Chr(34) & "> " & @CRLF)
	;~ 		FileWrite($file_HTML, "  <div align=" & Chr(34) & "center" & Chr(34) & ">" & $IPtoNAME & "</div>" & @CRLF)
	;~ 		FileWrite($file_HTML, "</td>" & @CRLF)
	;~ 		FileWrite($file_HTML, "</tr>" & @CRLF)
	;~ 		FileWrite($file_HTML, "</table>" & @CRLF)
		Wend


		FileWrite($file_HTML, "</body>")
		FileWrite($file_HTML, "</html>")
		
		
		
		
		
		
	EndIf




	; Check if file opened for reading OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf

	; Check if file opened for reading OK
	If $file_HTML = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf



	FileClose($file)
	FileClose($file_HTML)



	;//////////////////////////////////////////////////////////////////////
	;//				ciclo per aggiornamento HTML
	;//////////////////////////////////////////////////////////////////////
			

	$num_line = 0

	$file = FileOpen("IPLIST.txt", 0)
	;$file_HTML = FileOpen("Main_IP_table.html", 10)


	; Read in lines of text until the EOF is reached
	While 1
		$num_line = $num_line + 1
		$line = FileReadLine($file,$num_line)
		If @error = -1 Then ExitLoop
		


			;//////////////////////////////////////////////////////////////////////
			;//				IP <-> DNS name
			;//////////////////////////////////////////////////////////////////////
			local $IPtoNAME
			
			
			If StringRegExp($line, "(\d+\.\d+\.\d+\.\d+)", 0) = 1 Then ; Check if $line is an IP address
					
				;msgbox(0,"",$line & " sono un IPPPPPPPPPPPPPPPPP")

				TCPStartup()
				$IPtoNAME =  _TCPIpToName($line)
				TCPShutdown()

				if $IPtoNAME ="" then $IPtoNAME = "    Unknow     "
						
				$my_IP = $line
			Elseif StringRegExp($line, "(\d+\.\d+\.\d+\.\d+)", 0) = 0 Then
				;msgbox(0,"",$line & " sono un DNS")
			
				TCPStartup()
				$IPtoNAME =  TCPNameToIP($line)
				TCPShutdown()

				if $IPtoNAME ="" then $IPtoNAME = "    Unknow     "
			
				$my_IP = $IPtoNAME
			EndIf








		local $find, $replace, $filename, $msg, $retval

		$var = Ping($my_IP ,2000)
		
	;~ 	msgbox(0,""," Ping " & $my_ip)
	;~ 	
	;~ 	msgbox(0,"",$line & " " & $var)
		If $var Then; also possible:  If @error = 0 Then ...
			;Msgbox(0,"Status",$line & " Online, roundtrip was:" & $var)

			$filename = "Main_IP_table.html"

			$find =  "<td width=" & Chr(34) & "1" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td>" & "<!" & $my_IP & ">"
			$replace = "<td width=" & Chr(34) & "1" & Chr(34) & " bgcolor=" & Chr(34) & "#33FF33" & Chr(34) & ">&nbsp" & Chr(59) & "</td>" & "<!" & $my_IP & ">"
			$retval = _ReplaceStringInFile($filename,$find,$replace)

			$find =  "<td width=" & Chr(34) & "1" & Chr(34) & " bgcolor=" & Chr(34) & "#ff0033" & Chr(34) & ">&nbsp" & Chr(59) & "</td>" & "<!" & $my_IP & ">"
			$replace = "<td width=" & Chr(34) & "1" & Chr(34) & " bgcolor=" & Chr(34) & "#33FF33" & Chr(34) & ">&nbsp" & Chr(59) & "</td>" & "<!" & $my_IP & ">"
			$retval = _ReplaceStringInFile($filename,$find,$replace)

			$find =  Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & $che_ore_sono
			$replace = Chr(34) & "#33FF33" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & $che_ore_sono
			$retval = _ReplaceStringInFile($filename,$find,$replace)


		Else
			;Msgbox(0,"Status",$line & " An error occured with number: " & @error)

			$filename = "Main_IP_table.html"
			
			$find =  "<td width=" & Chr(34) & "1" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td>" & "<!" & $my_IP & ">"
			$replace = "<td width=" & Chr(34) & "1" & Chr(34) & " bgcolor=" & Chr(34) & "#ff0033" & Chr(34) & ">&nbsp" & Chr(59) & "</td>" & "<!" & $my_IP & ">"
			$retval = _ReplaceStringInFile($filename,$find,$replace)


			$find =  "<td width=" & Chr(34) & "1" & Chr(34) & " bgcolor=" & Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td>" & "<!" & $my_IP & ">"
			$replace = "<td width=" & Chr(34) & "1" & Chr(34) & " bgcolor=" & Chr(34) & "#ff0033" & Chr(34) & ">&nbsp" & Chr(59) & "</td>" & "<!" & $my_IP & ">"
			$retval = _ReplaceStringInFile($filename,$find,$replace)

			$find =  Chr(34) & "#F2FFF2" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & $che_ore_sono
			$replace = Chr(34) & "#ff0033" & Chr(34) & ">&nbsp" & Chr(59) & "</td> <!" & $my_IP & $che_ore_sono
			$retval = _ReplaceStringInFile($filename,$find,$replace)
	;~ 		if $retval = -1 then
	;~ 			msgbox(0, "ERROR", "The pattern could not be replaced in file: " & $filename & " Error: " & @error)
	;~ 			exit
	;~ 		else
	;~ 			msgbox(0, "INFO", "Found " & $retval & " occurances of the pattern: " & $find & " in the file: " & $filename)
	;~ 		endif

	;~ 		$msg = FileRead($filename, 1000)
			;msgbox(0,"AFTER",$msg)
			;FileDelete($filename)
			

			
			
			
			
		EndIf





	Wend

	FileClose($file)
	FileClose($file_HTML)


	sleep(1200000)
WEnd






 





Func _StringReplaceBetween ($sString, $sStart, $sEnd, $sReplace)
    $searchstring = _StringBetween ($sString, $sStart, $sEnd)
    If @error Then SetError (1, -1, 0)
    $return = StringReplace ($sString, $searchstring[0], $sReplace)
    Return $return
EndFunc