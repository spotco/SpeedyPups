<?php

/*
CREATE DATABASE spotco_speedypups_tracking;

USE spotco_speedypups_tracking;
CREATE TABLE event(
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
   event INT NOT NULL,
   uid VARCHAR(255),
   val1 VARCHAR(255),
   val2 VARCHAR(255),
   val3 VARCHAR(255),
   created TIMESTAMP DEFAULT NOW()
);

USE spotco_speedypups_tracking;
INSERT INTO `event`(`uid`, `event`) VALUES (1,1);

USE spotco_speedypups_tracking;
SELECT `id`, `uid`, `event`,`val1`,`val2`,`val3`, `created` FROM `event`;
*/
function db_connect() {
    try {
        $db = new PDO("mysql:host=localhost;dbname=spotco_speedypups_tracking", "spotco_sql", "dododo" );
        return $db;
    } catch(PDOException $e) {
        die($e->getMessage());
    }
}

if (!isset($_REQUEST["uid"]) || !isset($_REQUEST["event"])) {
    print_r($_REQUEST);
    die("error params");
}

$db = db_connect();

$stmt = $db->prepare('INSERT INTO `event`(`uid`, `event`, `val1`, `val2`, `val3` ) VALUES (:uid,:event,:val1,:val2,:val3)');
$stmt->execute( 
  array(
    ':uid'=>$_REQUEST["uid"],
    ':event'=>$_REQUEST["event"],
    ':val1'=>isset($_REQUEST["val1"])?$_REQUEST["val1"]:"",
    ':val2'=>isset($_REQUEST["val2"])?$_REQUEST["val2"]:"",
    ':val3'=>isset($_REQUEST["val3"])?$_REQUEST["val3"]:""
  ) 
);
echo "request ok";
?>