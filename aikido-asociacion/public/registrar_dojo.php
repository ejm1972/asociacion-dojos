<?php
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin']);

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

ob_start();
?>

<h2>Registrar nuevo dojo</h2>
<form method="post">
    <label>Nombre:</label><br>
    <input name="nombre" required><br><br>

    <label>Ciudad:</label><br>
    <input name="ciudad"><br><br>

    <label>País:</label><br>
    <input name="pais"><br><br>

    <button type="submit">Guardar dojo</button>
</form>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');