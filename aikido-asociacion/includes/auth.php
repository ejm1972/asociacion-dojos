<?php
session_start();
if (!isset($_SESSION['usuario'])) {
    header('Location: login.php');
    exit;
}
$usuario_actual = $_SESSION['usuario'];
$rol_actual = $_SESSION['rol'];
$dojo_actual = $_SESSION['dojo_id'] ?? null;
?>