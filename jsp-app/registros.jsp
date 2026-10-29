<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // registros.jsp — Muestra (GET) los registros de la sesión. POST con accion=limpiar los vacía.
    if ("POST".equals(request.getMethod()) && "limpiar".equals(request.getParameter("accion"))) {
        session.removeAttribute("registros");
        response.setStatus(HttpServletResponse.SC_SEE_OTHER); // 303: patrón Post/Redirect/Get
        response.setHeader("Location", "registros.jsp");
        return;
    }
    if (!"GET".equals(request.getMethod())) {
        response.setHeader("Allow", "GET, POST");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lab 09 | Registros JSP</title>
  <link rel="stylesheet" href="estilos.css">
</head>
<body>
  <main class="tarjeta ancha">
    <span class="etiqueta jsp">JSP · Tomcat</span>
    <h1>Registros de la sesión</h1>
    <p class="subtitulo">ID de sesión: <code><c:out value="${pageContext.session.id.substring(0, 8)}"/>…</code></p>

    <jsp:include page="WEB-INF/tabla.jsp"/>

    <form method="POST" class="en-linea">
      <input type="hidden" name="accion" value="limpiar">
      <button type="submit" class="secundario">Vaciar registros</button>
    </form>

    <p class="pie"><a href="index.jsp">← Volver al formulario</a></p>
  </main>
</body>
</html>
