<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Fragmento reutilizable: tabla de registros de la sesión (protegido dentro de WEB-INF) --%>
<c:set var="registros" value="${sessionScope.registros}"/>
<h2>Registros almacenados (${empty registros ? 0 : registros.size()})</h2>

<c:choose>
  <c:when test="${empty registros}">
    <p class="vacio">Aún no hay registros en esta sesión.</p>
  </c:when>
  <c:otherwise>
    <table>
      <thead>
        <tr><th>#</th><th>Nombre</th><th>Correo</th><th>Fecha</th></tr>
      </thead>
      <tbody>
        <c:forEach var="r" items="${registros}" varStatus="st">
          <tr>
            <td>${st.count}</td>
            <td><c:out value="${r.nombre}"/></td>
            <td><c:out value="${r.correo}"/></td>
            <td><c:out value="${r.fecha}"/></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:otherwise>
</c:choose>
