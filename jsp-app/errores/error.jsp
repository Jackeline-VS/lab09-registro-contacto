<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         isErrorPage="true" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Página de error personalizada (configurada en WEB-INF/web.xml) --%>
<c:set var="codigo" value="${pageContext.errorData.statusCode}"/>
<c:choose>
  <c:when test="${codigo == 404}"><c:set var="titulo" value="Página no encontrada"/><c:set var="detalle" value="El recurso solicitado no existe en el servidor."/></c:when>
  <c:when test="${codigo == 405}"><c:set var="titulo" value="Método no permitido"/><c:set var="detalle" value="El recurso no acepta este método HTTP."/></c:when>
  <c:when test="${codigo == 403}"><c:set var="titulo" value="Acceso prohibido"/><c:set var="detalle" value="No tienes permiso para ver este recurso."/></c:when>
  <c:otherwise><c:set var="titulo" value="Error interno del servidor"/><c:set var="detalle" value="Ocurrió un problema al procesar la solicitud."/></c:otherwise>
</c:choose>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${codigo} | ${titulo}</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos.css">
</head>
<body>
  <main class="tarjeta">
    <span class="etiqueta jsp">JSP · Tomcat</span>
    <h1 class="error">${codigo} · ${titulo}</h1>
    <p>${detalle}</p>
    <p class="pie"><a href="${pageContext.request.contextPath}/index.jsp">← Volver al formulario</a></p>
  </main>
</body>
</html>
