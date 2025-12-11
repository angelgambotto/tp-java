<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="proyectos.Proyecto" %>
<%@ page import="etapas.Etapa" %>
<%@ page import="tareas.Tarea" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>Detalle del Proyecto - Portal Cliente</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<%
    Proyecto proyecto = (Proyecto) request.getAttribute("proyecto");
    List<Etapa> etapas = (List<Etapa>) request.getAttribute("etapas");
    Integer horasTotales = (Integer) request.getAttribute("horas");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    
    // Calcular estadísticas
    int totalEtapas = etapas != null ? etapas.size() : 0;
    int etapasToDo = 0;
    int etapasInProgress = 0;
    int etapasDone = 0;
    int totalTareas = 0;
    int tareasCompletadas = 0;
    
    if (etapas != null) {
        for (Etapa e : etapas) {
            if ("To Do".equals(e.getEstado())) etapasToDo++;
            else if ("In Progress".equals(e.getEstado())) etapasInProgress++;
            else if ("Done".equals(e.getEstado())) etapasDone++;
            
            List<Tarea> tareas = e.getTareas();
            if (tareas != null) {
                totalTareas += tareas.size();
                for (Tarea t : tareas) {
                    if ("Done".equals(t.getEstado())) tareasCompletadas++;
                }
            }
        }
    }
    
    int progresoGeneral = totalEtapas > 0 ? (etapasDone * 100 / totalEtapas) : 0;
    if (horasTotales == null) horasTotales = 0;
%>

<div class="container mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6 lg:py-8">

    <!-- BOTÓN VOLVER -->
    <div class="mb-4">
        <button onclick="window.history.back()" 
                class="flex items-center gap-2 text-gray-600 hover:text-gray-800 font-medium transition">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
            </svg>
            Volver a Mis Proyectos
        </button>
    </div>

    <% if (proyecto != null) { %>
    
    <!-- HEADER DEL PROYECTO -->
    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-4">
            <div class="flex-1">
                <div class="flex flex-wrap items-center gap-2 mb-2">
                    <h1 class="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-800"><%= proyecto.getNombre() %></h1>
                    <span class="px-3 py-1 text-xs font-semibold rounded-full
                        <%= "Done".equals(proyecto.getEstado()) ? "bg-green-100 text-green-800" :
                            "In Progress".equals(proyecto.getEstado()) ? "bg-blue-100 text-blue-800" :
                            "To Do".equals(proyecto.getEstado()) ? "bg-bg-yellow-500 text-yellow-500" :
                            "bg-gray-100 text-gray-800" %>">
                        <%= proyecto.getEstado() %>
                    </span>
                </div>
                <p class="text-sm sm:text-base text-gray-600 mb-3"><%= proyecto.getDescripcion() %></p>
                
                <!-- Info adicional -->
                <div class="flex flex-wrap gap-4 text-sm text-gray-600">
                    <div class="flex items-center">
                        <svg class="w-4 h-4 mr-1.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                        <span class="font-medium">Supervisor:</span>
                        <span class="ml-1"><%= proyecto.getSupervisor().getNombreCompleto() %></span>
                    </div>
                    <% if (proyecto.getFechaCreacion() != null) { %>
                    <div class="flex items-center">
                        <svg class="w-4 h-4 mr-1.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                        </svg>
                        <span class="font-medium">Inicio:</span>
                        <span class="ml-1"><%= sdf.format(proyecto.getFechaCreacion()) %></span>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <!-- PROGRESO GENERAL -->
        <div class="mt-6 pt-6 border-t">
            <div class="flex justify-between items-center mb-2">
                <span class="text-sm font-semibold text-gray-700">Progreso General del Proyecto</span>
                <span class="text-2xl font-bold text-gray-800"><%= progresoGeneral %>%</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-4 overflow-hidden">
                <div class="<%= progresoGeneral < 33 ? "bg-red-500" : progresoGeneral < 66 ? "bg-yellow-500" : progresoGeneral < 100 ? "bg-blue-500" : "bg-green-500" %> h-full rounded-full transition-all duration-300" 
                     style="width: <%= progresoGeneral %>%"></div>
            </div>
            <p class="text-sm text-gray-600 mt-2">
                <%= etapasDone %> de <%= totalEtapas %> etapas completadas
            </p>
        </div>
    </div>

    <!-- MÉTRICAS CLAVE -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4 mb-4 sm:mb-6">
        <div class="bg-white rounded-lg shadow p-4">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs sm:text-sm text-gray-600">Etapas Totales</p>
                    <p class="text-xl sm:text-2xl font-bold text-gray-800"><%= totalEtapas %></p>
                </div>
                <div class="bg-slate-100 p-2 sm:p-3 rounded-full">
                    <svg class="h-5 w-5 sm:h-6 sm:w-6 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                    </svg>
                </div>
            </div>
        </div>
        
        <div class="bg-white rounded-lg shadow p-4">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs sm:text-sm text-gray-600">En Progreso</p>
                    <p class="text-xl sm:text-2xl font-bold text-blue-600"><%= etapasInProgress %></p>
                </div>
                <div class="bg-blue-100 p-2 sm:p-3 rounded-full">
                    <svg class="h-5 w-5 sm:h-6 sm:w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                    </svg>
                </div>
            </div>
        </div>
        
        <div class="bg-white rounded-lg shadow p-4">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs sm:text-sm text-gray-600">Tareas Totales</p>
                    <p class="text-xl sm:text-2xl font-bold text-teal-600"><%= totalTareas %></p>
                </div>
                <div class="bg-teal-100 p-2 sm:p-3 rounded-full">
                    <svg class="h-5 w-5 sm:h-6 sm:w-6 text-teal-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                    </svg>
                </div>
            </div>
        </div>
        
        <div class="bg-white rounded-lg shadow p-4">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs sm:text-sm text-gray-600">Horas Dedicadas</p>
                    <p class="text-xl sm:text-2xl font-bold text-green-600"><%= horasTotales %></p>
                </div>
                <div class="bg-green-100 p-2 sm:p-3 rounded-full">
                    <svg class="h-5 w-5 sm:h-6 sm:w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                </div>
            </div>
        </div>
    </div>

    <!-- GRÁFICO Y ETAPAS -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 sm:gap-6 mb-6">
        
        <!-- GRÁFICO DE PROGRESO -->
        <div class="lg:col-span-1 bg-white rounded-lg shadow p-4 sm:p-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                <svg class="w-5 h-5 mr-2 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z"></path>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z"></path>
                </svg>
                Estado de Etapas
            </h3>
            
            <div class="flex justify-center mb-4">
                <canvas id="etapasChart" width="200" height="200"></canvas>
            </div>
            
            <!-- Leyenda -->
            <div class="space-y-2 text-sm">
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <div class="w-3 h-3 bg-yellow-500 rounded-full mr-2"></div>
                        <span class="text-gray-700">Por Iniciar</span>
                    </div>
                    <span class="font-semibold text-gray-800"><%= etapasToDo %></span>
                </div>
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <div class="w-3 h-3 bg-blue-500 rounded-full mr-2"></div>
                        <span class="text-gray-700">En Progreso</span>
                    </div>
                    <span class="font-semibold text-gray-800"><%= etapasInProgress %></span>
                </div>
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <div class="w-3 h-3 bg-green-500 rounded-full mr-2"></div>
                        <span class="text-gray-700">Completadas</span>
                    </div>
                    <span class="font-semibold text-gray-800"><%= etapasDone %></span>
                </div>
            </div>
        </div>

        <!-- LISTA DE ETAPAS -->
        <div class="lg:col-span-2 bg-white rounded-lg shadow overflow-hidden">
            <div class="px-4 sm:px-6 py-4 border-b bg-gray-50">
                <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                    </svg>
                    Desglose de Etapas
                </h3>
            </div>
            
            <% if (etapas == null || etapas.isEmpty()) { %>
                <div class="p-8 text-center text-gray-500">
                    <svg class="mx-auto h-12 w-12 mb-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
                    </svg>
                    <p class="text-sm">Este proyecto aún no tiene etapas definidas</p>
                </div>
            <% } else { %>
                <div class="divide-y divide-gray-200">
                    <% for (Etapa etapa : etapas) { 
                        List<Tarea> tareasEtapa = etapa.getTareas();
                        int numTareas = tareasEtapa != null ? tareasEtapa.size() : 0;
                        int tareasCompletadasEtapa = 0;
                        
                        if (tareasEtapa != null) {
                            for (Tarea t : tareasEtapa) {
                                if ("Done".equals(t.getEstado())) tareasCompletadasEtapa++;
                            }
                        }
                        
                        int progresoEtapa = numTareas > 0 ? (tareasCompletadasEtapa * 100 / numTareas) : 0;
                        String colorBarraEtapa = progresoEtapa < 33 ? "bg-red-500" :
                                                 progresoEtapa < 66 ? "bg-yellow-500" :
                                                 progresoEtapa < 100 ? "bg-blue-500" : "bg-green-500";
                    %>
                    
                    <!-- ETAPA -->
                    <div class="p-4 hover:bg-gray-50 transition">
                        <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-3 mb-3">
                            <div class="flex-1">
                                <div class="flex items-center gap-2 mb-1">
                                    <h4 class="font-semibold text-gray-900"><%= etapa.getNombre() %></h4>
                                    <span class="px-2 py-0.5 text-xs font-semibold rounded-full
                                        <%= "To Do".equals(etapa.getEstado()) ? "bg-yellow-100 text-yellow-800" :
                                            "In Progress".equals(etapa.getEstado()) ? "bg-blue-100 text-blue-800" :
                                            "Done".equals(etapa.getEstado()) ? "bg-green-100 text-green-800" :
                                            "bg-gray-100 text-gray-800" %>">
                                        <%= etapa.getEstado() %>
                                    </span>
                                </div>
                                <% if (etapa.getDescripcion() != null && !etapa.getDescripcion().isEmpty()) { %>
                                    <p class="text-sm text-gray-600"><%= etapa.getDescripcion() %></p>
                                <% } %>
                            </div>
                            
                            <div class="text-right">
                                <p class="text-2xl font-bold text-gray-800"><%= progresoEtapa %>%</p>
                                <p class="text-xs text-gray-500">completado</p>
                            </div>
                        </div>
                        
                        <!-- Barra de progreso de la etapa -->
                        <div class="mb-2">
                            <div class="w-full bg-gray-200 rounded-full h-2 overflow-hidden">
                                <div class="<%= colorBarraEtapa %> h-full rounded-full transition-all duration-300" 
                                     style="width: <%= progresoEtapa %>%"></div>
                            </div>
                        </div>
                        
                        <div class="flex flex-wrap items-center gap-3 text-xs text-gray-600">
                            <div class="flex items-center">
                                <svg class="w-4 h-4 mr-1 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                                </svg>
                                <span><%= tareasCompletadasEtapa %> de <%= numTareas %> tareas completadas</span>
                            </div>
                            <% if (etapa.getFechaInicio() != null) { %>
                            <div class="flex items-center">
                                <svg class="w-4 h-4 mr-1 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                </svg>
                                <span>Inicio: <%= sdf.format(etapa.getFechaInicio()) %></span>
                            </div>
                            <% } %>
                            <% if (etapa.getFechaTentativa() != null) { %>
                            <div class="flex items-center">
                                <svg class="w-4 h-4 mr-1 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                                <span>Est. finalización: <%= sdf.format(etapa.getFechaTentativa()) %></span>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- RESUMEN DE HORAS -->
    <div class="bg-gradient-to-r from-green-50 to-teal-50 rounded-lg shadow p-4 sm:p-6 border-l-4 border-green-500">
        <div class="flex items-start gap-3">
            <div class="bg-green-100 p-3 rounded-lg">
                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
            </div>
            <div class="flex-1">
                <h3 class="font-semibold text-gray-800 mb-1">Horas Totales Dedicadas al Proyecto</h3>
                <p class="text-3xl font-bold text-green-600 mb-2"><%= horasTotales %> horas</p>
                <p class="text-sm text-gray-600">Nuestro equipo ha dedicado un total de <%= horasTotales %> horas de trabajo profesional en este proyecto, distribuidas entre todas las etapas y tareas.</p>
            </div>
        </div>
    </div>

    <% } else { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
            Proyecto no encontrado
        </div>
    <% } %>
</div>

<script>
// Gráfico de dona para estado de etapas
const ctx = document.getElementById('etapasChart');
if (ctx) {
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Por Iniciar', 'En Progreso', 'Completadas'],
            datasets: [{
                data: [<%= etapasToDo %>, <%= etapasInProgress %>, <%= etapasDone %>],
                backgroundColor: [
                    'rgb(234, 179, 8)',  // yellow-500
                    'rgb(59, 130, 246)',  // blue-500
                    'rgb(34, 197, 94)'    // green-500
                ],
                borderWidth: 2,
                borderColor: '#fff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.label + ': ' + context.parsed + ' etapas';
                        }
                    }
                }
            },
            cutout: '70%'
        }
    });
}
</script>

</body>
</html>