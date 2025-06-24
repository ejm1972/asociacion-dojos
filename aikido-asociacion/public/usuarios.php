<?php 
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin']);


// obtener lista de usuarios
$usuarios = $pdo->query("
    SELECT u.*, d.nombre AS dojo_nombre 
    FROM usuarios u
    LEFT JOIN dojos d ON u.dojo_id = d.id
")->fetchAll();

// obtener lista de dojos
$dojos = $pdo->query("SELECT id, nombre FROM dojos")->fetchAll();

// guardar nuevo usuario
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $rol = $_POST['rol'];
    $dojo_id = $_POST['dojo_id'] !== '' ? $_POST['dojo_id'] : null;

    if ($_POST['password'] !== '') {
        $hash = password_hash($_POST['password'], PASSWORD_DEFAULT);

        if (isset($_POST['id']) && $_POST['id'] !== '') {
            // actualizar usuario existente
            $stmt = $pdo->prepare("UPDATE usuarios SET username = ?, password = ?, rol = ?, dojo_id = ? WHERE id = ?");
            $stmt->execute([$username, $hash, $rol, $dojo_id, $_POST['id']]);
        } else {
            // crear nuevo
            $stmt = $pdo->prepare("INSERT INTO usuarios (username, password, rol, dojo_id) VALUES (?, ?, ?, ?)");
            $stmt->execute([$username, $hash, $rol, $dojo_id]);
        }
    } else {
        // actualizar sin cambiar contraseña
        $stmt = $pdo->prepare("UPDATE usuarios SET username = ?, rol = ?, dojo_id = ? WHERE id = ?");
        $stmt->execute([$username, $rol, $dojo_id, $_POST['id']]);
    }

    header("Location: usuarios.php");
    exit;
}

// editar usuario
$editar = null;
if (isset($_GET['editar'])) {
    $stmt = $pdo->prepare("SELECT * FROM usuarios WHERE id = ?");
    $stmt->execute([$_GET['editar']]);
    $editar = $stmt->fetch();
}

ob_start();
?>

<h2>Usuarios</h2>
<a href="registrar_usuario.php">➕ Crear nuevo usuario</a>
<table border="1">
    <tr>
        <th>Usuario</th>
        <th>Rol</th>
        <th>Dojo</th>
        <th>Acción</th>
    </tr>
    <?php foreach ($usuarios as $u): ?>
        <tr>
            <td><?= $u['username'] ?></td>
            <td><?= $u['rol'] ?></td>
            <td><?= $u['dojo_nombre'] ?? '-' ?></td>
            <td><a href="editar_usuario.php?id=<?= $usuario['id'] ?>">Editar</a></td>
        </tr>
    <?php endforeach; ?>
</table>

<h3><?= $editar ? "Editar Usuario" : "Nuevo Usuario" ?></h3>
<form method="post">
    <?php if ($editar): ?>
        <input type="hidden" name="id" value="<?= $editar['id'] ?>">
    <?php endif; ?>

    <label>Usuario:</label>
    <input name="username" required value="<?= $editar['username'] ?? '' ?>"><br>

    <label>Contraseña:</label>
    <input type="password" name="password" <?= $editar ? '' : 'required' ?>>
    <?= $editar ? "<small>Dejar en blanco para no cambiar</small>" : "" ?><br>

    <label>Rol:</label>
    <select name="rol" required>
        <?php foreach (['admin', 'dojo', 'lector'] as $rol): ?>
            <option value="<?= $rol ?>" <?= ($editar['rol'] ?? '') === $rol ? 'selected' : '' ?>><?= ucfirst($rol) ?></option>
        <?php endforeach; ?>
    </select><br>

    <label>Dojo asignado (opcional):</label>
    <select name="dojo_id">
        <option value="">-- Ninguno --</option>
        <?php foreach ($dojos as $dojo): ?>
            <option value="<?= $dojo['id'] ?>" <?= ($editar['dojo_id'] ?? '') == $dojo['id'] ? 'selected' : '' ?>>
                <?= $dojo['nombre'] ?>
            </option>
        <?php endforeach; ?>
    </select><br>

    <button type="submit"><?= $editar ? "Actualizar" : "Crear" ?></button>
</form>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');