<%@page import="usuarios.Usuario"%>
<%@ page import="java.util.List, tareas.Tarea, proyectos.Proyecto, etapas.Etapa" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>Mis Tareas</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
        function toggleModal(nameModal) {
            const modal = document.getElementById(nameModal);
            modal.classList.toggle('hidden');
        }
    </script>
</head>
<body class="bg-gray-100 font-sans">
<jsp:include page="../header.jsp" />

<% 
    List<Tarea> tareas = (List<Tarea>) request.getAttribute("tareas");
	List<Etapa> etapas = (List<Etapa>) request.getAttribute("etapas");
    List<Proyecto> proyectos = (List<Proyecto>) request.getAttribute("proyectos");
    Usuario usuario = (Usuario) request.getAttribute("usuario");
%>

<div class="container mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6 lg:py-8">

    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex items-center gap-3">
            <div class="bg-indigo-100 p-3 rounded-lg">
                <svg class="w-6 h-6 sm:w-8 sm:h-8 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                 <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                </svg>
            </div>
            <div>
                <h1 class="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-800">Mis Tareas</h1>
                 <p class="text-sm sm:text-base text-gray-600">Tareas asignadas a <%= usuario.getNombre() %> <%= usuario.getApellido() %></p>
            </div>
        </div>
    </div>

    <% if (tareas.isEmpty()) { %>
        <div class="bg-white rounded-lg shadow p-8 text-center">
            <p class="text-gray-500">No tienes tareas asignadas.</p>
        </div>
    <% } else { %>
    
        <div class="bg-white rounded-lg shadow overflow-x-auto">
            <table class="w-full whitespace-nowrap">
                <thead class="bg-gray-50 border-b">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Proyecto</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Etapa</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tarea</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">F. Inicio</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">F. Fin</th>
                        <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider w-[150px]">Acciones</th>
                    </tr>
                </thead>
               <tbody class="bg-white divide-y divide-gray-200">
                <% 
                    for (int i = 0; i < tareas.size(); i++) { 
                        Tarea t = tareas.get(i);
                        Etapa e = etapas.get(i);
                        Proyecto p = proyectos.get(i); // Proyecto correspondiente

                        // Lógica de colores de Badge
                        String estado = t.getEstado();
                        String badgeClass = "bg-gray-100 text-gray-800";
                        if ("To Do".equals(estado)) {
                            badgeClass = "bg-yellow-100 text-yellow-800";
                        } else if ("In Progress".equals(estado)) {
                            badgeClass = "bg-blue-100 text-blue-800";
                        } else if ("Done".equals(estado)) {
                            badgeClass = "bg-green-100 text-green-800";
                        } else if ("Canceled".equals(estado)) {
                            badgeClass = "bg-red-100 text-red-800";
                        }
                %>
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4">
                            <div class="text-sm font-medium text-indigo-600">
                                <%= p.getNombre() %>
                            </div>
                        </td>

						<td class="px-6 py-4">
                            <div class="text-sm text-gray-600">
                                <%= e.getNombre() %>
                            </div>
                        </td>

                        <td class="px-6 py-4">
                            <div class="text-sm font-medium text-gray-900">
                                <%= t.getNombre() %>
                            </div>
                            <div class="text-xs text-gray-500 max-w-xs truncate">
                                <%= t.getDescripcion() != null ? t.getDescripcion() : "—"%>
                            </div>
                        </td>

                        <td class="px-6 py-4">
                            <span class="px-3 py-1 text-xs font-semibold rounded-full <%= badgeClass %>">
                                <%= estado %>
                            </span>
                        </td>

                        <td class="px-6 py-4 text-sm text-gray-600">
                            <%= t.getFechaInicio() %>
                        </td>

                        <td class="px-6 py-4 text-sm text-gray-600">
                            <%= t.getFechaFin() != null ? t.getFechaFin() : "—" %>
                        </td>

                        <td class="px-6 py-4 text-center whitespace-nowrap">
                            <a href="TareaServlet?action=detalle&idTarea=<%= t.getId() %>&idEtapa=<%= t.getIdEtapa() %>"
                               class="text-indigo-600 hover:text-indigo-900">
                                Ver Tarea
                            </a>
                            </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>

</div>

<jsp:include page="../horasTrabajadas/formulario.jsp" />

</body>
</html>