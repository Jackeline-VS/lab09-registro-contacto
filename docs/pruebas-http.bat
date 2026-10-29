@echo off
REM ============================================================
REM  Lab 09 - Pruebas HTTP automaticas (PHP y JSP) con curl
REM  Uso: ejecutar con Apache (8080) y Tomcat (8081) encendidos
REM ============================================================
chcp 65001 >nul
set PHP=http://localhost:8080/lab09-php
set JSP=http://localhost:8081/lab09-jsp

echo.
echo ================== PHP (Apache :8080) ==================
curl -s -o NUL -w "[P1] GET  index.html               esperado 200 -> %%{http_code}\n" %PHP%/index.html
curl -s -o NUL -w "[P2] GET  procesar.php (no POST)   esperado 405 -> %%{http_code}\n" %PHP%/procesar.php
curl -s -o NUL -w "[P3] POST nombre con script (XSS)  esperado 400 -> %%{http_code}\n" -X POST -d "nombre=<script>alert(1)</script>&correo=a@b.com" %PHP%/procesar.php
curl -s -o NUL -w "[P4] POST correo invalido          esperado 400 -> %%{http_code}\n" -X POST -d "nombre=Ana&correo=xx" %PHP%/procesar.php
curl -s -o NUL -w "[P5] POST campos vacios            esperado 400 -> %%{http_code}\n" -X POST -d "nombre=&correo=" %PHP%/procesar.php
curl -s -o NUL -w "[P6] POST datos validos            esperado 201 -> %%{http_code}\n" -X POST -d "nombre=Ana Perez&correo=ana@uncp.edu.pe" %PHP%/procesar.php
curl -s -o NUL -w "[P7] GET  recurso inexistente      esperado 404 -> %%{http_code}\n" %PHP%/no-existe.php
curl -s -o NUL -w "[P8] GET  funciones.php (bloqueado) esperado 403 -> %%{http_code}\n" %PHP%/funciones.php

echo.
echo ================== JSP (Tomcat :8081) ==================
curl -s -o NUL -w "[J1] GET  index.jsp                esperado 200 -> %%{http_code}\n" %JSP%/index.jsp
curl -s -o NUL -w "[J2] GET  procesar.jsp (no POST)   esperado 405 -> %%{http_code}\n" %JSP%/procesar.jsp
curl -s -o NUL -w "[J3] POST nombre con script (XSS)  esperado 400 -> %%{http_code}\n" -X POST -d "nombre=<script>alert(1)</script>&correo=a@b.com" %JSP%/procesar.jsp
curl -s -o NUL -w "[J4] POST correo invalido          esperado 400 -> %%{http_code}\n" -X POST -d "nombre=Ana&correo=xx" %JSP%/procesar.jsp
curl -s -o NUL -w "[J5] POST campos vacios            esperado 400 -> %%{http_code}\n" -X POST -d "nombre=&correo=" %JSP%/procesar.jsp
curl -s -o NUL -w "[J6] POST datos validos            esperado 201 -> %%{http_code}\n" -X POST -d "nombre=Ana Perez&correo=ana@uncp.edu.pe" %JSP%/procesar.jsp
curl -s -o NUL -w "[J7] GET  recurso inexistente      esperado 404 -> %%{http_code}\n" %JSP%/no-existe.jsp
curl -s -o NUL -w "[J8] GET  WEB-INF/web.xml (oculto) esperado 404 -> %%{http_code}\n" %JSP%/WEB-INF/web.xml

echo.
echo ========== Evidencia XSS: el script vuelve ESCAPADO ==========
echo --- PHP ---
curl -s -X POST -d "nombre=<script>alert(1)</script>&correo=a@b.com" %PHP%/procesar.php | findstr /c:"&lt;script&gt;" >nul && echo OK: PHP devuelve ^&lt;script^&gt; (no ejecutable) || echo REVISAR: no se encontro el texto escapado en PHP
echo --- JSP ---
curl -s -X POST -d "nombre=<script>alert(1)</script>&correo=a@b.com" %JSP%/procesar.jsp | findstr /c:"&lt;script&gt;" >nul && echo OK: JSP devuelve ^&lt;script^&gt; (no ejecutable) || echo REVISAR: no se encontro el texto escapado en JSP
echo.
