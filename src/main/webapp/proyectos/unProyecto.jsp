<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="proyectos.Proyecto" %>
<%@ page import="etapas.Etapa" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>Proyecto - Etapas</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        function toggleModal(modalId) {
            const modal = document.getElementById(modalId);
            modal.classList.toggle('hidden');
        }

        // Cerrar modal al hacer clic fuera
        window.onclick = function(e) {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                if (e.target === modal) {
                    modal.classList.add('hidden');
                }
            });
        }
    </script>
</head>
<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<%
    Proyecto pro = (Proyecto) request.getAttribute("proyecto");
    List<Etapa> etapas = (List<Etapa>) request.getAttribute("etapas");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<div class="container mx-auto px-4 py-8 max-w-6xl">

    <!-- ENCABEZADO DEL PROYECTO -->
    <% if (pro != null) { %>
        <div class="bg-white rounded-lg shadow p-6 mb-6">
            <h1 class="text-2xl font-bold text-gray-800"><%= pro.getNombre() %></h1>
            <p class="text-gray-600">ID: <%= pro.getId() %></p>
        </div>
    <% } else { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
            Proyecto no encontrado
        </div>
    <% } %>

    <!-- BOTÓN NUEVA ETAPA -->
    <% if (pro != null) { %>
        <div class="mb-6">
            <a href="EtapaServlet?action=new&idProyecto=<%= pro.getId() %>">
                <button class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg shadow transition">
                    + Nueva Etapa
                </button>
            </a>
        </div>
    <% } %>

    <!-- MENSAJE DE ERROR -->
    <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <!-- LISTADO DE ETAPAS -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
        <% if (etapas == null || etapas.isEmpty()) { %>
            <div class="p-8 text-center text-gray-500">
                No hay etapas creadas aún.
            </div>
        <% } else { %>
            <table class="w-full">
                <thead class="bg-gray-50 border-b">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Etapa</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fechas</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <% for (Etapa e : etapas) { %>
                        <tr class="hover:bg-gray-50 transition">
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div>
                                    <div class="text-sm font-medium text-gray-900"><%= e.getNombre() %></div>
                                    <% if (e.getDescripcion() != null && !e.getDescripcion().isEmpty()) { %>
                                        <div class="text-sm text-gray-500"><%= e.getDescripcion() %></div>
                                    <% } %>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
                                    <%= "To Do".equals(e.getEstado()) ? "bg-yellow-100 text-yellow-800" :
                                        "In Progress".equals(e.getEstado()) ? "bg-blue-100 text-blue-800" :
                                        "Done".equals(e.getEstado()) ? "bg-green-100 text-green-800" :
                                        "bg-red-100 text-red-800" %>">
                                    <%= e.getEstado() %>
                                </span>
                            </td>
                            <td class="px-6 py-4 text-sm text-gray-600">
                                <div><strong>Inicio:</strong> <%= e.getFechaInicio() != null ? sdf.format(e.getFechaInicio()) : "—"%></div>
                                <div><strong>Tentativa:</strong> <%= e.getFechaTentativa() != null ? sdf.format(e.getFechaTentativa()) : "—"%></div>
                                <div><strong>Fin:</strong> <%= e.getFechaFin() != null ? sdf.format(e.getFechaFin()) : "—"%></div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <a href="EtapaServlet?action=edit&id=<%= e.getId() %>&idProyecto=<%= pro.getId() %>"
                                   class="text-indigo-600 hover:text-indigo-900 mr-4">
                                    Editar
                                </a>
                                <a href="EtapaServlet?action=delete&id=<%= e.getId() %>&idProyecto=<%= pro.getId() %>"
                                   class="text-red-600 hover:text-red-900"
                                   onclick="return confirm('¿Eliminar etapa <%= e.getNombre() %>?')">
                                    Eliminar
                                </a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<!-- INCLUIR EL MODAL DE FORMULARIO -->
<jsp:include page="../etapas/formulario.jsp" />

</body>
</html>