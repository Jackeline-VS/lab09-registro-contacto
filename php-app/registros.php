<?php
/**
 * registros.php — Muestra (GET) los registros guardados en la sesión.
 * Con POST y accion=limpiar vacía la lista.
 */

declare(strict_types=1);
require __DIR__ . '/funciones.php';

iniciar_sesion();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['accion'] ?? '') === 'limpiar') {
    $_SESSION['registros'] = [];
    header('Location: registros.php', true, 303); // patrón Post/Redirect/Get
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    header('Allow: GET, POST');
    exit('Método no permitido');
}

cabecera('Lab 09 | Registros');
echo '<h1>Registros de la sesión</h1>';
echo '<p class="subtitulo">ID de sesión: <code>' . e(substr(session_id(), 0, 8)) . '…</code></p>';
tabla_registros(obtener_registros());
echo '<form method="POST" class="en-linea"><input type="hidden" name="accion" value="limpiar">';
echo '<button type="submit" class="secundario">Vaciar registros</button></form>';
pie();
