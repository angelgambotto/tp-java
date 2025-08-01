<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="categoriaTarea.CategoriaTarea" %>

<html>
<head>
    <title>ABM Categoría Tarea</title>
</head>
<body>
    <h2>Agregar / Editar Categoría</h2>
    <form action="CategoriaTareaServlet" method="post">
        <input type="hidden" name="id" value="${param.id}" />
        Nombre: <input type="text" name="nombre" value="${param.nombre}" required /><br/>
        Descripción: <input type="text" name="descripcion" value="${param.descripcion}" required /><br/>
        <input type="submit" value="Guardar" />
    </form>

    <h2>Listado de Categorías</h2>
    <table border="1">
        <tr>
            <th>ID</th><th>Nombre</th><th>Descripción</th><th>Acciones</th>
        </tr>
        <%
            List<CategoriaTarea> categorias = (List<CategoriaTarea>) request.getAttribute("categorias");
            if (categorias != null) {
                for (CategoriaTarea cat : categorias) {
        %>
        <tr>
            <td><%= cat.getId() %></td>
            <td><%= cat.getNombre() %></td>
            <td><%= cat.getDescripcion() %></td>
            <td>
                <a href="CategoriaTareaServlet?action=edit&id=<%= cat.getId() %>">Editar</a>
                <a href="CategoriaTareaServlet?action=delete&id=<%= cat.getId() %>">Eliminar</a>
            </td>
        </tr>
        <%      }
            }
        %>
    </table>
</body>
</html>
