<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="proyectos.Proyecto" %>
<%@ page import="etapas.Etapa" %>
<%@ page import="usuarios.Usuario" %>

<!DOCTYPE html>
<html>
<head>
    <title>Portal del Cliente - Mis Proyectos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<%
    List<Proyecto> proyectos = (List<Proyecto>) request.getAttribute("proyectos");
    Usuario cliente = (Usuario) session.getAttribute("usuario");
%>

<div class="container mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6 lg:py-8">

    <!-- HEADER -->
    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex items-center gap-3 mb-2">
            <div class="bg-blue-100 p-3 rounded-lg">
                <svg class="w-6 h-6 sm:w-8 sm:h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                </svg>
            </div>
            <div>
                <h1 class="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-800">Portal del Cliente</h1>
                <p class="text-sm sm:text-base text-gray-600">Seguimiento en tiempo real de sus proyectos</p>
            </div>
        </div>
    </div>

    <!-- MENSAJE DE BIENVENIDA -->
    <div class="bg-gradient-to-r from-blue-50 to-teal-50 rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6 border-l-4 border-blue-500">
        <div class="flex items-start gap-3">
            <svg class="w-6 h-6 text-blue-600 flex-shrink-0 mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <div>
                <h3 class="font-semibold text-gray-800 mb-1">Bienvenido, <%= cliente != null ? cliente.getNombre() : "Cliente" %></h3>
                <p class="text-sm text-gray-600">En este portal puede visualizar el estado y progreso de todos sus proyectos en curso. Cada proyecto muestra información actualizada sobre etapas, tareas completadas y horas dedicadas por nuestro equipo.</p>
            </div>
        </div>
    </div>

    <% if (proyectos == null || proyectos.isEmpty()) { %>
        <!-- SIN PROYECTOS -->
        <div class="bg-white rounded-lg shadow p-8 sm:p-12 text-center">
            <div class="max-w-md mx-auto">
                <div class="bg-gray-100 p-4 rounded-full inline-block mb-4">
                    <svg class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"></path>
                    </svg>
                </div>
                <h3 class="text-xl font-semibold text-gray-800 mb-2">No hay proyectos asignados</h3>
                <p class="text-gray-600">Actualmente no tiene proyectos activos. Contacte con su representante para más información.</p>
            </div>
        </div>
    <% } else { %>
        
        <!-- LISTA DE PROYECTOS -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 sm:gap-6">
            <% for (Proyecto proyecto : proyectos) {
                // Simular datos - reemplazar con lógica real
                List<Etapa> etapas = proyecto.getEtapas(); // Obtener etapas del proyecto
                int totalEtapas = etapas != null ? etapas.size() : 0;
                int etapasCompletadas = 0;
                int totalTareas = 0;
                int tareasCompletadas = 0;
                int horasTotales = 0; // Calcular desde HorasTrabajadas
                
                if (etapas != null) {
                    for (Etapa e : etapas) {
                        if ("Done".equals(e.getEstado())) etapasCompletadas++;
                        // Aquí calcular tareas de cada etapa
                        // totalTareas += e.getTareas().size();
                        // tareasCompletadas += contar tareas "Done"
                    }
                }
                
                int progresoGeneral = totalEtapas > 0 ? (etapasCompletadas * 100 / totalEtapas) : 0;
                String colorProgreso = progresoGeneral < 33 ? "bg-red-500" :
                                       progresoGeneral < 66 ? "bg-yellow-500" :
                                       progresoGeneral < 100 ? "bg-blue-500" : "bg-green-500";
            %>
            
            <!-- TARJETA DE PROYECTO -->
            <div class="bg-white rounded-lg shadow-lg hover:shadow-xl transition-shadow cursor-pointer overflow-hidden"
				onclick="window.location.href='EtapaServlet?idProyecto=<%= proyecto.getId() %>&action=detalleCliente'">
                
                <!-- Header del proyecto -->
                <div class="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-4 sm:p-5">
                    <div class="flex items-start justify-between mb-3">
                        <div class="flex-1">
                            <h3 class="text-lg sm:text-xl font-bold mb-1"><%= proyecto.getNombre() %></h3>
                            <p class="text-sm text-blue-100"><%= proyecto.getDescripcion() %></p>
                        </div>
                        <span class="px-3 py-1 text-xs font-semibold rounded-full flex-shrink-0 ml-2
                            <%= "Activo".equals(proyecto.getEstado()) ? "bg-green-100 text-green-800" :
                                "Completo".equals(proyecto.getEstado()) ? "bg-blue-100 text-blue-800" :
                                "bg-gray-100 text-gray-800" %>">
                            <%= proyecto.getEstado() %>
                        </span>
                    </div>
                    
                    <!-- Supervisor -->
                    <div class="flex items-center text-sm text-blue-100">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                        <span class="font-medium">Supervisor:</span>
                        <span class="ml-1">Juan Pérez</span> <!-- Obtener del proyecto -->
                    </div>
                </div>
                
                <!-- Contenido del proyecto -->
                <div class="p-4 sm:p-5">
                    
                    <!-- Progreso General -->
                    <div class="mb-4">
                        <div class="flex justify-between items-center mb-2">
                            <span class="text-sm font-semibold text-gray-700">Progreso General</span>
                            <span class="text-lg font-bold text-gray-800"><%= progresoGeneral %>%</span>
                        </div>
                        <div class="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                            <div class="<%= colorProgreso %> h-full rounded-full transition-all duration-300" 
                                 style="width: <%= progresoGeneral %>%"></div>
                        </div>
                        <p class="text-xs text-gray-500 mt-1.5">
                            <%= etapasCompletadas %> de <%= totalEtapas %> etapas completadas
                        </p>
                    </div>
                    
                    <!-- Métricas -->
                    <div class="grid grid-cols-3 gap-3 mb-4">
                        <div class="bg-gray-50 rounded-lg p-3 text-center">
                            <svg class="w-5 h-5 mx-auto mb-1 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                            </svg>
                            <p class="text-xs text-gray-600 mb-0.5">Etapas</p>
                            <p class="text-lg font-bold text-gray-800"><%= totalEtapas %></p>
                        </div>
                        
                        <div class="bg-gray-50 rounded-lg p-3 text-center">
                            <svg class="w-5 h-5 mx-auto mb-1 text-teal-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                            </svg>
                            <p class="text-xs text-gray-600 mb-0.5">Tareas</p>
                            <p class="text-lg font-bold text-gray-800"><%= totalTareas %></p>
                        </div>
                        
                        <div class="bg-gray-50 rounded-lg p-3 text-center">
                            <svg class="w-5 h-5 mx-auto mb-1 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                            </svg>
                            <p class="text-xs text-gray-600 mb-0.5">Horas</p>
                            <p class="text-lg font-bold text-gray-800"><%= horasTotales %></p>
                        </div>
                    </div>
                    
                    <!-- Botón Ver Detalles -->
                    <button class="w-full bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition flex items-center justify-center gap-2">
                        <span>Ver Detalles del Proyecto</span>
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </button>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>
</div>

</body>
</html>