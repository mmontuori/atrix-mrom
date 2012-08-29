<?php
	$ip = $_GET['ip'];
	$build = $_GET['build'];
	$device_id = $_GET['device_id'];
	$con = mysql_connect('XXXXXXXXX','XXXXXXXXX','XXXXXXXX');
	if (!$con)
	{
		die('Could not connect: ' . mysql_error());
	}
	if ( $ip == null ) {
		die ("Error IP variable cannot be null");
	}	
	if ( $build == null ) {
		die ("Error BUILD variable cannot be null");
	}	
	mysql_select_db("montuorinet", $con);
	$sql="INSERT INTO mrom_checkin (ip, build, device_id)
	VALUES
	('$ip','$build','$device_id')";

	if (!mysql_query($sql,$con))
  	{
  		die('Error: ' . mysql_error());
  	}

	$sql="SELECT * FROM mrom_conf";
	$rows = array();
	if (!mysql_query($sql,$con))
        {
                die('Error: ' . mysql_error());
        }
	while($r = mysql_fetch_assoc($sth)) {
	    $rows[] = $r;
	}
	mysql_close($conn);
	print json_encode($rows);
?>
