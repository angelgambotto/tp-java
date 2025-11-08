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
            
            <thead class="bg-gray-50 border-b">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nombre</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Descripcion</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Etapa</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha inicio</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha fin</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                    </tr>
                </thead>
            <tbody>
            <% for (Tarea t : tareas) { %>
                <tr>
                <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900"><%= t.getNombre() %></div> 
               </td>
               <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900"><%= t.getDescripcion() %></div> 
               </td>
               <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900"><%= t.getIdEtapa() %></div> 
               </td>
               <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900"><%= t.getEstado() %></div> 
               </td>
               <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900"><%= t.getFechaInicio() %></div> 
               </td>
               <td class="px-6 py-4 whitespace-nowrap">
                      <div class="text-sm font-medium text-gray-900">
                      <% if(t.getFechaFin()!= null){ %>
                      <%= t.getFechaFin() %>
                      <%} else{
                    	  %>
                    	  ---</div> 
                      <% }%>
               </td>
               <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <a href="/"
                                   class="text-indigo-600 hover:text-indigo-900 mr-4">
                                    Editar
                                </a>
                                <a href="/"
                                   class="text-indigo-600 hover:text-indigo-900">
                                    Agregar horas
                                </a>
                            </td>
                   
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
</div>
</body>
</html>