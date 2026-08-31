<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$conexion = mysqli_connect(
    "localhost",
    "root",
    "",
    "floristería",
    3307
);

if (!$conexion) {
    echo json_encode(["error" => "No se pudo conectar a la base de datos"]);
    exit();
}

$idPedido = $_GET["idPedido"] ?? "";

$sql = "SELECT * FROM pedido WHERE idPedido = ?";

$stmt = mysqli_prepare($conexion, $sql);

mysqli_stmt_bind_param(
    $stmt,
    "i",
    $idPedido
);

mysqli_stmt_execute($stmt);

$resultado = mysqli_stmt_get_result($stmt);

$pedido = mysqli_fetch_assoc($resultado);

if ($pedido) {
    echo json_encode($pedido);
} else {
    echo json_encode([
        "error" => "Pedido no encontrado"
    ]);
}

mysqli_close($conexion);

?>