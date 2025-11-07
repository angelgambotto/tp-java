<%@ page import="java.util.List, tareas.Tarea" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdn.tailwindcss.com"></script>

</head>
<body>
<jsp:include page="../header.jsp" />
<div class="container mx-auto p-6">
    <h1 class="text-2xl font-bold mb-6">Mis Tareas</h1>

    <% List<Tarea> tareas = (List<Tarea>) request.getAttribute("tareas"); %>
    <% if (tareas.isEmpty()) { %>
        <p class="text-gray-500">No tienes tareas asignadas.</p>
    <% } else { %>
        <table class="min-w-full">
            <thead><tr><th>Nombre</th><th>Etapa</th><th>Estado</th><th>Fin</th></tr></thead>
            <tbody>
            <% for (Tarea t : tareas) { %>
                <tr>
                    <td><%= t.getNombre() %></td>
                    <td><%= t.getIdEtapa() %></td>
                    <td><%= t.getEstado() %></td>
                    <td><%= t.getFechaFin() %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
</div>
</body>
</html>