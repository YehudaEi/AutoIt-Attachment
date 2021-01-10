#Include "_XMLDomWrapper.au3"
$FILE = @ScriptDir & '\KML.KML'

_XMLCreateFile($FILE, 'kml', True)
$myFile = _XMLFileOpen ($FILE)

_XMLCreateRootChild ( 'Document')
_XMLCreateChildWAttr( '/kml/Document', 'Style', 'id', 'secureStyle')
_XMLCreateChildNode ( '/kml/Document/Style', 'IconStyle')
_XMLCreateChildNode ( '/kml/Document/Style/IconStyle', 'scale', '.5') 
_XMLCreateChildNode ( '/kml/Document/Style/IconStyle', 'Icon') 
_XMLCreateChildNode ( '/kml/Document/Style/IconStyle/Icon', 'href', '                                                          ') 
_XMLCreateChildNode ( '/kml/Document', 'Folder') 
_XMLCreateChildNode ( '/kml/Document/Folder', 'description', 'Vistumbler - By Andrew Calcutt')
_XMLCreateChildNode ( '/kml/Document/Folder', 'name', 'Vistumbler v8.1 pre-release 1')
_XMLCreateChildNode ( '/kml/Document/Folder', 'Folder', '')
_XMLCreateChildNode ( '/kml/Document/Folder/Folder', 'name', 'Access Points')
_XMLCreateChildNode ( '/kml/Document/Folder/Folder', 'description', 'Access points found')
_XMLCreateChildNode ( '/kml/Document/Folder/Folder', 'Placemark')
_XMLCreateChildNode ( '/kml/Document/Folder/Folder/Placemark', 'name')
;_XMLCreateCDATA ( 'description', '<b>SSID: </b>dd-wrt<br /><b>Mac Address: </b>00:1A:70:75:E7:E6<br /><b>Network Type: </b>Infrastructure<br /><b>Radio Type: </b>802.11g<br /><b>Channel: </b>9<br /><b>Authentication: </b>Open<br /><b>Encryption: </b>None<br /><b>Basic Transfer Rates: </b>1 2 5.5 11<br /><b>Other Transfer Rates: </b>6 9 12 18 24 36 48 54<br /><b>First Active: </b>07-20-2008 11:28:01<br /><b>Last Updated: </b>07-20-2008 11:28:10<br /><b>Latitude: </b>N 42.0647900<br /><b>Longitude: </b>W 72.1229700<br /><b>Manufacturer: </b>Linksys<br /><b>Signal History: </b>15-0-10-0<br />')
_XMLCreateChildNode ( '/kml/Document/Folder/Folder/Placemark', 'description', '<![CDATA[<b>SSID: </b>dd-wrt<br /><b>Mac Address: </b>00:1A:70:75:E7:E6<br /><b>Network Type: </b>Infrastructure<br /><b>Radio Type: </b>802.11g<br /><b>Channel: </b>9<br /><b>Authentication: </b>Open<br /><b>Encryption: </b>None<br /><b>Basic Transfer Rates: </b>1 2 5.5 11<br /><b>Other Transfer Rates: </b>6 9 12 18 24 36 48 54<br /><b>First Active: </b>07-20-2008 11:28:01<br /><b>Last Updated: </b>07-20-2008 11:28:10<br /><b>Latitude: </b>N 42.0647900<br /><b>Longitude: </b>W 72.1229700<br /><b>Manufacturer: </b>Linksys<br /><b>Signal History: </b>15-0-10-0<br />]]>')
_XMLCreateChildNode ( '/kml/Document/Folder/Folder/Placemark', 'styleUrl', '#secureStyle')
_XMLCreateChildNode ( '/kml/Document/Folder/Folder/Placemark', 'Point')
_XMLCreateChildNode ( '/kml/Document/Folder/Folder/Placemark/Point', 'coordinates', '-72.1229700,42.0647900,0')

_XMLTransform($myFile)
_XMLSaveDoc($FILE)
