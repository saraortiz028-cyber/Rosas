<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$conexion = mysqli_connect("localhost", "root", "", "floristería", 3307);

if (!$conexion) {
    echo json_encode(["error" => "No se pudo conectar a la base de datos"]);
    exit();
}

$sql = "SELECT * FROM producto";

$resultado = mysqli_query($conexion, $sql);

$productos = [];

while ($fila = mysqli_fetch_assoc($resultado)) {
    $productos[] = $fila;
}

echo json_encode($productos);

mysqli_close($conexion);

?>