<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.LinkedList" %>
<%@page import = "usuarios.Usuario" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link 
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
        rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" 
        crossorigin="anonymous">
<%LinkedList<Usuario> usuarios=(LinkedList<Usuario>)request.getAttribute("usuarios"); %>


</head>
<body>
<div class="container">
<div class="row">
<div class="col">
<table class="table">
<thead>
<tr>
<th>ID</th>
<th>Nombre</th>
<th>Apellido</th>
<th>Mail</th>
<th>Rol</th>
<th>Supervisor</th>
<th><a href="altaUsuario.jsp" class="btn btn-primary">Crear usuario</a></tr>
</thead>
<tbody>
<%
if(usuarios!=null){
for(Usuario user :usuarios){ %>
<tr>
<td><%=user.getId()%></td>
<td><%=user.getNombre() %></td>
<td><%=user.getApellido()%></td>
<td><%=user.getMail()%></td>
<td><%=user.getRol()%></td>
<td><%=user.getUsuario()%></td>
<td><a href="UsuariosServlet?action=edit&id=<%= user.getId() %>" class="btn btn-secondary" >Editar</a></td>
<td><a href="UsuariosServlet?action=delete&id=<%= user.getId() %>" class="btn btn-danger">Borrar</a></td>
</tr>
<%}} %>
</tbody>




</table>

</div></div>
</div>

<script 
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
        integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+OYbI1YkF0UksdQRVvoxMfooAo9r" 
        crossorigin="anonymous"></script>
</body>
</html>