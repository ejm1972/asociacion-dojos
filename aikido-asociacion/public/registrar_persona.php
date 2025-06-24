<?php
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin', 'dojo']);

// Obtener lista de dojos (solo si es admin)
$dojos = [];
if ($rol_actual === 'admin') {
    $dojos = $pdo->query("SELECT id, nombre FROM dojos ORDER BY nombre")->fetchAll();
} elseif ($rol_actual === 'dojo') {
    $stmt = $pdo->prepare("SELECT * FROM dojos WHERE id = ?");
    $stmt->execute([$dojo_actual]);
    $dojos = $stmt->fetchAll();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("INSERT INTO personas (nombre, apellido, email, telefono, dojo_id) VALUES (?, ?, ?, ?, ?)");

    $dojo_id = ($rol_actual === 'admin') ? $_POST['dojo_id'] : $dojo_actual;

    $stmt->execute([
        $_POST['nombre'],
        $_POST['apellido'],
        $_POST['email'],
        $_POST['telefono'],
        $dojo_id
    ]);

    header("Location: index.php");
    exit;
}

ob_start();
?>

<h2>Registrar nueva persona</h2>

<form method="post">
    <label>Nombre:</label><br>
    <input name="nombre" required><br><br>

    <label>Apellido:</label><br>
    <input name="apellido" required><br><br>

    <label>Email:</label><br>
    <input name="email"><br><br>

    <label>Teléfono:</label><br>
    <input name="telefono"><br><br>

    <?php if ($rol_actual === 'admin'): ?>
        <label>Dojo:</label><br>
        <select name="dojo_id" required>
            <option value="">-- Seleccionar dojo --</option>
            <?php foreach ($dojos as $dojo): ?>
                <option value="<?= $dojo['id'] ?>"><?= htmlspecialchars($dojo['nombre']) ?></option>
            <?php endforeach; ?>
        </select><br><br>
    <?php endif; ?>

    <button type="submit">Guardar persona</button>
</form>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');