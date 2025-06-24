<?php
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin']);

$id = $_GET['id'] ?? null;
if (!$id) {
    echo "ID de usuario no especificado.";
    exit;
}

// Buscar datos actuales del usuario
$stmt = $pdo->prepare("SELECT * FROM usuarios WHERE id = ?");
$stmt->execute([$id]);
$usuario = $stmt->fetch();

if (!$usuario) {
    echo "Usuario no encontrado.";
    exit;
}

$dojos = $pdo->query("SELECT id, nombre FROM dojos ORDER BY nombre")->fetchAll();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $query = "UPDATE usuarios SET username = ?, rol = ?, dojo_id = ?";
    $params = [$_POST['username'], $_POST['rol'], $_POST['dojo_id'] ?: null];

    if (!empty($_POST['password'])) {
        $query .= ", password = ?";
        $params[] = md5($_POST['password']);
    }

    $query .= " WHERE id = ?";
    $params[] = $id;

    $stmt = $pdo->prepare($query);
    $stmt->execute($params);

    header("Location: usuarios.php");
    exit;
}

ob_start();
?>

<h2>Editar usuario</h2>

<form method="post">
    <label>Usuario:</label><br>
    <input name="username" value="<?= htmlspecialchars($usuario['username']) ?>" required><br><br>

    <label>Nueva contraseña (opcional):</label><br>
    <input name="password" type="password"><br><br>

    <label>Rol:</label><br>
    <select name="rol" required>
        <?php foreach (['admin', 'dojo', 'lector'] as $rol): ?>
            <option value="<?= $rol ?>" <?= $usuario['rol'] === $rol ? 'selected' : '' ?>><?= $rol ?></option>
        <?php endforeach; ?>
    </select><br><br>

    <label>Dojo (opcional):</label><br>
    <select name="dojo_id">
        <option value="">-- Ninguno --</option>
        <?php foreach ($dojos as $dojo): ?>
            <option value="<?= $dojo['id'] ?>" <?= $usuario['dojo_id'] == $dojo['id'] ? 'selected' : '' ?>>
                <?= htmlspecialchars($dojo['nombre']) ?>
            </option>
        <?php endforeach; ?>
    </select><br><br>

    <button type="submit">Guardar cambios</button>
</form>

<p><a href="usuarios.php">Volver al listado</a></p>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');