<%@page import="usuarios.Usuario"%>
<%@ page import="java.util.List, tareas.Tarea, proyectos.Proyecto" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
        function toggleModal(nameModal) {
            const modal = document.getElementById(nameModal);
            modal.classList.toggle('hidden');
        }
    </script>
</head>
<body>
<jsp:include page="../header.jsp" />
<div class="container mx-auto p-6">
    <h1 class="text-2xl font-bold mb-6">Mis Tareas</h1>

    <% List<Tarea> tareas = (List<Tarea>) request.getAttribute("tareas"); 
    	List<Proyecto> proyectos = (List<Proyecto>) request.getAttribute("proyectos");
    	Usuario usuario = (Usuario) request.getAttribute("usuario");
    %>
    <% if (tareas.isEmpty()) { %>
        <p class="text-gray-500">No tienes tareas asignadas.</p>
    <% } else { %>
        <table class="min-w-full">
            
            <thead class="bg-gray-50 border-b">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Proyecto</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Etapa</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tarea</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Descripcion</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha inicio</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha fin</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                    </tr>
                </thead>
           <tbody class="bg-white divide-y divide-gray-200">
                    <% 
                        for (int i = 0; i < tareas.size(); i++) { 
                            Tarea t = tareas.get(i);
                            Proyecto p = proyectos.get(i); // Proyecto correspondiente
                    %>
                        <tr class="hover:bg-gray-50">
                            <!-- NOMBRE DEL PROYECTO -->
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm font-medium text-indigo-600">
                                    <%= p.getNombre() %>
                                </div>
                            </td>

                            <!-- ETAPA (solo ID por ahora, puedes mejorarlo luego) -->
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm text-gray-900">
                                    <%= t.getIdEtapa() %>
                                </div>
                            </td>

                            <!-- NOMBRE DE LA TAREA -->
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="text-sm font-medium text-gray-900">
                                    <%= t.getNombre() %>
                                </div>
                            </td>

                            <!-- DESCRIPCIÓN -->
                            <td class="px-6 py-4">
                                <div class="text-sm text-gray-600 max-w-xs truncate">
                                    <%= t.getDescripcion() != null ? t.getDescripcion() : "—"%>
                                </div>
                            </td>

                            <!-- ESTADO -->
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                                    <%= "To Do".equals(t.getEstado()) ? "bg-yellow-100 text-yellow-800" :
                                        "In Progress".equals(t.getEstado()) ? "bg-blue-100 text-blue-800" :
                                        "Done".equals(t.getEstado()) ? "bg-green-100 text-green-800" :
                                        "bg-red-100 text-red-800" %>">
                                    <%= t.getEstado() %>
                                </span>
                            </td>

                            <!-- FECHA INICIO -->
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                <%= t.getFechaInicio() %>
                            </td>

                            <!-- FECHA FIN -->
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                <% if (t.getFechaFin() != null) { %>
                                    <%= t.getFechaFin() %>
                                <% } else { %>
                                    <span class="text-gray-400">—</span>
                                <% } %>
                            </td>

                            <!-- ACCIONES -->
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <a href="HoraTrabajadaServlet?action=new&idTarea=<%= t.getId() %>&idEmpleado=<%= usuario.getId() %>&origin=mis-tareas"
                                   class="text-indigo-600 hover:text-indigo-900">
                                    Agregar horas
                                </a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
        </table>
    <% } %>
<jsp:include page="../horasTrabajadas/formulario.jsp" />

</div>
</body>
</html>