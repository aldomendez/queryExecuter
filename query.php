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

    // $query = "";
    $DB = new MxOptix();
    $DB->setQuery($body['query']);
    echo $body['query'];
    oci_execute($DB->statement);
    $results = null;
    oci_fetch_all($DB->statement, $results,0,-1,OCI_FETCHSTATEMENT_BY_ROW);
    // $json = $DB->json();
    print_r($results);
    echo PHP_EOL;
    // if ($json == "[]") {
    //     throw new Exception("No arrojo datos la base de datos", 1);
    // } else {
    //     echo implode(',', $results['SERIAL_NUM']);
    // }
    $DB->close();
}

$app->run();
