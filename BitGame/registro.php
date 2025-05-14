<?php
require 'db.php';

$nombre = $_POST['nombre'] ?? '';
$apellido_pat = $_POST['apellido_pat'] ?? '';
$apellido_mat = $_POST['apellido_mat'] ?? '';
$correo_elect = $_POST['correo_elect'] ?? '';
$telefono = $_POST['telefono'] ?? '';
$fecha_nacimiento = $_POST['fecha_nacimiento'] ?? '';
$pais_region = $_POST['pais_region'] ?? '';
$contrasena = $_POST['contrasena'] ?? '';

if (
    empty($nombre) || empty($apellido_pat) || empty($apellido_mat) ||
    empty($correo_elect) || empty($telefono) || empty($fecha_nacimiento) ||
    empty($pais_region) || empty($contrasena)
) {
    die("Por favor completa todos los campos.");
}

$hash = password_hash($contrasena, PASSWORD_DEFAULT);

$stmt = $conexion->prepare("INSERT INTO Usuarios (Nombre, Apellido_Mat, Apellido_Pat, Correo_elect, Telefono, Fecha_Nacimiento, Pais_Region, Contrasena) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
$stmt->bind_param("ssssssss", $nombre, $apellido_mat, $apellido_pat, $correo_elect, $telefono, $fecha_nacimiento, $pais_region, $hash);

if ($stmt->execute()) {
    echo "Registro exitoso. <a href='login.html'>Inicia sesión aquí</a>.";
} else {
    echo "Error al registrar: " . $conexion->error;
}

$stmt->close();
$conexion->close();
?>