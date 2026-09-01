<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

$conexion = mysqli_connect("localhost", "root", "", "floristeria", 3307);

if (!$conexion) {
    echo json_encode(["error" => "No se pudo conectar a la base de datos: " . mysqli_connect_error()]);
    exit();
}

mysqli_set_charset($conexion, "utf8mb4");

$sql = "SELECT * FROM producto";
$resultado = mysqli_query($conexion, $sql);

if ($resultado) {
    $productos = [];
    while ($fila = mysqli_fetch_assoc($resultado)) {
        $productos[] = $fila;
    }
    echo json_encode($productos);
} else {
    echo json_encode(["error" => "Error al obtener los productos"]);
}

mysqli_close($conexion);
?>