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

$sql = "INSERT INTO dojos (
    nombre, ciudad, provincia, pais, direccion,
    fecha_inicio, rama_dependencia, fecha_ingreso_ada,
    responsable_admin_id, celular, mail, observaciones
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $pdo->prepare($sql);
$stmt->execute([
    $_POST['nombre'], $_POST['ciudad'], $_POST['provincia'], $_POST['pais'], $_POST['direccion'],
    $_POST['fecha_inicio'], $_POST['rama_dependencia'], $_POST['fecha_ingreso_ada'],
    $_POST['responsable_admin_id'], $_POST['celular'], $_POST['mail'], $_POST['observaciones']
]);

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

<label>Fecha de Inicio de Actividades:</label>
<input type="date" name="fecha_inicio"><br>

<label>Rama de Dependencia:</label>
<input type="text" name="rama_dependencia"><br>

<label>Fecha de Ingreso a ADA:</label>
<input type="date" name="fecha_ingreso_ada"><br>

<label>Instructor Responsable Administrativo:</label>
<select name="responsable_admin_id">
  <option value="">-- Seleccionar Persona --</option>
  <?php
  require_once 'includes/db.php';
  $stmt = $pdo->query("SELECT id, nombre, apellido FROM personas ORDER BY apellido");
  while ($row = $stmt->fetch()) {
    echo "<option value=\"{$row['id']}\">{$row['apellido']}, {$row['nombre']}</option>";
  }
  ?>
</select><br>

<label>Celular:</label>
<input type="text" name="celular"><br>

<label>Mail:</label>
<input type="email" name="mail"><br>

<label>Observaciones:</label><br>
<textarea name="observaciones" rows="3" cols="40"></textarea><br>

    <button type="submit">Guardar dojo</button>
</form>

<?php
$contenido = ob_get_clean();
include('../includes/layout.php');