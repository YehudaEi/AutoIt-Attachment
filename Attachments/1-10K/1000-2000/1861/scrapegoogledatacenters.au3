#Include <Array.au3>
#include <Misc.au3>
Global $results
;the website to check
Global $website = 'autoitscript.com'
;all of Google's datacenters
$DCs = StringSplit('64.233.161.99,64.233.161.104,64.233.161.105,64.233.161.147,64.233.167.99,64.233.167.104,64.233.167.147,64.233.171.99,64.233.171.104,64.233.171.105,64.233.171.147,64.233.179.99,64.233.179.99,64.233.183.99,64.233.183.104,64.233.185.99,64.233.185.104,64.233.187.99,64.233.187.104,64.233.189.104,66.102.7.104,66.102.7.105,66.102.7.147,66.102.9.104,66.102.11.104,216.239.37.104,216.239.37.105,216.239.37.147,216.239.39.104,216.239.53.104,216.239.57.98,216.239.57.104,216.239.57.105,216.239.57.147,216.239.59.104,216.239.59.105,216.239.63.104', ',')
For $loop = 1 To $DCs[0]
	;the scraping code. i found very small unique before and after strings which are optimal.
	Global $pagesingoogle = _ScreenScrape ('http://' & $DCs[$loop] & '/search?hl=en&q=site%3A' & $website & '&btnG=Google+Search', 't <b>', '</b> f')
	;update $results to equal the datacenter, a colon, the number of pages, and a line break for every iteration
	$results = $results & @CRLF & $DCs[$loop] & ' : ' & $pagesingoogle
Next
ClipPut($results)