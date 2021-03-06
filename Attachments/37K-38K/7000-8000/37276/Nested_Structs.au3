#include "_DLLStructDisplay.au3"

Dim $s_struct_ndis_essid = "ULONG length;BYTE essid[32];"

Dim $s_struct_ndis_configuration_fh = "ULONG length;ULONG hop_pattern;ULONG hop_set;ULONG dwell_time;"

Dim $s_struct_ndis_configuration = 	"ULONG length;" 		& _
									"ULONG beacon_period;" 	& _
									"ULONG atim_window;" 	& _
									"ULONG ds_config;" 		& _
									"STRUCT fh_config;" 	& $s_struct_ndis_configuration_fh & "ENDSTRUCT ds_config;"

Dim $s_struct_ndis_wlan_bssid = 	"ULONG length;" 		& _
									"BYTE mac[6];" 			& _
									"BYTE reserved[2];" 	& _
									"STRUCT ssid;" 			& 	$s_struct_ndis_essid & "ENDSTRUCT ssid;" & _
									"ULONG privacy;" 		& _
									"LONG rssi;" 			& _
									"UINT net_type;" 		& _
									"STRUCT config;"		&	$s_struct_ndis_configuration & "ENDSTRUCT config;" & _
									"UINT mode;"			& _
									"BYTE rates[8];"

Dim $iNumberOfItems = 10
Dim $s_struct__NDIS_802_11_BSSID_LIST = "UINT NumberOfItems;"
For $i = 1 To $iNumberOfItems
	$s_struct__NDIS_802_11_BSSID_LIST &= $s_struct_ndis_wlan_bssid
Next

ConsoleWrite("$s_struct__NDIS_802_11_BSSID_LIST = " & $s_struct__NDIS_802_11_BSSID_LIST & @CRLF)

Dim $struct__NDIS_802_11_BSSID_LIST = DllStructCreate($s_struct__NDIS_802_11_BSSID_LIST)
If @error Then Exit ConsoleWrite("DLLStructCreate @error=" &@error & @CRLF)

If Not _DLLStructDisplay($struct__NDIS_802_11_BSSID_LIST,$s_struct__NDIS_802_11_BSSID_LIST,"NDIS 802.11 BSSID List") Then
    ConsoleWrite("_DLLStructDisplay failed, @error=" & @error & @CRLF)
EndIf

$struct__NDIS_802_11_BSSID_LIST = 0