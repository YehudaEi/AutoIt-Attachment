<?php
if($_GET["clear"]==1){
$fp = fopen("com.con", "w");
fwrite($fp, "");
fclose($fp);
};
if($_GET["textout"]==1){
$fp = fopen("com.con", "r");
$read = fread($fp,1000);
fclose($fp);
echo $read;
};
if ($_GET['textin']!=""){
$textin = $_GET['textin'];
$fp = fopen("com.con", "w");
fwrite($fp, $textin);
fclose($fp);
};
php?>