<%@page import="proyectos.Proyecto"%>
<%@page import="usuarios.Usuario"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="tareas.Tarea" %>
<%@ page import="etapas.Etapa" %>
<%@ page import="categoriaTarea.CategoriaTarea" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>Etapa - Tareas</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .tab-active {
            border-bottom: 2px solid #2563eb;
            color: #2563eb;
        }
        tr.clickable-row {
            cursor: pointer;
        }
    </style>
</head>

<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<%
	Proyecto pro = (Proyecto) request.getAttribute("proyecto");
    Etapa etapa = (Etapa) request.getAttribute("etapa");
	System.out.println("la etapa que se recibe en unaEtapa es :  "+ etapa);
    List<Tarea> tareas = (List<Tarea>) request.getAttribute("tareas");
    List<CategoriaTarea> categorias = (List<CategoriaTarea>) request.getAttribute("categorias");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String estadoEtapa=etapa.getEstado();
    // Calcular estadísticas
    int tareasToDo = 0;
    int tareasInProgress = 0;
    int tareasDone = 0;
    int totalHorasEstimadas = 0;
    
    if (tareas != null) {
        for (Tarea t : tareas) {
            if ("To Do".equals(t.getEstado())) tareasToDo++;
            else if ("In Progress".equals(t.getEstado())) tareasInProgress++;
            else if ("Done".equals(t.getEstado())) tareasDone++;
        }
    }
    
    int totalTareas = tareas != null ? tareas.size() : 0;
    int progreso = totalTareas > 0 ? (tareasDone * 100 / totalTareas) : 0;
    Usuario usuarioActual = (Usuario) session.getAttribute("usuario");
    String rol = usuarioActual.getRol();
%>

<div class="container mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6 lg:py-8">
	<!-- BOTÓN VOLVER -->
    <div class="mb-4">
	    <a href="EtapaServlet?action=list&idProyecto=<%= etapa.getIdProyecto() %>"
	       class="flex items-center gap-2 text-gray-600 hover:text-gray-800 font-medium transition">
	        
	        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
	            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
	                  d="M15 19l-7-7 7-7"></path>
	        </svg>
	
	        Volver al Proyecto
	    </a>
	</div>


    <!-- HEADER DE LA ETAPA -->
    <% if (etapa != null) { %>
        <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
            <div class="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-4 mb-4">
                <div class="flex-1">
                    <div class="flex flex-wrap items-center gap-2 mb-2">
                        <h1 class="text-xl sm:text-2xl font-bold text-gray-800"><%= etapa.getNombre() %></h1>
                        <span class="px-3 py-1 text-xs font-semibold rounded-full
                            <%= "To Do".equals(etapa.getEstado()) ? "bg-yellow-100 text-yellow-800" :
                                "In Progress".equals(etapa.getEstado()) ? "bg-blue-100 text-blue-800" :
                                "Done".equals(etapa.getEstado()) ? "bg-green-100 text-green-800" :
                                "bg-red-100 text-red-800" %>">
                            <%= etapa.getEstado() %>
                        </span>
                    </div>
                    
                    <% if (etapa.getDescripcion() != null && !etapa.getDescripcion().isEmpty()) { %>
                        <p class="text-sm sm:text-base text-gray-600 mb-3"><%= etapa.getDescripcion() %></p>
                    <% } %>
                    
                    <!-- Fechas -->
                    <div class="flex flex-wrap gap-4 text-sm text-gray-600">
                        <% if (etapa.getFechaInicio() != null) { %>
                            <div class="flex items-center">
                                <svg class="w-4 h-4 mr-1.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                                </svg>
                                <span class="font-medium">Inicio:</span>
                                <span class="ml-1"><%= sdf.format(etapa.getFechaInicio()) %></span>
                            </div>
                        <% } %>
                        <% if (etapa.getFechaTentativa() != null) { %>
                            <div class="flex items-center">
                                <svg class="w-4 h-4 mr-1.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                                <span class="font-medium">Tentativa:</span>
                                <span class="ml-1"><%= sdf.format(etapa.getFechaTentativa()) %></span>
                            </div>
                        <% } %>
                        <% if (etapa.getFechaFin() != null) { %>
                            <div class="flex items-center">
                                <svg class="w-4 h-4 mr-1.5 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                </svg>
                                <span class="font-medium">Finalizada:</span>
                                <span class="ml-1"><%= sdf.format(etapa.getFechaFin()) %></span>
                            </div>
                        <% } %>
                    </div>
                </div>

                <div class="flex flex-col sm:flex-row gap-2 flex-shrink-0">
                   
                    <% if (rol.equalsIgnoreCase("administrador") ||
                    		usuarioActual.getId() == pro.getSupervisor().getId()) { %>
	          
                    <button 
					    <% if ("Done".equals(etapa.getEstado())) { %> 
					        disabled 
					        class="bg-gray-400 cursor-not-allowed text-white font-medium py-2 px-4 sm:px-6 rounded-lg shadow transition text-center" 
					    <% } else { %>
					        onclick="window.location.href='TareaServlet?action=new&idEtapa=<%= etapa.getId() %>'"
					        class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 sm:px-6 rounded-lg shadow transition text-center"
					    <% } %>
					>
					    <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
					    </svg>
					    Nueva Tarea
					</button>
                    <button onclick="window.location.href='EtapaServlet?action=edit&id=<%= etapa.getId() %>'" 
                            class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium py-2 px-4 sm:px-6 rounded-lg shadow transition text-center">
                        <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                        </svg>
                        Editar Etapa
                    </button>
                    <% } %>
                </div>
            </div>

            <!-- BARRA DE PROGRESO -->
            <div class="border-t pt-4">
                <div class="flex justify-between items-center mb-2">
                    <span class="text-sm font-semibold text-gray-700">Progreso General</span>
                    <span class="text-lg font-bold text-gray-800"><%= progreso %>%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                    <div class="<%= progreso < 33 ? "bg-red-500" : progreso < 66 ? "bg-yellow-500" : progreso < 100 ? "bg-blue-500" : "bg-green-500" %> h-full rounded-full transition-all duration-300" 
                         style="width: <%= progreso %>%"></div>
                </div>
                <div class="flex justify-between items-center mt-2 text-sm text-gray-600">
                    <span><%= tareasDone %> de <%= totalTareas %> tareas completadas</span>
                </div>
            </div>
        </div>
	    <% } else { %>
	        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4 sm:mb-6">
	            Etapa no encontrada
	        </div>
	    <% } %>

    <!-- ESTADÍSTICAS RÁPIDAS -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4 mb-4 sm:mb-6">
        <div class="bg-white rounded-lg shadow p-4">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs sm:text-sm text-gray-600">Total</p>
                    <p class="text-xl sm:text-2xl font-bold text-gray-800"><%= totalTareas %></p>
                </div>
                <div class="bg-purple-100 p-2 sm:p-3 rounded-full">
                    <svg class="h-5 w-5 sm:h-6 sm:w-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                    </svg>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow p-4">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs sm:text-sm text-gray-600">Por Hacer</p>
                    <p class="text-xl sm:text-2xl font-bold text-yellow-600"><%= tareasToDo %></p>
                </div>
                <div class="bg-yellow-100 p-2 sm:p-3 rounded-full">
                    <svg class="h-5 w-5 sm:h-6 sm:w-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow p-4">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-xs sm:text-sm text-gray-600">En Progreso</p>
                    <p class="text-xl sm:text-2xl font-bold text-blue-600"><%= tareasInProgress %></p>
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
                    <p class="text-xs sm:text-sm text-gray-600">Completadas</p>
                    <p class="text-xl sm:text-2xl font-bold text-green-600"><%= tareasDone %></p>
                </div>
                <div class="bg-green-100 p-2 sm:p-3 rounded-full">
                    <svg class="h-5 w-5 sm:h-6 sm:w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                </div>
            </div>
        </div>
    </div>

    <!-- FILTROS Y ORDENAMIENTO -->
    <div class="bg-white rounded-lg shadow p-4 mb-4 sm:mb-6">
        <div class="flex flex-col sm:flex-row gap-3 sm:items-center sm:justify-between">
            <div class="flex flex-wrap gap-2">
                <select id="filtroEstado" onchange="filtrarTareas()" 
                        class="px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="">Todos los estados</option>
                    <option value="To Do">Por Hacer</option>
                    <option value="In Progress">En Progreso</option>
                    <option value="Done">Completadas</option>
                </select>

                <select id="filtroCategoria" onchange="filtrarTareas()" 
                        class="px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <option value="">Todas las categorías</option>
                    <% if (categorias != null) {
                        for (CategoriaTarea cat : categorias) { %>
                            <option value="<%= cat.getId() %>"><%= cat.getNombre() %></option>
                    <%  }
                    } %>
                </select>
            </div>

            <div class="flex gap-2">
                <button onclick="cambiarVista('tabla')" id="btnTabla" 
                        class="px-3 py-2 bg-blue-600 text-white rounded-lg text-sm hover:bg-blue-700 transition">
                    <svg class="inline w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                    </svg>
                    <span class="hidden sm:inline ml-1">Tabla</span>
                </button>
                <button onclick="cambiarVista('kanban')" id="btnKanban" 
                        class="px-3 py-2 bg-gray-200 text-gray-700 rounded-lg text-sm hover:bg-gray-300 transition">
                    <svg class="inline w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"></path>
                    </svg>
                    <span class="hidden sm:inline ml-1">Kanban</span>
                </button>
            </div>
        </div>
    </div>

    <!-- VISTA TABLA -->
    <div id="vistaTabla" class="bg-white rounded-lg shadow overflow-hidden">
        <% if (tareas == null || tareas.isEmpty()) { %>
            <div class="p-8 text-center text-gray-500">
                <svg class="mx-auto h-12 w-12 mb-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                </svg>
                <p class="text-sm">No hay tareas creadas aún.</p>
                
                <%if(!"Done".equals(estadoEtapa)){ %>
                <button onclick="window.location.href='TareaServlet?action=new&idEtapa=<%= etapa.getId() %>'" 
                        class="mt-4 text-blue-600 hover:text-blue-700 text-sm font-medium">
                    + Crear primera tarea
                </button>
                <%}else{ %>
                <p class="text-sm">La etapa finalizó. No se pueden crear tareas.</p>
                <%} %>
            </div>
        <% } else { %>
            <!-- Vista móvil: Cards -->
            <div class="block lg:hidden divide-y divide-gray-200">
                <% for (Tarea t : tareas) { 
                    String nombreCat = "Sin categoría";
                    System.out.println("categorias"+ categorias);
                    if (categorias != null && t.getIdCategoria() > 0) {
                        for (CategoriaTarea c : categorias) {
                            if (c.getId() == t.getIdCategoria()) {
                                nombreCat = c.getNombre();
                                break;
                            }
                        }
                    }
                %>
                    <div class="p-4 hover:bg-gray-50 cursor-pointer tarea-item" 
                         data-estado="<%= t.getEstado() %>" 
                         data-categoria="<%= t.getIdCategoria() %>"
                         onclick="window.location.href='TareaServlet?action=detalle&idTarea=<%= t.getId() %>&idEtapa=<%= etapa.getId() %>'">
                        <div class="flex items-start justify-between mb-2">
                            <h3 class="text-sm font-semibold text-gray-900 flex-1"><%= t.getNombre() %></h3>
                            <span class="px-2 py-1 text-xs font-semibold rounded-full flex-shrink-0 ml-2
                                <%= "To Do".equals(t.getEstado()) ? "bg-yellow-100 text-yellow-800" :
                                    "In Progress".equals(t.getEstado()) ? "bg-blue-100 text-blue-800" :
                                    "Done".equals(t.getEstado()) ? "bg-green-100 text-green-800" :
                                    "bg-red-100 text-red-800" %>">
                                <%= t.getEstado() %>
                            </span>
                        </div>
                        <% if (t.getDescripcion() != null && !t.getDescripcion().isEmpty()) { %>
                            <p class="text-xs text-gray-600 mb-2 line-clamp-2"><%= t.getDescripcion() %></p>
                        <% } %>
                        <div class="flex flex-wrap items-center gap-2 text-xs text-gray-500">
                            <span class="bg-blue-50 text-blue-700 px-2 py-1 rounded"><%= nombreCat %></span>
                            <span><%= t.getFechaInicio() != null ? sdf.format(t.getFechaInicio()) : "—" %> → <%= t.getFechaFin() != null ? sdf.format(t.getFechaFin()) : "—" %></span>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Vista desktop: Tabla -->
            <table class="w-full hidden lg:table">
                <thead class="bg-gray-50 border-b">
                    <tr>
                        <th class="px-4 lg:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tarea</th>
                        <th class="px-4 lg:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
                        <th class="px-4 lg:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Categoría</th>
                        <th class="px-4 lg:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fechas</th>
                        <th class="px-4 lg:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
                    </tr>
                </thead>

                <tbody class="bg-white divide-y divide-gray-200">
                    <% for (Tarea t : tareas) {
                        String nombreCat = "Sin categoría";
                        if (categorias != null && t.getIdCategoria() > 0) {
                            for (CategoriaTarea c : categorias) {
                                if (c.getId() == t.getIdCategoria()) {
                                    nombreCat = c.getNombre();
                                    break;
                                }
                            }
                        }
                    %>
                        <tr class="hover:bg-gray-50 transition clickable-row tarea-item" 
                            data-estado="<%= t.getEstado() %>" 
                            data-categoria="<%= t.getIdCategoria() %>"
                            onclick="window.location.href='TareaServlet?action=detalle&idTarea=<%= t.getId() %>&idEtapa=<%= etapa.getId() %>'">
                            <td class="px-4 lg:px-6 py-4">
                                <div>
                                    <div class="text-sm font-medium text-gray-900"><%= t.getNombre() %></div>
                                    <% if (t.getDescripcion() != null && !t.getDescripcion().isEmpty()) { %>
                                        <div class="text-sm text-gray-500 truncate max-w-xs"><%= t.getDescripcion() %></div>
                                    <% } %>
                                </div>
                            </td>

                            <td class="px-4 lg:px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
                                    <%= "To Do".equals(t.getEstado()) ? "bg-yellow-100 text-yellow-800" :
                                        "In Progress".equals(t.getEstado()) ? "bg-blue-100 text-blue-800" :
                                        "Done".equals(t.getEstado()) ? "bg-green-100 text-green-800" :
                                        "bg-red-100 text-red-800" %>">
                                    <%= t.getEstado() %>
                                </span>
                            </td>

                            <td class="px-4 lg:px-6 py-4 whitespace-nowrap">
                                <span class="text-sm text-gray-900"><%= nombreCat %></span>
                            </td>

                            <td class="px-4 lg:px-6 py-4 text-sm text-gray-600">
                                <div><strong>Inicio:</strong> <%= t.getFechaInicio() != null ? sdf.format(t.getFechaInicio()) : "—" %></div>
                                <div><strong>Fin:</strong> <%= t.getFechaFin() != null ? sdf.format(t.getFechaFin()) : "—" %></div>
                            </td>

                            <td class="px-4 lg:px-6 py-4 whitespace-nowrap text-sm font-medium">
                                 <% if (rol.equalsIgnoreCase("administrador") ||
                                 		usuarioActual.getId() == pro.getSupervisor().getId()) { %>
	          
                                <a href="TareaServlet?action=edit&idTarea=<%= t.getId() %>&idEtapa=<%= etapa.getId() %>"
                                   class="text-indigo-600 hover:text-indigo-900 mr-3"
                                   onclick="event.stopPropagation()">
                                    Editar
                                </a>
								<a href="TareaServlet?action=delete&idTarea=<%= t.getId() %>&idEtapa=<%= etapa.getId() %>"
                                   class="text-red-600 hover:text-red-900 mr-3">
                                    Eliminar
                                </a>
                                    <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>

    <!-- VISTA KANBAN -->
    <div id="vistaKanban" class="hidden">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <!-- Columna TO DO -->
            <div class="bg-white rounded-lg shadow p-4">
                <h3 class="font-semibold text-gray-700 mb-3 flex items-center">
                    <span class="w-3 h-3 bg-yellow-500 rounded-full mr-2"></span>
                    Por Hacer (<span id="countToDo"><%= tareasToDo %></span>)
                </h3>
                <div class="space-y-3 kanban-column" data-estado="To Do">
                    <% if (tareas != null) {
                        for (Tarea t : tareas) {
                            if ("To Do".equals(t.getEstado())) { %>
                                <div class="bg-gray-50 p-3 rounded-lg border-l-4 border-yellow-500 cursor-pointer hover:shadow-md transition tarea-item"
                                     data-estado="<%= t.getEstado() %>"
                                     data-categoria="<%= t.getIdCategoria() %>"
                                     onclick="window.location.href='TareaServlet?action=detalle&idTarea=<%= t.getId() %>&idEtapa=<%= etapa.getId() %>'">
                                    <h4 class="font-semibold text-sm text-gray-900 mb-1"><%= t.getNombre() %></h4>
                                    <p class="text-xs text-gray-600 line-clamp-2"><%= t.getDescripcion() != null ? t.getDescripcion() : "" %></p>
                                    <div class="mt-2 text-xs text-gray-500">
                                        <%= t.getFechaFin() != null ? sdf.format(t.getFechaFin()) : "Sin fecha" %>
                                    </div>
                                </div>
                    <%      }
                        }
                    } %>
                </div>
            </div>

            <!-- Columna IN PROGRESS -->
            <div class="bg-white rounded-lg shadow p-4">
                <h3 class="font-semibold text-gray-700 mb-3 flex items-center">
                    <span class="w-3 h-3 bg-blue-500 rounded-full mr-2"></span>
                    En Progreso (<span id="countInProgress"><%= tareasInProgress %></span>)
                </h3>
                <div class="space-y-3 kanban-column" data-estado="In Progress">
                    <% if (tareas != null) {
                        for (Tarea t : tareas) {
                            if ("In Progress".equals(t.getEstado())) { %>
                                <div class="bg-gray-50 p-3 rounded-lg border-l-4 border-blue-500 cursor-pointer hover:shadow-md transition tarea-item"
                                     data-estado="<%= t.getEstado() %>"
                                     data-categoria="<%= t.getIdCategoria() %>"
                                     onclick="window.location.href='TareaServlet?action=detalle&idTarea=<%= t.getId() %>&idEtapa=<%= etapa.getId() %>'">
                                    <h4 class="font-semibold text-sm text-gray-900 mb-1"><%= t.getNombre() %></h4>
                                    <p class="text-xs text-gray-600 line-clamp-2"><%= t.getDescripcion() != null ? t.getDescripcion() : "" %></p>
                                    <div class="mt-2 text-xs text-gray-500">
                                        <%= t.getFechaFin() != null ? sdf.format(t.getFechaFin()) : "Sin fecha" %>
                                    </div>
                                </div>
                    <%      }
                        }
                    } %>
                </div>
            </div>

            <!-- Columna DONE -->
            <div class="bg-white rounded-lg shadow p-4">
                <h3 class="font-semibold text-gray-700 mb-3 flex items-center">
                    <span class="w-3 h-3 bg-green-500 rounded-full mr-2"></span>
                    Completadas (<span id="countDone"><%= tareasDone %></span>)
                </h3>
                <div class="space-y-3 kanban-column" data-estado="Done">
                    <% if (tareas != null) {
                        for (Tarea t : tareas) {
                            if ("Done".equals(t.getEstado())) { %>
                                <div class="bg-gray-50 p-3 rounded-lg border-l-4 border-green-500 cursor-pointer hover:shadow-md transition tarea-item"
                                     data-estado="<%= t.getEstado() %>"
                                     data-categoria="<%= t.getIdCategoria() %>"
                                     onclick="window.location.href='TareaServlet?action=detalle&idTarea=<%= t.getId() %>&idEtapa=<%= etapa.getId() %>'">
                                    <h4 class="font-semibold text-sm text-gray-900 mb-1"><%= t.getNombre() %></h4>
                                    <p class="text-xs text-gray-600 line-clamp-2"><%= t.getDescripcion() != null ? t.getDescripcion() : "" %></p>
                                    <div class="mt-2 flex items-center text-xs text-green-600">
                                        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                                        </svg>
                                        Completada
                                    </div>
                                </div>
                    <%      }
                        }
                    } %>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../etapas/formulario.jsp" />
<jsp:include page="../tareas/formulario.jsp" />
<jsp:include page="modalEliminarTarea.jsp" />


<script>
function toggleModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.classList.toggle("hidden");
}
<% if (request.getAttribute("abrirModalTarea") != null) { %>
document.addEventListener("DOMContentLoaded", function() {

    document.getElementById("modalFormTarea").classList.remove("hidden");
});
<% } %>

function toggleModalEliminar(nameModal) {
    const modal = document.getElementById(nameModal);
    modal.classList.toggle('hidden');
}

function cambiarVista(vista) {
    const vistaTabla = document.getElementById('vistaTabla');
    const vistaKanban = document.getElementById('vistaKanban');
    const btnTabla = document.getElementById('btnTabla');
    const btnKanban = document.getElementById('btnKanban');
    
    if (vista === 'tabla') {
        vistaTabla.classList.remove('hidden');
        vistaKanban.classList.add('hidden');
        btnTabla.classList.remove('bg-gray-200', 'text-gray-700');
        btnTabla.classList.add('bg-blue-600', 'text-white');
        btnKanban.classList.remove('bg-blue-600', 'text-white');
        btnKanban.classList.add('bg-gray-200', 'text-gray-700');
    } else {
        vistaTabla.classList.add('hidden');
        vistaKanban.classList.remove('hidden');
        btnKanban.classList.remove('bg-gray-200', 'text-gray-700');
        btnKanban.classList.add('bg-blue-600', 'text-white');
        btnTabla.classList.remove('bg-blue-600', 'text-white');
        btnTabla.classList.add('bg-gray-200', 'text-gray-700');
    }
}

function filtrarTareas() {
    const filtroEstado = document.getElementById('filtroEstado').value;
    const filtroCategoria = document.getElementById('filtroCategoria').value;
    const tareas = document.querySelectorAll('.tarea-item');
    
    let contadores = { 'To Do': 0, 'In Progress': 0, 'Done': 0 };
    
    tareas.forEach(tarea => {
        const estado = tarea.getAttribute('data-estado');
        const categoria = tarea.getAttribute('data-categoria');
        
        const cumpleFiltroEstado = !filtroEstado || estado === filtroEstado;
        const cumpleFiltroCategoria = !filtroCategoria || categoria === filtroCategoria;
        
        if (cumpleFiltroEstado && cumpleFiltroCategoria) {
            tarea.style.display = '';
            if (estado) contadores[estado]++;
        } else {
            tarea.style.display = 'none';
        }
    });
    
    // Actualizar contadores en vista Kanban
    if (document.getElementById('countToDo')) {
        document.getElementById('countToDo').textContent = contadores['To Do'];
        document.getElementById('countInProgress').textContent = contadores['In Progress'];
        document.getElementById('countDone').textContent = contadores['Done'];
    }
}


</script>

</body>
</html>