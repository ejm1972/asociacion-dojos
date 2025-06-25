<?php
include('../includes/auth.php');
include('../config/db.php');
require_once('../includes/rol.php');

requiere_rol(['admin']);

if (!isset($_GET['id'])) {
    header("Location: dojos.php");
    exit;
}

$id = (int)$_GET['id'];

// Obtener datos para llenar el formulario
$stmt = $pdo->prepare("SELECT * FROM dojos WHERE id = ?");
$stmt->execute([$id]);
$dojo = $stmt->fetch();

$fecha_inicio = $dojo['fecha_inicio'];
$rama = $dojo['rama_dependencia'];
$ingreso_ada = $dojo['fecha_ingreso_ada'];
$responsable = $dojo['responsable_admin_id'];
$celular = $dojo['celular'];
$mail = $dojo['mail'];
$obs = $dojo['observaciones'];

if (!$dojo) {
    echo "Dojo no encontrado.";
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $stmt = $pdo->prepare("UPDATE dojos SET nombre = ?, ciudad = ?, pais = ? WHERE id = ?");
    $stmt->execute([
        $_POST['nombre'],
        $_POST['ciudad'],
        $_POST['pais'],
        $id
    ]);
    header("Location: index.php");
    exit;
}

$sql = "UPDATE dojos SET
    nombre = ?, ciudad = ?, provincia = ?, pais = ?, direccion = ?,
    fecha_inicio = ?, rama_dependencia = ?, fecha_ingreso_ada = ?,
    responsable_admin_id = ?, celular = ?, mail = ?, observaciones = ?
    WHERE id = ?";

$stmt = $pdo->prepare($sql);
$stmt->execute([
    $_POST['nombre'], $_POST['ciudad'], $_POST['provincia'], $_POST['pais'], $_POST['direccion'],
    $_POST['fecha_inicio'], $_POST['rama_dependencia'], $_POST['fecha_ingreso_ada'],
    $_POST['responsable_admin_id'], $_POST['celular'], $_POST['mail'], $_POST['observaciones'],
    $_POST['id']
]);

ob_start();
?>

<h2>Editar Dojo</h2>
<form method="post">
    <label>Nombre:</label>
    <input name="nombre" value="<?= htmlspecialchars($dojo['nombre']) ?>" required><br>

    <label>Ciudad:</label>
    <input name="ciudad" value="<?= htmlspecialchars($dojo['ciudad']) ?>"><br>

    <label>País:</label>
    <input name="pais" value="<?= htmlspecialchars($dojo['pais']) ?>"><br>

<label>Fecha de Inicio de Actividades:</label>
<input type="date" name="fecha_inicio" value="<?= $fecha_inicio ?>"><br>

<label>Rama de Dependencia:</label>
<input type="text" name="rama_dependencia" value="<?= $rama ?>"><br>

<label>Fecha de Ingreso a ADA:</label>
<input type="date" name="fecha_ingreso_ada" value="<?= $ingreso_ada ?>"><br>

<label>Instructor Responsable Administrativo:</label>
<select name="responsable_admin_id">
  <option value="">-- Seleccionar Persona --</option>
  <?php
  $stmt = $pdo->query("SELECT id, nombre, apellido FROM personas ORDER BY apellido");
  while ($row = $stmt->fetch()) {
    $selected = ($row['id'] == $responsable) ? 'selected' : '';
    echo "<option value=\"{$row['id']}\" $selected>{$row['apellido']}, {$row['nombre']}</option>";
  }
  ?>
</select><br>

<label>Celular:</label>
<input type="text" name="celular" value="<?= $celular ?>"><br>

<label>Mail:</label>
<input type="email" name="mail" value="<?= $mail ?>"><br>

<label>Observaciones:</label><br>
<textarea name="observaciones" rows="3" cols="40"><?= $obs ?></textarea><br>

    <button type="submit">Guardar cambios</button>
</form>

<h3>Instructores Asignados</h3>

<?php
$stmt = $pdo->prepare("
    SELECT p.nombre, p.apellido, ipd.rol, ipd.grado, ipd.desde_fecha
    FROM instructores_por_dojo ipd
    JOIN personas p ON ipd.persona_id = p.id
    WHERE ipd.dojo_id = ?
    ORDER BY ipd.rol
");
$stmt->execute([$dojo['id']]);
$instructores = $stmt->fetchAll();

if ($instructores):
?>
<table border="1" cellpadding="5">
    <tr>
        <th>Nombre</th><th>Rol</th><th>Grado</th><th>Desde</th>
    </tr>
    <?php foreach ($instructores as $i): ?>
        <tr>
            <td><?= $i['apellido'] ?>, <?= $i['nombre'] ?></td>
            <td><?= $i['rol'] ?></td>
            <td><?= $i['grado'] ?></td>
            <td><?= $i['desde_fecha'] ?></td>

            <td>
  <a href="eliminar_instructor.php?id=<?= $i['id'] ?>&dojo_id=<?= $dojo['id'] ?>" onclick="return confirm('¿Eliminar este instructor?')">❌</a>
</td>

    Asegurate de que el SELECT también devuelva ipd.id para que $i['id'] funcione:

SELECT ipd.id, p.nombre, p.apellido, ipd.rol, ipd.grado, ipd.desde_fecha

        </tr>
    <?php endforeach; ?>
</table>
<?php else: ?>
<p>No hay instructores asignados aún.</p>
<?php endif; ?>

<a href="asignar_instructor.php?dojo_id=<?= $dojo['id'] ?>">➕ Asignar Instructor</a>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');