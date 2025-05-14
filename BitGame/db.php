<?php
$conexion = new mysqli("localhost", "root", "", "steamex");

if ($conexion->connect_error) {
    die("Conexión fallida: " . $conexion->connect_error);
}
?>


