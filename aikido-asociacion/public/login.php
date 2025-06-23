<?php
session_start();
include('../config/db.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("SELECT * FROM usuarios WHERE username = ?");
    $stmt->execute([$_POST['username']]);
    $user = $stmt->fetch();

    if ($user && password_verify($_POST['password'], $user['password'])) {
        $_SESSION['usuario'] = $user['username'];
        $_SESSION['rol'] = $user['rol'];
        $_SESSION['dojo_id'] = $user['dojo_id'];
        header('Location: index.php');
        exit;
    } else {
        $error = "Usuario o contraseña incorrectos.";
    }
}
?>

<form method="post">
    <input name="username" placeholder="Usuario" required>
    <input type="password" name="password" placeholder="Contraseña" required>
    <button type="submit">Ingresar</button>
</form>
<?php if (isset($error)) echo "<p>$error</p>"; ?>
