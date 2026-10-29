<?php
/**
 * Funciones compartidas del Sistema de Registro de Contacto (PHP).
 */

declare(strict_types=1);

date_default_timezone_set('America/Lima'); // hora de Perú para la fecha de registro

/** Inicia la sesión con cookies más seguras (HttpOnly + SameSite). */
function iniciar_sesion(): void
{
    if (session_status() === PHP_SESSION_NONE) {
        session_set_cookie_params([
            'httponly' => true,     // JavaScript no puede leer la cookie de sesión
            'samesite' => 'Strict', // la cookie no viaja en peticiones de otros sitios
        ]);
        session_start();
    }
}

/** Escapa texto para HTML (prevención de XSS). */
function e(string $texto): string
{
    return htmlspecialchars($texto, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

/** Devuelve los registros guardados en la sesión. */
function obtener_registros(): array
{
    return $_SESSION['registros'] ?? [];
}

/** Imprime la cabecera HTML común. */
function cabecera(string $titulo): void
{
    echo '<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8">';
    echo '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
    echo '<title>' . e($titulo) . '</title>';
    echo '<link rel="stylesheet" href="/lab09-php/estilos.css"></head><body>';
    echo '<main class="tarjeta ancha"><span class="etiqueta php">PHP · Apache</span>';
}

/** Imprime el pie HTML común. */
function pie(): void
{
    echo '<p class="pie"><a href="/lab09-php/index.html">← Volver al formulario</a></p>';
    echo '</main></body></html>';
}

/** Imprime la tabla de registros (cada valor se escapa antes de mostrarse). */
function tabla_registros(array $registros): void
{
    echo '<h2>Registros almacenados (' . count($registros) . ')</h2>';

    if (count($registros) === 0) {
        echo '<p class="vacio">Aún no hay registros en esta sesión.</p>';
        return;
    }

    echo '<table><thead><tr><th>#</th><th>Nombre</th><th>Correo</th><th>Fecha</th></tr></thead><tbody>';
    foreach ($registros as $i => $r) {
        echo '<tr>';
        echo '<td>' . ($i + 1) . '</td>';
        echo '<td>' . e($r['nombre']) . '</td>';
        echo '<td>' . e($r['correo']) . '</td>';
        echo '<td>' . e($r['fecha']) . '</td>';
        echo '</tr>';
    }
    echo '</tbody></table>';
}
