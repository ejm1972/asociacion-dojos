<?php
session_start();
require_once('../config/db.php');

// Procesar login
$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("SELECT * FROM usuarios WHERE username = ?");
    $stmt->execute([$_POST['username']]);
    $usuario = $stmt->fetch();

    if ($usuario && password_verify($_POST['password'], $usuario['password'])) {
        $_SESSION['usuario'] = $usuario['username'];
        $_SESSION['rol'] = $usuario['rol'];
        $_SESSION['dojo_id'] = $usuario['dojo_id'] ?? null;

        header("Location: menu.php");
        exit;
    } else {
        $error = "Usuario o contraseña incorrectos.";
    }
}

// Contenido visual
ob_start();
?>

<h2>Iniciar sesión</h2>

<?php if ($error): ?>
    <p style="color: red;"><?= htmlspecialchars($error) ?></p>
<?php endif; ?>

<form method="post">
    <label>Usuario:</label><br>
    <input type="text" name="username" required><br><br>

    <label>Contraseña:</label><br>
    <input type="password" name="password" required><br><br>

    <button type="submit">Entrar</button>
</form>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');

// <form method="post">
//     <input name="username" placeholder="Usuario" required>
//     <input type="password" name="password" placeholder="Contraseña" required>
//     <button type="submit">Ingresar</button>
// </form>
// <?php if (isset($error)) echo "<p>$error</p>"; ?>