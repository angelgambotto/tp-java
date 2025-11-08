<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="tareas.Tarea" %>
<%@ page import="etapas.Etapa" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>Etapa - Tareas</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<%
    Etapa etapa = (Etapa) request.getAttribute("etapa");
    List<Tarea> tareas = (List<Tarea>) request.getAttribute("tareas");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<div class="container mx-auto px-4 py-8 max-w-6xl">

  
    <% if (etapa != null) { %>
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <h1 class="text-2xl font-bold text-gray-800"><%= etapa.getNombre() %></h1>
            <p class="text-gray-600">ID Etapa: <%= etapa.getId() %></p>
        </div>
    <% } else { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
            Etapa no encontrada
        </div>
    <% } %>

  
    <% if (etapa != null) { %>
        <div class="mb-6">
            
                <button onclick="window.location.href='TareaServlet?action=new&idEtapa=<%= etapa.getId() %>'" class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg shadow transition">
                    + Nueva Tarea
                </button>
            
        </div>
    <% } %>

    
    <div class="bg-white rounded-lg shadow overflow-hidden">

        <% if (tareas == null || tareas.isEmpty()) { %>
            <div class="p-8 text-center text-gray-500">
                No hay tareas creadas aún.
            </div>

        <% } else { %>

            <table class="w-full">
                <thead class="bg-gray-50 border-b">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tarea</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fechas</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                    </tr>
                </thead>

                <tbody class="bg-white divide-y divide-gray-200">
                    <% for (Tarea t : tareas) { %>
                        <tr class="hover:bg-gray-50 transition"
                            >

                           
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div>
                                    <div class="text-sm font-medium text-gray-900"><%= t.getNombre() %></div>
                                    <% if (t.getDescripcion() != null && !t.getDescripcion().isEmpty()) { %>
                                        <div class="text-sm text-gray-500"><%= t.getDescripcion() %></div>
                                    <% } %>
                                </div>
                            </td>

                            
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
                                    <%= "To Do".equals(t.getEstado()) ? "bg-yellow-100 text-yellow-800" :
                                        "In Progress".equals(t.getEstado()) ? "bg-blue-100 text-blue-800" :
                                        "Done".equals(t.getEstado()) ? "bg-green-100 text-green-800" :
                                        "bg-red-100 text-red-800" %>">
                                    <%= t.getEstado() %>
                                </span>
                            </td>

                          
                            <td class="px-6 py-4 text-sm text-gray-600">
                                <div><strong>Inicio:</strong> <%= t.getFechaInicio() != null ? sdf.format(t.getFechaInicio()) : "—"%></div>
                               
                                <div><strong>Fin:</strong> <%= t.getFechaFin() != null ? sdf.format(t.getFechaFin()) : "—"%></div>
                            </td>

                           
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <a href="TareaServlet?action=edit&idTarea=<%= t.getId() %>&idEtapa=<%= etapa.getId() %>"
                                   class="text-indigo-600 hover:text-indigo-900 mr-4">
                                    Editar
                                </a>

                               <form action="TareaServlet" method="post" style="display:inline" onsubmit="return confirm('¿Eliminar tarea <%= t.getNombre() %>?');">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="idTarea" value="<%= t.getId() %>">
    <input type="hidden" name="idEtapa" value="<%= etapa.getId() %>">
    <button type="submit" class="text-red-600 hover:text-red-900 bg-transparent border-0 p-0 cursor-pointer">
        Eliminar
    </button>
</form>

                            </td>

                        </tr>
                    <% } %>
                </tbody>
            </table>

        <% } %>
    </div>
</div>

<jsp:include page="../tareas/formulario.jsp" />
<script>
function toggleModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.classList.toggle("hidden");
}


<% if (request.getAttribute("abrirModal") != null) { %>
    window.onload = () => toggleModal("modalFormTarea");
<% } %>
</script>


</body>
</html>

