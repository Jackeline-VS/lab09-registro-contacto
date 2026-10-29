<?php
/**
 * procesar.php — Recibe el formulario, valida, sanitiza y guarda en $_SESSION.
 * Flujo: validar método → leer y sanitizar → validar → guardar → responder.
 */

declare(strict_types=1);
require __DIR__ . '/funciones.php';

iniciar_sesion();

// 1) Validar método HTTP: solo se acepta POST (si no, 405 Method Not Allowed)
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    header('Allow: POST');
    cabecera('405 | Método no permitido');
    echo '<h1 class="error">405 · Método no permitido</h1>';
    echo '<p>Este recurso solo acepta peticiones <strong>POST</strong> desde el formulario.</p>';
    pie();
    exit;
}

// 2) Leer y sanitizar entradas (trim + quitar caracteres de control)
$nombre = trim((string) filter_input(INPUT_POST, 'nombre', FILTER_UNSAFE_RAW, FILTER_FLAG_STRIP_LOW));
$correo = trim((string) filter_input(INPUT_POST, 'correo', FILTER_SANITIZE_EMAIL));

// 3) Validar
$errores = [];

if ($nombre === '') {
    $errores[] = 'El nombre es obligatorio.';
} elseif (mb_strlen($nombre) < 2 || mb_strlen($nombre) > 60) {
    $errores[] = 'El nombre debe tener entre 2 y 60 caracteres.';
} elseif (!preg_match("/^[\p{L} .'-]+$/u", $nombre)) {
    // Solo letras (incluye tildes y ñ), espacios, punto, apóstrofo y guion
    $errores[] = 'El nombre «' . e($nombre) . '» contiene caracteres no permitidos.';
}

if ($correo === '') {
    $errores[] = 'El correo es obligatorio.';
} elseif (strlen($correo) > 100 || filter_var($correo, FILTER_VALIDATE_EMAIL) === false) {
    $errores[] = 'El correo «' . e($correo) . '» no tiene un formato válido.';
}

// Si hay errores → 400 Bad Request
if ($errores) {
    http_response_code(400);
    cabecera('400 | Datos inválidos');
    echo '<h1 class="error">400 · Datos inválidos</h1><ul class="errores">';
    foreach ($errores as $err) {
        echo '<li>' . $err . '</li>'; // los valores del usuario ya vienen escapados con e()
    }
    echo '</ul>';
    pie();
    exit;
}

// 4) Guardar en la sesión
$_SESSION['registros'][] = [
    'nombre' => $nombre,
    'correo' => $correo,
    'fecha'  => date('d/m/Y H:i:s'),
];

// 5) Respuesta estructurada: confirmación + tabla de registros
http_response_code(201); // 201 Created: se creó un nuevo registro
cabecera('Lab 09 | Registro guardado');
echo '<h1 class="ok">✔ Registro guardado</h1>';
echo '<p>Se registró a <strong>' . e($nombre) . '</strong> correctamente.</p>';
tabla_registros(obtener_registros());
pie();
