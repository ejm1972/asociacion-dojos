<?php
include('../includes/auth.php');
include('../config/db.php');

if ($rol_actual !== 'admin') {
    echo "Acceso denegado.";
    exit;
}

if (!isset($_GET['id'])) {
    header("Location: index.php");
    exit;
}

$id = (int)$_GET['id'];

$stmt = $pdo->prepare("SELECT * FROM dojos WHERE id = ?");
$stmt->execute([$id]);
$dojo = $stmt->fetch();

if (!$dojo) {
    echo "Dojo no encontrado.";
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("UPDATE dojos SET nombre = ?, ciudad = ?, pais = ? WHERE id = ?");
    $stmt->execute([
        $_POST['nombre'],
        $_POST['ciudad'],
        $_POST['pais'],
        $id
    ]);
    header("Location: index.php");
    exit;
}
?>

<h2>Editar Dojo</h2>
<form method="post">
    <label>Nombre:</label>
    <input name="nombre" value="<?= htmlspecialchars($dojo['nombre']) ?>" required><br>

    <label>Ciudad:</label>
    <input name="ciudad" value="<?= htmlspecialchars($dojo['ciudad']) ?>"><br>

    <label>País:</label>
    <input name="pais" value="<?= htmlspecialchars($dojo['pais']) ?>"><br>

    <button type="submit">Guardar cambios</button>
</form>
