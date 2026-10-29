<?php
/**
 * Página de error personalizada para Apache (ErrorDocument en .htaccess).
 */

declare(strict_types=1);

$mensajes = [
    403 => ['Acceso prohibido', 'No tienes permiso para ver este recurso.'],
    404 => ['Página no encontrada', 'El recurso solicitado no existe en el servidor.'],
    500 => ['Error interno del servidor', 'Ocurrió un problema al procesar la solicitud.'],
];

$codigo = (int) ($_GET['codigo'] ?? 500);
if (!isset($mensajes[$codigo])) {
    $codigo = 500;
}
[$titulo, $detalle] = $mensajes[$codigo];

http_response_code($codigo);
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><?= $codigo ?> | <?= htmlspecialchars($titulo, ENT_QUOTES, 'UTF-8') ?></title>
  <link rel="stylesheet" href="/lab09-php/estilos.css">
</head>
<body>
  <main class="tarjeta">
    <span class="etiqueta php">PHP · Apache</span>
    <h1 class="error"><?= $codigo ?> · <?= htmlspecialchars($titulo, ENT_QUOTES, 'UTF-8') ?></h1>
    <p><?= htmlspecialchars($detalle, ENT_QUOTES, 'UTF-8') ?></p>
    <p class="pie"><a href="/lab09-php/index.html">← Volver al formulario</a></p>
  </main>
</body>
</html>
