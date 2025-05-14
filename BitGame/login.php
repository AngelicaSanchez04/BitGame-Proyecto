<?php
session_start();
require 'db.php';

$correo = $_POST['correo_elect'] ?? '';
$nombre = $_POST['nombre'] ?? '';
$contrasena = $_POST['contrasena'] ?? '';

if (empty($correo) || empty($nombre) || empty($contrasena)) {
    die("Por favor completa todos los campos.");
}

$stmt = $conexion->prepare("SELECT Contrasena FROM Usuarios WHERE Correo_elect = ? AND Nombre = ?");
$stmt->bind_param("ss", $correo, $nombre);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows === 1) {
    $stmt->bind_result($hash);
    $stmt->fetch();

    if (password_verify($contrasena, $hash)) {
        $_SESSION['usuario'] = $nombre;
        header("Location: bienvenida.php");
        exit;
    } else {
        echo "Contraseña incorrecta.";
    }
} else {
    echo "Correo o nombre no encontrados.";
}

$stmt->close();
$conexion->close();
?>


