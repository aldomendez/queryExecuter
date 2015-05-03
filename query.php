<?php
require '../Slim/Slim.php';
include "../inc/database.php";

$app = new Slim();

$app->post('/', 'index' );

function index(){

    global $app;
    $body = $app->request()->getBody();
    $body = json_decode($body, true);
    // parse_str($body, $body);
    print_r( $body );

    $query = "select serial_num from carrier_site where carrier_serial_num = 'carrier'";
    // $DB = new MxOptix();
    // $DB->setQuery($query);
    // oci_execute($DB->statement);
    // $results = null;
    // oci_fetch_all($DB->statement, $results,0,-1,OCI_FETCHSTATEMENT_BY_COLUMN);
    // $json = $DB->json();
    
    // if ($json == "[]") {
    //     throw new Exception("No arrojo datos la base de datos", 1);
    // } else {
    //     echo implode(',', $results['SERIAL_NUM']);
    // }
    // $DB->close();
}

$app->run();
