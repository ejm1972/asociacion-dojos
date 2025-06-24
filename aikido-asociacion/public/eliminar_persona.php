<?php
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin', 'dojo']);

if (!isset($_GET['id'])) {
    header("Location: index.php");
    exit;
}

$id = (int)$_GET['id'];

$stmt = $pdo->prepare("DELETE FROM personas WHERE id = ?");
$stmt->execute([$id]);

header("Location: index.php");
exit;
