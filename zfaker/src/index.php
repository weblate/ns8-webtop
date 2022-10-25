<?php
$json = file_get_contents('php://input');
$data = json_decode($json,true);
$cmd = __DIR__ ."/wrapper.sh -- {$data['params']}";
$out = shell_exec($cmd);
echo $out;
?>
