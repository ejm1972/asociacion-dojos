<?php
include('../includes/auth.php');
include('../config/db.php');

if ($rol_actual !== 'admin') {
    echo "Acceso denegado.";
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("INSERT INTO dojos (nombre, ciudad, pais) VALUES (?, ?, ?)");
    $stmt->execute([
        $_POST['nombre'],
        $_POST['ciudad'],
        $_POST['pais']
    ]);
    header("Location: dojos.php");
    exit;
}
?>

<h2>Crear nuevo dojo</h2>
<form method="post">
    <label>Nombre:</label><br>
    <input name="nombre" required><br><br>

    <label>Ciudad:</label><br>
    <input name="ciudad"><br><br>

    <label>País:</label><br>
    <input name="pais"><br><br>

    <button type="submit">Guardar</button>
</form>

<p><a href="dojos.php">Volver al listado</a></p>
