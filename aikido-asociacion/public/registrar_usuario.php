<?php
include('../includes/auth.php');
include('../config/db.php');

if ($rol_actual !== 'admin') {
    echo "Acceso denegado.";
    exit;
}

$dojos = $pdo->query("SELECT id, nombre FROM dojos ORDER BY nombre")->fetchAll();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("INSERT INTO usuarios (username, password, rol, dojo_id) VALUES (?, ?, ?, ?)");

    $hashed_password = md5($_POST['password']); // Podés reemplazar con password_hash en producción

    $stmt->execute([
        $_POST['username'],
        $hashed_password,
        $_POST['rol'],
        $_POST['dojo_id'] ?: null
    ]);

    header("Location: usuarios.php");
    exit;
}
?>

<h2>Registrar nuevo usuario</h2>

<form method="post">
    <label>Usuario:</label><br>
    <input name="username" required><br><br>

    <label>Contraseña:</label><br>
    <input name="password" type="password" required><br><br>

    <label>Rol:</label><br>
    <select name="rol" required>
        <option value="admin">admin</option>
        <option value="dojo">dojo</option>
        <option value="lector">lector</option>
    </select><br><br>

    <label>Dojo (opcional):</label><br>
    <select name="dojo_id">
        <option value="">-- Ninguno --</option>
        <?php foreach ($dojos as $dojo): ?>
            <option value="<?= $dojo['id'] ?>"><?= htmlspecialchars($dojo['nombre']) ?></option>
        <?php endforeach; ?>
    </select><br><br>

    <button type="submit">Crear usuario</button>
</form>

<p><a href="usuarios.php">Volver al listado</a></p>

<?php
include('../includes/auth.php');
include('../config/db.php');

if ($rol_actual !== 'admin') {
    echo "Acceso denegado.";
    exit;
}

$dojos = $pdo->query("SELECT id, nombre FROM dojos ORDER BY nombre")->fetchAll();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("INSERT INTO usuarios (username, password, rol, dojo_id) VALUES (?, ?, ?, ?)");

    $hashed_password = password_hash($_POST['password'], PASSWORD_DEFAULT); // O usar password_hash() para mayor seguridad

    $stmt->execute([
        $_POST['username'],
        $hashed_password,
        $_POST['rol'],
        $_POST['dojo_id'] ?: null
    ]);

    header("Location: usuarios.php");
    exit;
}
?>

<h2>Registrar nuevo usuario</h2>

<form method="post">
    <label>Usuario:</label><br>
    <input name="username" required><br><br>

    <label>Contraseña:</label><br>
    <input name="password" type="password" required><br><br>

    <label>Rol:</label><br>
    <select name="rol" required>
        <option value="admin">admin</option>
        <option value="dojo">dojo</option>
        <option value="lector">lector</option>
    </select><br><br>

    <label>Dojo (opcional):</label><br>
    <select name="dojo_id">
        <option value="">-- Ninguno --</option>
        <?php foreach ($dojos as $dojo): ?>
            <option value="<?= $dojo['id'] ?>"><?= htmlspecialchars($dojo['nombre']) ?></option>
        <?php endforeach; ?>
    </select><br><br>

    <button type="submit">Crear usuario</button>
</form>

<p><a href="usuarios.php">Volver al listado</a></p>
