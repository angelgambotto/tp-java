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

<input type="text" name="nombre" placeholder="Ingrese su nombre" required><br/>
<input type="text" name="apellido" placeholder="Ingrese su apellido" required><br/>
<input type="password" name="clave" placeholder="Ingrese su contraseña" required><br/>
<input type="email" name="mail" placeholder="Ingrese su mail" required><br/>
<input type="text" name="rol" placeholder="Ingrese su rol" required><br/>
<input type="text" name="usuario" placeholder="Ingrese su supervisor" required><br/>
<input type="submit" value="Guardar">

</form>
</body>
</html>