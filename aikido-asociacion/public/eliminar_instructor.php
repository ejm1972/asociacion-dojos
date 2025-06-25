<?php
require_once 'includes/db.php';

$id = $_GET['id'] ?? null;
$dojo_id = $_GET['dojo_id'] ?? null;

if ($id && $dojo_id) {
    $stmt = $pdo->prepare("DELETE FROM instructores_por_dojo WHERE id = ?");
    $stmt->execute([$id]);
}

header("Location: editar_dojo.php?id=$dojo_id");
exit;
