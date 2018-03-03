<?php

    // error_reporting(~E_ALL & ~E_DEPRECATED &  ~E_NOTICE);

    // Report all warnings and errors
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    define('DBHOST', '192.168.4.2');
    define('DBUSER', 'read_localino');
    define('DBPASS', 'localino');
    define('DBNAME', 'localino');

    $connect = mysqli_connect(DBHOST, DBUSER, DBPASS, DBNAME);

    if (mysqli_connect_errno()) {
        echo '<p>Verbindung zum MySQL Server fehlgeschlagen: '.mysqli_connect_error().'</p>';
    }

    // localhost
    $db_host_local = '192.168.4.2';
    $db_name_local = 'localino';
    $db_user_local = 'read_localino';
    $db_password_local = 'localino';
    $charset_local = "charset=utf8";

    $pdo = new PDO("mysql:host=$db_host_local;dbname=$db_name_local", $db_user_local, $db_password_local);

?>