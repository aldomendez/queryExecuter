<?php
require '../Slim/Slim.php';
include "../inc/database.php";

$app = new Slim();

$app->post('/', 'index' );

function index(){

    try {
        
        $DB = new MxOptix();

        global $app;
        $body = $app->request()->getBody();
        $body = json_decode($body, true);
        // print_r($body);
        $DB->setQuery($body['query']);
        $results = null;
        oci_execute($DB->statement);
        oci_fetch_all($DB->statement, $results,0,-1,OCI_FETCHSTATEMENT_BY_ROW);
        // print_r($results);
        // print_r($results);
        echo array2csv($results). PHP_EOL;
        $DB->close();
    } catch (Exception $e) {
        $DB->close();
        echo ('Caught exception: '.  $e->getMessage(). "\n");
    }
}


function array2csv($array) {
    $ans = '';
    $start = true;
    $head = array();
    foreach($array as $key => $value) {
        if ($start) {
            foreach ($value as $key2 => $value2) {
                array_push($head, $key2);
            }
            $ans .= '"' . implode('","', $head) . '"' . PHP_EOL;
            $start = false;
        }
        $ans .= implode(',', $value) . PHP_EOL;
    }
    return $ans;
}

$app->run();
