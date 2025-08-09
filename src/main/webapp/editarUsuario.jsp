<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="UsuariosServlet" method="post">
    <input type="hidden" name="id" value="${usuario.id}" />
    Nombre: <input type="text" name="nombre" value="${usuario.nombre}" required /><br/>
    Apellido: <input type="text" name="apellido" value="${usuario.apellido}" required /><br/>
    Mail: <input type="email" name="mail" value="${usuario.mail}" required /><br/>
    Clave: <input type="password" name="clave" value="${usuario.clave}" required /><br/>
    Rol: <input type="text" name="rol" value="${usuario.rol}" required /><br/>
    Supervisor: <input type="text" name="usuario" value="${usuario.usuario}" required /><br/>
    <input type="submit" value="Guardar Cambios" />
</form>

</body>
</html>