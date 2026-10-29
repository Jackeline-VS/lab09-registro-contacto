<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // procesar.jsp — Recibe el formulario, valida, guarda en HttpSession y responde.
    // Flujo: validar método → leer parámetros → validar → guardar → responder.

    // 1) Validar método HTTP: solo POST (si no, 405 Method Not Allowed)
    if (!"POST".equals(request.getMethod())) {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.setHeader("Allow", "POST");
        request.setAttribute("estado", 405);
    } else {
        // 2) Leer parámetros en UTF-8 (para tildes y ñ) y limpiar espacios
        request.setCharacterEncoding("UTF-8");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        nombre = (nombre == null) ? "" : nombre.trim();
        correo = (correo == null) ? "" : correo.trim();

        // 3) Validar
        List<String> errores = new ArrayList<String>();

        if (nombre.isEmpty()) {
            errores.add("El nombre es obligatorio.");
        } else if (nombre.length() < 2 || nombre.length() > 60) {
            errores.add("El nombre debe tener entre 2 y 60 caracteres.");
        } else if (!nombre.matches("^[\\p{L} .'-]+$")) {
            // Solo letras (incluye tildes y ñ), espacios, punto, apóstrofo y guion
            errores.add("El nombre «" + nombre + "» contiene caracteres no permitidos.");
        }

        if (correo.isEmpty()) {
            errores.add("El correo es obligatorio.");
        } else if (correo.length() > 100
                || !correo.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errores.add("El correo «" + correo + "» no tiene un formato válido.");
        }

        if (!errores.isEmpty()) {
            // Datos inválidos → 400 Bad Request
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("estado", 400);
            request.setAttribute("errores", errores);
        } else {
            // 4) Guardar en la sesión
            @SuppressWarnings("unchecked")
            List<Map<String, String>> registros =
                    (List<Map<String, String>>) session.getAttribute("registros");
            if (registros == null) {
                registros = new ArrayList<Map<String, String>>();
            }

            SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            formato.setTimeZone(TimeZone.getTimeZone("America/Lima"));

            Map<String, String> registro = new HashMap<String, String>();
            registro.put("nombre", nombre);
            registro.put("correo", correo);
            registro.put("fecha", formato.format(new Date()));
            registros.add(registro);

            session.setAttribute("registros", registros);

            // 5) Respuesta: 201 Created + datos para la vista
            response.setStatus(HttpServletResponse.SC_CREATED);
            request.setAttribute("estado", 201);
            request.setAttribute("nombre", nombre);
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lab 09 | Resultado JSP</title>
  <link rel="stylesheet" href="estilos.css">
</head>
<body>
  <main class="tarjeta ancha">
    <span class="etiqueta jsp">JSP · Tomcat</span>

    <c:choose>
      <c:when test="${estado == 405}">
        <h1 class="error">405 · Método no permitido</h1>
        <p>Este recurso solo acepta peticiones <strong>POST</strong> desde el formulario.</p>
      </c:when>

      <c:when test="${estado == 400}">
        <h1 class="error">400 · Datos inválidos</h1>
        <ul class="errores">
          <%-- <c:out> escapa < > & " ' → prevención de XSS --%>
          <c:forEach var="err" items="${errores}">
            <li><c:out value="${err}"/></li>
          </c:forEach>
        </ul>
      </c:when>

      <c:otherwise>
        <h1 class="ok">✔ Registro guardado</h1>
        <p>Se registró a <strong><c:out value="${nombre}"/></strong> correctamente.</p>
        <jsp:include page="WEB-INF/tabla.jsp"/>
      </c:otherwise>
    </c:choose>

    <p class="pie"><a href="index.jsp">← Volver al formulario</a></p>
  </main>
</body>
</html>
