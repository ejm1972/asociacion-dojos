<?php
function requiere_rol($roles_permitidos) {
    global $rol_actual;
    if (!in_array($rol_actual, (array)$roles_permitidos)) {
        echo "<h3>❌ Acceso denegado. No tenés permiso para ver esta sección.</h3>";
        exit;
    }
}
