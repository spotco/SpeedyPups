<?php
$DATE_FORMAT = "m-d-Y";
$today = new DateTime("now");
$tomorrow = new DateTime("+1 day");
$tomorrow->setTime(0,0,0);
$time_remaining = $tomorrow->diff($today,true);
echo json_encode(array(
	'remain_h'=>$time_remaining->format("%h"),
	'remain_m'=>$time_remaining->format("%i"),
	'remain_s'=>$time_remaining->format("%s"),
	'remain'=>date_create('@0')->add($time_remaining)->getTimestamp(),
	'today'=>$today->format($DATE_FORMAT), 
	'tomorrow'=>$tomorrow->format($DATE_FORMAT)
));
?>