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
        <div class="bg-white rounded-lg shadow p-6 mb-6 relative">
        <div class="flex justify-between items-start">
            <h1 class="text-2xl font-bold text-gray-800"><%= etapa.getNombre() %></h1>
            <p class="text-gray-600">ID Etapa: <%= etapa.getId() %></p>
            
    <!-- Menú de tres puntos arriba derecha -->
			<div class="relative inline-block text-left">
			    <button type="button" 
			            class="menu-button inline-flex justify-center w-full rounded-full p-1 text-gray-500 hover:text-gray-700 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
			            id="menu-button-<%= etapa.getId() %>"
			            aria-expanded="false" 
			            aria-haspopup="true">
			        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
			            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
			                  d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
			        </svg>
			    </button>
			
			    <!-- Menú desplegable -->
			    <div class="origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 hidden z-50"
			         role="menu" 
			         aria-orientation="vertical" 
			         aria-labelledby="menu-button-<%= etapa.getId() %>"
			         id="menu-<%= etapa.getId() %>">
			        <div class="py-1" role="none">
			            <a href="EtapaServlet?action=edit&id=<%= etapa.getId() %>&idProyecto=<%= etapa.getIdProyecto() %>"
			               class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">
			                Editar Etapa
			            </a>
			            <a href="EtapaServlet?action=delete&id=<%= etapa.getId() %>&idProyecto=<%= etapa.getIdProyecto() %>"
			               class="block px-4 py-2 text-sm text-red-700 hover:bg-red-50" role="menuitem"
			               onclick="return confirm('¿Estás seguro de eliminar la etapa <%= etapa.getNombre() %>?')">
			                Eliminar Etapa
			            </a>
			        </div>
			    </div>
			</div>
			</div>
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


<script>
// Mostrar/ocultar menú de tres puntos
document.addEventListener('DOMContentLoaded', function () {
    const button = document.getElementById('menu-button-<%= etapa.getId() %>');
    const menu = document.getElementById('menu-<%= etapa.getId() %>');

    if (!button || !menu) return;

    button.addEventListener('click', function () {
        const isHidden = menu.classList.contains('hidden');
        // Cerrar todos los menús primero
        document.querySelectorAll('[id^="menu-"]').forEach(m => m.classList.add('hidden'));
        // Mostrar el actual
        if (isHidden) {
            menu.classList.remove('hidden');
        }
    });

    // Cerrar al hacer clic fuera
    document.addEventListener('click', function (e) {
        if (!button.contains(e.target) && !menu.contains(e.target)) {
            menu.classList.add('hidden');
        }
    });
});
</script>

</body>
</html>

