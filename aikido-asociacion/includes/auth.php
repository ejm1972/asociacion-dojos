<?php
session_start();

// Tiempo máximo de inactividad (en segundos)
define('TIEMPO_MAXIMO_INACTIVIDAD', 20 * 60); // 20 minutos

if (isset($_SESSION['ultimo_acceso'])) {
    $inactivo = time() - $_SESSION['ultimo_acceso'];
    if ($inactivo > TIEMPO_MAXIMO_INACTIVIDAD) {
        session_unset();
        session_destroy();
        header("Location: ../login.php?expirada=1");
        exit;
    }
}
$_SESSION['ultimo_acceso'] = time();

// Asegurar que el usuario esté logueado
if (!isset($_SESSION['usuario'])) {
    header("Location: ../login.php");
    exit;
}

// Variables comunes
$usuario_actual = $_SESSION['usuario'];
$rol_actual = $_SESSION['rol'] ?? 'lector';
$dojo_actual = $_SESSION['dojo_id'] ?? null;
