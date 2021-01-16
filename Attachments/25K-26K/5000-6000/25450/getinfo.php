<?php
$fn = $_GET["file"];
$fh = fopen($fn, 'w') or die("can't open file");
$username = $_GET["username"];
fwrite($fh, "Username: ".$username."\n");
$ip = $_GET["ip"];
fwrite($fh, "IP Address: ".$ip."\n");
$computername = $_GET["computername"];
fwrite($fh, "Computer Name: ".$computername."\n");
$date = $_GET["date"];
fwrite($fh, "Date of Message Sent: ".$date."\n");
$time = $_GET["time"];
fwrite($fh, "Time Message Sent: ".$time."\n");
fclose($fh);
?>