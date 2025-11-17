<%@ page import="java.util.*" %>
<%@ page import="horasReporte.HorasReporte" %>

<!DOCTYPE html>
<html>
<head>
    <title>Reportes de Horas Trabajadas</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .chevron {
            transition: transform 0.3s ease;
        }
        .proyecto-content,
        .etapa-content,
        .tarea-content {
            transition: max-height 0.3s ease;
        }
   
		@media print {
	        body {
	            background: white;
	        }
	        .no-print {
	            display: none !important;
	        }
	        .bg-white {
	            box-shadow: none !important;
	        }
	        button {
	            display: none !important;
	        }
	        header {
	            display: none !important;
	        }
	        .proyecto-content,
	        .etapa-content,
	        .tarea-content {
	            display: block !important;
	        }
	    }
	</style>
</head>

<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<%
    String tipo = (String) request.getAttribute("tipo");
    List data = (List) request.getAttribute("data");
    
    // Calcular totales
    int totalHoras = 0;
    if (data != null && !data.isEmpty()) {
        for (HorasReporte r : (List<HorasReporte>)data) {
            totalHoras += r.getHoras();
        }
    }
%>

<div class="container mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6 lg:py-8">

    <!-- HEADER -->
    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <div class="flex items-center gap-3 mb-2">
            <div class="bg-blue-100 p-3 rounded-lg">
                <svg class="w-6 h-6 sm:w-8 sm:h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                </svg>
            </div>
            <div>
                <h1 class="text-xl sm:text-2xl lg:text-3xl font-bold text-gray-800">Reportes de Horas Trabajadas</h1>
                <p class="text-sm sm:text-base text-gray-600">Análisis detallado de tiempo por proyecto y colaborador</p>
            </div>
        </div>
    </div>

    <!-- FORMULARIO DE FILTROS -->
    <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
        <h2 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
            <svg class="w-5 h-5 mr-2 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"></path>
            </svg>
            Filtros de Búsqueda
        </h2>
        
        <form method="get" action="HoraTrabajadaServlet" class="space-y-4">
            <input type="hidden" name="action" value="reporte">
            
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <!-- Fecha Desde -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                        </svg>
                        Fecha Desde
                    </label>
                    <input type="date" name="desde" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                </div>

                <!-- Fecha Hasta -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                        </svg>
                        Fecha Hasta
                    </label>
                    <input type="date" name="hasta" 
                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                </div>

                <!-- Tipo de Reporte -->
                <div class="sm:col-span-2 lg:col-span-1">
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                        </svg>
                        Tipo de Reporte
                    </label>
                    <select name="lista" 
                            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition">
                        <option value="usuarios">Por Usuario</option>
                        <option value="usuariosProyecto">Por Usuario - Proyecto</option>
                        <option value="usuariosProyectoEtapa">Por Usuario - Proyecto - Etapa</option>
                        <option value="usuariosProyectoEtapaTarea">Por Usuario - Proyecto - Etapa - Tarea</option>
                    </select>
                </div>

                <!-- Botón -->
                <div class="flex items-end">
                    <button type="submit" 
                            class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-lg hover:shadow-xl transition">
                        <svg class="inline w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                        Generar Reporte
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- RESULTADOS -->
    <% if (data != null && !data.isEmpty()) { %>
        
        <!-- RESUMEN -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-4 sm:mb-6">
            <div class="bg-white rounded-lg shadow p-4">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Total de Registros</p>
                        <p class="text-2xl font-bold text-gray-800"><%= data.size() %></p>
                    </div>
                    <div class="bg-slate-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-4">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Total de Horas</p>
                        <p class="text-2xl font-bold text-blue-600"><%= totalHoras %></p>
                    </div>
                    <div class="bg-blue-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow p-4">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Promedio por Registro</p>
                        <p class="text-2xl font-bold text-green-600"><%= Math.round((double)totalHoras / data.size() * 10.0) / 10.0 %></p>
                    </div>
                    <div class="bg-green-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 12l3-3 3 3 4-4M8 21l4-4 4 4M3 4h18M4 4h16v12a1 1 0 01-1 1H5a1 1 0 01-1-1V4z"></path>
                        </svg>
                    </div>
                </div>
            </div>
        </div>

        <!-- TABLA DE RESULTADOS -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="px-4 sm:px-6 py-4 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
                <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                    Resultados del Reporte
                </h3>
                <% if (!"usuarios".equals(tipo)) { %>
                <button onclick="expandirTodo()" 
                        class="text-sm bg-blue-600 hover:bg-blue-700 text-white font-medium py-1.5 px-4 rounded-lg transition">
                    Expandir Todo
                </button>
                <% } %>
            </div>

            <!-- USUARIOS -->
            <% if ("usuarios".equals(tipo)) { %>
                <!-- Vista móvil: Cards -->
                <div class="block lg:hidden divide-y divide-gray-200">
                    <% for (HorasReporte r : (List<HorasReporte>)data) { %>
                        <div class="p-4 hover:bg-gray-50">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <div class="bg-blue-100 p-2 rounded-full">
                                        <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="font-semibold text-gray-900"><%= r.getNombreUsuario() %> <%= r.getApellidoUsuario() %></p>
                                        <p class="text-xs text-gray-500">Usuario</p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="text-2xl font-bold text-blue-600"><%= r.getHoras() %></p>
                                    <p class="text-xs text-gray-500">horas</p>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Vista desktop: Tabla -->
                <table class="w-full hidden lg:table">
                    <thead class="bg-gray-50 border-b">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Usuario</th>
                            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Horas Trabajadas</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <% for (HorasReporte r : (List<HorasReporte>)data) { %>
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-6 py-4">
                                    <div class="flex items-center">
                                        <div class="bg-blue-100 p-2 rounded-full mr-3">
                                            <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                            </svg>
                                        </div>
                                        <span class="text-sm font-medium text-gray-900"><%= r.getNombreUsuario() %> <%= r.getApellidoUsuario() %></span>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <span class="bg-blue-100 text-blue-800 text-sm font-semibold px-3 py-1 rounded-full">
                                        <%= r.getHoras() %> horas
                                    </span>
                                </td>
                            </tr>
                        <% } %>
                        <tr class="bg-blue-50 font-semibold">
                            <td class="px-6 py-4 text-sm text-gray-700">Total</td>
                            <td class="px-6 py-4 text-right">
                                <span class="bg-blue-600 text-white text-sm font-bold px-4 py-1.5 rounded-full">
                                    <%= totalHoras %> horas
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            <% } %>

            <!-- USUARIOS - PROYECTO (VISTA JERÁRQUICA) -->
            <% if ("usuariosProyecto".equals(tipo)) { %>
                <%
                    // Agrupar por proyecto
                    Map<String, List<HorasReporte>> proyectos = new LinkedHashMap<>();
                    
                    for (HorasReporte r : (List<HorasReporte>)data) {
                        String proyecto = r.getNombreProyecto();
                        proyectos.putIfAbsent(proyecto, new ArrayList<>());
                        proyectos.get(proyecto).add(r);
                    }
                %>

                <!-- Vista Jerárquica -->
                <div class="space-y-4 p-4">
                    <% 
                    for (Map.Entry<String, List<HorasReporte>> proyectoEntry : proyectos.entrySet()) {
                        String nombreProyecto = proyectoEntry.getKey();
                        List<HorasReporte> usuarios = proyectoEntry.getValue();
                        
                        // Calcular total del proyecto
                        int totalProyecto = 0;
                        for (HorasReporte r : usuarios) {
                            totalProyecto += r.getHoras();
                        }
                    %>
                    
                    <!-- PROYECTO -->
                    <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                        <div class="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-4 cursor-pointer hover:from-blue-600 hover:to-blue-700 transition"
                             onclick="toggleSeccion('proyecto-simple-<%= nombreProyecto.hashCode() %>')">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"></path>
                                    </svg>
                                    <div>
                                        <h3 class="text-lg font-bold"><%= nombreProyecto %></h3>
                                        <p class="text-sm text-blue-100"><%= usuarios.size() %> usuario<%= usuarios.size() != 1 ? "s" : "" %></p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div class="text-right">
                                        <p class="text-2xl font-bold"><%= totalProyecto %></p>
                                        <p class="text-xs text-blue-100">horas totales</p>
                                    </div>
                                    <svg class="w-5 h-5 transform transition-transform chevron" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>
                        
                        <div id="proyecto-simple-<%= nombreProyecto.hashCode() %>" class="proyecto-content hidden">
                            <div class="divide-y divide-gray-100">
                                <% for (HorasReporte r : usuarios) { %>
                                <!-- USUARIO -->
                                <div class="p-4 hover:bg-gray-50 transition">
                                    <div class="flex items-center justify-between">
                                        <div class="flex items-center gap-3">
                                            <div class="bg-blue-100 p-2 rounded-full">
                                                <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                                </svg>
                                            </div>
                                            <span class="text-sm font-medium text-gray-800"><%= r.getNombreUsuario() %> <%= r.getApellidoUsuario() %></span>
                                        </div>
                                        <span class="bg-blue-100 text-blue-800 text-sm font-semibold px-3 py-1 rounded-full">
                                            <%= r.getHoras() %>h
                                        </span>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } %>

            <!-- USUARIOS - PROYECTO - ETAPA (VISTA JERÁRQUICA) -->
            <% if ("usuariosProyectoEtapa".equals(tipo)) { %>
                <%
                    // Agrupar por proyecto y etapa
                    Map<String, Map<String, List<HorasReporte>>> proyectosEtapas = new LinkedHashMap<>();
                    
                    for (HorasReporte r : (List<HorasReporte>)data) {
                        String proyecto = r.getNombreProyecto();
                        String etapa = r.getNombreEtapa();
                        
                        proyectosEtapas.putIfAbsent(proyecto, new LinkedHashMap<>());
                        proyectosEtapas.get(proyecto).putIfAbsent(etapa, new ArrayList<>());
                        proyectosEtapas.get(proyecto).get(etapa).add(r);
                    }
                %>

                <!-- Vista Jerárquica -->
                <div class="space-y-4 p-4">
                    <% 
                    for (Map.Entry<String, Map<String, List<HorasReporte>>> proyectoEntry : proyectosEtapas.entrySet()) {
                        String nombreProyecto = proyectoEntry.getKey();
                        Map<String, List<HorasReporte>> etapas = proyectoEntry.getValue();
                        
                        // Calcular total del proyecto
                        int totalProyecto = 0;
                        for (List<HorasReporte> usuarios : etapas.values()) {
                            for (HorasReporte r : usuarios) {
                                totalProyecto += r.getHoras();
                            }
                        }
                    %>
                    
                    <!-- PROYECTO -->
                    <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                        <div class="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-4 cursor-pointer hover:from-blue-600 hover:to-blue-700 transition"
                             onclick="toggleSeccion('proyecto-etapa-<%= nombreProyecto.hashCode() %>')">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"></path>
                                    </svg>
                                    <div>
                                        <h3 class="text-lg font-bold"><%= nombreProyecto %></h3>
                                        <p class="text-sm text-blue-100"><%= etapas.size() %> etapa<%= etapas.size() != 1 ? "s" : "" %></p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div class="text-right">
                                        <p class="text-2xl font-bold"><%= totalProyecto %></p>
                                        <p class="text-xs text-blue-100">horas totales</p>
                                    </div>
                                    <svg class="w-5 h-5 transform transition-transform chevron" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>
                        
                        <div id="proyecto-etapa-<%= nombreProyecto.hashCode() %>" class="proyecto-content hidden">
                            <div class="p-4 space-y-3">
                                <% 
                                for (Map.Entry<String, List<HorasReporte>> etapaEntry : etapas.entrySet()) {
                                    String nombreEtapa = etapaEntry.getKey();
                                    List<HorasReporte> usuarios = etapaEntry.getValue();
                                    
                                    // Calcular total de la etapa
                                    int totalEtapa = 0;
                                    for (HorasReporte r : usuarios) {
                                        totalEtapa += r.getHoras();
                                    }
                                %>
                                
                                <!-- ETAPA -->
                                <div class="bg-gray-50 rounded-lg border-l-4 border-teal-500 overflow-hidden">
                                    <div class="bg-teal-50 p-3 cursor-pointer hover:bg-teal-100 transition"
                                         onclick="toggleSeccion('etapa-simple-<%= (nombreProyecto + nombreEtapa).hashCode() %>')">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center gap-3">
                                                <svg class="w-5 h-5 text-teal-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                                                </svg>
                                                <div>
                                                    <h4 class="font-semibold text-gray-800"><%= nombreEtapa %></h4>
                                                    <p class="text-xs text-gray-600"><%= usuarios.size() %> usuario<%= usuarios.size() != 1 ? "s" : "" %></p>
                                                </div>
                                            </div>
                                            <div class="flex items-center gap-3">
                                                <span class="bg-teal-600 text-white text-sm font-semibold px-3 py-1 rounded-full">
                                                    <%= totalEtapa %>h
                                                </span>
                                                <svg class="w-4 h-4 text-teal-600 transform transition-transform chevron" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                                </svg>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div id="etapa-simple-<%= (nombreProyecto + nombreEtapa).hashCode() %>" class="etapa-content hidden">
                                        <div class="divide-y divide-gray-100">
                                            <% for (HorasReporte r : usuarios) { %>
                                            <!-- USUARIO -->
                                            <div class="p-3 hover:bg-gray-50 transition">
                                                <div class="flex items-center justify-between">
                                                    <div class="flex items-center gap-2">
                                                        <div class="bg-blue-100 p-1.5 rounded-full">
                                                            <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                                            </svg>
                                                        </div>
                                                        <span class="text-sm text-gray-800"><%= r.getNombreUsuario() %> <%= r.getApellidoUsuario() %></span>
                                                    </div>
                                                    <span class="bg-blue-100 text-blue-800 text-sm font-semibold px-2.5 py-0.5 rounded-full">
                                                        <%= r.getHoras() %>h
                                                    </span>
                                                </div>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } %>

            <!-- USUARIOS - PROYECTO - ETAPA - TAREA (VISTA JERÁRQUICA) -->
            <% if ("usuariosProyectoEtapaTarea".equals(tipo)) { %>
                <%
                    // Agrupar datos jerárquicamente
                    Map<String, Map<String, Map<String, List<HorasReporte>>>> jerarquia = new LinkedHashMap<>();
                    
                    for (HorasReporte r : (List<HorasReporte>)data) {
                        String proyecto = r.getNombreProyecto();
                        String etapa = r.getNombreEtapa();
                        String tarea = r.getNombreTarea();
                        
                        jerarquia.putIfAbsent(proyecto, new LinkedHashMap<>());
                        jerarquia.get(proyecto).putIfAbsent(etapa, new LinkedHashMap<>());
                        jerarquia.get(proyecto).get(etapa).putIfAbsent(tarea, new ArrayList<>());
                        jerarquia.get(proyecto).get(etapa).get(tarea).add(r);
                    }
                %>

                <!-- Vista Jerárquica -->
                <div class="space-y-4 p-4">
                    <% 
                    for (Map.Entry<String, Map<String, Map<String, List<HorasReporte>>>> proyectoEntry : jerarquia.entrySet()) {
                        String nombreProyecto = proyectoEntry.getKey();
                        Map<String, Map<String, List<HorasReporte>>> etapas = proyectoEntry.getValue();
                        
                        // Calcular total del proyecto
                        int totalProyecto = 0;
                        for (Map<String, List<HorasReporte>> etapaMap : etapas.values()) {
                            for (List<HorasReporte> usuarios : etapaMap.values()) {
                                for (HorasReporte r : usuarios) {
                                    totalProyecto += r.getHoras();
                                }
                            }
                        }
                    %>
                    
                    <!-- PROYECTO -->
                    <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                        <div class="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-4 cursor-pointer hover:from-blue-600 hover:to-blue-700 transition"
                             onclick="toggleSeccion('proyecto-<%= nombreProyecto.hashCode() %>')">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"></path>
                                    </svg>
                                    <div>
                                        <h3 class="text-lg font-bold"><%= nombreProyecto %></h3>
                                        <p class="text-sm text-blue-100"><%= etapas.size() %> etapa<%= etapas.size() != 1 ? "s" : "" %></p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div class="text-right">
                                        <p class="text-2xl font-bold"><%= totalProyecto %></p>
                                        <p class="text-xs text-blue-100">horas totales</p>
                                    </div>
                                    <svg class="w-5 h-5 transform transition-transform chevron" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                    </svg>
                                </div>
                            </div>
                        </div>
                        
                        <div id="proyecto-<%= nombreProyecto.hashCode() %>" class="proyecto-content hidden">
                            <div class="p-4 space-y-3">
                                <% 
                                for (Map.Entry<String, Map<String, List<HorasReporte>>> etapaEntry : etapas.entrySet()) {
                                    String nombreEtapa = etapaEntry.getKey();
                                    Map<String, List<HorasReporte>> tareas = etapaEntry.getValue();
                                    
                                    // Calcular total de la etapa
                                    int totalEtapa = 0;
                                    for (List<HorasReporte> usuarios : tareas.values()) {
                                        for (HorasReporte r : usuarios) {
                                            totalEtapa += r.getHoras();
                                        }
                                    }
                                %>
                                
                                <!-- ETAPA -->
                                <div class="bg-gray-50 rounded-lg border-l-4 border-teal-500 overflow-hidden">
                                    <div class="bg-teal-50 p-3 cursor-pointer hover:bg-teal-100 transition"
                                         onclick="toggleSeccion('etapa-<%= (nombreProyecto + nombreEtapa).hashCode() %>')">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center gap-3">
                                                <svg class="w-5 h-5 text-teal-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                                                </svg>
                                                <div>
                                                    <h4 class="font-semibold text-gray-800"><%= nombreEtapa %></h4>
                                                    <p class="text-xs text-gray-600"><%= tareas.size() %> tarea<%= tareas.size() != 1 ? "s" : "" %></p>
                                                </div>
                                            </div>
                                            <div class="flex items-center gap-3">
                                                <span class="bg-teal-600 text-white text-sm font-semibold px-3 py-1 rounded-full">
                                                    <%= totalEtapa %>h
                                                </span>
                                                <svg class="w-4 h-4 text-teal-600 transform transition-transform chevron" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                                </svg>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div id="etapa-<%= (nombreProyecto + nombreEtapa).hashCode() %>" class="etapa-content hidden">
                                        <div class="p-3 space-y-2">
                                            <% 
                                            for (Map.Entry<String, List<HorasReporte>> tareaEntry : tareas.entrySet()) {
                                                String nombreTarea = tareaEntry.getKey();
                                                List<HorasReporte> usuarios = tareaEntry.getValue();
                                                
                                                // Calcular total de la tarea
                                                int totalTarea = 0;
                                                for (HorasReporte r : usuarios) {
                                                    totalTarea += r.getHoras();
                                                }
                                            %>
                                            
                                            <!-- TAREA -->
                                            <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
                                                <div class="bg-gray-50 p-3 cursor-pointer hover:bg-gray-100 transition"
                                                     onclick="toggleSeccion('tarea-<%= (nombreProyecto + nombreEtapa + nombreTarea).hashCode() %>')">
                                                    <div class="flex items-center justify-between">
                                                        <div class="flex items-center gap-2">
                                                            <svg class="w-4 h-4 text-pink-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                                                            </svg>
                                                            <div>
                                                                <p class="font-medium text-sm text-gray-800"><%= nombreTarea %></p>
                                                                <p class="text-xs text-gray-500"><%= usuarios.size() %> usuario<%= usuarios.size() != 1 ? "s" : "" %></p>
                                                            </div>
                                                        </div>
                                                        <div class="flex items-center gap-2">
                                                            <span class="bg-pink-100 text-pink-800 text-xs font-semibold px-2 py-1 rounded-full">
                                                                <%= totalTarea %>h
                                                            </span>
                                                            <svg class="w-4 h-4 text-gray-400 transform transition-transform chevron" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                                                            </svg>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div id="tarea-<%= (nombreProyecto + nombreEtapa + nombreTarea).hashCode() %>" class="tarea-content hidden">
                                                    <div class="divide-y divide-gray-100">
                                                        <% for (HorasReporte r : usuarios) { %>
                                                        <!-- USUARIO -->
                                                        <div class="p-3 hover:bg-gray-50 transition">
                                                            <div class="flex items-center justify-between">
                                                                <div class="flex items-center gap-2">
                                                                    <div class="bg-blue-100 p-1.5 rounded-full">
                                                                        <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                                                        </svg>
                                                                    </div>
                                                                    <span class="text-sm text-gray-800"><%= r.getNombreUsuario() %> <%= r.getApellidoUsuario() %></span>
                                                                </div>
                                                                <span class="bg-blue-100 text-blue-800 text-sm font-semibold px-2.5 py-0.5 rounded-full">
                                                                    <%= r.getHoras() %>h
                                                                </span>
                                                            </div>
                                                        </div>
                                                        <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <!-- BOTONES DE ACCIÓN -->
        <div class="mt-6 flex flex-col sm:flex-row gap-3 justify-end">
            <button onclick="window.print()" 
                    class="bg-gray-600 hover:bg-gray-700 text-white font-medium py-2 px-6 rounded-lg shadow transition flex items-center justify-center">
                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path>
                </svg>
                Imprimir Reporte
            </button>
        </div>

    <% } else if (data != null && data.isEmpty()) { %>
        <!-- NO HAY RESULTADOS -->
        <div class="bg-white rounded-lg shadow p-8 sm:p-12 text-center">
            <div class="max-w-md mx-auto">
                <div class="bg-yellow-100 p-4 rounded-full inline-block mb-4">
                    <svg class="w-12 h-12 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
                    </svg>
                </div>
                <h3 class="text-xl font-semibold text-gray-800 mb-2">No se encontraron resultados</h3>
                <p class="text-gray-600 mb-6">No hay datos para mostrar con los filtros seleccionados. Intenta ajustar las fechas o el tipo de reporte.</p>
                <button onclick="window.location.href='HoraTrabajadaServlet?action=reporte'" 
                        class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg transition">
                    Reiniciar Filtros
                </button>
            </div>
        </div>
    <% } else { %>
        <!-- MENSAJE INICIAL -->
        <div class="bg-white rounded-lg shadow p-8 sm:p-12 text-center">
            <div class="max-w-md mx-auto">
                <div class="bg-blue-100 p-4 rounded-full inline-block mb-4">
                    <svg class="w-12 h-12 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <h3 class="text-xl font-semibold text-gray-800 mb-2">Genera tu primer reporte</h3>
                <p class="text-gray-600">Selecciona las fechas y el tipo de reporte que deseas visualizar para comenzar el análisis de horas trabajadas.</p>
            </div>
        </div>
    <% } %>
</div>

<script>
function toggleSeccion(id) {
    const elemento = document.getElementById(id);
    const chevron = event.currentTarget.querySelector('.chevron');
    
    if (elemento.classList.contains('hidden')) {
        elemento.classList.remove('hidden');
        if (chevron) chevron.style.transform = 'rotate(180deg)';
    } else {
        elemento.classList.add('hidden');
        if (chevron) chevron.style.transform = 'rotate(0deg)';
    }
}

function expandirTodo() {
    const proyectos = document.querySelectorAll('.proyecto-content');
    const etapas = document.querySelectorAll('.etapa-content');
    const tareas = document.querySelectorAll('.tarea-content');
    const chevrons = document.querySelectorAll('.chevron');
    
    const todosExpandidos = Array.from(proyectos).every(p => !p.classList.contains('hidden'));
    
    if (todosExpandidos) {
        // Colapsar todo
        proyectos.forEach(p => p.classList.add('hidden'));
        etapas.forEach(e => e.classList.add('hidden'));
        tareas.forEach(t => t.classList.add('hidden'));
        chevrons.forEach(c => c.style.transform = 'rotate(0deg)');
        event.target.textContent = 'Expandir Todo';
    } else {
        // Expandir todo
        proyectos.forEach(p => p.classList.remove('hidden'));
        etapas.forEach(e => e.classList.remove('hidden'));
        tareas.forEach(t => t.classList.remove('hidden'));
        chevrons.forEach(c => c.style.transform = 'rotate(180deg)');
        event.target.textContent = 'Colapsar Todo';
    }
}

// Mantener los valores seleccionados después de enviar el formulario
window.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const lista = urlParams.get('lista');
    if (lista) {
        document.querySelector('select[name="lista"]').value = lista;
    }
});
</script>

</body>
</html>