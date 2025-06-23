<?php
include('../includes/auth.php');
include('../config/db.php');

if (!in_array($rol_actual, ['admin', 'dojo'])) {
    echo "Acceso denegado.";
    exit;
}

if (!isset($_GET['id'])) {
    header("Location: index.php");
    exit;
}

$id = (int)$_GET['id'];

$stmt = $pdo->prepare("DELETE FROM personas WHERE id = ?");
$stmt->execute([$id]);

header("Location: index.php");
exit;
