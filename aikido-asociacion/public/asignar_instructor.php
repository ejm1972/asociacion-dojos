<?php
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin']);

$dojo_id = $_GET['dojo_id'] ?? null;

if (!$dojo_id) {
    echo "ID de dojo no especificado.";
    exit;
}

// Obtener dojo
$stmt = $pdo->prepare("SELECT nombre FROM dojos WHERE id = ?");
$stmt->execute([$dojo_id]);
$dojo = $stmt->fetch();

// Validar que no haya ya un 'principal' en ese dojo
if ($rol === 'principal') {
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM instructores_por_dojo WHERE dojo_id = ? AND rol = 'principal'");
    $stmt->execute([$dojo_id]);
    $ya_existe = $stmt->fetchColumn();

    if ($ya_existe > 0) {
        echo "⚠️ Ya hay un instructor principal asignado a este dojo.";
        echo "<br><a href='editar_dojo.php?id=$dojo_id'>Volver</a>";
        exit;
    }
}

// Obtener personas para elegir
$personas = $pdo->query("SELECT id, nombre, apellido FROM personas ORDER BY apellido")->fetchAll();

$dojo_id = $_POST['dojo_id'];
$persona_id = $_POST['persona_id'];
$rol = $_POST['rol'];
$grado = $_POST['grado'] ?? null;
$desde_fecha = $_POST['desde_fecha'] ?? null;

$sql = "INSERT INTO instructores_por_dojo 
    (dojo_id, persona_id, rol, grado, desde_fecha) 
    VALUES (?, ?, ?, ?, ?)";

$stmt = $pdo->prepare($sql);
$stmt->execute([$dojo_id, $persona_id, $rol, $grado, $desde_fecha]);

header("Location: editar_dojo.php?id=$dojo_id");
exit;

?>

<h2>Asignar Instructor a: <?= htmlspecialchars($dojo['nombre']) ?></h2>

<form method="post" action="procesar_asignacion_instructor.php">
    <input type="hidden" name="dojo_id" value="<?= $dojo_id ?>">

    <label>Persona:</label>
    <select name="persona_id" required>
        <option value="">-- Seleccionar --</option>
        <?php foreach ($personas as $p): ?>
            <option value="<?= $p['id'] ?>"><?= $p['apellido'] ?>, <?= $p['nombre'] ?></option>
        <?php endforeach; ?>
    </select><br>

    <label>Rol:</label>
    <select name="rol" required>
        <option value="">-- Seleccionar --</option>
        <option value="principal">Principal</option>
        <option value="adjunto">Adjunto</option>
        <option value="administrativo">Administrativo</option>
    </select><br>

    <label>Grado:</label>
    <input type="text" name="grado"><br>

    <label>Desde:</label>
    <input type="date" name="desde_fecha"><br>

    <button type="submit">Asignar Instructor</button>
</form>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');