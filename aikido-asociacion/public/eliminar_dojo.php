<?php
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin']);

if (!isset($_GET['id'])) {
    header("Location: index.php");
    exit;
}

$id = (int)$_GET['id'];

// Antes de eliminar, podrías agregar validación para que no haya personas vinculadas a ese dojo.

$stmt = $pdo->prepare("DELETE FROM dojos WHERE id = ?");
$stmt->execute([$id]);

header("Location: index.php");
exit;
