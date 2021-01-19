<?
$dir = 'V:\htdocs\loader\files\system';
if ($handle = opendir($dir)) {
	while (false !== ($file = readdir($handle))) {
		if ($file != "." && $file != ".." && $file != "GameGuard") {
$hash = strtoupper(md5_file($dir.'/'.$file));
echo "$file:$hash|";
}}}
	closedir($handle);
?>