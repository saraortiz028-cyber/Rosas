<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// Manejo de petición pre-flight OPTIONS
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

$conexion = mysqli_connect(
    "localhost",
    "root",
    "",
    "floristeria",
    3307
);

if (!$conexion) {
    echo json_encode(["error" => "No se pudo conectar a la base de datos: " . mysqli_connect_error()]);
    exit();
}

// Asegurar codificación UTF-8 para evitar problemas con acentos o caracteres especiales
mysqli_set_charset($conexion, "utf8mb4");

$idPedido = $_GET["idPedido"] ?? "";

if (empty($idPedido)) {
    echo json_encode(["error" => "ID de pedido no proporcionado"]);
    mysqli_close($conexion);
    exit();
}

$sql = "SELECT * FROM pedido WHERE idPedido = ?";
$stmt = mysqli_prepare($conexion, $sql);

if ($stmt) {
    mysqli_stmt_bind_param($stmt, "i", $idPedido);
    mysqli_stmt_execute($stmt);
    $resultado = mysqli_stmt_get_result($stmt);
    $pedido = mysqli_fetch_assoc($resultado);

    if ($pedido) {
        echo json_encode($pedido);
    } else {
        echo json_encode(["error" => "Pedido no encontrado"]);
    }
    mysqli_stmt_close($stmt);
} else {
    echo json_encode(["error" => "Error en la consulta"]);
}

mysqli_close($conexion);
?>