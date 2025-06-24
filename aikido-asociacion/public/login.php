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

        header("Location: index.php");
        exit;
    } else {
        $error = "Usuario o contraseña incorrectos.";
    }
}

// Contenido visual
ob_start();
?>

<?php if (isset($_GET['logout'])): ?>
    <div class="alerta alerta-info">
        ✅ Cerraste sesión correctamente.
    </div>
<?php elseif (isset($_GET['expirada'])): ?>
    <div class="alerta alerta-info">
        ⚠️ Tu sesión expiró por inactividad. Por favor, iniciá sesión nuevamente.
    </div>
<?php endif; ?>

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