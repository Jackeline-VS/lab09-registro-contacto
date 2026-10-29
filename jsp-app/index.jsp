<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lab 09 | Registro JSP</title>
  <link rel="stylesheet" href="estilos.css">
</head>
<body>
  <main class="tarjeta">
    <span class="etiqueta jsp">JSP · Tomcat</span>
    <h1>Formulario de Contacto</h1>
    <p class="subtitulo">Registra un contacto. Los datos se guardan en la sesión (HttpSession).</p>

    <form action="procesar.jsp" method="POST">
      <label for="nombre">Nombre</label>
      <input type="text" id="nombre" name="nombre" maxlength="60" required
             placeholder="Ej.: Jackeline Vivanco">

      <label for="correo">Correo electrónico</label>
      <input type="email" id="correo" name="correo" maxlength="100" required
             placeholder="Ej.: nombre@correo.com">

      <button type="submit">Registrar</button>
    </form>

    <p class="pie"><a href="registros.jsp">Ver registros guardados</a></p>
  </main>
</body>
</html>
